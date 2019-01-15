# Override ARG with docker build --build-arg TAG=<vresion> .
ARG TAG=latest
ARG INTERNAL_HTTP=8081

FROM audioscavenger/ubuntu-lemp:${TAG:-latest}

## Check latest version: https://github.com/owncloud/core/wiki/Maintenance-and-Release-Schedule
ENV OWNCLOUD_VERSION=${TAG:-latest}
ENV USER_LDAP_VERSION="0.11.0" \
    OWNCLOUD_IN_ROOTPATH="0" \
    OWNCLOUD_SERVERNAME="127.0.0.1"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

LABEL maintainer="audioscavenger <dev@derewonko.com>" \
  org.label-schema.name="ownCloud Server LEMP" \
  org.label-schema.vendor="lesmoules" \
  org.label-schema.schema-version="1.0"

VOLUME ["/mnt/data"]

RUN mkdir -p /var/www/html /var/www/owncloud /mnt/data/files /mnt/data/config /mnt/data/certs /mnt/data/sessions && \
chown -R www-data:www-data /var/www /mnt/data && \
chgrp root /var/run /etc/environment && \
chmod g+w /var/run /etc/environment && \
chgrp root /etc/nginx/sites-enabled/default /etc/php/7.2/mods-available/owncloud.ini && \
chmod g+w /etc/nginx/sites-enabled/default /etc/php/7.2/mods-available/owncloud.ini && \
chsh -s /bin/bash www-data


# ADD local compressed files will unzip them but cannot be automated by docker hub:
#ADD owncloud-*.tar.bz2 /var/www/
#ADD user_ldap.tar.gz /var/www/owncloud/apps/

# ADD downloaded compressed files will NOT unzip them:
ADD https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.tar.bz2 /var/www/owncloud-${OWNCLOUD_VERSION}.tar.bz2
ADD https://github.com/owncloud/user_ldap/releases/download/v${USER_LDAP_VERSION}/user_ldap.tar.gz /var/www/owncloud/apps/user_ldap.tar.gz
RUN /bin/tar -xjf /var/www/owncloud-${OWNCLOUD_VERSION}.tar.bz2 -C /var/www && /bin/rm /var/www/owncloud-${OWNCLOUD_VERSION}.tar.bz2 && \
    /bin/tar -xzf /var/www/owncloud/apps/user_ldap.tar.gz -C /var/www/owncloud/apps && /bin/rm /var/www/owncloud/apps/user_ldap.tar.gz

RUN a2enmod rewrite headers env dir mime expires remoteip && \
mkdir -p /var/www/html /var/log/nginx /var/run/php && \
chown -R www-data:www-data /var/www/html /var/log/nginx /var/run/php && \
chsh -s /bin/bash www-data

# https://stackoverflow.com/questions/30215830/dockerfile-copy-keep-subdirectory-structure
# Note: rootfs/.keep is under configs/
COPY configs/ /

# each CMD = one temporary container!
# Note: it looks like php cannot start without /run/php/ because the service doesn't create it every first time
RUN /bin/rm -f /etc/cron.daily/apache2 /var/log/*log* && \
    /bin/ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime && \
    /bin/ln -sf /etc/environment /etc/default/php-fpm7.2 && \
    /bin/ln -sf /etc/php/7.2/mods-available/owncloud.ini /etc/php/7.2/fpm/conf.d/99-owncloud.ini && \
    /bin/ln -sf /usr/bin/server.nginx /usr/bin/server && \
    /bin/mkdir -p /var/www/owncloud /mnt/data/files /mnt/data/config /mnt/data/certs /mnt/data/sessions /run/php && \
    /bin/chown www-data:www-data /run/php && \
    /bin/chmod 755 /etc/owncloud.d/* /etc/entrypoint.d/* /root/.bashrc /usr/bin/server.*


WORKDIR /var/www/owncloud
RUN find /var/www/owncloud \( \! -user www-data -o \! -group root \) -print0 | xargs -r -0 chown www-data:root && \
    chmod g+w /var/www/owncloud

EXPOSE ${INTERNAL_HTTP}
ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/usr/bin/owncloud", "server"]

#!/usr/bin/env bash

declare -x NGINX_ENABLE_LOG
[[ -z "${NGINX_ENABLE_LOG}" ]] && NGINX_ENABLE_LOG="false"

declare -x NGINX_ENABLE_TEST_URL
[[ -z "${NGINX_ENABLE_TEST_URL}" ]] && NGINX_ENABLE_TEST_URL="true"

declare -x NGINX_ENABLED_TEST_URL
${NGINX_ENABLE_TEST_URL} && NGINX_ENABLED_TEST_URL="#rewrite ^ /index.php;" || NGINX_ENABLED_TEST_URL="rewrite ^ /index.php;"

declare -x NGINX_LISTEN
[[ -z "${NGINX_LISTEN}" ]] && NGINX_LISTEN="8081"

declare -x NGINX_ROOT
[[ -z "${NGINX_ROOT}" ]] && NGINX_ROOT="/var/www/owncloud"

declare -x NGINX_ROOT_TEST_URL
[[ -z "${NGINX_ROOT_TEST_URL}" ]] && NGINX_ROOT_TEST_URL="/var/www/html"

declare -x NGINX_ROOT_ACME_CHALLENGE
[[ -z "${NGINX_ROOT_ACME_CHALLENGE}" ]] && NGINX_ROOT_ACME_CHALLENGE=${NGINX_ROOT_TEST_URL}

declare -x NGINX_RUN_USER
[[ -z "${NGINX_RUN_USER}" ]] && NGINX_RUN_USER="www-data"

declare -x NGINX_RUN_GROUP
[[ -z "${NGINX_RUN_GROUP}" ]] && NGINX_RUN_GROUP="www-data"

declare -x NGINX_PID_FILE
[[ -z "${NGINX_PID_FILE}" ]] && NGINX_PID_FILE="/var/run/nginx.pid"

declare -x NGINX_DEFAULT_ACCESS_LOG
[[ -z "${NGINX_DEFAULT_ACCESS_LOG}" ]] && NGINX_DEFAULT_ACCESS_LOG="/var/log/nginx/access.log"

declare -x NGINX_DEFAULT_ERROR_LOG
[[ -z "${NGINX_DEFAULT_ERROR_LOG}" ]] && NGINX_DEFAULT_ERROR_LOG="/var/log/nginx/error.log"

declare -x NGINX_ACCESS_LOG
[[ -z "${NGINX_ACCESS_LOG}" ]] && NGINX_ACCESS_LOG="off"

declare -x NGINX_ERROR_LOG
[[ -z "${NGINX_ERROR_LOG}" ]] && NGINX_ERROR_LOG="off"

declare -x NGINX_LOG_FORMAT
[[ -z "${NGINX_LOG_FORMAT}" ]] && NGINX_LOG_FORMAT="combined"

declare -x NGINX_LOG_LEVEL
[[ -z "${NGINX_LOG_LEVEL}" ]] && NGINX_LOG_LEVEL="crit"

if ${NGINX_ENABLE_LOG}; then
  NGINX_ACCESS_LOG="${NGINX_DEFAULT_ACCESS_LOG} ${NGINX_LOG_FORMAT}"
  NGINX_ERROR_LOG="${NGINX_DEFAULT_ERROR_LOG} ${NGINX_LOG_LEVEL}"
fi

declare -x NGINX_SERVER_NAME
[[ -z "${NGINX_SERVER_NAME}" ]] && NGINX_SERVER_NAME="_"

declare -x NGINX_SERVER_SIGNATURE
[[ -z "${NGINX_SERVER_SIGNATURE}" ]] && NGINX_SERVER_SIGNATURE="Off"

declare -x NGINX_WORKER_CONNECTIONS
[[ -z "${NGINX_WORKER_CONNECTIONS}" ]] && NGINX_WORKER_CONNECTIONS="1024"

declare -x NGINX_KEEP_ALIVE_TIMEOUT
[[ -z "${NGINX_KEEP_ALIVE_TIMEOUT}" ]] && NGINX_KEEP_ALIVE_TIMEOUT="65"

declare -x NGINX_ENTRYPOINT_INITIALIZED
[[ -z "${NGINX_ENTRYPOINT_INITIALIZED}" ]] && NGINX_ENTRYPOINT_INITIALIZED="true"

true
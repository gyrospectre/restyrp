#!/bin/sh

NGINX_DIR=/usr/local/openresty/nginx
NGINX_CONF="${NGINX_DIR}/conf/nginx.conf"

OPENRESTY_BIN_DIR=/usr/local/openresty/bin
OPENRESTY_BIN=${OPENRESTY_BIN_DIR}/openresty

echo "Using nginx config:"
cat "${NGINX_CONF}"

echo "Starting nginx:"
"${OPENRESTY_BIN}" -g "daemon off;"

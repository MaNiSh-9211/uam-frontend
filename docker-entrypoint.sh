#!/bin/sh
# Render / production: set GATEWAY_PROXY_* in the host dashboard (never commit real URLs).
# Local Compose: defaults below match the `gateway` service on port 8080.
set -e

export GATEWAY_PROXY_PASS="${GATEWAY_PROXY_PASS:-http://gateway:8080/api/}"
export GATEWAY_PROXY_HOST="${GATEWAY_PROXY_HOST:-gateway}"

envsubst '${GATEWAY_PROXY_PASS} ${GATEWAY_PROXY_HOST}' \
    < /etc/nginx/nginx.conf.template \
    > /etc/nginx/nginx.conf

exec nginx -g 'daemon off;'

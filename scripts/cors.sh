#!/bin/sh

# Environment:
# - INVENTREE_ALLOWED_HOSTS (optional)
# - INVENTREE_CORS_ORIGIN_ALLOW_ALL (optional)
# - INVENTREE_CORS_ORIGIN_WHITELIST (optional)

if [ -n "${INVENTREE_ALLOWED_HOSTS}" ]; then
    info "Configuring allowed_hosts -> ${INVENTREE_ALLOWED_HOSTS}"

    for allowed_host in ${INVENTREE_ALLOWED_HOSTS}; do
        put -t string -v "${allowed_host}" 'allowed_hosts.[]'
    done
fi

if [ -n "${INVENTREE_CORS_ORIGIN_ALLOW_ALL}" ]; then
    info "Configuring cors.allow_all -> ${INVENTREE_CORS_ORIGIN_ALLOW_ALL}"
    put -t bool -v "${INVENTREE_CORS_ORIGIN_ALLOW_ALL}" 'cors.allow_all'
fi

if [ -n "${INVENTREE_CORS_ORIGIN_WHITELIST}" ]; then
    info "Configuring cors.whitelist -> ${INVENTREE_CORS_ORIGIN_WHITELIST}"

    for origin in ${INVENTREE_CORS_ORIGIN_WHITELIST}; do
        put -t string -v "${origin}" 'cors.whitelist.[]'
    done
fi

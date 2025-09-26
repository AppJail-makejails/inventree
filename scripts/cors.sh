#!/bin/sh

# Environment:
# - INVENTREE_TRUSTED_ORIGINS (optional)
# - INVENTREE_ALLOWED_HOSTS (optional)
# - INVENTREE_CORS_ORIGIN_ALLOW_ALL (optional)
# - INVENTREE_CORS_ORIGIN_WHITELIST (optional)

. /scripts/lib.subr

if [ -n "${INVENTREE_TRUSTED_ORIGINS}" ]; then
    info "Configuring trusted_origins -> ${INVENTREE_TRUSTED_ORIGINS}"

    printf "%s\n" "${INVENTREE_TRUSTED_ORIGINS}" | sed -Ee 's/ /\n/g' | while IFS= read -r trusted_origin; do
        put -t string -v "${trusted_origin}" 'trusted_origins.[]'
    done
fi

if [ -n "${INVENTREE_ALLOWED_HOSTS}" ]; then
    info "Configuring allowed_hosts -> ${INVENTREE_ALLOWED_HOSTS}"

    printf "%s\n" "${INVENTREE_ALLOWED_HOSTS}" | sed -Ee 's/ /\n/g' | while IFS= read -r allowed_host; do
        put -t string -v "${allowed_host}" 'allowed_hosts.[]'
    done
fi

if [ -n "${INVENTREE_CORS_ORIGIN_ALLOW_ALL}" ]; then
    info "Configuring cors.allow_all -> ${INVENTREE_CORS_ORIGIN_ALLOW_ALL}"
    put -t bool -v "${INVENTREE_CORS_ORIGIN_ALLOW_ALL}" 'cors.allow_all'
fi

if [ -n "${INVENTREE_CORS_ORIGIN_WHITELIST}" ]; then
    info "Configuring cors.whitelist -> ${INVENTREE_CORS_ORIGIN_WHITELIST}"

    printf "%s\n" "${INVENTREE_CORS_ORIGIN_WHITELIST}" | sed -Ee 's/ /\n/g' | while IFS= read -r origin; do
        put -t string -v "${origin}" 'cors.whitelist.[]'
    done
fi

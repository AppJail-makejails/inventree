#!/bin/sh

# Environment:
# - INVENTREE_CACHE_HOST (optional)
# - INVENTREE_CACHE_PORT (optional)

. /scripts/lib.subr

if [ -n "${INVENTREE_CACHE_HOST}" ]; then
    info "Configuring cache.host -> ${INVENTREE_CACHE_HOST}"
    put -t string -v "${INVENTREE_CACHE_HOST}" cache.host
fi

if [ -n "${INVENTREE_CACHE_PORT}" ]; then
    info "Configuring cache.port -> ${INVENTREE_CACHE_PORT}"
    put -t int -v "${INVENTREE_CACHE_PORT}" cache.port
fi

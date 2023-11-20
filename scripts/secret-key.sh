#!/bin/sh

# Environment:
# - INVENTREE_SECRET_KEY (optional) or INVENTREE_SECRET_KEY_FILE (/inventree/data/secret_key.txt, fallback)

. /scripts/lib.subr

INVENTREE_SECRET_KEY_FILE="${INVENTREE_SECRET_KEY_FILE:-/inventree/data/secret_key.txt}"

if [ -n "${INVENTREE_SECRET_KEY}" ]; then
    info "Configuring secret_key -> ${INVENTREE_SECRET_KEY}"
    put -t string -v "${INVENTREE_SECRET_KEY}" secret_key
else
    info "Configuring secret_key_file -> ${INVENTREE_SECRET_KEY_FILE}"
    put -t string -v "${INVENTREE_SECRET_KEY_FILE}" secret_key_file
fi

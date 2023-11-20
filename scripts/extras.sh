#!/bin/sh

# Environment:
# - INVENTREE_EXTRA_URL_SCHEMES (optional)

if [ -n "${INVENTREE_EXTRA_URL_SCHEMES}" ]; then
    info "Configuring extra_url_schemes -> ${INVENTREE_EXTRA_URL_SCHEMES}"

    for extra_url_scheme in ${INVENTREE_EXTRA_URL_SCHEMES}; do
        put -t string -v "${extra_url_scheme}" 'extra_url_schemes.[]'
    done
fi

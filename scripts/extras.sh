#!/bin/sh

# Environment:
# - INVENTREE_EXTRA_URL_SCHEMES (optional)

. /scripts/lib.subr

if [ -n "${INVENTREE_EXTRA_URL_SCHEMES}" ]; then
    info "Configuring extra_url_schemes -> ${INVENTREE_EXTRA_URL_SCHEMES}"

    printf "%s\n" "${INVENTREE_EXTRA_URL_SCHEMES}" | sed -Ee 's/ /\n/g' | while IFS= read -r extra_url_scheme; do
        put -t string -v "${extra_url_scheme}" 'extra_url_schemes.[]'
    done
fi

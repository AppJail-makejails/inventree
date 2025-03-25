#!/bin/sh

# Environment:
# - INVENTREE_BASE_CURRENCY (USD)
# - INVENTREE_CURRENCIES (AUD CAD CNY EUR GBP JPY NZD USD)

. /scripts/lib.subr

INVENTREE_BASE_CURRENCY="${INVENTREE_BASE_CURRENCY:-USD}"
INVENTREE_CURRENCIES="${INVENTREE_CURRENCIES:-AUD CAD CNY EUR GBP JPY NZD USD}"

info "Configuring base_currency -> ${INVENTREE_BASE_CURRENCY}"
put -t string -v "${INVENTREE_BASE_CURRENCY}" base_currency

info "Configuring currencies -> ${INVENTREE_CURRENCIES}"

printf "%s\n" "${INVENTREE_CURRENCIES}" | sed -Ee 's/ /\n/g' | while IFS= read -r currency; do
    put -t string -v "${currency}" 'currencies.[]'
done

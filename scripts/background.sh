#!/bin/sh

# Environment:
# - INVENTREE_BACKGROUND_WORKERS (1)
# - INVENTREE_BACKGROUND_TIMEOUT (90)
# - INVENTREE_BACKGROUND_MAX_ATTEMPTS (5)

. /scripts/lib.subr

INVENTREE_BACKGROUND_WORKERS="${INVENTREE_BACKGROUND_WORKERS:-1}"
INVENTREE_BACKGROUND_TIMEOUT="${INVENTREE_BACKGROUND_TIMEOUT:-90}"
INVENTREE_BACKGROUND_MAX_ATTEMPTS="${INVENTREE_BACKGROUND_MAX_ATTEMPTS:-5}"

info "Configuring background.workers -> ${INVENTREE_BACKGROUND_WORKERS}"
put -t int -v "${INVENTREE_BACKGROUND_WORKERS}" background.workers

info "Configuring background.timeout -> ${INVENTREE_BACKGROUND_TIMEOUT}"
put -t int -v "${INVENTREE_BACKGROUND_TIMEOUT}" background.timeout

info "Configuring background.max_attempts -> ${INVENTREE_BACKGROUND_MAX_ATTEMPTS}"
put -t int -v "${INVENTREE_BACKGROUND_MAX_ATTEMPTS}" background.max_attempts

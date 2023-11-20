#!/bin/sh

# Environment:
# - INVENTREE_SENTRY_ENABLED (False)
# - INVENTREE_SENTRY_SAMPLE_RATE (optional)
# - INVENTREE_SENTRY_DSN (optional)

. /scripts/lib.subr

INVENTREE_SENTRY_ENABLED="${INVENTREE_SENTRY_ENABLED:-False}"

info "Configuring sentry_enabled -> ${INVENTREE_SENTRY_ENABLED}"
put -t bool -v "${INVENTREE_SENTRY_ENABLED}" sentry_enabled

if [ -n "${INVENTREE_SENTRY_SAMPLE_RATE}" ]; then
    info "Configuring sentry_sample_rate -> ${INVENTREE_SENTRY_SAMPLE_RATE}"
    put -t float -v "${INVENTREE_SENTRY_SAMPLE_RATE}" sentry_sample_rate
fi

if [ -n "${INVENTREE_SENTRY_DSN}" ]; then
    info "Configuring sentry_dsn -> ${INVENTREE_SENTRY_DSN}"
    put -t string -v "${INVENTREE_SENTRY_DSN}" sentry_dsn
fi

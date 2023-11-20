#!/bin/sh

# Environment:
# - INVENTREE_EMAIL_BACKEND (optional)
# - INVENTREE_EMAIL_HOST (optional)
# - INVENTREE_EMAIL_PORT (optional)
# - INVENTREE_EMAIL_USERNAME (optional)
# - INVENTREE_EMAIL_PASSWORD (optional)
# - INVENTREE_EMAIL_TLS (optional)
# - INVENTREE_EMAIL_SSL (optional)
# - INVENTREE_EMAIL_SENDER (optional)
# - INVENTREE_EMAIL_PREFIX (optional)

if [ -n "${INVENTREE_EMAIL_BACKEND}" ]; then
    info "Configuring email.backend -> ${INVENTREE_EMAIL_BACKEND}"
    put -t string -v "${INVENTREE_EMAIL_BACKEND}" email.backend
fi

if [ -n "${INVENTREE_EMAIL_HOST}" ]; then
    info "Configuring email.host -> ${INVENTREE_EMAIL_HOST}"
    put -t string -v "${INVENTREE_EMAIL_HOST}" email.host
fi

if [ -n "${INVENTREE_EMAIL_PORT}" ]; then
    info "Configuring email.port -> ${INVENTREE_EMAIL_PORT}"
    put -t int -v "${INVENTREE_EMAIL_PORT}" email.port
fi

if [ -n "${INVENTREE_EMAIL_USERNAME}" ]; then
    info "Configuring email.username -> ${INVENTREE_EMAIL_USERNAME}"
    put -t string -v "${INVENTREE_EMAIL_USERNAME}" email.username
fi

if [ -n "${INVENTREE_EMAIL_PASSWORD}" ]; then
    info "Configuring email.password -> ${INVENTREE_EMAIL_PASSWORD}"
    put -t string -v "${INVENTREE_EMAIL_PASSWORD}" email.password
fi

if [ -n "${INVENTREE_EMAIL_TLS}" ]; then
    info "Configuring email.tls -> ${INVENTREE_EMAIL_TLS}"
    put -t bool -v "${INVENTREE_EMAIL_TLS}" email.tls
fi

if [ -n "${INVENTREE_EMAIL_SSL}" ]; then
    info "Configuring email.ssl -> ${INVENTREE_EMAIL_SSL}"
    put -t bool -v "${INVENTREE_EMAIL_SSL}" email.ssl
fi

if [ -n "${INVENTREE_EMAIL_SENDER}" ]; then
    info "Configuring email.sender -> ${INVENTREE_EMAIL_SENDER}"
    put -t string -v "${INVENTREE_EMAIL_SENDER}" email.sender
fi

if [ -n "${INVENTREE_EMAIL_PREFIX}" ]; then
    info "Configuring email.prefix -> ${INVENTREE_EMAIL_PREFIX}"
    put -t string -v "${INVENTREE_EMAIL_PREFIX}" email.prefix
fi

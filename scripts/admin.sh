#!/bin/sh

# Environment:
# - INVENTREE_ADMIN_USER (optional)
# - INVENTREE_ADMIN_PASSWORD (optional)
# - INVENTREE_ADMIN_EMAIL (optional)

. /scripts/lib.subr

if [ -n "${INVENTREE_ADMIN_USER}" ]; then
    info "Configuring admin_user -> ${INVENTREE_ADMIN_USER}"
    put -t string -v "${INVENTREE_ADMIN_USER}" admin_user
fi

if [ -n "${INVENTREE_ADMIN_PASSWORD}" ]; then
    info "Configuring admin_password -> ${INVENTREE_ADMIN_PASSWORD}"
    put -t string -v "${INVENTREE_ADMIN_PASSWORD}" admin_password
fi

if [ -n "${INVENTREE_ADMIN_EMAIL}" ]; then
    info "Configuring admin_email -> ${INVENTREE_ADMIN_EMAIL}"
    put -t string -v "${INVENTREE_ADMIN_EMAIL}" admin_email
fi

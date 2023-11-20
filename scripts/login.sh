#!/bin/sh

# Environment:
# - INVENTREE_LOGIN_CONFIRM_DAYS (3)
# - INVENTREE_LOGIN_ATTEMPTS (5)
# - INVENTREE_LOGIN_DEFAULT_PROTOCOL (http)
# - INVENTREE_REMOTE_LOGIN_ENABLED (False)
# - INVENTREE_REMOTE_LOGIN_HEADER (HTTP_REMOTE_USER)
# - INVENTREE_USE_JWT (optional)
# - INVENTREE_LOGOUT_REDIRECT_URL (optional)

. /scripts/lib.subr

if [ -n "${INVENTREE_LOGIN_CONFIRM_DAYS}" ]; then
    info "Configuring login_confirms_days -> ${INVENTREE_LOGIN_CONFIRM_DAYS}"
    put -t int -v "${INVENTREE_LOGIN_CONFIRM_DAYS}" login_confirm_days
fi

if [ -n "${INVENTREE_LOGIN_ATTEMPTS}" ]; then
    info "Configuring login_attempts -> ${INVENTREE_LOGIN_ATTEMPTS}"
    put -t int -v "${INVENTREE_LOGIN_ATTEMPTS}" login_attempts
fi

if [ -n "${INVENTREE_LOGIN_DEFAULT_PROTOCOL}" ]; then
    info "Configuring login_default_protocol -> ${INVENTREE_LOGIN_DEFAULT_PROTOCOL}"
    put -t string -v "${INVENTREE_LOGIN_DEFAULT_PROTOCOL}" login_default_protocol
fi

if [ -n "${INVENTREE_REMOTE_LOGIN_ENABLED}" ]; then
    info "Configuring remote_login_enabled -> ${INVENTREE_REMOTE_LOGIN_ENABLED}"
    put -t bool -v "${INVENTREE_REMOTE_LOGIN_ENABLED}" remote_login_enabled
fi

if [ -n "${INVENTREE_REMOTE_LOGIN_HEADER}" ]; then
    info "Configuring remote_login_header -> ${INVENTREE_REMOTE_LOGIN_HEADER}"
    put -t string -v "${INVENTREE_REMOTE_LOGIN_HEADER}" remote_login_header
fi

if [ -n "${INVENTREE_USE_JWT}" ]; then
    info "Configuring use_jwt -> ${INVENTREE_USE_JWT}"
    put -t bool -v "${INVENTREE_USE_JWT}" use_jwt
fi

if [ -n "${INVENTREE_LOGOUT_REDIRECT_URL}" ]; then
    info "Configuring logout_redirect_url -> ${INVENTREE_LOGOUT_REDIRECT_URL}"
    put -t string -v "${INVENTREE_LOGOUT_REDIRECT_URL}" logout_redirect_url
fi

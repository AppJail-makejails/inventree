#!/bin/sh

# Environment:
# - INVENTREE_CUSTOM_LOGO (optional)
# - INVENTREE_CUSTOM_SPLASH (optional)
# - INVENTREE_CUSTOM_LOGIN_MESSAGE (optional)
# - INVENTREE_CUSTOM_NAVBAR_MESSAGE (optional)
# - INVENTREE_CUSTOM_HIDE_ADMIN_LINK (optional)
# - INVENTREE_CUSTOM_HIDE_PASSWORD_RESET (optional)

. /scripts/lib.subr

if [ -n "${INVENTREE_CUSTOM_LOGO}" ]; then
    info "Configuring customize.logo -> ${INVENTREE_CUSTOM_LOGO}"
    put -t string -v "${INVENTREE_CUSTOM_LOGO}" customize.logo
fi

if [ -n "${INVENTREE_CUSTOM_SPLASH}" ]; then
    info "Configuring customize.splash -> ${INVENTREE_CUSTOM_SPLASH}"
    put -t string -v "${INVENTREE_CUSTOM_SPLASH}" customize.splash
fi

if [ -n "${INVENTREE_CUSTOM_LOGIN_MESSAGE}" ]; then
    info "Configuring customize.login_message -> ${INVENTREE_CUSTOM_LOGIN_MESSAGE}"
    put -t string -v "${INVENTREE_CUSTOM_LOGIN_MESSAGE}" customize.login_message
fi

if [ -n "${INVENTREE_CUSTOM_NAVBAR_MESSAGE}" ]; then
    info "Configuring customize.navbar_message -> ${INVENTREE_CUSTOM_NAVBAR_MESSAGE}"
    put -t string -v "${INVENTREE_CUSTOM_NAVBAR_MESSAGE}" customize.navbar_message
fi

if [ -n "${INVENTREE_CUSTOM_HIDE_ADMIN_LINK}" ]; then
    info "Configuring customize.hide_admin_link -> ${INVENTREE_CUSTOM_HIDE_ADMIN_LINK}"
    put -t string -v "${INVENTREE_CUSTOM_HIDE_ADMIN_LINK}" customize.hide_admin_link
fi

if [ -n "${INVENTREE_CUSTOM_HIDE_PASSWORD_RESET}" ]; then
    info "Configuring customize.hide_password_reset -> ${INVENTREE_CUSTOM_HIDE_PASSWORD_RESET}"
    put -t string -v "${INVENTREE_CUSTOM_HIDE_PASSWORD_RESET}" customize.hide_password_reset
fi

#!/bin/sh

# Environment:
# - INVENTREE_DEBUG (True)
# - INVENTREE_LOG_LEVEL (WARNING)
# - INVENTREE_TIMEZONE (UTC)
# - INVENTREE_ADMIN_URL (admin)
# - INVENTREE_LANGUAGE (en-us)
# - INVENTREE_BASE_URL (optional)
# - INVENTREE_AUTO_UPDATE (False)
# - INVENTREE_SITE_URL (optional)

. /scripts/lib.subr

INVENTREE_DEBUG="${INVENTREE_DEBUG:-True}"
INVENTREE_LOG_LEVEL="${INVENTREE_LOG_LEVEL:-WARNING}"
INVENTREE_TIMEZONE="${INVENTREE_TIMEZONE:-UTC}"
INVENTREE_ADMIN_URL="${INVENTREE_ADMIN_URL:-admin}"
INVENTREE_LANGUAGE="${INVENTREE_LANGUAGE:-en-us}"
INVENTREE_AUTO_UPDATE="${INVENTREE_AUTO_UPDATE:-False}"

info "Configuring debug -> ${INVENTREE_DEBUG}"
put -t bool -v "${INVENTREE_DEBUG}" debug

info "Configuring log_level -> ${INVENTREE_LOG_LEVEL}"
put -t string -v "${INVENTREE_LOG_LEVEL}" log_level

info "Configuring timezone -> ${INVENTREE_TIMEZONE}"
put -t string -v "${INVENTREE_TIMEZONE}" timezone

info "Configuring admin_url -> ${INVENTREE_ADMIN_URL}"
put -t string -v "${INVENTREE_ADMIN_URL}" admin_url

info "Configuring language -> ${INVENTREE_LANGUAGE}"
put -t string -v "${INVENTREE_LANGUAGE}" language

if [ -n "${INVENTREE_BASE_URL}" ]; then
    info "Configuring base_url -> ${INVENTREE_BASE_URL}"
    put -t string -v "${INVENTREE_BASE_URL}" base_url
fi

info "Configuring auto_update -> ${INVENTREE_AUTO_UPDATE}"
put -t bool -v "${INVENTREE_AUTO_UDPATE}" auto_update

if [ -n "${INVENTREE_SITE_URL}" ]; then
    info "Configuring site_url -> ${INVENTREE_SITE_URL}"
    put -t string -v "${INVENTREE_SITE_URL}" site_url
fi

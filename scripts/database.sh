#!/bin/sh

# Environment:
# - INVENTREE_DB_ENGINE (sqlite3)
# - INVENTREE_DB_NAME (/inventree/data/database.db)
# - INVENTREE_DB_USER (optional)
# - INVENTREE_DB_PASSWORD (optional)
# - INVENTREE_DB_HOST (optional)
# - INVENTREE_DB_PORT (optional)
#
# Environment (postgresql):
# - INVENTREE_DB_TIMEOUT (optional)
# - INVENTREE_DB_TCP_KEEPALIVES (optional)
# - INVENTREE_DB_TCP_KEEPALIVES_IDLE (optional)
# - INVENTREE_DB_TCP_KEEPALIVES_INTERNAL (optional)
# - INVENTREE_DB_TCP_KEEPALIVES_COUNT (optional)
# - INVENTREE_DB_ISOLATION_SERIALIZABLE (optional)
#
# Environment (MySQL):
# - INVENTREE_DB_ISOLATION_SERIALIZABLE (optional)

. /scripts/lib.subr

INVENTREE_DB_ENGINE="${INVENTREE_DB_ENGINE:-sqlite3}"
INVENTREE_DB_NAME="${INVENTREE_DB_NAME:-/inventree/data/database.db}"

info "Configuring database.ENGINE -> ${INVENTREE_DB_ENGINE}"
put -t string -v "${INVENTREE_DB_ENGINE}" database.ENGINE

info "Configuring database.NAME -> ${INVENTREE_DB_NAME}"
put -t string -v "${INVENTREE_DB_NAME}" database.NAME

if [ -n "${INVENTREE_DB_USER}" ]; then
    info "Configuring database.USER -> ${INVENTREE_DB_USER}"
    put -t string -v "${INVENTREE_DB_USER}" database.USER
fi

if [ -n "${INVENTREE_DB_PASSWORD}" ]; then
    info "Configuring database.PASSWORD -> ${INVENTREE_DB_PASSWORD}"
    put -t string -v "${INVENTREE_DB_PASSWORD}" database.PASSWORD
fi

if [ -n "${INVENTREE_DB_HOST}" ]; then
    info "Configuring database.HOST -> ${INVENTREE_DB_HOST}"
    put -t string -v "${INVENTREE_DB_HOST}" database.HOST
fi

if [ -n "${INVENTREE_DB_PORT}" ]; then
    info "Configuring database.PORT -> ${INVENTREE_DB_PORT}"
    put -t int -v "${INVENTREE_DB_PORT}" database.PORT
fi

if [ -n "${INVENTREE_DB_TIMEOUT}" ]; then
    info "Configuring database.timeout -> ${INVENTREE_DB_TIMEOUT}"
    put -t int -v "${INVENTREE_DB_TIMEOUT}" database.timeout
fi

if [ -n "${INVENTREE_DB_TCP_KEEPALIVES}" ]; then
    info "Configuring database.tcp_keepalives -> ${INVENTREE_DB_TCP_KEEPALIVES}"
    put -t int -v "${INVENTREE_DB_TCP_KEEPALIVES}" database.tcp_keepalives
fi

if [ -n "${INVENTREE_DB_TCP_KEEPALIVES_IDLE}" ]; then
    info "Configuring database.tcp_keepalives_idle -> ${INVENTREE_DB_TCP_KEEPALIVES_IDLE}"
    put -t int -v "${INVENTREE_DB_TCP_KEEPALIVES_IDLE}" database.tcp_keepalives_idle
fi

if [ -n "${INVENTREE_DB_TCP_KEEPALIVES_INTERNAL}" ]; then
    info "Configuring database.tcp_keepalives_internal -> ${INVENTREE_DB_TCP_KEEPALIVES_INTERNAL}"
    put -t int -v "${INVENTREE_DB_TCP_KEEPALIVES_INTERNAL}" database.tcp_keepalives_internal
fi

if [ -n "${INVENTREE_DB_TCP_KEEPALIVES_COUNT}" ]; then
    info "Configuring database.tcp_keepalives_count -> ${INVENTREE_DB_TCP_KEEPALIVES_COUNT}"
    put -t int -v "${INVENTREE_DB_TCP_KEEPALIVES_COUNT}" database.tcp_keepalives_count
fi

if [ -n "${INVENTREE_DB_ISOLATION_SERIALIZABLE}" ]; then
    info "Configuring database.serializable -> ${INVENTREE_DB_ISOLATION_SERIALIZABLE}"
    put -t bool -v "${INVENTREE_DB_ISOLATION_SERIALIZABLE}" database.serializable
fi

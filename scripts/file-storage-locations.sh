#!/bin/sh

# Environment:
# - INVENTREE_STATIC_ROOT (/inventree/data/static)
# - INVENTREE_MEDIA_ROOT (/inventree/data/media)
# - INVENTREE_BACKUP_DIR (/inventree/data/backup)

. /scripts/lib.subr

INVENTREE_STATIC_ROOT="${INVENTREE_STATIC_ROOT:-/inventree/data/static}"
INVENTREE_MEDIA_ROOT="${INVENTREE_MEDIA_ROOT:-/inventree/data/media}"
INVENTREE_BACKUP_DIR="${INVENTREE_BACKUP_DIR:-/inventree/data/backup}"

info "Configuring static_root -> ${INVENTREE_STATIC_ROOT}"
put -t string -v "${INVENTREE_STATIC_ROOT}" static_root

info "Configuring media_root -> ${INVENTREE_MEDIA_ROOT}"
put -t string -v "${INVENTREE_MEDIA_ROOT}" media_root

info "Configuring backup_dir -> ${INVENTREE_BACKUP_DIR}"
put -t string -v "${INVENTREE_BACKUP_DIR}" backup_dir

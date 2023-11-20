#!/bin/sh

# Environment:
# - INVENTREE_PLUGINS_ENABLED (False)
# - INVENTREE_PLUGIN_FILE (/inventree/data/plugins.txt)
# - INVENTREE_PLUGIN_DIR (/inventree/data/plugins/)
# - INVENTREE_PLUGIN_RETRY (5)

. /scripts/lib.subr

INVENTREE_PLUGINS_ENABLED="${INVENTREE_PLUGINS_ENABLED:-False}"
INVENTREE_PLUGIN_FILE="${INVENTREE_PLUGIN_FILE:-/inventree/data/plugins.txt}"
INVENTREE_PLUGIN_DIR="${INVENTREE_PLUGIN_DIR:-/inventree/data/plugins/}"
INVENTREE_PLUGIN_RETRY="${INVENTREE_PLUGIN_RETRY:-5}"

info "Configuring plugins_enabled -> ${INVENTREE_PLUGINS_ENABLED}"
put -t bool -v "${INVENTREE_PLUGINS_ENABLED}" plugins_enabled

info "Configuring plugin_file -> ${INVENTREE_PLUGIN_FILE}"
put -t string -v "${INVENTREE_PLUGIN_FILE}" plugin_file

info "Configuring plugin_dir -> ${INVENTREE_PLUGIN_DIR}"
put -t string -v "${INVENTREE_PLUGIN_DIR}" plugin_dir

info "Configuring PLUGIN_RETRY -> ${INVENTREE_PLUGIN_RETRY}"
put -t int -v "${INVENTREE_PLUGIN_RETRY}" PLUGIN_RETRY

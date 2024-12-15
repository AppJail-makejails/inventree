#!/bin/sh

BASEDIR=`dirname -- "$0"` || exit $?
BASEDIR=`realpath -- "${BASEDIR}"` || exit $?

. "${BASEDIR}/update.conf"

set -xe
set -o pipefail

cat -- "${BASEDIR}/Makejail.template" |\
    sed -Ee "s/%%TAG1%%/${TAG1}/g" > "${BASEDIR}/../Makejail"

cat -- "${BASEDIR}/build.makejail.template" |\
    sed -E \
        -e "s/%%VERSION%%/${VERSION}/g" \
        -e "s/%%PYVER%%/${PYVER}/g" > "${BASEDIR}/../build.makejail"

cat -- "${BASEDIR}/install-pillow.sh.template" |\
    sed -Ee "s/%%PYVER%%/${PYVER}/g" > "${BASEDIR}/../install-pillow.sh"

chmod +x "${BASEDIR}/../install-pillow.sh"

cat -- "${BASEDIR}/README.md.template" |\
    sed -E \
        -e "s/%%TAG1%%/${TAG1}/g" \
        -e "s/%%TAG2%%/${TAG2}/g" \
        -e "s/%%VERSION%%/${VERSION}/g" > "${BASEDIR}/../README.md"

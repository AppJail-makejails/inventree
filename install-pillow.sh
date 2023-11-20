#!/bin/sh

# Install py39-pillow just to install all its dependencies. pillow cannot be used from
# ports as the version does not match and conflicts with the one InvenTree expects.

set -e

appjail pkg jail "$1" install -y py39-pillow
appjail pkg jail "$1" query '%dn-%dv' py39-pillow | xargs -I % appjail pkg jail "$1" set -y -A0 %
appjail pkg jail "$1" delete -y py39-pillow

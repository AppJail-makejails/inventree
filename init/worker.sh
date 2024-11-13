#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/inventree/.local/bin; export PATH

cd /inventree/src/src/backend/InvenTree

daemon \
    -o /inventree/log/worker.log \
    -p /inventree/run/worker.pid \
    -t "InvenTree background worker" \
    python manage.py qcluster

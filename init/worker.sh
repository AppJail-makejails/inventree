#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/inventree/.local/bin; export PATH

cd /inventree/src/InvenTree

daemon -r \
    -o /inventree/log/worker.log \
    -P /inventree/run/master-worker.pid \
    -p /inventree/run/worker.pid \
    -t "InvenTree background worker" \
    python manage.py qcluster

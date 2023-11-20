#!/bin/sh

pidfile=/inventree/run/pid
pid=`pgrep -F "${pidfile}" 2> /dev/null`

echo -n ${pid}

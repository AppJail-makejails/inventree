#!/bin/sh

pid=`/inventree/init/get-pid.sh`

if [ -n "${pid}" ]; then
	echo "inventree is running as pid ${pid}."
	exit 0
else
	echo "inventree is not running."
	exit 1
fi

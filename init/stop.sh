#!/bin/sh

pidfile="/inventree/run/pid"
pid=`/inventree/init/get-pid.sh`

if [ -n "${pid}" ]; then
	echo "Stopping inventree."

	kill ${pid}

	pid=`/inventree/init/get-pid.sh`

	if [ -z "${pid}" ]; then
		exit 0
	fi

	echo "Waiting for PID: ${pid}."
	
	while sleep 1; do
		pid=`/inventree/init/get-pid.sh`

		if [ -n "${pid}" ]; then
			kill ${pid}
		else
			break
		fi
	done
else
	echo "inventree not running? (check ${pidfile})."
fi

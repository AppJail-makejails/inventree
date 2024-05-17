#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/inventree/.local/bin; export PATH

inventree_src="/inventree/src/src/backend"
inventree_srvdir="${inventree_src}/InvenTree"
inventree_logdir="/inventree/log"
inventree_tmpdir="/inventree/run"
pid=`/inventree/init/get-pid.sh`

if [ -n "${pid}" ]; then
	echo "inventree is running as pid ${pid}."
	exit 0
fi

echo "Starting inventree."

if [ ! -d "${inventree_logdir}" ]; then
	install -d -o inventree -g inventree -m 0750 "${inventree_logdir}"
fi

if [ ! -d "${inventree_tmpdir}" ]; then
	install -d -o inventree -g inventree -m 0750 "${inventree_tmpdir}"
fi

gunicorn \
	--daemon \
	--config "${inventree_srvdir}/gunicorn.conf.py" \
	--chdir "${inventree_srvdir}" \
	--user inventree \
	--group inventree \
	--env "INVENTREE_CONFIG_FILE=${inventree_srvdir}/config.yaml" \
	--pid "${inventree_tmpdir}/pid" \
	--worker-tmp-dir "${inventree_tmpdir}" \
	--error-logfile "${inventree_logdir}/error.log" \
	--access-logfile "${inventree_logdir}/access.log" \
	InvenTree.wsgi

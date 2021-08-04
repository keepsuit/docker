#!/bin/sh

if [ $# -ne 0 ]; then
	$@
	exit 0;
fi

set -e

ln -sf /etc/services-available/nginx /etc/services.d/nginx
ln -sf /etc/services-available/octane /etc/services.d/octane
ln -sf /etc/nginx/sites-available/octane.conf /etc/nginx/sites-enabled/default.conf

/init
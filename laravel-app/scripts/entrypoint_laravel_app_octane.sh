#!/bin/sh

if [ $# -ne 0 ]; then
	$@
	exit 0;
fi

set -e

/scripts/reset_services.sh

ln -sf /etc/services-available/octane /etc/services.d/octane

/init
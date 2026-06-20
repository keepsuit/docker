#!/bin/sh

set -e

SUPERCRONIC_CRONTAB="/tmp/crontab"

# If command is "php artisan schedule:work", we override it with supercronic
if [ "$1" = "php" ] && [ "$2" = "artisan" ] && [ "$3" = "schedule:work" ]; then
	cat >"$SUPERCRONIC_CRONTAB" <<EOF
* * * * * cd "$APP_BASE_DIR" && php artisan schedule:run --no-interaction 2>&1 | grep -v "No scheduled commands are ready to run"
EOF

	echo "/usr/local/bin/supercronic -quiet -passthrough-logs $SUPERCRONIC_CRONTAB" >/tmp/docker_cmd_override
fi

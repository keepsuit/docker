#!/bin/sh

set -e

SUPERCRONIC_CRONTAB="/tmp/crontab"

# shellcheck source=/usr/local/lib/docker-laravel-scheduler
. /usr/local/lib/docker-laravel-scheduler

# If command is "php artisan schedule:work", we override it with supercronic
if [ "$1" = "php" ] && [ "$2" = "artisan" ] && [ "$3" = "schedule:work" ]; then
	scheduler_command="$(schedule_run_command)"

	cat >"$SUPERCRONIC_CRONTAB" <<EOF
* * * * * cd "$APP_BASE_DIR" && $scheduler_command
EOF

	echo "/usr/local/bin/supercronic -quiet -passthrough-logs $SUPERCRONIC_CRONTAB" >/tmp/docker_cmd_override
fi

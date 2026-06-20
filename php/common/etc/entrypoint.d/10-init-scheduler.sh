#!/bin/sh

set -e

# If command is "php artisan schedule:work", we override it with supercronic
if [ "$1" = "php" ] && [ "$2" = "artisan" ] && [ "$3" = "schedule:work" ]; then
    crontab="/tmp/crontab"

    cat > "$crontab" <<EOF
* * * * * cd "$APP_BASE_DIR" && php artisan schedule:run --no-interaction 2>&1 | grep -v "No scheduled commands are ready to run"
EOF

    echo "/usr/local/bin/supercronic -quiet -passthrough-logs $crontab" > /tmp/docker_cmd_override
fi

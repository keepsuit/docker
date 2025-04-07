#!/bin/sh

set -e

# If command is "php artisan schedule:work", we override it with supercronic
if [ "$1" = "php" ] && [ "$2" = "artisan" ] && [ "$3" = "schedule:work" ]; then
    echo "* * * * * cd $APP_BASE_DIR && php artisan schedule:run" > /tmp/crontab

    cat /tmp/crontab

    echo "/usr/local/bin/supercronic /tmp/crontab" > /tmp/docker_cmd_override
fi

#!/bin/sh

if [ $# -ne 0 ]; then
  $@
  exit 0
fi

set -e

/scripts/runtime_cache.sh

supercronic /etc/supercronic/crontab

#!/bin/sh

if [ $# -ne 0 ]; then
  $@
  exit 0
fi

set -e

/scripts/reset_services.sh

ln -sf /etc/services-available/grpc /etc/services.d/grpc

/init

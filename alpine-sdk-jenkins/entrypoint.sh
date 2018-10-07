#!/bin/sh
set -e

PUID=$(id -u)
PGID=$(id -g)
su-exec root sh -c "usermod -u $PUID sdk"
su-exec root sh -c "groupmod -g $PGID sdk"
su-exec root sh -c "chown -R sdk:sdk /home/sdk"
exec "$@"

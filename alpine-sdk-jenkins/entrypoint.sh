#!/bin/sh
PUID=$(id -u)
PGID=$(id -g)
su-exec root sh -c "usermod -u $PUID sdk"
su-exec root sh -c "groupmod -g $PGID sdk"
exec "$@"

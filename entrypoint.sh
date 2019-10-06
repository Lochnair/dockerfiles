#!/bin/sh

groupmod -g "$DAEMON_GID" smtpd
usermod -u "$DAEMON_UID" smtpd

groupmod -g "$QUEUE_GID" smtpq
usermod -u "$QUEUE_UID" smtpq
chown -R smtpq:smtpq /var/spool/smtpd

test -f /etc/smtpd/smtpd.conf || cp -v /etc/smtpd.dist/smtpd.conf /etc/smtpd/
test -f /etc/smtpd/aliases || cp -v /etc/smtpd.dist/aliases /etc/smtpd/

exec "$@"

#!/bin/sh

groupmod -g "$DAEMON_GID" smtpd
usermod -u "$DAEMON_UID" smtpd

groupmod -g "$QUEUE_GID" smtpq
usermod -u "$QUEUE_UID" smtpq

mkdir -p /var/spool/smtpd
mkdir -p /var/spool/smtpd/purge
mkdir -p /var/spool/smtpd/queue
mkdir -p /var/spool/smtpd/corrupt
mkdir -p /var/spool/smtpd/offline

chown -R root.root /var/spool/smtpd
chmod 0711 /var/spool/smtpd
chown -R smtpd.root /var/spool/smtpd/purge /var/spool/smtpd/queue /var/spool/smtpd/corrupt
chmod 0700 /var/spool/smtpd/purge
chown -R root.smtpq /var/spool/smtpd/offline
chmod 0770 /var/spool/smtpd/offline
chmod 0700 /var/spool/smtpd/queue /var/spool/smtpd/corrupt

test -f /etc/smtpd/smtpd.conf || cp -v /etc/smtpd.dist/smtpd.conf /etc/smtpd/
test -f /etc/smtpd/aliases || cp -v /etc/smtpd.dist/aliases /etc/smtpd/

exec "$@"

FROM alpine:3.21

ARG PUID 102
ARG PGID 104

RUN apk add --no-cache --update alpine-sdk autoconf doas su-exec sudo cmake meson ninja-build argp-standalone gdb && \
    chmod +s /sbin/su-exec && \
    addgroup -g $PGID sdk && \
    adduser -G sdk -u $PUID -s /bin/sh -D sdk && \
    echo "sdk    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "permit nopass keepenv :sdk" > /etc/doas.d/sdk.conf && \
    chmod g+w /var/cache/distfiles && \
    addgroup sdk abuild

USER sdk
WORKDIR /home/sdk

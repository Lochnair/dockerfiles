FROM alpine:3.21

RUN apk add --no-cache --update alpine-sdk autoconf doas su-exec sudo cmake meson ninja-build argp-standalone gdb && \
    chmod +s /sbin/su-exec && \
    addgroup sdk && \
    adduser -G sdk -s /bin/sh -D sdk && \
    echo "sdk    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "permit nopass keepenv :sdk" > /etc/doas.d/sdk.conf && \
    chmod g+w /var/cache/distfiles && \
    addgroup sdk abuild

USER sdk
WORKDIR /home/sdk

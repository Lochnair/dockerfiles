FROM alpine:edge

RUN apk add --no-cache --update alpine-sdk autoconf su-exec
RUN chmod +s /sbin/su-exec
RUN addgroup sdk
RUN adduser -G sdk -s /bin/sh -D sdk
RUN echo "sdk    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN chmod g+w /var/cache/distfiles
RUN addgroup sdk abuild
USER sdk
WORKDIR /home/sdk
RUN git clone --recursive https://github.com/alpinelinux/aports.git


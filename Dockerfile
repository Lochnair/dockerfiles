FROM alpine:3.10 as builder

RUN apk update
RUN apk add alpine-sdk
RUN adduser -D sdk
RUN addgroup sdk abuild
RUN echo 'sdk ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN mkdir -p /var/cache/distfiles
RUN chgrp abuild /var/cache/distfiles
RUN chmod g+w /var/cache/distfiles

USER sdk

WORKDIR /home/sdk
RUN abuild-keygen -a -i
RUN git clone https://git.alpinelinux.org/aports

WORKDIR /home/sdk/aports/main/opensmtpd
RUN abuild -r

WORKDIR /home/sdk/aports/testing/opensmtpd-extras
RUN abuild -r

FROM alpine:3.10

ENV DAEMON_UID=200
ENV DAEMON_GID=200
ENV QUEUE_UID=300
ENV QUEUE_GID=300

COPY --from=builder /home/sdk/packages /etc/apk/packages
COPY --from=builder /etc/apk/keys /etc/apk/keys/

RUN apk add --no-cache --repository /etc/apk/packages/main opensmtpd
RUN apk add --no-cache --repository /etc/apk/packages/testing opensmtpd-extras
RUN apk add shadow

RUN cp -rv /etc/smtpd /etc/smtpd.dist

VOLUME /etc/smtpd
VOLUME /var/spool/smtpd

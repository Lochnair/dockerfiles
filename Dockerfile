FROM alpine:3.10 as builder

RUN apk add --no-cache --update alpine-sdk
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
USER root
RUN apk update
USER sdk
WORKDIR /home/sdk/aports/main/opensmtpd
RUN abuild -r
WORKDIR /home/sdk/aports/testing/opensmtpd-extras
RUN abuild -r

FROM alpine:3.10

ENV PUID=200
ENV PGID=200

COPY --from=builder /home/sdk/packages /etc/apk/packages
COPY --from=builder /etc/apk/keys /etc/apk/keys/
RUN apk add --repository /etc/apk/packages/main opensmtpd
RUN apk add --repository /etc/apk/packages/testing opensmtpd-extras

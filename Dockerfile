FROM alpine:3.10

ARG OPENSMTPD_VERSION=6.4.2p1
ARG EXTRAS_VERSION=6.4.0

RUN apk add --virtual .build-dependencies \
			automake \
			autoconf \
			libtool \
			mdocml \
			db-dev \
			libasr-dev \
			libevent-dev \
			fts-dev \
			zlib-dev \
			libressl-dev \
			bison \
			flex-dev \
			mariadb-connector-c-dev \
			postgresql-dev \
			hiredis-dev \
			sqlite-dev \
			wget && \
    cd /tmp && \
    wget https://www.opensmtpd.org/archives/opensmtpd-${OPENSMTPD_VERSION}.tar.gz && \
    wget https://www.opensmtpd.org/archives/opensmtpd-extras-${EXTRAS_VERSION}.tar.gz && \
    tar xf opensmtpd-${OPENSMTPD_VERSION}.tar.gz && \
    tar xf opensmtpd-extras-${EXTRAS_VERSION}.tar.gz

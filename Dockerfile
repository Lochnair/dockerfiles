FROM debian:buster

RUN apt-get update && \
    apt-get -y install build-essential curl debhelper wget && \
    rm -rf /var/lib/apt/lists/*

RUN \
wget https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c && \
gcc -o /usr/bin/su-exec su-exec.c && \
rm su-exec.c && \
chmod +s /usr/bin/su-exec && \
chmod 777 /tmp

COPY root/ /
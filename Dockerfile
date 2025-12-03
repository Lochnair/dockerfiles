FROM debian:trixie

COPY root/ /

RUN rm -fv /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install bc build-essential curl debhelper flex git libncurses-dev libssl-dev python3-dev unzip wget zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

RUN \
wget https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c && \
gcc -o /usr/bin/su-exec su-exec.c && \
rm su-exec.c && \
chmod +s /usr/bin/su-exec && \
chmod 777 /tmp


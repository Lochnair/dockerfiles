FROM debian:stretch-slim

RUN echo $' \n\
    deb http://archive.debian.org/debian/ stretch main contrib non-free
    deb http://archive.debian.org/debian/ stretch-proposed-updates main contrib non-free
    deb http://archive.debian.org/debian-security stretch/updates main contrib non-free' > /etc/apt/sources.list && \
    dpkg --add-architecture mipsel && \
    apt-get update && \
    apt-get -y install build-essential curl dpkg-cross g++-mipsel-linux-gnu git wget && \
    wget https://deb.freexian.com/extended-lts/pool/main/f/freexian-archive-keyring/freexian-archive-keyring_2022.06.08_all.deb && \
    dpkg -i freexian-archive-keyring_2022.06.08_all.deb && \
    echo 'deb http://deb.freexian.com/extended-lts stretch-lts main contrib non-free' >> /etc/apt/sources.list && \
    apt-get -y dist-upgrade && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c && \
    gcc -o /usr/bin/su-exec su-exec.c && \
    rm su-exec.c && \
    chmod +s /usr/bin/su-exec && \
    chmod 777 /tmp

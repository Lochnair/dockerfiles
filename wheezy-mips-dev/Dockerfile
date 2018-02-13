FROM lochnair/wheezy-mips:latest

COPY root/ /

RUN apt-get update && \
apt-get install -y build-essential flex bison bc git && \
apt-get build-dep -y linux && \
rm -rf /var/lib/apt/lists/*

RUN \
wget https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c && \
gcc -o /usr/bin/su-exec su-exec.c && \
rm su-exec.c && \
chmod +s /usr/bin/su-exec && \
chmod 777 /tmp

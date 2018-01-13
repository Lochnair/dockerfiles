FROM lochnair/wheezy-mips:latest

COPY root/ /

RUN apt-get update && \
apt-get install build-essential flex bison bc git && \
apt-get build-dep linux && \
rm -rf /var/lib/apt/lists/*

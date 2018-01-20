FROM lochnair/wheezy-mipsel:latest

COPY root/ /

RUN apt-get update && \
apt-get install -y build-essential flex bison bc git && \
apt-get build-dep -y linux && \
rm -rf /var/lib/apt/lists/*

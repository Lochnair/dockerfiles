FROM lochnair/wheezy-mipsel-dev:latest

RUN \
apt-get update && \
apt-get -y install libmnl-dev pkg-config && \
rm -rf /var/lib/apt/lists/*

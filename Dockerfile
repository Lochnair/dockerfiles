FROM lochnair/wheezy-mips-dev:latest

RUN apt-get update && \
    apt-get -y -t wheezy-backports install autoconf automake bzip2 debhelper dh-autoreconf graphviz libssl-dev libtool openssl procps python-all python-six python-twisted-conch python-zopeinterface && \
    rm -rf /var/lib/apt/lists/*

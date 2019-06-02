FROM lochnair/mtk-buildenv:latest

RUN \
apt-get update && \
apt-get --allow-unauthenticated -y install autoconf automake bzip2 cpio debhelper dh-autoreconf graphviz libssl-dev libtool module-assistant openssl procps python-all python-six python-twisted-conch python-zopeinterface && \
rm -rf /var/lib/apt/lists/* && \
chmod -R 777 /tmp && \
sed -i 's/PKGARCH =/PKGARCH ?=/' /usr/share/modass/include/generic.make

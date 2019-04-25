FROM lochnair/buildenv-base:debian
LABEL Description="Build environment for Octeon-based devices"
LABEL Maintainer="Nils Andreas Svee <me@lochnair.net>"

ENV PATH="/opt/cross/bin:${PATH}"

COPY root/ /

RUN /build_toolchain.sh
RUN \
wget https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c && \
gcc -o /usr/bin/su-exec su-exec.c && \
rm su-exec.c && \
chmod +s /usr/bin/su-exec && \
chmod 777 /tmp

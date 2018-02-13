FROM lochnair/buildenv-base:debian

LABEL Description="Build environment for EdgeRouter X kernel development"
LABEL Maintainer="Nils Andreas Svee <me@lochnair.net>"

ARG BINUTILS_VER=2.29.1
ARG GCC_VER=4.8.5
ARG GMP_VER=6.1.2
ARG ISL_VER=0.18
ARG MPC_VER=1.0.3
ARG MPFR_VER=3.1.5

ARG TARGET=mipsel-mtk-linux

ENV PATH="/opt/cross/bin:${PATH}"

COPY root/ /

RUN chmod +x /build_toolchain.sh && /build_toolchain.sh && \
wget https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c && \
gcc -o /usr/bin/su-exec su-exec.c && \
rm su-exec.c && \
chmod +s /usr/bin/su-exec && \
chmod 777 /tmp

FROM lochnair/base-buildenv:latest

LABEL Description="musl build environment for MIPSel"
LABEL Maintainer="Nils Andreas Svee <me@lochnair.net>"

ARG BINUTILS_VER=2.31.1
ARG GCC_VER=8.2.0
ARG GMP_VER=6.1.2
ARG ISL_VER=0.19
ARG KERNEL_VER=4.14.29
ARG MPC_VER=1.1.0
ARG MPFR_VER=4.0.1
ARG MUSL_VER=1.1.20

ARG ARCH=mips

ENV PATH="/opt/cross/bin:${PATH}"
ENV TARGET="$ARCH-linux-musl"

COPY root/ /

RUN /build_toolchain.sh

FROM lochnair/base-buildenv:latest

LABEL Description="musl build environment for MIPSel"
LABEL Maintainer="Nils Andreas Svee <me@lochnair.net>"

ARG BINUTILS_VER=2.32
ARG GCC_VER=9.1.0
ARG GMP_VER=6.1.2
ARG ISL_VER=0.19
ARG KERNEL_VER=4.19.47
ARG MPC_VER=1.1.0
ARG MPFR_VER=4.0.2
ARG MUSL_VER=1.1.22

ENV PATH="/opt/cross/bin:${PATH}"

COPY root/ /

ONBUILD RUN /build_toolchain.sh

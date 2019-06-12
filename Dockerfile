FROM lochnair/base-buildenv:latest

LABEL Description="musl build environment for MIPSel"
LABEL Maintainer="Nils Andreas Svee <me@lochnair.net>"

ENV BINUTILS_VER=2.32
ENV GCC_VER=8.3.0
ENV GMP_VER=6.1.2
ENV ISL_VER=0.19
ENV KERNEL_VER=4.19.47
ENV MPC_VER=1.1.0
ENV MPFR_VER=4.0.2
ENV MUSL_VER=1.1.22

ENV PATH="/opt/cross/bin:${PATH}"

COPY root/ /

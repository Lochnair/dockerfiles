FROM lochnair/musl-buildenv:latest

LABEL Description="musl build environment for MIPS/MIPSel"
LABEL Maintainer="Nils Andreas Svee <me@lochnair.net>"

ENV ARCH=mipsel
ENV TARGET="$ARCH-linux-musl"

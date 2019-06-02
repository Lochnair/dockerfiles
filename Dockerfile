ARG ARCH=mips
ARG TARGET="$ARCH-linux-musl"
FROM lochnair/musl-buildenv:latest

LABEL Description="musl build environment for MIPS/MIPSel"
LABEL Maintainer="Nils Andreas Svee <me@lochnair.net>"

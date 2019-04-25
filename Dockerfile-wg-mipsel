FROM lochnair/musl-buildenv:mipsel

WORKDIR /usr/src
RUN \
wget -nv https://netfilter.org/projects/libmnl/files/libmnl-1.0.4.tar.bz2 && \
tar -xvf libmnl-1.0.4.tar.bz2 && \
cd libmnl-1.0.4 && \
CC="mipsel-linux-musl-gcc" ./configure --prefix=/opt/cross/mipsel-linux-musl --enable-shared --enable-static --host=x86_64-alpine-linux-musl && \
make -j$(nproc) && \
make install && \
cd /root && \
rm -rf /usr/src/*

FROM debian:stretch as qemu
ARG QEMU_VER=2.11.1
COPY sources.list /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y build-dep qemu
RUN apt-get -y install ca-certificates git
RUN git clone https://git.qemu.org/git/qemu.git
WORKDIR /qemu
RUN git checkout "tags/v$QEMU_VER" -b "stable-$QEMU_VER"
RUN git config --global user.email "builder@docker" && git config --global user.name "Docker Builder"
RUN wget -O- https://gist.githubusercontent.com/Lochnair/8aac1b6315649e09fb2062768e400800/raw/699d9ffbac8527fdbbfd7339a067ccee6928545e/linux-user-add-option-to-intercept-execve-syscalls.patch | git am
RUN ./configure \
        --target-list=mips-linux-user \
        --static \
        --disable-bluez \
        --disable-capstone \
        --disable-curses \
        --disable-gcrypt \
        --disable-kvm \
        --disable-libssh2 \
        --disable-slirp \
        --disable-smartcard \
        --disable-system \
        --disable-tools \
        --disable-vde \
        --disable-vnc \
        --disable-werror
RUN make
RUN file mips-linux-user/qemu-mips

FROM debian:stretch as bootstrap
RUN apt-get update && \
    apt-get -y install debootstrap
COPY --from=qemu /qemu/mips-linux-user/qemu-mips /usr/bin/qemu-mips-static
COPY --from=qemu /qemu/mips-linux-user/qemu-mips /bootstrap/usr/bin/qemu-mips-static
RUN qemu-mips-static --help
RUN debootstrap --arch mips --foreign stretch /bootstrap
RUN chroot /bootstrap /usr/bin/qemu-mips-static -execve /usr/bin/qemu-mips-static /debootstrap/debootstrap --second-stage

FROM scratch
COPY --from=bootstrap /bootstrap/. /
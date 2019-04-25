FROM lochnair/alpine-sdk:latest AS qemubuilder
USER sdk
WORKDIR /home/sdk
RUN git clone https://github.com/resin-io/qemu.git -b resin-3.0.0
WORKDIR /home/sdk/qemu
RUN sudo apk add bison flex glib-dev glib-static linux-headers musl-dev python zlib-dev
RUN sed -i 's/^VL_LDFLAGS=$/VL_LDFLAGS=-Wl,-z,execheap/' Makefile.target
RUN wget -O- https://git.alpinelinux.org/cgit/aports/plain/main/qemu/musl-F_SHLCK-and-F_EXLCK.patch | patch -p1
RUN wget -O- https://dl.lochnair.net/linux-user-signal.c-define-__SIGRTMIN-MAX-for-non-GN.patch | patch -p1
RUN wget -O- https://git.alpinelinux.org/cgit/aports/plain/main/qemu/fix-sigevent-and-sigval_t.patch | patch -p1
RUN ./configure \
	--prefix=/usr \
	--localstatedir=/var \
	--sysconfdir=/etc \
	--libexecdir=/usr/lib/qemu \
	--disable-glusterfs \
	--disable-debug-info \
	--disable-bsd-user \
	--disable-werror \
	--disable-xen \
	--disable-kvm \
	--disable-seccomp \
	--cc="${CC:-gcc}" \
	--enable-linux-user \
	--disable-system \
	--static \
	--disable-sdl \
	--disable-gtk \
	--disable-spice \
	--disable-tools \
	--disable-guest-agent \
	--disable-guest-agent-msi \
	--disable-curses \
	--disable-curl \
	--disable-gnutls \
	--disable-gcrypt \
	--disable-nettle \
	--disable-cap-ng \
	--disable-brlapi \
	--disable-mpath \
	--disable-libnfs \
	--disable-capstone \
	--target-list=mips64-linux-user
RUN make ARFLAGS="rc" -j7

FROM lochnair/alpine-sdk:latest AS imgbuilder
USER root
COPY --from=qemubuilder /home/sdk/qemu/mips64-linux-user/qemu-mips64 /usr/bin/qemu-mips64
RUN install -v -Dm 755 /usr/bin/qemu-mips64 /img/usr/bin/qemu-mips64
USER sdk
WORKDIR /home/sdk/aports
RUN git pull --recurse-submodules
RUN abuild-keygen -a -i
RUN sed -i 's/^KERNEL_PKG=.*/KERNEL_PKG=""/' /home/sdk/aports/scripts/bootstrap.sh
RUN sed -i 's|community/go ||' /home/sdk/aports/scripts/bootstrap.sh
RUN sudo sed -i 's/JOBS=2/JOBS=8/' /etc/abuild.conf
RUN sudo apk update
RUN sudo apk add python
RUN wget -O- https://dl.lochnair.net/main-libffi-add-patch-fixing-compilation-issue-with-.patch | patch -p1
RUN /home/sdk/aports/scripts/bootstrap.sh mips64
USER root
RUN echo kek
RUN apk --repository "/home/sdk/packages/main" --root "/img/" --keys-dir /etc/apk/keys add --arch mips64 --initdb alpine-base
RUN cp -R -v /etc/apk/keys/. /img/etc/apk/keys/

FROM scratch
COPY --from=imgbuilder /img/. /
ENTRYPOINT ["/usr/bin/qemu-mips64", "-execve"]
CMD ["/bin/sh"]

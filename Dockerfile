FROM archlinux/base

RUN pacman -Syu --noconfirm --noprogressbar python-gitpython python-natsort python-requests && \
    rm -v /var/lib/pacman/sync/*

COPY rootfs/ /

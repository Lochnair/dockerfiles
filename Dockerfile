FROM archlinux/base

RUN pacman -Syu --noconfirm --noprogressbar python-gitpython && \
    rm -v /var/lib/pacman/sync/*

COPY rootfs/ /

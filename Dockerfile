FROM debian:trixie

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture arm64
    apt-get clean && apt-get update && \
    apt-get install -y \
    git bc sshfs bison flex libssl-dev python3 make kmod libc6-dev libncurses5-dev \
    crossbuild-essential-armhf \
    crossbuild-essential-arm64 \
    libssl-dev:arm64 \
    wget curl

RUN mkdir -p /root/.ssh
RUN chmod 644 /root/.ssh

RUN mkdir /build

WORKDIR /build

CMD ["bash"]

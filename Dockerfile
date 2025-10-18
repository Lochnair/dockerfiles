FROM --platform=linux/arm64/v8 debian:trixie
ENV DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get clean && apt-get update && \
    apt-get install -y \
    git bc sshfs bison flex libssl-dev python3 make kmod libc6-dev libncurses5-dev build-essential \
    libssl-dev \
    wget curl file

RUN mkdir -p /root/.ssh
RUN chmod 644 /root/.ssh

RUN mkdir /build

WORKDIR /build

CMD ["bash"]

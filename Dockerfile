FROM alpine:3.9

# Install build dependencies
RUN apk add --no-cache \
        --update-cache \
        autoconf \
        automake \
        bc \
        bison \
        build-base \
        coreutils \
        curl \
        file \
        flex \
        gawk \
        git \
        gmp-dev \
        libtool \
        linux-headers \
        mpc1-dev \
        mpfr-dev \
        shadow \
        su-exec \
        texinfo \
        wget

# Let any user elevate to root
RUN chmod +s /sbin/su-exec

# Fix /tmp permissions
RUN chmod 777 /tmp

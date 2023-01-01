FROM wonderfall/nextcloud AS base
USER root
RUN \
  apk add -t build-deps --no-cache --update autoconf build-base imagemagick-dev \
  && apk add --no-cache --update ffmpeg imagemagick-libs \
  && pecl install imagick \
  && docker-php-ext-install -j "$(nproc)" \
      imagick \
  && apk del build-deps
USER nextcloud

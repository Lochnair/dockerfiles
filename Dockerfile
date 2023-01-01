FROM wonderfall/nextcloud AS base
USER root
RUN \
  apk add --no-cache --update automake ffmpeg imagemagick-dev \
  && pecl install imagick \
  && docker-php-ext-install -j "$(nproc)" \
      imagick
USER nextcloud

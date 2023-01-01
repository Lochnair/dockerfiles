FROM wonderfall/nextcloud AS base
RUN \
  apk add --no-cache --update ffmpeg
  && docker-php-ext-install -j "$(nproc)" \
      imagick

FROM wonderfall/nextcloud AS base
USER root
RUN \
  apk add --no-cache --update ffmpeg \
  && docker-php-ext-install -j "$(nproc)" \
      imagick
USER nextcloud

FROM alpine:latest

RUN apk add --no-cache --update \
        git \
        libpng-dev \
        yarn
RUN yarn global add hexo-cli
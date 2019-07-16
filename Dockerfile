FROM alpine:latest

RUN apk add --no-cache --update \
        git \
        yarn
RUN yarn global add hexo-cli
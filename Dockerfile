FROM alpine:latest

RUN apk add --no-cache --update \
        yarn
RUN yarn install hexo-cli
FROM alpine:latest

RUN apk add --no-cache --update \
        yarn
RUN yarn global add hexo-cli
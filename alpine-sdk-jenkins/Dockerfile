FROM lochnair/alpine-sdk:latest
USER root
RUN apk add --no-cache --update shadow su-exec
RUN chmod +s /sbin/su-exec
USER sdk
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh"]

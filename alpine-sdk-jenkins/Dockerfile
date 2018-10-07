FROM lochnair/alpine-sdk:latest
USER root
RUN apk add --no-cache --update shadow su-exec
RUN chmod +s /sbin/su-exec
RUN usermod -u 107 sdk
RUN groupmod -g 111 sdk
RUN chown -R sdk:sdk /home/sdk
USER sdk
CMD ["/bin/sh"]

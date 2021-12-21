FROM lochnair/alpine-sdk:latest
USER root
RUN apk add --no-cache --update shadow su-exec
RUN chmod +s /sbin/su-exec
RUN usermod -u 1000 sdk
RUN groupmod -g 1000 sdk
RUN chown -R sdk:sdk /home/sdk
RUN usermod -aG abuild sdk
USER sdk
CMD ["/bin/sh"]

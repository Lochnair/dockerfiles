FROM debian:jessie

COPY root/ /

RUN /tmp/build_env.sh
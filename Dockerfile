FROM alpine:3.8

RUN apk add --no-cache --update \
	py3-pip
RUN pip3 install mkdocs
RUN pip3 install mkdocs-windmill
RUN pip3 install Pygments

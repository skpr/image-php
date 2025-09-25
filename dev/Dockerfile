FROM base
ARG PHP_VERSION=8.0

ARG ARCH=amd64

USER root

RUN apk --update --no-cache add \
      php${PHP_VERSION}-xdebug \
      php${PHP_VERSION}-spx

COPY --chown=skpr:skpr etc /etc

ENV PHP_FPM_REQUEST_TIMEOUT=600

RUN mkdir -p /tmp/xdebug && \
    chown -R skpr:skpr /tmp/xdebug
VOLUME /tmp/xdebug

USER skpr


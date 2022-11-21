ARG IMAGE=skpr/php:8.0-1.x
FROM ${IMAGE}
ARG PHP_VERSION=8.0

ARG ARCH=amd64

USER root

RUN apk add php${PHP_VERSION}-xdebug

# https://blog.blackfire.io/alpine-linux-support.html
RUN curl -sSL -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/${ARCH}/${PHP_VERSION//./} && \
    mkdir -p /tmp/blackfire && \
    tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire && \
    mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so && \
    rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

COPY --chown=skpr:skpr conf.d /etc/php/conf.d

ENV PHP_FPM_REQUEST_TIMEOUT 600

VOLUME /tmp/xdebug
RUN chown -R skpr:skpr /tmp/xdebug

USER skpr


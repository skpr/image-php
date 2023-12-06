ARG IMAGE=skpr/php:8.0-1.x
FROM ${IMAGE}
ARG PHP_VERSION=8.0

ARG ARCH=amd64

USER root

RUN apk --update --no-cache add \
      php${PHP_VERSION}-xdebug

# @todo remove when spx is available for php 8.3.
RUN if [ "$PHP_VERSION" != "8.3" ]; then apk --update --no-cache add php${PHP_VERSION}-spx; fi

# https://blog.blackfire.io/alpine-linux-support.html
RUN if [ "$PHP_VERSION" != "8.3" ]; then \
        curl -sSL -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/${ARCH}/${PHP_VERSION//./} && \
        mkdir -p /tmp/blackfire && \
        tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire && \
        mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so && \
        rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz; \
    fi

COPY --chown=skpr:skpr etc /etc

# @todo remove when spx is available for php 8.3.
RUN if [ "$PHP_VERSION" == "8.3" ]; then rm /etc/php/conf.d/01_spx.ini /etc/php/php-fpm.d/spx.conf /etc/php/conf.d/01_blackfire.ini; fi

ENV PHP_FPM_REQUEST_TIMEOUT 600

RUN mkdir -p /tmp/xdebug && \
    chown -R skpr:skpr /tmp/xdebug
VOLUME /tmp/xdebug

USER skpr


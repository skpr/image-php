ARG IMAGE=skpr/php:8.0-1.x
FROM ${IMAGE}

ARG ARCH=amd64

USER root

# https://blog.blackfire.io/alpine-linux-support.html
RUN curl -sSL -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/${ARCH}/$PHP_VERSION && \
    mkdir -p /tmp/blackfire && \
    tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire && \
    mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so && \
    rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

COPY conf.d/01_blackfire.ini /etc/php/conf.d/01_blackfire.ini
COPY conf.d/50_dev.ini /etc/php/conf.d/50_dev.ini

ENV PHP_FPM_REQUEST_TIMEOUT 600

USER skpr

ARG IMAGE=skpr/php:8.0-1.x
FROM ${IMAGE}

ARG PHP_VERSION=8.0

USER root
RUN apk add php${PHP_VERSION}-xdebug
USER skpr

COPY conf.d/01_xdebug.ini /etc/php/conf.d/01_xdebug.ini
ENV PHP_FPM_REQUEST_TIMEOUT 600

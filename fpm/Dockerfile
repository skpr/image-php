ARG IMAGE=skpr/php:8.0-1.x
FROM ${IMAGE}
ARG PHP_VERSION=8.0

RUN apk --update --no-cache add \
      php${PHP_VERSION}-fpm

COPY conf.d/50_fpm.ini /etc/php/conf.d/50_fpm.ini
COPY php-fpm.conf /etc/php/php-fpm.conf

# Ensure the FPM configuration directory is empty.
# Create an empty file to ensure there are no warnings.
RUN rm -f /etc/php/php-fpm.d/*.conf && \
    touch /etc/php/php-fpm.d/empty.conf

EXPOSE 9000

USER skpr

# Configuration which can be overriden.
# See /etc/php/php-fpm.conf
ENV PHP_FPM_PORT=9000 \
    PHP_FPM_LOG_LIMIT=32768 \
    PHP_FPM_MAX_CHILDREN=20 \
    PHP_FPM_START_SERVERS=2 \
    PHP_FPM_MIN_SPARE_SERVERS=2 \
    PHP_FPM_MAX_SPARE_SERVERS=10 \
    PHP_FPM_MAX_REQUESTS=500 \
    PHP_FPM_REQUEST_TIMEOUT=60

CMD ["php-fpm", "-F"]

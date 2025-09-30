FROM from_image AS base
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

# Run the test stage to verify the image.
FROM base AS test
COPY --from=ghcr.io/goss-org/goss:latest /usr/bin/goss /usr/bin/goss
ADD goss.yml /tmp/goss.yml
RUN goss --gossfile /tmp/goss.yml validate

# The final stage which is used to run the image.
FROM base AS run
CMD ["php-fpm", "-F"]

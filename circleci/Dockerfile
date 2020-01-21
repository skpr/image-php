ARG PHP_VERSION=7.2
FROM skpr/php-cli:${PHP_VERSION}-1.x
ARG PHP_VERSION=7.2

USER root

RUN apk --update --no-cache add php${PHP_VERSION}-fpm

COPY fpm/50-setting.ini /etc/php7/conf.d/50-setting.ini
COPY fpm/php-fpm.conf /etc/php7/php-fpm.conf

# Configuration which can be overriden.
# See /etc/php7/php-fpm.conf
ENV PHP_FPM_PORT=9000 \
    PHP_FPM_MAX_CHILDREN=20 \
    PHP_FPM_START_SERVERS=2 \
    PHP_FPM_MIN_SPARE_SERVERS=2 \
    PHP_FPM_MAX_SPARE_SERVERS=10 \
    PHP_FPM_MAX_REQUESTS=500

EXPOSE 9000

# Configuration duplicated from the Nginx Dockerfile.
RUN apk --update --no-cache add nginx

ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/default.conf /etc/nginx/conf.d/default.conf
ADD nginx/security.conf /etc/nginx/conf.d/security.conf
RUN touch /etc/nginx/conf.d/custom.conf
RUN touch /etc/nginx/redirects.conf

# We need to create and chown these directory for
# readonly and non-root execution.
RUN mkdir -p /run/nginx
RUN chown -R skpr:skpr /var/lib/nginx \
                       /var/log/nginx \
                       /var/tmp/nginx \
                       /var/lib/nginx/logs \
                       /usr/lib/nginx/modules \
                       /run/nginx

# Declaring these here means they inherit the "chown"
# directive from above.
VOLUME /run/nginx
VOLUME /var/tmp/nginx
VOLUME /var/lib/nginx/logs

EXPOSE 8080

STOPSIGNAL SIGTERM

USER skpr
ARG ALPINE_VERSION=3.21
ARG PHP_VERSION=8.0

FROM docker.io/skpr/docconv:alpine${ALPINE_VERSION} AS docconv
FROM ghcr.io/skpr/compass-extension:v1.10.0-php${PHP_VERSION} AS compass

FROM from_image AS base

ARG TARGETARCH
ARG ALPINE_VERSION=3.21
ARG PHP_VERSION=8.0

ENV ALPINE_VERSION=${ALPINE_VERSION}
ENV PHP_MEMORY_LIMIT=128M
ENV PHP_LOG_LIMIT=4096
ENV PATH="$PATH:/data/bin"

RUN apk add util-linux ca-certificates
RUN adduser -D -u 1000 skpr

# https://github.com/moby/moby/issues/20295
RUN mkdir /data && \
    chown -R skpr:skpr /data

WORKDIR /data

RUN apk add --no-cache curl && \
    curl -sSL https://packages.skpr.io/php-alpine/skpr.rsa.pub -o /etc/apk/keys/skpr.rsa.pub && \
    echo "https://packages.skpr.io/php-alpine/${ALPINE_VERSION}/php${PHP_VERSION}" >> /etc/apk/repositories

RUN apk --update --no-cache add \
      php${PHP_VERSION} \
      php${PHP_VERSION}-apcu \
      php${PHP_VERSION}-bcmath \
      php${PHP_VERSION}-ctype \
      php${PHP_VERSION}-curl \
      php${PHP_VERSION}-dom \
      php${PHP_VERSION}-ftp \
      php${PHP_VERSION}-fileinfo \
      php${PHP_VERSION}-gd \
      php${PHP_VERSION}-mbstring \
      php${PHP_VERSION}-intl \
      php${PHP_VERSION}-openssl \
      php${PHP_VERSION}-pcntl \
      php${PHP_VERSION}-pdo \
      php${PHP_VERSION}-pdo_mysql \
      php${PHP_VERSION}-pdo_sqlite \
      php${PHP_VERSION}-phar \
      php${PHP_VERSION}-posix \
      php${PHP_VERSION}-redis \
      php${PHP_VERSION}-session \
      php${PHP_VERSION}-simplexml \
      php${PHP_VERSION}-soap \
      php${PHP_VERSION}-sockets \
      php${PHP_VERSION}-sodium \
      php${PHP_VERSION}-sqlite3 \
      php${PHP_VERSION}-tokenizer \
      php${PHP_VERSION}-xml \
      php${PHP_VERSION}-xmlreader \
      php${PHP_VERSION}-xmlwriter \
      php${PHP_VERSION}-zlib \
      php${PHP_VERSION}-zip \
      gnu-libiconv \
      pngquant \
      jpegoptim \
      mysql-client \
      mariadb-connector-c \
      optipng \
      tesseract-ocr \
      tesseract-ocr-dev \
      poppler-utils \
      libsodium

RUN if [ "${PHP_VERSION}" != "8.5" ]; then \
        apk add --no-cache php${PHP_VERSION}-opcache \; \
    fi

RUN export SKPRMAIL_VERSION=1.0.1 && \
    curl -sSL https://github.com/skpr/mail/releases/download/v${SKPRMAIL_VERSION}/skprmail_${SKPRMAIL_VERSION}_linux_${TARGETARCH} -o /usr/local/bin/skprmail && \
    chmod +rx /usr/local/bin/skprmail

# https://github.com/skpr/compass
ENV COMPASS_ENABLED=false
COPY --from=compass /etc/php/conf.d/00_compass.ini /etc/php/conf.d/00_compass.ini
COPY --from=compass /usr/lib/php/modules/compass.so /usr/lib/php/modules/compass.so

# Built using an updated build approach in this fork: https://github.com/skpr/docconv
COPY --from=docconv /usr/local/bin/docconv /usr/local/bin/docconv

ADD conf.d/01_apcu.ini /etc/php/conf.d/01_apcu.ini
ADD conf.d/50_overrides.ini /etc/php/conf.d/50_overrides.ini

ADD certs/skpr-alb-internal.crt /usr/local/share/ca-certificates/skpr-alb-internal.crt
RUN cat /usr/local/share/ca-certificates/skpr-alb-internal.crt >> /etc/ssl/certs/ca-certificates.crt

# Drush uses /tmp.
VOLUME /tmp

# Run the test stage to verify the image.
FROM base AS test
COPY --from=ghcr.io/goss-org/goss:latest /usr/bin/goss /usr/bin/goss
ADD goss.yml /tmp/goss.yml
RUN goss --gossfile /tmp/goss.yml validate

# This is our run image.
FROM base AS run
CMD ["sh"]

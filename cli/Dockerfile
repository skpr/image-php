ARG IMAGE=skpr/php:8.0-1.x
ARG ALPINE_VERSION=3.21
ARG ARCH=amd64

FROM alpine:${ALPINE_VERSION} as redis-cli

RUN apk add redis

FROM ${IMAGE}

ARG ARCH=amd64
ARG PHP_VERSION=8.0

ENV PHP_MEMORY_LIMIT=256M

ENV PATH=$PATH:$EXTRA_PATH

ENV PS1='\u@\h:\W \$ '

COPY --from=redis-cli /usr/bin/redis-cli /usr/bin/redis-cli

RUN apk --update --no-cache add \
      bash \
      curl \
      git \
      jq \
      less \
      make \
      openssh-client \
      patch \
      rsync \
      tar \
      vim

RUN curl -sS https://getcomposer.org/download/latest-1.x/composer.phar -o /usr/local/bin/composer1 && \
    chmod +x /usr/local/bin/composer1

RUN curl -sS https://getcomposer.org/download/latest-2.x/composer.phar -o /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    ln -sv /usr/local/bin/composer /usr/local/bin/composer2

# A lightweight crond for local development environments.
COPY --from=ghcr.io/skpr/crond:main /usr/local/bin/skpr-crond /usr/local/bin/skpr-crond

ADD drush /etc/drush

USER skpr

CMD ["bash"]

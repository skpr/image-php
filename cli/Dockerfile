ARG ALPINE_VERSION=3.20

FROM alpine:${ALPINE_VERSION} AS redis-cli

RUN apk add redis

FROM from_image AS base

ENV PHP_MEMORY_LIMIT=256M

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

# Run the test stage to verify the image.
FROM base AS test
COPY --from=ghcr.io/goss-org/goss:latest /usr/bin/goss /usr/bin/goss
ADD goss.yml /tmp/goss.yml
RUN goss --gossfile /tmp/goss.yml validate

FROM base AS run
CMD ["bash"]

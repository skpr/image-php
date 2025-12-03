FROM from_image
ARG PHP_VERSION=8.0

USER root

RUN apk --update --no-cache add \
      php${PHP_VERSION}-spx;

RUN if [ "${PHP_VERSION}" != "8.5" ]; then \
        apk --update --no-cache add \
            php${PHP_VERSION}-xdebug; \
    fi

COPY --chown=skpr:skpr etc /etc

ENV PHP_FPM_REQUEST_TIMEOUT=600

RUN mkdir -p /tmp/xdebug && \
    chown -R skpr:skpr /tmp/xdebug
VOLUME /tmp/xdebug

USER skpr

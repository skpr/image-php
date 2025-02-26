# New Relic - https://docs.newrelic.com/docs/release-notes/agent-release-notes/php-release-notes

ARG IMAGE=skpr/php:8.0-1.x
FROM ${IMAGE}

ENV NEW_RELIC_ENABLED=false
# ENV NEW_RELIC_APP_NAME=My Application
# ENV NEW_RELIC_LICENSE_KEY=xxxxxxxxxxxxxxxxx

RUN export NR_INSTALL_SILENT=true && \
    export NR_INSTALL_USE_CP_NOT_LN=true && \
    export NR_VERSION=11.6.0.19 && \
    export NR_FILENAME=newrelic-php5-${NR_VERSION}-linux-musl && \
    curl -sSL https://download.newrelic.com/php_agent/archive/${NR_VERSION}/${NR_FILENAME}.tar.gz | gzip -dc | tar xf - && \
    cd ${NR_FILENAME} && ./newrelic-install install && \
    rm -fR /data/${NR_FILENAME} && \
    rm -f /etc/php/conf.d/newrelic.ini;

ADD conf.d/01_newrelic.ini /etc/php/conf.d/01_newrelic.ini

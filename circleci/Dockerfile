ARG IMAGE=skpr/php-cli:8.0-1.x
ARG PHP_VERSION=8.0

FROM ${IMAGE}

ARG ARCH=amd64
ARG PHP_VERSION=8.0

USER root

RUN apk --update --no-cache add \
  php${PHP_VERSION}-fpm \
  openssh-client

COPY fpm/conf.d/50_fpm.ini /etc/php/conf.d/50_fpm.ini
COPY fpm/php-fpm.conf /etc/php/php-fpm.conf

# Configuration which can be overriden.
# See /etc/php/php-fpm.conf
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

# Configuration file used for overriding default.conf server configuration.
RUN mkdir -p /etc/nginx/overrides.d

# Configuration duplicated from the Node Dockerfile.
RUN apk --update --no-cache add bash \
  make \
  zip \
  ca-certificates \
  g++ \
  git \
  openssh-client \
  # Below are for packages such as https://www.npmjs.com/package/sharp
  python2 \
  autoconf \
  automake \
  libpng-dev \
  libtool \
  nasm \
  vips-dev \
  chromium

# https://github.com/nodejs/docker-node/blob/main/14/alpine3.17/Dockerfile
ENV NODE_VERSION=14.21.3

RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    && apk add --no-cache \
        libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        curl \
    && ARCH= && alpineArch="$(apk --print-arch)" \
      && case "${alpineArch##*-}" in \
        x86_64) \
          ARCH='x64' \
          CHECKSUM="39c334bd7ef3a6e5a5a396e08b3edbe335d86161bbfba222c75aa4a3518af942" \
          ;; \
        *) ;; \
      esac \
  && if [ -n "${CHECKSUM}" ]; then \
    set -eu; \
    curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz"; \
    echo "$CHECKSUM  node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" | sha256sum -c - \
      && tar -xJf "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
      && ln -s /usr/local/bin/node /usr/local/bin/nodejs; \
  else \
    echo "Building from source" \
    # backup build
    && apk add --no-cache --virtual .build-deps-full \
        binutils-gold \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python3 \
    # gpg keys listed at https://github.com/nodejs/node#release-keys
    && for key in \
      4ED778F539E3634C779C87C6D7062848A1AB005C \
      141F07595B7B3FFE74309A937405533BE57C7D57 \
      74F12602B6F1C4E913FAA37AD3A89613643B6201 \
      61FC681DFB92A079F1685E77973F295594EC4689 \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      890C08DB8579162FEE0DF9DB8BEAB4DFCF555EF4 \
      C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
      108F52B48DB57BB0CC439B2997B01419BD92F80A \
    ; do \
      gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
      gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
    done \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) V= \
    && make install \
    && apk del .build-deps-full \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt; \
  fi \
  && rm -f "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" \
  && apk del .build-deps \
  # smoke tests
  && node --version \
  && npm --version

ENV YARN_VERSION 1.22.19

RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && apk del .build-deps-yarn \
  # smoke test
  && yarn --version

RUN apk --update --no-cache add ruby ruby-dev && \
    gem install -N bundler:2.0.2

# Install Github Hub
RUN curl -sSL http://bins.skpr.io/hub-latest -o /usr/local/bin/hub && \
  chmod +rx /usr/local/bin/hub

# Install Github CLI
RUN export GITHUB_CLI_VERSION=1.10.2 && \
    export GITHUB_CLI_DIST=gh_${GITHUB_CLI_VERSION}_linux_${ARCH} && \
    curl -sSL https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/${GITHUB_CLI_DIST}.tar.gz -o /tmp/${GITHUB_CLI_DIST}.tar.gz && \
    tar xf /tmp/${GITHUB_CLI_DIST}.tar.gz -C /tmp && \
    mv /tmp/${GITHUB_CLI_DIST}/bin/gh /usr/local/bin/ && \
    chmod +rx /usr/local/bin/gh

# Install PHP Local Security Checker
RUN curl -sSL https://github.com/fabpot/local-php-security-checker/releases/download/v1.0.0/local-php-security-checker_1.0.0_linux_${ARCH} -o /usr/local/bin/local-php-security-checker && \
  chmod +rx /usr/local/bin/local-php-security-checker

# We need to create and chown these directory for
# readonly and non-root execution.
RUN mkdir -p /run/nginx /var/tmp/nginx
RUN chown -R skpr:skpr /var/lib/nginx \
                       /var/log/nginx \
                       /var/tmp/nginx \
                       /var/lib/nginx/logs \
                       /usr/lib/nginx/modules \
                       /run/nginx \
                       /etc/nginx/overrides.d

# Allow edits to php/nginx conf in circle jobs
RUN chown :skpr /etc/nginx/conf.d/default.conf \
  /etc/php/php-fpm.conf
RUN chmod g+w /etc/nginx/conf.d/default.conf \
  /etc/php/php-fpm.conf

# Declaring these here means they inherit the "chown"
# directive from above.
VOLUME /run/nginx
VOLUME /var/tmp/nginx
VOLUME /var/lib/nginx/logs

EXPOSE 8080

STOPSIGNAL SIGTERM

USER skpr

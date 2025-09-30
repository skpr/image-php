# Skpr PHP Images

Images for building and running PHP applications.

## Streams

This image suite provides 2 streams for images:

* `stable` - Our production/stable upstream for projects. Use this by default.
* `latest` - Recently merged changes which will be merged into `stable` as part of a release.

## Images

Images are available in the following registries:

* `ghcr.io`
* `docker.io`

## Image List

Below is the list of PHP images we provide.

By default we recommend the following registry and stream:

```
REGISTRY=docker.io
STREAM=stable
```

```
REGISTRY/skpr/php:8.2-v2-STREAM
REGISTRY/skpr/php-fpm:8.2-v2-STREAM
REGISTRY/skpr/php-fpm:8.2-dev-v2-STREAM
REGISTRY/skpr/php-cli:8.2-v2-STREAM
REGISTRY/skpr/php-cli:8.2-dev-v2-STREAM
REGISTRY/skpr/php-circleci:8.2-v2-STREAM
REGISTRY/skpr/php-circleci:8.2-node20-v2-STREAM
REGISTRY/skpr/php-circleci:8.2-node22-v2-STREAM

REGISTRY/skpr/php:8.3-v2-STREAM
REGISTRY/skpr/php-fpm:8.3-v2-STREAM
REGISTRY/skpr/php-fpm:8.3-dev-v2-STREAM
REGISTRY/skpr/php-cli:8.3-v2-STREAM
REGISTRY/skpr/php-cli:8.3-dev-v2-STREAM
REGISTRY/skpr/php-circleci:8.3-v2-STREAM
REGISTRY/skpr/php-circleci:8.3-node20-v2-STREAM
REGISTRY/skpr/php-circleci:8.3-node22-v2-STREAM

REGISTRY/skpr/php:8.4-v2-latest
REGISTRY/skpr/php-fpm:8.4-v2-latest
REGISTRY/skpr/php-fpm:8.4-dev-v2-latest
REGISTRY/skpr/php-cli:8.4-v2-latest
REGISTRY/skpr/php-cli:8.4-dev-v2-latest
REGISTRY/skpr/php-circleci:8.4-v2-latest
REGISTRY/skpr/php-circleci:8.4-node20-v2-latest
REGISTRY/skpr/php-circleci:8.4-node22-v2-latest
```

## Building

You need to specify `PHP_VERSION` to build locally:
```
make build PHP_VERSION=8.1
```

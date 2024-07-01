# Skpr PHP Images

Images for building and running PHP applications.

## Streams

This image suite provides 2 streams for images:

* `latest` - A stable upstream.
* `edge` - Recently merged changes which will be merged into `latest` as part of a release.

## Images

**Latest**

```
docker.io/skpr/php:7.4-v2-latest
docker.io/skpr/php-fpm:7.4-v2-latest
docker.io/skpr/php-fpm:7.4-dev-v2-latest
docker.io/skpr/php-cli:7.4-v2-latest
docker.io/skpr/php-cli:7.4-dev-v2-latest

docker.io/skpr/php:8.0-v2-latest
docker.io/skpr/php-fpm:8.0-v2-latest
docker.io/skpr/php-fpm:8.0-dev-v2-latest
docker.io/skpr/php-cli:8.0-v2-latest
docker.io/skpr/php-cli:8.0-dev-v2-latest

docker.io/skpr/php:8.1-v2-latest
docker.io/skpr/php-fpm:8.1-v2-latest
docker.io/skpr/php-fpm:8.1-dev-v2-latest
docker.io/skpr/php-cli:8.1-v2-latest
docker.io/skpr/php-cli:8.1-dev-v2-latest

docker.io/skpr/php:8.2-v2-latest
docker.io/skpr/php-fpm:8.2-v2-latest
docker.io/skpr/php-fpm:8.2-dev-v2-latest
docker.io/skpr/php-cli:8.2-v2-latest
docker.io/skpr/php-cli:8.2-dev-v2-latest

docker.io/skpr/php:8.3-v2-latest
docker.io/skpr/php-fpm:8.3-v2-latest
docker.io/skpr/php-fpm:8.3-dev-v2-latest
docker.io/skpr/php-cli:8.3-v2-latest
docker.io/skpr/php-cli:8.3-dev-v2-latest
```

**Edge**

```
docker.io/skpr/php:7.4-v2-edge
docker.io/skpr/php-fpm:7.4-v2-edge
docker.io/skpr/php-fpm:7.4-dev-v2-edge
docker.io/skpr/php-cli:7.4-v2-edge
docker.io/skpr/php-cli:7.4-dev-v2-edge
docker.io/skpr/php-circleci:7.4-v2-test
docker.io/skpr/php-circleci:7.4-node18-v2-test
docker.io/skpr/php-circleci:7.4-node20-v2-test
docker.io/skpr/php-circleci:7.4-node22-v2-test

docker.io/skpr/php:8.0-v2-edge
docker.io/skpr/php-fpm:8.0-v2-edge
docker.io/skpr/php-fpm:8.0-dev-v2-edge
docker.io/skpr/php-cli:8.0-v2-edge
docker.io/skpr/php-cli:8.0-dev-v2-edge
docker.io/skpr/php-circleci:8.0-v2-test
docker.io/skpr/php-circleci:8.0-node18-v2-test
docker.io/skpr/php-circleci:8.0-node20-v2-test
docker.io/skpr/php-circleci:8.0-node22-v2-test

docker.io/skpr/php:8.1-v2-edge
docker.io/skpr/php-fpm:8.1-v2-edge
docker.io/skpr/php-fpm:8.1-dev-v2-edge
docker.io/skpr/php-cli:8.1-v2-edge
docker.io/skpr/php-cli:8.1-dev-v2-edge
docker.io/skpr/php-circleci:8.1-v2-test
docker.io/skpr/php-circleci:8.1-node18-v2-test
docker.io/skpr/php-circleci:8.1-node20-v2-test
docker.io/skpr/php-circleci:8.1-node22-v2-test

docker.io/skpr/php:8.2-v2-edge
docker.io/skpr/php-fpm:8.2-v2-edge
docker.io/skpr/php-fpm:8.2-dev-v2-edge
docker.io/skpr/php-cli:8.2-v2-edge
docker.io/skpr/php-cli:8.2-dev-v2-edge
docker.io/skpr/php-circleci:8.2-v2-edge
docker.io/skpr/php-circleci:8.2-node18-v2-edge
docker.io/skpr/php-circleci:8.2-node20-v2-edge
docker.io/skpr/php-circleci:8.2-node22-v2-edge

docker.io/skpr/php:8.3-v2-edge
docker.io/skpr/php-fpm:8.3-v2-edge
docker.io/skpr/php-fpm:8.3-dev-v2-edge
docker.io/skpr/php-cli:8.3-v2-edge
docker.io/skpr/php-cli:8.3-dev-v2-edge
docker.io/skpr/php-circleci:8.3-v2-edge
docker.io/skpr/php-circleci:8.3-node18-v2-edge
docker.io/skpr/php-circleci:8.3-node20-v2-edge
docker.io/skpr/php-circleci:8.3-node22-v2-edge
```

## Building

You need to specify `PHP_VERSION` to build locally:
```
make build PHP_VERSION=8.1
```

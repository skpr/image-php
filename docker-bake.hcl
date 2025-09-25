variable "PHP_VERSION" {
  default = "8.2"
}

variable "ALPINE_VERSION" {
  default = "3.20"
}

variable "STREAM" {
  default = "latest"
}

variable "VERSION" {
  default = "v2"
}

group "default" {
  targets = [
    "base",
    "fpm",
    "fpm-dev",
    "cli",
    "cli-dev",
    "circleci-node-20",
    "circleci-node-22",
  ]
}

target "base" {
  context = "base"

  contexts = {
    base = "docker-image://docker.io/alpine:${ALPINE_VERSION}"
  }

  args = {
    ALPINE_VERSION = ALPINE_VERSION
    PHP_VERSION = PHP_VERSION
  }

  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]

  tags = [
    "docker.io/skpr/php:${PHP_VERSION}-${VERSION}-${STREAM}",
    "ghrc.io/skpr/php:${PHP_VERSION}-${VERSION}-${STREAM}",
  ] 
}

target "fpm" {
  context = "fpm"

  contexts = {
    base = "target:base"
  }

  args = {
    PHP_VERSION = PHP_VERSION
  }

  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]

  tags = [
    "docker.io/skpr/php-fpm:${PHP_VERSION}-${VERSION}-${STREAM}",
    "ghrc.io/skpr/php-fpm:${PHP_VERSION}-${VERSION}-${STREAM}",
  ] 
}

target "fpm-dev" {
  context = "dev"

  contexts = {
    base = "target:fpm"
  }

  args = {
    PHP_VERSION = PHP_VERSION
  }

  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]

  tags = [
    "docker.io/skpr/php-fpm:${PHP_VERSION}-dev-${VERSION}-${STREAM}",
    "ghrc.io/skpr/php-fpm:${PHP_VERSION}-dev-${VERSION}-${STREAM}",
  ] 
}

target "cli" {
  context = "cli"

  contexts = {
    base = "target:base"
  }

  args = {
    ALPINE_VERSION = ALPINE_VERSION
  }

  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]

  tags = [
    "docker.io/skpr/php-cli:${PHP_VERSION}-${VERSION}-${STREAM}",
    "ghrc.io/skpr/php-cli:${PHP_VERSION}-${VERSION}-${STREAM}",
  ] 
}

target "cli-dev" {
  context = "dev"

  contexts = {
    base = "target:cli"
  }

  args = {
    PHP_VERSION = PHP_VERSION
  }

  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]

  tags = [
    "docker.io/skpr/php-cli:${PHP_VERSION}-dev-${VERSION}-${STREAM}",
    "ghrc.io/skpr/php-cli:${PHP_VERSION}-dev-${VERSION}-${STREAM}",
  ] 
}

target "circleci-node-20" {
  context = "circleci"

  contexts = {
    base = "target:cli"
  }

  args = {
    PHP_VERSION = PHP_VERSION
    NODE_VERSION = 20
  }

  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]

  tags = [
    "docker.io/skpr/php-circleci:${PHP_VERSION}-node20-${VERSION}-${STREAM}",
    "ghrc.io/skpr/php-circleci:${PHP_VERSION}-node20-${VERSION}-${STREAM}",
  ] 
}

target "circleci-node-22" {
  context = "circleci"

  contexts = {
    base = "target:cli"
  }

  args = {
    PHP_VERSION = PHP_VERSION
    NODE_VERSION = 22
  }

  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]

  tags = [
    "docker.io/skpr/php-circleci:${PHP_VERSION}-node22-${VERSION}-${STREAM}",
    "ghrc.io/skpr/php-circleci:${PHP_VERSION}-node22-${VERSION}-${STREAM}",
  ] 
}

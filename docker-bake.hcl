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

variable "PLATFORMS" {
  default = ["linux/amd64", "linux/arm64"]
}

variable "REGISTRIES" {
  default = ["docker.io", "ghcr.io"]
}

# Common target: Everything inherits from this
target "_common" {
  platforms = PLATFORMS
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
    "test",
  ]
}

target "base" {
  inherits = ["_common"]
  context  = "base"

  contexts = {
    from_image = "docker-image://docker.io/alpine:${ALPINE_VERSION}"
  }

  args = {
    ALPINE_VERSION = ALPINE_VERSION
    PHP_VERSION    = PHP_VERSION
  }

  tags = [
    for r in REGISTRIES :
    "${r}/skpr/php:${PHP_VERSION}-${VERSION}-${STREAM}"
  ]
}

target "fpm" {
  inherits = ["_common"]
  context  = "fpm"

  contexts = {
    from_image = "target:base"
  }

  args = {
    PHP_VERSION = PHP_VERSION
  }

  tags = [
    for r in REGISTRIES :
    "${r}/skpr/php-fpm:${PHP_VERSION}-${VERSION}-${STREAM}"
  ]
}

target "fpm-dev" {
  inherits = ["_common"]
  context  = "dev"

  contexts = {
    from_image = "target:fpm"
  }

  args = {
    PHP_VERSION = PHP_VERSION
  }

  tags = [
    for r in REGISTRIES :
    "${r}/skpr/php-fpm:${PHP_VERSION}-dev-${VERSION}-${STREAM}"
  ]
}

target "cli" {
  inherits = ["_common"]
  context  = "cli"

  contexts = {
    from_image = "target:base"
  }

  args = {
    ALPINE_VERSION = ALPINE_VERSION
  }

  tags = [
    for r in REGISTRIES :
    "${r}/skpr/php-cli:${PHP_VERSION}-${VERSION}-${STREAM}"
  ]
}

target "cli-dev" {
  inherits = ["_common"]
  context  = "dev"

  contexts = {
    from_image = "target:cli"
  }

  args = {
    PHP_VERSION = PHP_VERSION
  }

  tags = [
    for r in REGISTRIES :
    "${r}/skpr/php-cli:${PHP_VERSION}-dev-${VERSION}-${STREAM}"
  ]
}

target "circleci-node-20" {
  inherits = ["_common"]
  context  = "circleci"

  contexts = {
    from_image = "target:cli"
  }

  args = {
    PHP_VERSION = PHP_VERSION
    NODE_VERSION = 20
  }

  tags = [
    for r in REGISTRIES :
    "${r}/skpr/php-circleci:${PHP_VERSION}-node20-${VERSION}-${STREAM}"
  ]
}

target "circleci-node-22" {
  inherits = ["_common"]
  context  = "circleci"

  contexts = {
    from_image = "target:cli"
  }

  args = {
    PHP_VERSION = PHP_VERSION
    NODE_VERSION = 22
  }

  tags = [
    for r in REGISTRIES :
    "${r}/skpr/php-circleci:${PHP_VERSION}-node22-${VERSION}-${STREAM}"
  ]
}

target "test" {
  matrix = {
    variant = ["base", "fpm", "cli"]
  }

  name = "${variant}-test"

  inherits = [variant]

  # Run this stage from the Dockerfile.
  target = "test"

  # Only build the test target locally.
  output = ["type=cacheonly"]
}

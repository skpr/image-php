#!/usr/bin/make -f

PHP_VERSION=8.4

# Example build command for local development.
# See Github Action for multi-arch and multi-stream building.
nbake:
	PHP_VERSION=${PHP_VERSION} docker buildx bake

.PHONY: *

#!/usr/bin/make -f

REGISTRY=docker.io/skpr/php
ARCH=amd64
VERSION_TAG=v2-latest

COMMON_BUILD_ARGS=--build-arg ARCH=${ARCH} --build-arg PHP_VERSION=${PHP_VERSION}

IMAGE_BASE=${REGISTRY}:${PHP_VERSION}
IMAGE_FPM=${REGISTRY}-fpm:${PHP_VERSION}
IMAGE_CLI=${REGISTRY}-cli:${PHP_VERSION}

IMAGE_FPM_DEV=${IMAGE_FPM}-dev
IMAGE_CLI_DEV=${IMAGE_CLI}-dev

IMAGE_FPM_XDEBUG=${IMAGE_FPM}-xdebug
IMAGE_CLI_XDEBUG=${IMAGE_CLI}-xdebug

IMAGE_CIRCLECI=${REGISTRY}-circleci:${PHP_VERSION}

build: validate
	# Building base image.
	docker build --no-cache ${COMMON_BUILD_ARGS} -t ${IMAGE_BASE}-${VERSION_TAG}-${ARCH} base

ifeq ($(ARCH), amd64)
	# Building base image with New Relic support.
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_BASE}-${VERSION_TAG}-${ARCH} -t ${IMAGE_BASE}-${VERSION_TAG}-${ARCH} newrelic
endif

	# Building production images.
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_BASE}-${VERSION_TAG}-${ARCH} -t ${IMAGE_FPM}-${VERSION_TAG}-${ARCH} fpm
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_BASE}-${VERSION_TAG}-${ARCH} -t ${IMAGE_CLI}-${VERSION_TAG}-${ARCH} cli

	# Testing production images.
	container-structure-test test --image ${IMAGE_BASE}-${VERSION_TAG}-${ARCH} --config base/tests.yml
	container-structure-test test --image ${IMAGE_FPM}-${VERSION_TAG}-${ARCH} --config fpm/tests.yml
	container-structure-test test --image ${IMAGE_CLI}-${VERSION_TAG}-${ARCH} --config cli/tests.yml

	# Building dev images.
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_FPM}-${VERSION_TAG}-${ARCH} -t ${IMAGE_FPM}-dev-${VERSION_TAG}-${ARCH} dev
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_CLI}-${VERSION_TAG}-${ARCH} -t ${IMAGE_CLI}-dev-${VERSION_TAG}-${ARCH} dev

ifeq ($(ARCH), amd64)
	# Building CircleCI images.
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_CLI}-${VERSION_TAG}-${ARCH} --build-arg NODE_VERSION=18 -t ${IMAGE_CIRCLECI}-node18-${VERSION_TAG} circleci
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_CLI}-${VERSION_TAG}-${ARCH} --build-arg NODE_VERSION=20 -t ${IMAGE_CIRCLECI}-node20-${VERSION_TAG} circleci
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_CLI}-${VERSION_TAG}-${ARCH} --build-arg NODE_VERSION=22 -t ${IMAGE_CIRCLECI}-node22-${VERSION_TAG} circleci
endif

push: validate
	# Pushing production images
	docker push ${IMAGE_BASE}-${VERSION_TAG}-${ARCH}
	docker push ${IMAGE_FPM}-${VERSION_TAG}-${ARCH}
	docker push ${IMAGE_CLI}-${VERSION_TAG}-${ARCH}

	# Pushing dev images.
	docker push ${IMAGE_FPM_DEV}-${VERSION_TAG}-${ARCH}
	docker push ${IMAGE_CLI_DEV}-${VERSION_TAG}-${ARCH}

ifeq ($(ARCH), amd64)
	# Pushing CircleCI image.
	docker push ${IMAGE_CIRCLECI}-node18-${VERSION_TAG}
	docker push ${IMAGE_CIRCLECI}-node20-${VERSION_TAG}
	docker push ${IMAGE_CIRCLECI}-node22-${VERSION_TAG}
endif

manifest:
	# Building skpr/php
	$(eval IMAGE=skpr/php:${PHP_VERSION}-${VERSION_TAG})
	docker manifest create ${IMAGE} --amend ${IMAGE}-arm64 --amend ${IMAGE}-amd64
	docker manifest push ${IMAGE}

	# Building skpr/php-fpm
	$(eval IMAGE="skpr/php-fpm:${PHP_VERSION}-${VERSION_TAG}")
	docker manifest create ${IMAGE} --amend ${IMAGE}-arm64 --amend ${IMAGE}-amd64
	docker manifest push ${IMAGE}

	# Building skpr/php-fpm dev
	$(eval IMAGE="skpr/php-fpm:${PHP_VERSION}-dev-${VERSION_TAG}")
	docker manifest create ${IMAGE} --amend ${IMAGE}-arm64 --amend ${IMAGE}-amd64
	docker manifest push ${IMAGE}

	# Building skpr/php-cli
	$(eval IMAGE="skpr/php-cli:${PHP_VERSION}-${VERSION_TAG}")
	docker manifest create ${IMAGE} --amend ${IMAGE}-arm64 --amend ${IMAGE}-amd64
	docker manifest push ${IMAGE}

	# Building skpr/php-cli dev
	$(eval IMAGE="skpr/php-cli:${PHP_VERSION}-dev-${VERSION_TAG}")
	docker manifest create ${IMAGE} --amend ${IMAGE}-arm64 --amend ${IMAGE}-amd64
	docker manifest push ${IMAGE}

validate:
ifndef PHP_VERSION
	$(error PHP_VERSION is undefined)
endif

.PHONY: *

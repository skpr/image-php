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
	# Building production images.
	docker build --no-cache ${COMMON_BUILD_ARGS} -t ${IMAGE_BASE}-${VERSION_TAG}-${ARCH} base
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_BASE}-${VERSION_TAG}-${ARCH} -t ${IMAGE_FPM}-${VERSION_TAG}-${ARCH} fpm
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_BASE}-${VERSION_TAG}-${ARCH} -t ${IMAGE_CLI}-${VERSION_TAG}-${ARCH} cli

	# Testing production images.
	container-structure-test test --image ${IMAGE_BASE}-${VERSION_TAG}-${ARCH} --config base/tests.yml
	container-structure-test test --image ${IMAGE_FPM}-${VERSION_TAG}-${ARCH} --config fpm/tests.yml
	container-structure-test test --image ${IMAGE_CLI}-${VERSION_TAG}-${ARCH} --config cli/tests.yml

	# Building dev images.
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_FPM}-${VERSION_TAG}-${ARCH} -t ${IMAGE_FPM}-dev-${VERSION_TAG}-${ARCH} dev
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_CLI}-${VERSION_TAG}-${ARCH} -t ${IMAGE_CLI}-dev-${VERSION_TAG}-${ARCH} dev

	# Building Xdebug images.
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_FPM_DEV}-${VERSION_TAG}-${ARCH} -t ${IMAGE_FPM_XDEBUG}-${VERSION_TAG}-${ARCH} xdebug
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_CLI_DEV}-${VERSION_TAG}-${ARCH} -t ${IMAGE_CLI_XDEBUG}-${VERSION_TAG}-${ARCH} xdebug

	# Building CircleCI images.
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_CLI}-${VERSION_TAG}-${ARCH} --build-arg NODE_VERSION=10 -t ${IMAGE_CIRCLECI}-${VERSION_TAG}-${ARCH} circleci

push: validate
	# Pushing production images
	docker push ${IMAGE_BASE}-${VERSION_TAG}-${ARCH}
	docker push ${IMAGE_FPM}-${VERSION_TAG}-${ARCH}
	docker push ${IMAGE_CLI}-${VERSION_TAG}-${ARCH}

	# Pushing dev images.
	docker push ${IMAGE_FPM_DEV}-${VERSION_TAG}-${ARCH}
	docker push ${IMAGE_CLI_DEV}-${VERSION_TAG}-${ARCH}

	# Pushing Xdebug images.
	docker push ${IMAGE_FPM_XDEBUG}-${VERSION_TAG}-${ARCH}
	docker push ${IMAGE_CLI_XDEBUG}-${VERSION_TAG}-${ARCH}

	# Pushing CircleCI images.
	docker push ${IMAGE_CIRCLECI}-${VERSION_TAG}-${ARCH}

manifest:
	IMAGE="skpr/php:${PHP_VERSION}-${VERSION_TAG}"
	docker manifest create ${IMAGE} --amend ${IMAGE}-arm64 --amend ${IMAGE}-amd64
	docker manifest push ${IMAGE}

	IMAGE="skpr/php-fpm:${PHP_VERSION}-${VERSION_TAG}"
	docker manifest create ${IMAGE} --amend ${IMAGE}-arm64 --amend ${IMAGE}-amd64
	docker manifest push ${IMAGE}

	IMAGE="skpr/php-fpm:${PHP_VERSION}-${VERSION_TAG}-dev"
	docker manifest create ${IMAGE} --amend ${IMAGE}-arm64 --amend ${IMAGE}-amd64
	docker manifest push ${IMAGE}

	IMAGE="skpr/php-fpm:${PHP_VERSION}-${VERSION_TAG}-xdebug"
	docker manifest create ${IMAGE} --amend ${IMAGE}-arm64 --amend ${IMAGE}-amd64
	docker manifest push ${IMAGE}

	IMAGE="skpr/php-cli:${PHP_VERSION}-${VERSION_TAG}"
	docker manifest create ${IMAGE} --amend ${IMAGE}-arm64 --amend ${IMAGE}-amd64
	docker manifest push ${IMAGE}

	IMAGE="skpr/php-cli:${PHP_VERSION}-${VERSION_TAG}-dev"
	docker manifest create ${IMAGE} --amend ${IMAGE}-arm64 --amend ${IMAGE}-amd64
	docker manifest push ${IMAGE}

	IMAGE="skpr/php-cli:${PHP_VERSION}-${VERSION_TAG}-xdebug"
	docker manifest create ${IMAGE} --amend ${IMAGE}-arm64 --amend ${IMAGE}-amd64
	docker manifest push ${IMAGE}

	IMAGE="skpr/php-circleci:${PHP_VERSION}-${VERSION_TAG}"
	docker manifest create ${IMAGE} --amend ${IMAGE}-arm64 --amend ${IMAGE}-amd64
	docker manifest push ${IMAGE}

validate:
ifndef PHP_VERSION
	$(error PHP_VERSION is undefined)
endif

.PHONY: *

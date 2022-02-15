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

ALL_IMAGES=${IMAGE_FPM} ${IMAGE_CLI} ${IMAGE_FPM_DEV} ${IMAGE_CLI_DEV} ${IMAGE_FPM_XDEBUG} ${IMAGE_CLI_XDEBUG} ${IMAGE_CIRCLECI}

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
	docker push ${IMAGE_CIRCLECI_V1}-${VERSION_TAG}-${ARCH}
	docker push ${IMAGE_CIRCLECI_V2}-${VERSION_TAG}-${ARCH}

manifest:
	for IMAGE in ${ALL_IMAGES}; do \
		docker manifest create $${IMAGE}-${VERSION_TAG} \
		  --amend $${IMAGE}-${VERSION_TAG}-arm64 \
		  --amend $${IMAGE}-${VERSION_TAG}-amd64; \
		docker manifest push $${IMAGE}-${VERSION_TAG}; \
	done

validate:
ifndef PHP_VERSION
	$(error PHP_VERSION is undefined)
endif

.PHONY: *

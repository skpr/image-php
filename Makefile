#!/usr/bin/make -f

REGISTRY=docker.io/skpr/php
ARCH=amd64

COMMON_BUILD_ARGS=--build-arg=ARCH=${ARCH} --build-arg PHP_VERSION=${VERSION}

IMAGE_BASE=${REGISTRY}:${VERSION}-1.x
IMAGE_FPM=${REGISTRY}-fpm:${VERSION}-1.x
IMAGE_CLI=${REGISTRY}-cli:${VERSION}-1.x

IMAGE_FPM_DEV=${IMAGE_FPM}-dev
IMAGE_CLI_DEV=${IMAGE_CLI}-dev

IMAGE_FPM_XDEBUG=${IMAGE_FPM}-xdebug
IMAGE_CLI_XDEBUG=${IMAGE_CLI}-xdebug

IMAGE_CIRCLECI_V1=${REGISTRY}-circleci:${VERSION}-1.x
IMAGE_CIRCLECI_V2=${REGISTRY}-circleci:${VERSION}-2.x

ALL_IMAGES=${IMAGE_BASE} ${IMAGE_FPM} ${IMAGE_CLI} ${IMAGE_FPM_DEV} ${IMAGE_CLI_DEV} ${IMAGE_FPM_XDEBUG} ${IMAGE_CLI_XDEBUG} ${IMAGE_CIRCLECI_V1} ${IMAGE_CIRCLECI_V2}

build: validate
	# Building production images.
	docker build --no-cache ${COMMON_BUILD_ARGS} -t ${IMAGE_BASE}-${ARCH} base
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_BASE} -t ${IMAGE_FPM}-${ARCH} fpm
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_BASE} -t ${IMAGE_CLI}-${ARCH} cli

	# Testing production images.
	container-structure-test test --image ${IMAGE_BASE}-${ARCH} --config base/tests.yml
	container-structure-test test --image ${IMAGE_FPM}-${ARCH} --config fpm/tests.yml
	container-structure-test test --image ${IMAGE_CLI}-${ARCH} --config cli/tests.yml

	# Building dev images.
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_FPM} -t ${IMAGE_FPM}-dev-${ARCH} dev
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_CLI} -t ${IMAGE_CLI}-dev-${ARCH} dev

	# Building Xdebug images.
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_FPM_DEV} -t ${IMAGE_FPM_XDEBUG}-${ARCH} xdebug
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_CLI_DEV} -t ${IMAGE_CLI_XDEBUG}-${ARCH} xdebug

	# Building CircleCI images.
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_CLI}-${ARCH} --build-arg NODE_VERSION=10 -t ${IMAGE_CIRCLECI_V1}-${ARCH} circleci
	# 1.x version is Node 10, 2.x is Node 14.
	docker build --no-cache ${COMMON_BUILD_ARGS} --build-arg IMAGE=${IMAGE_CLI}-${ARCH} --build-arg NODE_VERSION=14 -t ${IMAGE_CIRCLECI_V2}-${ARCH} circleci

push: validate
	# Pushing production images
	docker push ${IMAGE_BASE}-${ARCH}
	docker push ${IMAGE_FPM}-${ARCH}
	docker push ${IMAGE_CLI}-${ARCH}

	# Pushing dev images.
	docker push ${IMAGE_FPM_DEV}-${ARCH}
	docker push ${IMAGE_CLI_DEV}-${ARCH}

	# Pushing Xdebug images.
	docker push ${IMAGE_FPM_XDEBUG}-${ARCH}
	docker push ${IMAGE_CLI_XDEBUG}-${ARCH}

	# Pushing CircleCI images.
	docker push ${IMAGE_CIRCLECI_V1}-${ARCH}
	docker push ${IMAGE_CIRCLECI_V2}-${ARCH}

manifest:
	for IMAGE in ${ALL_IMAGES}; do \
		docker manifest create $${IMAGE} \
		  --amend $${IMAGE}-arm64 \
		  --amend $${IMAGE}-amd64; \
		docker manifest push $${IMAGE}; \
	done

validate:
ifndef VERSION
	$(error VERSION is undefined)
endif

.PHONY: *

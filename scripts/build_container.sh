#!/usr/bin/env bash

# Helper function for error handling.
quit () {
	echo $1
	exit 1
}

# Parse arguments.
SERVICE=$1
if [ -z "$SERVICE" ]; then quit "Usage: build_container.sh <service> <version>"; fi
VERSION=$2
if [ -z "$VERSION" ]; then VERSION=testing; fi
# Optional build platform (e.g. linux/arm64). Can be passed via the
# PLATFORM environment variable or as the third argument.
PLATFORM_ARG=$3
if [ -z "$PLATFORM" ]; then PLATFORM="$PLATFORM_ARG"; fi

# Choose docker build command depending on platform.
if [ -n "$PLATFORM" ]; then
    DOCKER_BUILD="docker buildx build --platform $PLATFORM --load"
else
    DOCKER_BUILD="docker build"
fi

# Rebuild the base Node.js image if needed.
echo "Building image for duelyst-nodejs:$VERSION."${PLATFORM:+ " for $PLATFORM"}
$DOCKER_BUILD \
        -f docker/nodejs.Dockerfile \
        -t duelyst-nodejs:$VERSION \
        . || quit "Failed to build Node.js image!"

# Build the service image.
$DOCKER_BUILD \
        -f docker/$SERVICE.Dockerfile \
        -t duelyst-$SERVICE:$VERSION \
        --build-arg NODEJS_IMAGE_VERSION=$VERSION \
        . || quit "Failed to build service image!"

echo "Successfully built image duelyst-${SERVICE}:${VERSION}"

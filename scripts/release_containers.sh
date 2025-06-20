#!/usr/bin/env bash

version=$1
registry=$2
platform=$3
if [ -z "$version" ] || [ -z "$registry" ]; then
        echo "Usage: release_containers.sh <version> <ecr-registry-id> [platform]"
        exit 1
fi

if [ $(basename $(pwd)) != 'heroes-of-hecanos' ]; then
        echo "Run this from the repo root."
        exit 1
fi

for svc in api game migrate sp worker; do
        PLATFORM=$platform ./scripts/build_container.sh $svc $version
        ./scripts/publish_container.sh $svc $version $registry
done

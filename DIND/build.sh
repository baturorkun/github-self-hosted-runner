#!/usr/bin/env bash

TAG="$1"
REGISTRY_URL="yourregistry.com/library/github-runner"
REGISTRY_USER="admin"

export DOCKER_PASSWORD="xxxx"

docker build -t ${REGISTRY_URL}:${TAG} .

if [[ $? -ne 0 ]]; then
    echo "Docker build failed"
    exit 1
fi

echo "$DOCKER_PASSWORD" | docker login ${REGISTRY_URL}-u ${REGISTRY_USER}

docker push ${REGISTRY_URL}:${TAG}

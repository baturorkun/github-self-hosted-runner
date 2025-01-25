#!/usr/bin/env bash

kubectl create namespace github-runner || true

helm  upgrade --install -n github-runner -f values-runner-1.yaml  runner-1 ./chart

#!/bin/bash

DOCKER_REPO=intersystemsdc/irisdemo-demo-opcua
VERSION=`cat ./VERSION`

./generate_certificates.sh

# Building the IRIS Image
docker build -t ${DOCKER_REPO}:iris-version-${VERSION} ./image-iris

# Building the OPCUA Certified Server Image
docker build -t ${DOCKER_REPO}:server-ctt-version-${VERSION} ./image-server-ctt

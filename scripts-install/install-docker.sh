#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install apt-utils

## Install docker ##
curl -sSL https://get.docker.com | sh
DOCKER_VERSION=$(docker version | grep Version | tr -s " " | cut -d" " -f 3)
echo "$(date "+%d.%m.%Y %T") Added docker version ${DOCKER_VERSION}" >> /build.info

# Clean up
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

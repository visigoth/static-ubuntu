#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install libicu66 libmediainfo0v5 sqlite3 curl jq

## Install sonarr ##
SONARR_BRANCH="main"
SONARR_VERSION=$(curl -sX GET http://services.sonarr.tv/v1/releases | jq -r ".[] | select(.branch==\"${SONARR_BRANCH}\") | .version")
rm -rf /app/sonarr/bin \
    && curl -sL "https://download.sonarr.tv/v${SONARR_VERSION:0:1}/${SONARR_BRANCH}/${SONARR_VERSION}/Sonarr.${SONARR_BRANCH}.${SONARR_VERSION}.linux.tar.gz" -o /tmp/sonarr.tar.gz \
    && mkdir -p /app/sonarr/bin \
    && tar xf /tmp/sonarr.tar.gz -C /app/sonarr/bin --strip-components=1 \
    && rm -f /tmp/sonarr.tar.gz

## Set update method and build info ##
echo "UpdateMethod=docker\nBranch=${SONARR_BRANCH}\nPackageVersion=${SONARR_VERSION}\nPackageAuthor=[testdasi](https://github.com/testdasi)" > /app/sonarr/package_info \
    && rm -rf /app/sonarr/bin/Sonarr.Update
echo "$(date "+%d.%m.%Y %T") Added sonarr version ${SONARR_VERSION} from ${SONARR_BRANCH} branch" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

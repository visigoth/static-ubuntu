#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install --no-install-recommends --no-install-suggests libicu66 sqlite3

## Install Prowlarr ##
PROWLARR_BRANCH="develop"
PROWLARR_VERSION=$(curl -sL "https://prowlarr.servarr.com/v1/update/${PROWLARR_BRANCH}/changes?runtime=netcore&os=linux" | jq -r '.[0].version')
rm -rf /app/prowlarr/bin \
    && curl -o /tmp/prowlarr.tar.gz -L "https://prowlarr.servarr.com/v1/update/${PROWLARR_BRANCH}/updatefile?version=${PROWLARR_VERSION}&os=linux&runtime=netcore&arch=x64" \
    && mkdir -p /app/prowlarr/bin \
    && tar ixzf /tmp/prowlarr.tar.gz -C /app/prowlarr/bin --strip-components=1 \
    && rm -f /tmp/prowlarr.tar.gz

## Set update method and build info ##
echo "UpdateMethod=docker\nBranch=${PROWLARR_BRANCH}\nPackageVersion=${PROWLARR_VERSION}\nPackageAuthor=[testdasi](https://github.com/testdasi)" > /app/prowlarr/package_info \
    && rm -rf /app/prowlarr/bin/Prowlarr.Update
echo "$(date "+%d.%m.%Y %T") Added prowlarr version ${PROWLARR_VERSION} from ${PROWLARR_BRANCH} branch" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
    

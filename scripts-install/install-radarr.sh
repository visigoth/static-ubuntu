#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install libicu66 libmediainfo0v5 sqlite3 curl jq
    
## Install Radarr ##
RADARR_BRANCH="master"
RADARR_VERSION=$(curl -sL "https://radarr.servarr.com/v1/update/${RADARR_BRANCH}/changes?os=linux&runtime=netcore&arch=x64" | jq -r '.[0].version')
rm -rf /app/radarr/bin \
    && curl -sL "https://radarr.servarr.com/v1/update/${RADARR_BRANCH}/updatefile?version=${RADARR_VERSION}&os=linux&runtime=netcore&arch=x64" -o /tmp/radarr.tar.gz \
    && mkdir -p /app/radarr/bin \
    && tar ixzf /tmp/radarr.tar.gz -C /app/radarr/bin --strip-components=1 \
    && rm -f /tmp/radarr.tar.gz
    
## Set update method and build info ##
echo "UpdateMethod=docker\nBranch=${RADARR_BRANCH}\nPackageVersion=${RADARR_VERSION}\nPackageAuthor=[testdasi](https://github.com/testdasi)" > /app/radarr/package_info \
    && rm -rf /app/radarr/bin/Radarr.Update
echo "$(date "+%d.%m.%Y %T") Added radarr version ${RADARR_VERSION} from ${RADARR_BRANCH} branch" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

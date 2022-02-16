#!/bin/bash

## Install dependencies ##
apt-get -y update \
    && apt-get -y install --no-install-recommends --no-install-suggests libicu66 libmediainfo0v5 sqlite3
    
## Install Radarr ##
RADARR_BRANCH="master"
RADARR_RELEASE=$(curl -sL "https://radarr.servarr.com/v1/update/${RADARR_BRANCH}/changes?os=linux&runtime=netcore&arch=x64" | jq -r '.[0].version')
curl -o /tmp/radarr.tar.gz -L "https://radarr.servarr.com/v1/update/${RADARR_BRANCH}/updatefile?version=${RADARR_RELEASE}&os=linux&runtime=netcore&arch=x64" \
    && mkdir -p /app/radarr \
    && tar ixzf /tmp/radarr.tar.gz -C /app/radarr --strip-components=1 \
    && rm -f /tmp/radarr.tar.gz \
    && rm -rf /app/radarr/Radarr.Update \
    && echo "$(date "+%d.%m.%Y %T") Added radarr version ${RADARR_RELEASE} from ${RADARR_BRANCH} branch" >> /build_date.info

## Clean up ##
apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install libicu66 sqlite3 curl jq

## Set arc string for download URL ##
if [[ ${TARGETPLATFORM} =~ "arm64" ]]
then
    DARC="arm64"
elif [[ ${TARGETPLATFORM} =~ "amd64" ]]
then
    DARC="x64"
elif [[ ${TARGETPLATFORM} =~ "arm/v7" ]]
then
    DARC="arm"
else
    DARC="ERROR"
fi

## Install Prowlarr ##
if [[ $DARC =~ "ERROR" ]]
then
    echo "$(date "+%d.%m.%Y %T") ERROR - no supported platform found for prowlarr" >> /build.info
else
    PROWLARR_BRANCH="develop"
    PROWLARR_VERSION=$(curl -sL "https://prowlarr.servarr.com/v1/update/${PROWLARR_BRANCH}/changes?runtime=netcore&os=linux&arch=${DARC}" | jq -r '.[0].version')
    DURL=$(curl -sL "https://prowlarr.servarr.com/v1/update/${PROWLARR_BRANCH}/changes?runtime=netcore&os=linux&arch=${DARC}" | jq -r '.[0].url')
    rm -rf /app/prowlarr/bin \
        && curl -sL "$DURL" -o /tmp/prowlarr.tar.gz \
        && mkdir -p /app/prowlarr/bin \
        && tar ixzf /tmp/prowlarr.tar.gz -C /app/prowlarr/bin --strip-components=1 \
        && rm -f /tmp/prowlarr.tar.gz
fi

## Set update method and build info ##
echo "UpdateMethod=docker\nBranch=${PROWLARR_BRANCH}\nPackageVersion=${PROWLARR_VERSION}\nPackageAuthor=[testdasi](https://github.com/testdasi)" > /app/prowlarr/package_info \
    && rm -rf /app/prowlarr/bin/Prowlarr.Update
echo "$(date "+%d.%m.%Y %T") Added prowlarr version ${PROWLARR_VERSION} from ${PROWLARR_BRANCH} branch for ${TARGETPLATFORM}" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

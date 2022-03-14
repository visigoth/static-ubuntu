#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install libicu66

## Set download URL ##
JACKETT_VERSION=$(curl -sX GET "https://api.github.com/repos/Jackett/Jackett/releases/latest" | jq -r .tag_name | cut -d'v' -f 2)
if [[ ${TARGETPLATFORM} =~ "arm64" ]]
then
    DURL="https://github.com/Jackett/Jackett/releases/download/v${JACKETT_VERSION}/Jackett.Binaries.LinuxARM64.tar.gz"
elif [[ ${TARGETPLATFORM} =~ "amd64" ]]
then 
    DURL="https://github.com/Jackett/Jackett/releases/download/v${JACKETT_VERSION}/Jackett.Binaries.LinuxAMDx64.tar.gz"
elif [[ ${TARGETPLATFORM} =~ "arm/v7" ]]
then
    DURL="https://github.com/Jackett/Jackett/releases/download/v${JACKETT_VERSION}/Jackett.Binaries.LinuxARM32.tar.gz"
else 
    DURL="ERROR"
fi

## Install jackett ##
if [[ ${DURL} =~ "ERROR" ]]
then
    echo "$(date "+%d.%m.%Y %T") ERROR - no supported platform found for jackett" >> /build.info
else 
    rm -rf /app/jackett \
    && curl -sL "${DURL}" -o /tmp/jacket.tar.gz \
    && mkdir -p /app/jackett \
    && tar xf /tmp/jacket.tar.gz -C /app/jackett --strip-components=1 \
    && rm -f /tmp/jacket.tar.gz \
    && chown -R root:root /app/jackett \
    && echo "$(date "+%d.%m.%Y %T") Added jackett version ${JACKETT_VERSION} for ${TARGETPLATFORM}" >> /build.info
fi

## Debug ##
if [[ -f "/container-in-debug-mode" ]]
then
    echo "$(date "+%d.%m.%Y %T") Debug info: " >> /build.info
    echo ${DURL} >> /build.info
fi

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

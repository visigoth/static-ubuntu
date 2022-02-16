#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install libicu66

## Install jackett ##
JACKETT_VERSION=$(curl -sX GET "https://api.github.com/repos/Jackett/Jackett/releases/latest" | jq -r .tag_name)
rm -rf /app/jackett \
    && curl -sL "https://github.com/Jackett/Jackett/releases/download/${JACKETT_VERSION}/Jackett.Binaries.LinuxAMDx64.tar.gz" -o /tmp/jacket.tar.gz \
    && mkdir -p /app/jackett \
    && tar xf /tmp/jacket.tar.gz -C /app/jackett --strip-components=1 \
    && rm -f /tmp/jacket.tar.gz \
    && chown -R root:root /app/jackett \
    && echo "$(date "+%d.%m.%Y %T") Added jackett version ${JACKETT_VERSION}" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

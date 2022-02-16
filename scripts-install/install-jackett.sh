#!/bin/bash

## Install dependencies ##
apt-get -y update \
    && apt-get -y install --no-install-recommends --no-install-suggests libicu66

## Install jackett ##
JACKETT_VERSION=$(curl -sX GET "https://api.github.com/repos/Jackett/Jackett/releases/latest" | jq -r .tag_name)
rm -rf /app/jackett \
    && curl -o /tmp/jacket.tar.gz -L "https://github.com/Jackett/Jackett/releases/download/${JACKETT_VERSION}/Jackett.Binaries.LinuxAMDx64.tar.gz" \
    && mkdir -p /app/jackett \
    && tar xf /tmp/jacket.tar.gz -C /app/jackett --strip-components=1 \
    && rm -f /tmp/jacket.tar.gz \
    && chown -R root:root /app/jackett \
    && echo "$(date "+%d.%m.%Y %T") Added jackett version ${JACKETT_VERSION}" >> /build_date.info

## Clean up ##
apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

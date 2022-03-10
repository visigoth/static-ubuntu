#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install gnupg software-properties-common
mkdir -p /etc/init.d.disabled

## Add repos ##
add-apt-repository -y multiverse \
    && add-apt-repository -y universe \
    && add-apt-repository -y ppa:jcfp/nobetas \
    && apt -y update \
    && apt -y full-upgrade

## Install sabnzbdplus and set build info ##
apt -y install sabnzbdplus
mv /etc/init.d/sabnzbdplus /etc/init.d.disabled/
SABNZBDPLUS_VERSION=$(sabnzbdplus -v | grep 'sabnzbdplus' | cut -d'-' -f 2)
echo "$(date "+%d.%m.%Y %T") Added sabnzbdplus version ${SABNZBDPLUS_VERSION}" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

#!/bin/bash

## Install dependencies ##
# New nodejs instruction per https://github.com/nodesource/distributions#debian-and-ubuntu-based-distributions
apt update && apt -y install ca-certificates curl gnupg
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt update && apt -y install nodejs
mkdir -p /etc/init.d.disabled


## Install torrent client ##
apt -y install transmission-daemon
mv /etc/init.d/transmission-daemon /etc/init.d.disabled/ \
    && rm -Rf /etc/transmission-daemon/*
TRANSMISSION_VERSION=$(dpkg -s transmission-daemon | grep 'Version' | cut -d' ' -f 2)

## New fork of flood at https://github.com/jesec/flood ##
npm install --global flood
FLOOD_VERSION=$(npm list -g | grep 'flood' | cut -d'@' -f 2)

## Set build info ##
echo "$(date "+%d.%m.%Y %T") Added flood version ${FLOOD_VERSION} with transmission-daemon version ${TRANSMISSION_VERSION}" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

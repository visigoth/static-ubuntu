#!/bin/bash

## Install dependencies ##
apt -y update \
    && curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt -y install -y nodejs

## Install torrent client ##
apt -y install transmission-daemon
systemctl disable transmission-daemon
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

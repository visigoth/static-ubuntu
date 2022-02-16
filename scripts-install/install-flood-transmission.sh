#!/bin/bash

## Install dependencies ##
apt-get -y update \
    && curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get -y install -y nodejs

## Install torrent client ##
apt-get -y install transmission-daemon
TRANSMISSION_VERSION=$(dpkg -s transmission-daemon | grep 'Version' | cut -d' ' -f 2)

## New fork of flood at https://github.com/jesec/flood ##
npm install --global flood
FLOOD_VERSION=$(npm list -g | grep 'flood' | cut -d'@' -f 2)

## Set build info ##
echo "$(date "+%d.%m.%Y %T") Added flood (v${FLOOD_VERSION}) with transmission-daemon (v${TRANSMISSION_VERSION})" >> /build.info

## Clean up ##
apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

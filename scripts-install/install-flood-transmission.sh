#!/bin/bash

## Install dependencies ##
apt-get -y update \
    && curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get -y install -y nodejs

## Install torrent client ##
apt-get -y install transmission-daemon
CLITXT=$(dpkg -s transmission-daemon | grep 'Version')
TRANSMISSION_VERSION=${CLITXT:9:12}

## New fork of flood at https://github.com/jesec/flood ##
npm install --global flood
CLITXT=$(npm list -g | grep 'flood')
FLOOD_VERSION=${CLITXT:10:5}

## Set build info ##
echo "$(date "+%d.%m.%Y %T") Added flood (${FLOOD_VERSION}) with transmission-daemon (${TRANSMISSION_VERSION})" >> /build.info

## Clean up ##
apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

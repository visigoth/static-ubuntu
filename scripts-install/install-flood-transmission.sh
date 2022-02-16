#!/bin/bash

## Install dependencies ##
apt-get -y update \
    && curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get -y install -y nodejs

## Install torrent client ##
apt-get -y install transmission-daemon

## New fork of flood at https://github.com/jesec/flood ##
npm install --global flood

## Clean up ##
apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

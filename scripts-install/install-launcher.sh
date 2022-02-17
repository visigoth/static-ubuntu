#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install python3

## Install launcher ##
rm -rf /app/launcher \
    && mkdir -p /temp \
    && cd /temp \
    && curl -L "https://github.com/testdasi/BrowserStartPage/archive/master.zip" -o /temp/launcher.zip \
    && unzip /temp/launcher.zip \
    && mkdir -p /app \
    && mv /temp/BrowserStartPage-master /app/launcher \
    && chmod +x /app/launcher/launcher-python2.sh \
    && chmod +x /app/launcher/launcher-python3.sh \
    && rm -f /temp/launcher.zip

## Set build info ##
echo "$(date "+%d.%m.%Y %T") Added customized fork of lucasgrinspan/BrowserStartPage" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

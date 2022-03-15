#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install curl jq unzip

## Install PIA script ##
rm -rf /app/pia-script \
    && mkdir -p /temp \
    && cd /temp \
    && curl -L "https://github.com/pia-foss/manual-connections/archive/refs/heads/master.zip" -o /temp/pia.zip \
    && unzip /temp/pia.zip \
    && mkdir -p /app \
    && mv /temp/manual-connections-master /app/pia-script \
    && chmod +x /app/pia-script/*.sh \
    && chmod +x /app/pia-script/openvpn_config/*.sh \
    && rm -f /temp/pia.zip

## Set build info ##
echo "$(date "+%d.%m.%Y %T") Added PIA manual connections scripts" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

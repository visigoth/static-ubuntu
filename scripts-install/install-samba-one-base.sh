#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install samba samba-common smbclient samba-common-bin smbclient cifs-utils

## Set build info ##
echo "$(date "+%d.%m.%Y %T") Added samba" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

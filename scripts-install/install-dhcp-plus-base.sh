#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install wget tee gnupg1 apt-transport-https

## Add depot ##
echo 'deb https://download.webmin.com/download/repository sarge contrib' | sudo tee -a /etc/apt/sources.list
wget -q -O- http://www.webmin.com/jcameron-key.asc | sudo apt-key add

## Install packages ##
apt update -y \
    && apt install -y isc-dhcp-server webmin perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python unzip shared-mime-info

## Set build info ##
ISC_VERSION=$(apt-show-versions isc-dhcp-server | grep uptodate | cut -d' ' -f 2)
echo "$(date "+%d.%m.%Y %T") Added ISC DHCP Server version ${ISC_VERSION}" >> /build.info
WEBMIN_VERSION=$(webmin --version)
echo "$(date "+%d.%m.%Y %T") Added WEBMIN version ${WEBMIN_VERSION}" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

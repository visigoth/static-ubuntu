#!/bin/bash

## Install dependencies ##

## Set build info ##
ISC_VERSION=$(apt-show-versions isc-dhcp-server | grep uptodate | cut -d' ' -f 2)
echo "$(date "+%d.%m.%Y %T") Added ISC DHCP Server version ${ISC_VERSION}" >> /build.info
WEBMIN_VERSION=$(webmin --version)
echo "$(date "+%d.%m.%Y %T") Added WEBMIN version ${WEBMIN_VERSION}" >> /build.info


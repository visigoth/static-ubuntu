#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install dnsutils sipcalc

## openvpn ##
apt -y install openvpn
OPENVPN_VERSION=$(openvpn --version | grep 'linux-gnu' | cut -d' ' -f 2)
echo "$(date "+%d.%m.%Y %T") Added openvpn version ${OPENVPN_VERSION}" >> /build.info

## nftables ##
apt -y install nftables
NFT_VERSION=$(nft --version | cut -d' ' -f 2 | cut -d'v' -f 2)
echo "$(date "+%d.%m.%Y %T") Added nftables version ${NFT_VERSION}" >> /build.info

## stubby ##
apt -y install stubby
STUBBY_VERSION=$(stubby -V)
systemctl disable stubby
echo "$(date "+%d.%m.%Y %T") Added stubby version ${STUBBY_VERSION}" >> /build.info

## dante-server ##
apt -y install dante-server
systemctl disable danted
DANTED_VERSION=$(danted -v | cut -d' ' -f 2 | cut -d'v' -f 2 | cut -c'1-5')
echo "$(date "+%d.%m.%Y %T") Added dante-server version ${DANTED_VERSION}" >> /build.info

## tinyproxy ##
apt -y install tinyproxy
systemctl disable tinyproxy
TINYPROXY_VERSION=$(tinyproxy -v | cut -d' ' -f 2)
echo "$(date "+%d.%m.%Y %T") Added tinyproxy version ${TINYPROXY_VERSION}" >> /build.info

# Clean up
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install dnsutils sipcalc
mkdir -p /etc/init.d.disabled

## openvpn ##
apt -y install openvpn
mv /etc/init.d/openvpn /etc/init.d.disabled/
# wipe openvpn etc default config to prevent dup #
rm -Rf /etc/openvpn
OPENVPN_VERSION=$(openvpn --version | grep 'linux-gnu' | cut -d' ' -f 2)
echo "$(date "+%d.%m.%Y %T") Added openvpn version ${OPENVPN_VERSION}" >> /build.info

## nftables ##
apt -y install nftables
NFT_VERSION=$(nft --version | cut -d' ' -f 2 | cut -d'v' -f 2)
echo "$(date "+%d.%m.%Y %T") Added nftables version ${NFT_VERSION}" >> /build.info

## stubby ##
apt -y install stubby
STUBBY_VERSION=$(stubby -V)
rm -Rf /etc/stubby/*
echo "$(date "+%d.%m.%Y %T") Added stubby version ${STUBBY_VERSION}" >> /build.info

## dante-server ##
apt -y install dante-server
mv /etc/init.d/danted /etc/init.d.disabled/ \
    && rm -f /etc/danted.conf
DANTED_VERSION=$(danted -v | cut -d' ' -f 2 | cut -d'v' -f 2 | cut -c'1-5')
echo "$(date "+%d.%m.%Y %T") Added dante-server version ${DANTED_VERSION}" >> /build.info

## tinyproxy ##
apt -y install tinyproxy
mv /etc/init.d/tinyproxy /etc/init.d.disabled/ \
    && rm -Rf /etc/tinyproxy/*
TINYPROXY_VERSION=$(tinyproxy -v | cut -d' ' -f 2)
echo "$(date "+%d.%m.%Y %T") Added tinyproxy version ${TINYPROXY_VERSION}" >> /build.info

# Clean up
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

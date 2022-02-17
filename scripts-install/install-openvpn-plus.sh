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
echo "$(date "+%d.%m.%Y %T") Added stubby version ${STUBBY_VERSION}" >> /build.info

## dante-server ##
apt -y install dante-server
DANTED_VERSION=$(danted -v | cut -d' ' -f 2 | cut -d'v' -f 2 | cut -c'1-5')
echo "$(date "+%d.%m.%Y %T") Added dante-server version ${DANTED_VERSION}" >> /build.info

## tinyproxy ##
apt -y install tinyproxy
TINYPROXY_VERSION=$(tinyproxy -v | cut -d' ' -f 2)
echo "$(date "+%d.%m.%Y %T") Added tinyproxy version ${TINYPROXY_VERSION}" >> /build.info

## add tor and privoxy depending on torless tag ##
if [[ ${BUILD_OPT} =~ "torless" ]]
then
    echo "$(date "+%d.%m.%Y %T") Skip torsocks and privoxy due to build option ${BUILD_OPT}" >> /build.info
else
    # torsocks #
    apt -y install torsocks
    TOR_VERSION=$(tor --version | cut -d' ' -f 3 | cut -c'1-7')
    echo "$(date "+%d.%m.%Y %T") Added torsocks version ${TOR_VERSION}" >> /build.info
    
    # privoxy #
    apt -y install privoxy
    PRIVOXY_VERSION=$(privoxy --version | cut -d' ' -f 3)
    echo "$(date "+%d.%m.%Y %T") Added privoxy version ${PRIVOXY_VERSION}" >> /build.info
fi

# Clean up
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

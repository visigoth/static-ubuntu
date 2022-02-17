#!/bin/bash

## install dependencies ##
apt -y update \
    && apt -y install dnsutils sipcalc nftables

## install stubby for DNS-over-TLS ##
apt -y install stubby
STUBBY_VERSION=$(stubby -V)
echo "$(date "+%d.%m.%Y %T") Added stubby version ${STUBBY_VERSION}" >> /build.info

## install openvpn ##
apt install -y openvpn
OPENVPN_VERSION=$(openvpn --version | grep 'linux-gnu' | cut -d' ' -f 2)
echo "$(date "+%d.%m.%Y %T") Added openvpn version ${OPENVPN_VERSION}" >> /build.info

## install dante-server for socks proxy ##
apt -y install dante-server
DANTED_VERSION=$(danted -v | cut -d' ' -f 2 | cut -c 2-6)
echo "$(date "+%d.%m.%Y %T") Added dante-server version ${DANTED_VERSION}" >> /build.info

## install tinyproxy for http proxy ##
apt -y install tinyproxy
TINYPROXY_VERSION=$(tinyproxy -v | cut -d' ' -f 2)
echo "$(date "+%d.%m.%Y %T") Added tinyproxy version ${TINYPROXY_VERSION}" >> /build.info

## use torless tag to determine whether to install torsocks and privoxy ##
if [[ ${BUILD_OPT} =~ "torless" ]]
then
    echo "$(date "+%d.%m.%Y %T") Skip torsocks and privoxy due to build option ${BUILD_OPT}" >> /build.info
else
    apt -y install torsocks
    TORSOCKS_VERSION=$(torsocks --version | cut -d' ' -f 2)
    echo "$(date "+%d.%m.%Y %T") Added torsocks version ${TORSOCKS_VERSION}" >> /build.info
    
    apt -y install privoxy
    PRIVOXY_VERSION=$(privoxy --version | cut -d' ' -f 3)
    echo "$(date "+%d.%m.%Y %T") Added privoxy version ${PRIVOXY_VERSION}" >> /build.info
fi

# Clean up
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

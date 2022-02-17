#!/bin/bash

# install more packages
apt -y update \
    && apt -y install dnsutils sipcalc nftables

# install stubby
apt -y install stubby
STUBBY_VERSION=$(stubby -V)
echo "$(date "+%d.%m.%Y %T") Added stubby version ${STUBBY_VERSION}" >> /build.info

# install openvpn
apt install -y openvpn
OPENVPN_VERSION=$(openvpn --version | grep 'linux-gnu' | cut -d' ' -f 2)
echo "$(date "+%d.%m.%Y %T") Added openvpn version ${OPENVPN_VERSION}" >> /build.info

# install dante-server
apt -y install dante-server
DANTED_VERSION=$(danted -v | cut -d' ' -f 2 | cut -d'v' -f 2)
echo "$(date "+%d.%m.%Y %T") Added dante-server version ${DANTED_VERSION}" >> /build.info

# install tinyproxy
apt -y install tinyproxy
TINYPROXY_VERSION=$(tinyproxy -v | cut -d' ' -f 2)
echo "$(date "+%d.%m.%Y %T") Added tinyproxy version ${TINYPROXY_VERSION}" >> /build.info

# add tor and privoxy depending on torless tag
if [[ ${BUILD_OPT} =~ "torless" ]]
then
    echo "[info] Don't install torsocks and privoxy due to build option ${BUILD_OPT}"
else
    apt -y install torsocks privoxy
    TORSOCKS_VERSION=$(torsocks --version | cut -d' ' -f 2)
    echo "$(date "+%d.%m.%Y %T") Added torsocks version ${TORSOCKS_VERSION}" >> /build.info
    PRIVOXY_VERSION=$(privoxy --version | cut -d' ' -f 3)
    echo "$(date "+%d.%m.%Y %T") Added privoxy version ${PRIVOXY_VERSION}" >> /build.info
fi

# Clean up
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

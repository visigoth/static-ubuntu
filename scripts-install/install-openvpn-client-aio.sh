#!/bin/bash

# install more packages
apt -y update \
    && apt -y install dnsutils sipcalc

# install openvpn
apt install -y openvpn nftables

# install stubby
apt -y install stubby

# install dante-server
apt -y install dante-server

# install tinyproxy
apt -y install tinyproxy

# add tor and privoxy depending on torless tag
if [[ ${BUILD_OPT} =~ "torless" ]]
then
    echo "[info] Don't install torsocks and privoxy due to build option ${BUILD_OPT}"
else
    apt -y install torsocks privoxy
fi

# Clean up
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

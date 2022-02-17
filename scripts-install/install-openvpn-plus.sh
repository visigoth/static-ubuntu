#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install dnsutils sipcalc

## install openvpn and nftables
apt install -y openvpn nftables

# install other apps
apt -y install stubby dante-server tinyproxy

# add tor and privoxy depending on torless tag
if [[ ${BUILD_OPT} =~ "torless" ]]
then
    echo "$(date "+%d.%m.%Y %T") Skip torsocks and privoxy due to build option ${BUILD_OPT}" >> /build.info
else
    apt -y install torsocks privoxy    
    echo "$(date "+%d.%m.%Y %T") Skip torsocks and privoxy due to build option ${BUILD_OPT}" >> /build.info
fi

# Clean up
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

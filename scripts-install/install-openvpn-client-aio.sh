#!/bin/bash

# install more packages
apt-get -y update \
    && apt-get -y install dnsutils wget sipcalc curl unzip

# install openvpn
apt-get install -y openvpn
apt-get install -y nftables

# install stubby and clean config
apt-get -y install stubby \
    && mkdir -p /etc/stubby \
    && rm -rf /etc/stubby/*

# install dante server
apt-get -y install dante-server \
    && rm -f /etc/danted.conf

# install tinyproxy
apt-get -y install tinyproxy \
    && mkdir -p /etc/tinyproxy \
    && rm -rf /etc/tinyproxy/*

# add tor and privoxy depending on torless tag
if [[ ${BUILD_OPT} =~ "torless" ]]
then
    cd /tmp \
    && rm -fr ./torrc \
    && rm -fr ./privoxy
    echo "[info] Don't install torsocks and privoxy due to build option ${BUILD_OPT}"
else
    # install torsocks and privoxy
    apt-get -y update \
    && apt-get -y install torsocks privoxy \
    && mkdir -p /etc/tor \
    && rm -rf /etc/tor/* \
    && mkdir -p /etc/privoxy \
    && rm -rf /etc/privoxy/*
    
    # install config files
    cd /tmp \
    && cp -n ./torrc /etc/tor/ \
    && cp -n ./privoxy /etc/privoxy/config
    
    echo "[info] Installed torsocks and privoxy due to build option ${BUILD_OPT}"
fi

# Clean up
apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

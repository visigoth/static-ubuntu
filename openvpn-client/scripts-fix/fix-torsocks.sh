#!/bin/bash

TORSOCKS_PORT=${TOR_SOCKS_PORT}
sed -i "s|_TORSOCKS_PORT_|$TORSOCKS_PORT|g" '/nftables.rules'

mkdir -p /config/tor \
    && cp -n /static-ubuntu/openvpn-client/etc/torrc /config/tor/
sed -i "s|\.0:9050|\.0:$TORSOCKS_PORT|g" '/config/tor/torrc'
echo '[info] torsocks fixed.'

#!/bin/bash

DANTE_PORT=${SOCKS_PROXY_PORT}
sed -i "s|_DANTE_PORT_|$DANTE_PORT|g" '/nftables.rules'

mkdir -p /config/dante \
    && cp -n /static-ubuntu/etc/danted.conf /config/dante/
sed -i "s|port=1080|port=$DANTE_PORT|g" '/config/dante/danted.conf'
echo '[info] danted fixed.'

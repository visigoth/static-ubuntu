#!/bin/bash

JACKETT_PORT=${TORZNAB_PORT}
sed -i "s|_JACKETT_PORT_|$JACKETT_PORT|g" '/nftables.rules'
sed -i "s|:9117|:$JACKETT_PORT|g" '/app/launcher/index.html'

mkdir -p /config/jackett \
    && cp -n /static-ubuntu/openvpn-client/etc/jackett.json /config/jackett/ServerConfig.json \
    && chmod -R 777 /config/jackett
sed -i "s|: 9117|: $JACKETT_PORT|g" '/config/jackett/ServerConfig.json'
sed -i "s|: 1080|: $DANTE_PORT|g" '/config/jackett/ServerConfig.json'
echo '[info] jackett fixed.'

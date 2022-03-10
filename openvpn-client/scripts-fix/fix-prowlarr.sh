#!/bin/bash

PROWLARR_PORT=${INDEXER_PORT}
sed -i "s|_PROWLARR_PORT_|$PROWLARR_PORT|g" '/nftables.rules'
sed -i "s|:9696|:$PROWLARR_PORT|g" '/app/launcher/index.html'

mkdir -p /config/prowlarr \
    && cp -n /static-ubuntu/openvpn-client/etc/prowlarr.xml /config/prowlarr/config.xml
sed -i "s|9696|$PROWLARR_PORT|g" '/config/prowlarr/config.xml'
echo '[info] prowlarr fixed.'

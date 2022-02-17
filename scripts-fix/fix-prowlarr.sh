#!/bin/bash

PROWLARR_PORT=${INDEXER_PORT}
sed -i "s|:9696|:$PROWLARR_PORT|g" '/app/launcher/index.html'

mkdir -p /config/prowlarr \
    && cp -n /static-ubuntu/etc/prowlarr.xml /config/prowlarr/config.xml
sed -i "s|9696|$PROWLARR_PORT|g" '/config/prowlarr/config.xml'
echo '[info] prowlarr fixed.'

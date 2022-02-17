#!/bin/bash

mkdir -p /config/prowlarr \
    && cp -n /testdasi/etc/prowlarr.xml /config/prowlarr/config.xml
sed -i "s|9696|$PROWLARR_PORT|g" '/config/prowlarr/config.xml'
echo '[info] prowlarr fixed.'

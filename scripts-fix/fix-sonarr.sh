#!/bin/bash

SONARR_PORT=${PVR_TV_PORT}
sed -i "s|_SONARR_PORT_|$SONARR_PORT|g" '/nftables.rules'
sed -i "s|:8989|:$SONARR_PORT|g" '/app/launcher/index.html'

mkdir -p /config/sonarr \
    && cp -n /static-ubuntu/etc/sonarr.xml /config/sonarr/config.xml \
    && mkdir -p /data/sonarr/downloads \
    && mkdir -p /data/sonarr/recycle \
    && mkdir -p /data/sonarr/watch \
    && mkdir -p /tv
sed -i "s|8989|$SONARR_PORT|g" '/config/sonarr/config.xml'
echo '[info] sonarr fixed.'

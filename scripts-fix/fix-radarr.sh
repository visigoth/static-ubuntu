#!/bin/bash

RADARR_PORT=${PVR_MOVIE_PORT}
sed -i "s|_RADARR_PORT_|$RADARR_PORT|g" '/nftables.rules'
sed -i "s|:7878|:$RADARR_PORT|g" '/app/launcher/index.html'

mkdir -p /config/radarr \
    && cp -n /static-ubuntu/etc/radarr.xml /config/radarr/config.xml \
    && mkdir -p /data/radarr/downloads \
    && mkdir -p /data/radarr/recycle \
    && mkdir -p /data/radarr/watch \
    && mkdir -p /movies
sed -i "s|7878|$RADARR_PORT|g" '/config/radarr/config.xml'
echo '[info] radarr fixed.'

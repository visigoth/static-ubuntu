#!/bin/bash

mkdir -p /config/radarr \
    && cp -n /static-ubuntu/etc/radarr.xml /config/radarr/config.xml \
    && mkdir -p /data/radarr/downloads \
    && mkdir -p /data/radarr/recycle \
    && mkdir -p /data/radarr/watch \
    && mkdir -p /movies
sed -i "s|7878|$RADARR_PORT|g" '/config/radarr/config.xml'
echo '[info] radarr fixed.'

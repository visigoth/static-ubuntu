#!/bin/bash

cp -f /static-ubuntu/etc/index.html /app/launcher/
sed -i "s|192.168.1.1|$LAUNCHER_IP|g" '/app/launcher/index.html'
sed -i "s|server 8000|server $LAUNCHER_PORT|g" '/app/launcher/launcher-python3.sh'
sed -i "s|python3 |python3-launcher |g" '/app/launcher/launcher-python3.sh'
sed -i "s|Server 8000|Server $LAUNCHER_PORT|g" '/app/launcher/launcher-python2.sh'
sed -i "s|python2 |python2-launcher |g" '/app/launcher/launcher-python2.sh'
sed -i "s|:8080|:$SAB_PORT_A|g" '/app/launcher/index.html'
sed -i "s|:5076|:$HYDRA_PORT|g" '/app/launcher/index.html'
sed -i "s|:3000|:$FLOOD_PORT|g" '/app/launcher/index.html'
sed -i "s|:9117|:$JACKETT_PORT|g" '/app/launcher/index.html'
sed -i "s|:8989|:$SONARR_PORT|g" '/app/launcher/index.html'
sed -i "s|:7878|:$RADARR_PORT|g" '/app/launcher/index.html'
sed -i "s|:9696|:$PROWLARR_PORT|g" '/app/launcher/index.html'
echo '[info] launcher fixed.'

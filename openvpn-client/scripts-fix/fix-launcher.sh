#!/bin/bash

LAUNCHER_PORT=${LAUNCHER_GUI_PORT}
LAUNCHER_IP=${SERVER_IP}

# Pick index.html #
if [[ -f "/app/radarr/package_info" ]]
then
    cp -f /static-ubuntu/openvpn-client/etc/index-rio.html /app/launcher/index.html
elif [[ -f "/app/nzbhydra2/package_info" ]]
then
    cp -f /static-ubuntu/openvpn-client/etc/index-aio-plus.html /app/launcher/index.html
else
    echo '[ERROR] No index.html selected due to unexpected installed packs.'
fi

# Fix configs #
sed -i "s|192.168.1.1|$LAUNCHER_IP|g" '/app/launcher/index.html'
sed -i "s|server 8000|server $LAUNCHER_PORT|g" '/app/launcher/launcher-python3.sh'
sed -i "s|python3 |python3-launcher |g" '/app/launcher/launcher-python3.sh'
echo '[info] launcher fixed.'

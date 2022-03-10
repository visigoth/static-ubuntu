#!/bin/bash

LAUNCHER_PORT=${LAUNCHER_GUI_PORT}
LAUNCHER_IP=${SERVER_IP}

cp -f /static-ubuntu/openvpn-client/etc/index.html /app/launcher/
sed -i "s|192.168.1.1|$LAUNCHER_IP|g" '/app/launcher/index.html'
sed -i "s|server 8000|server $LAUNCHER_PORT|g" '/app/launcher/launcher-python3.sh'
sed -i "s|python3 |python3-launcher |g" '/app/launcher/launcher-python3.sh'
sed -i "s|Server 8000|Server $LAUNCHER_PORT|g" '/app/launcher/launcher-python2.sh'
sed -i "s|python2 |python2-launcher |g" '/app/launcher/launcher-python2.sh'
echo '[info] launcher fixed.'

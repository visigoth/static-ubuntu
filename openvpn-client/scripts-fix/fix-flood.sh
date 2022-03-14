#!/bin/bash

FLOOD_IP=${SERVER_IP}
FLOOD_PORT=${TORRENT_GUI_PORT}
sed -i "s|_FLOOD_PORT_|$FLOOD_PORT|g" '/nftables.rules'
sed -i "s|:3000|:$FLOOD_PORT|g" '/app/launcher/index.html'

mkdir -p /config/flood/db \
    && cp -n /static-ubuntu/openvpn-client/etc/flood.db /config/flood/db/users.db
echo 'default flood login is admin:flood unless changed in settings'
echo '[info] flood fixed.'

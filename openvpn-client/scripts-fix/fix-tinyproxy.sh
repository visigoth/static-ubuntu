#!/bin/bash

TINYPROXY_PORT=${HTTP_PROXY_PORT}
sed -i "s|_TINYPROXY_PORT_|$TINYPROXY_PORT|g" '/nftables.rules'

mkdir -p /config/tinyproxy \
    && cp -n /static-ubuntu/openvpn-client/etc/tinyproxy.conf /config/tinyproxy/
sed -i "s|Port 8080|Port $TINYPROXY_PORT|g" '/config/tinyproxy/tinyproxy.conf'
sed -i "s|upstream socks5 localhost:1080|upstream socks5 localhost:$DANTE_PORT|g" '/config/tinyproxy/tinyproxy.conf'
echo '[info] tinyproxy fixed.'

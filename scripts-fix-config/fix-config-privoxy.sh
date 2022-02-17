#!/bin/bash

mkdir -p /config/privoxy \
    && cp -n /testdasi/etc/privoxy /config/privoxy/config
sed -i "s|listen-address 0\.0\.0\.0:8118|listen-address 0\.0\.0\.0:$PRIVOXY_PORT|g" '/config/privoxy/config'
sed -i "s|forward-socks5t \/ localhost:9050|forward-socks5t \/ localhost:$TORSOCKS_PORT|g" '/config/privoxy/config'
echo '[info] privoxy fixed.'

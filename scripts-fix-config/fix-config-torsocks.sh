#!/bin/bash

mkdir -p /config/tor \
    && cp -n /static-ubuntu/etc/torrc /config/tor/
sed -i "s|SOCKSPort 0\.0\.0\.0:9050|SOCKSPort 0\.0\.0\.0:$TORSOCKS_PORT|g" '/config/tor/torrc'
echo '[info] torsocks fixed.'

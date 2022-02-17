#!/bin/bash

mkdir -p /config/transmission \
    && cp -n /static-ubuntu/etc/transmission.json /config/transmission/settings.json \
    && mkdir -p /data/transmission/watch \
    && mkdir -p /data/transmission/incomplete \
    && mkdir -p /data/transmission/complete
echo '[info] transmission fixed.'

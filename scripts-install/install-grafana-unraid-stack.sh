#!/bin/bash

## Make copy of static folder ##
mkdir -p /static-ubuntu
cp -rf /testdasi/grafana-unraid-stack /static-ubuntu/

## Replace service ##
rm -f /etc/init.d/grafana-server \
    && rm -f /etc/init.d/influxdb \
    && rm -f /etc/init.d/telegraf
cp /static-ubuntu/grafana-unraid-stack/init.d/* /etc/init.d/

## chmod ##
chmod +x /*.sh
chmod +x /etc/init.d/*
chmod +x /static-ubuntu/grafana-unraid-stack/*.sh

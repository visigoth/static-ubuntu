#!/bin/bash

## Fix locales and tzdata to prevent tzdata stopping installation ##
apt -y update \
    && apt -y install locales tzdata
locale-gen 'en_GB.UTF-8' \
    && dpkg-reconfigure --frontend=noninteractive locales
ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime \
    && echo 'Europe/London' > /etc/timezone \
    && dpkg-reconfigure --frontend=noninteractive tzdata

## Install dependencies ##
apt -y install gnupg gnupg1 gnupg2 dirmngr ca-certificates apt-transport-https software-properties-common

## Install grafana from repo ##
# add telegraf repo
curl -sOL "https://repos.influxdata.com/influxdb.key" | apt-key add -
echo "deb https://repos.influxdata.com/ubuntu focal stable" | tee /etc/apt/sources.list.d/influxdb.list
apt-get -y update \
    && apt-get -y install telegraf influxdb
systemctl daemon-reload \
    && systemctl disable influxdb
# clean config #
rm -rf /etc/telegraf
rm -rf /etc/influxdb
INFLUXDB_VERSION=$(influxd version | cut -d' ' -f 2 | cut -d'v' -f 2)
TELEGRAF_VERSION=$(telegraf version | cut -d' ' -f 2)
echo "$(date "+%d.%m.%Y %T") Added InfluxDB version ${INFLUXDB_VERSION}" >> /build.info
echo "$(date "+%d.%m.%Y %T") Added Telegraf version ${TELEGRAF_VERSION}" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

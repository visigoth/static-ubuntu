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
#wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
curl -sOL "https://packages.grafana.com/gpg.key" | apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list
apt-get -y update \
    && apt-get -y install grafana
systemctl daemon-reload
systemctl disable grafana-server

## clean config ##
rm -f /etc/default/grafana-server \
    && touch /etc/default/grafana-server

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

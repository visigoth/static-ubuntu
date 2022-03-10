#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install gnupg gnupg1 gnupg2 dirmngr ca-certificates apt-transport-https software-properties-common

## Install grafana from repo ##
curl -sOL "https://packages.grafana.com/gpg.key"
apt-key add gpg.key
echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list
apt -y update \
    && apt -y install grafana
# clean config #
rm -f /etc/default/grafana-server \
    && touch /etc/default/grafana-server \
    && rm -rf /etc/grafana
GRAFANA_VERSION=$(grafana-server -v | cut -d' ' -f 2)
echo "$(date "+%d.%m.%Y %T") Added Grafana version ${GRAFANA_VERSION}" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

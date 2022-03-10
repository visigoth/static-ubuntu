#!/bin/bash

## Install dependencies ##
#apt -y update \
#    && apt -y install lm-sensors smartmontools ipmitool hddtemp
#rm -f /etc/hddtemp.db

apt -y update
source /testdasi/scripts-install/install-grafana.sh
source /testdasi/scripts-install/install-influxdb-telegraf.sh
source /testdasi/scripts-install/install-loki-promtail.sh

# clean up
apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

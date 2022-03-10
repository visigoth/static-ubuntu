#!/bin/bash

## Fix locales and tzdata to prevent tzdata stopping installation ##
apt -y update \
    && apt -y install locales tzdata
locale-gen 'en_GB.UTF-8' \
    && dpkg-reconfigure --frontend=noninteractive locales
ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime \
    && echo 'Europe/London' > /etc/timezone \
    && dpkg-reconfigure --frontend=noninteractive tzdata

## Install additional tools ##
apt -y install lm-sensors smartmontools ipmitool

## Install hddtemp ##
apt -y install hddtemp
rm -f /etc/hddtemp.db
HDDTEMP_VERSION=$(hddtemp -v | cut -d' ' -f 3)
echo "$(date "+%d.%m.%Y %T") Added hddtemp version ${LOKI_VER}" >> /build.info

source /testdasi/scripts-install/install-grafana.sh
source /testdasi/scripts-install/install-influxdb-telegraf.sh
source /testdasi/scripts-install/install-loki-promtail.sh

# clean up
apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

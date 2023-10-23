#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install gnupg software-properties-common
mkdir -p /etc/init.d.disabled

## Add repos ##
add-apt-repository -y multiverse \
    && add-apt-repository -y universe \
    && add-apt-repository -y ppa:jcfp/nobetas \
    && add-apt-repository -y ppa:jcfp/sab-addons \
    && apt -y update \
    && apt -y full-upgrade

## Fix locales and tzdata ##
ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime
export DEBIAN_FRONTEND=noninteractive
echo 'Europe/London' > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata
locale-gen 'en_GB.UTF-8'
dpkg-reconfigure --frontend=noninteractive locales
apt -y install tzdata
apt -y install locales

## Install sabnzbdplus and set build info ##
apt -y install sabnzbdplus par2-turbo
mv /etc/init.d/sabnzbdplus /etc/init.d.disabled/
SABNZBDPLUS_VERSION=$(sabnzbdplus -v | grep 'sabnzbdplus' | cut -d'-' -f 2)
echo "$(date "+%d.%m.%Y %T") Added sabnzbdplus version ${SABNZBDPLUS_VERSION}" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

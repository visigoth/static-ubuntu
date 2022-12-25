#!/bin/bash

## Install dependencies and fix locales and tzdata to prevent tzdata stopping installation ##
apt -y update \
    && apt -y install wget gnupg1 apt-transport-https \
    && apt -y install locales tzdata
locale-gen 'en_GB.UTF-8' \
    && dpkg-reconfigure --frontend=noninteractive locales
ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime \
    && echo 'Europe/London' > /etc/timezone \
    && dpkg-reconfigure --frontend=noninteractive tzdata

## Add depot ##
echo 'deb https://download.webmin.com/download/repository sarge contrib' | tee -a /etc/apt/sources.list
wget -q -O- http://www.webmin.com/jcameron-key.asc | apt-key add

## Install packages ##
apt update -y \
    && apt install -y isc-dhcp-server webmin perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl python unzip shared-mime-info

## Rename installed folder because /etc/webmin will be volume-ised ##
touch /etc/webmin/orig.flag
mv /etc/webmin /etc/webmin-orig

## Set build info ##
ISC_VERSION=$(apt-cache policy isc-dhcp-server | grep Installed | cut -d' ' -f 4)
echo "$(date "+%d.%m.%Y %T") Added ISC DHCP Server version ${ISC_VERSION}" >> /build.info
WEBMIN_VERSION=$(webmin --version)
echo "$(date "+%d.%m.%Y %T") Added WEBMIN version ${WEBMIN_VERSION}" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install gnupg software-properties-common

## Add repos ##
add-apt-repository -y multiverse \
    && add-apt-repository -y universe \
    && add-apt-repository -y ppa:jcfp/nobetas \
    && apt -y update \
    && apt -y full-upgrade
apt -y install sabnzbdplus

## Add sabnzbd repo ##
#apt-key adv --keyserver hkp://keyserver.ubuntu.com:11371 --recv-keys 0x98703123E0F52B2BE16D586EF13930B14BB9F05F \
#    && echo "deb http://ppa.launchpad.net/jcfp/nobetas/ubuntu focal main" >> /etc/apt/sources.list.d/sabnzbd.list \
#    && echo "deb-src http://ppa.launchpad.net/jcfp/nobetas/ubuntu focal main" >> /etc/apt/sources.list.d/sabnzbd.list \
#    && echo "deb http://ppa.launchpad.net/jcfp/sab-addons/ubuntu focal main" >> /etc/apt/sources.list.d/sabnzbd.list  \
#    && echo "deb-src http://ppa.launchpad.net/jcfp/sab-addons/ubuntu focal main" >> /etc/apt/sources.list.d/sabnzbd.list \
#    && apt -y update
#apt -y install libffi-dev libssl-dev p7zip-full par2-tbb python3 python3-cryptography python3-distutils python3-pip python3-setuptools unrar

## Install sabnzbd ##
#rm -rf /app/sabnzbd \
#    && curl -sL "https://github.com/sabnzbd/sabnzbd/releases/download/${SABNZBD_VERSION}/SABnzbd-${SABNZBD_VERSION}-src.tar.gz" -o /tmp/sabnzbd.tar.gz \
#    && mkdir -p /app/sabnzbd \
#    && tar xf /tmp/sabnzbd.tar.gz -C /app/sabnzbd --strip-components=1 \
#    && rm -f /tmp/sabnzbd.tar.gz \
#    && echo "$(date "+%d.%m.%Y %T") Added jackett version ${JACKETT_VERSION}" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

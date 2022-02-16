#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install gnupg dirmngr ca-certificates apt-transport-https

## Obtain latest mono stable version depo ##
UBUNTU_RELEASE=$(cat /etc/os-release | grep 'UBUNTU_CODENAME' | cut -d'=' -f 2)
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb https://download.mono-project.com/repo/ubuntu stable-${UBUNTU_RELEASE} main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
    && apt -y update

#MONO_VERSION=$(curl -s 'https://www.mono-project.com/download/stable/#download-lin-ubuntu' | grep 'latest Stable' | cut -d'(' -f 2 | cut -d')' -f 1)
#apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
#    && echo "deb https://download.mono-project.com/repo/ubuntu stable-${UBUNTU_RELEASE}/snapshots/${MONO_VERSION} main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
#    && apt -y update

## Install mono-complete (cover most cases of "assembly not found" errors) ##
apt-get -y install mono-complete
MONO_VERSION=$(mono --version | grep version | cut -d' ' -f 5)

## Set build info ##
echo "$(date "+%d.%m.%Y %T") Added mono version ${MONO_VERSION}" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

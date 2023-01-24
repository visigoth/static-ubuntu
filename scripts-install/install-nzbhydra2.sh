#!/bin/bash

## create man1 folder otherwise openjdk-11-jre-headless would fail because of reasons ##
#mkdir -p /usr/share/man/man1

## Install dependencies ##
apt -y update \
    && apt -y install python3 curl jq

# v5 no longer needs java but only for amd64 and arm64 so still installing
apt -y install openjdk-11-jre-headless

## Install nzbhydra2 and fix permission (new core permission fix for v5) ##
ARCHI=$(uname -m)
if [[ $ARCHI =~ "armv7l" ]]
then
    ARCHSTR="arm64"
elif [[ $ARCHI =~ "aarch64" ]]
then
    ARCHSTR="arm64"
elif [[ $ARCHI =~ "x86_64" ]]
then
    ARCHSTR="amd64"
else
    echo "$(date "+%d.%m.%Y %T") ERROR unexpected architecture $ARCHI" >> /build.info
fi
NZBHYDRA2_VERSION=$(curl -sX GET "https://api.github.com/repos/theotherp/nzbhydra2/releases/latest" | jq -r .tag_name | cut -d'v' -f 2)
rm -rf /app/nzbhydra2/bin \
    && curl -sL "https://github.com/theotherp/nzbhydra2/releases/download/v${NZBHYDRA2_VERSION}/nzbhydra2-${NZBHYDRA2_VERSION}-${ARCHSTR}-linux.zip" -o /tmp/nzbhydra2.zip \
    && mkdir -p /app/nzbhydra2/bin \
    && unzip /tmp/nzbhydra2.zip -d /app/nzbhydra2/bin \
    && chmod +x /app/nzbhydra2/bin/nzbhydra2wrapperPy3.py \
    && chmod +x /app/nzbhydra2/bin/nzbhydra2wrapper.py \
    && chmod +x /app/nzbhydra2/bin/nzbhydra2 \
    && chmod +x /app/nzbhydra2/bin/core \
    && rm -f /tmp/nzbhydra2.zip

## Set package info and build info ##
echo "ReleaseType=Release\nPackageVersion=${NZBHYDRA2_VERSION}\nPackageAuthor=[testdasi](https://github.com/testdasi)" > /app/nzbhydra2/package_info
echo "$(date "+%d.%m.%Y %T") Added nzbhydra2 version ${NZBHYDRA2_VERSION} for ${ARCHSTR}" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

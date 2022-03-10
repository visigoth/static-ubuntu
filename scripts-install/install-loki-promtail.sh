#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install curl jq unzip

# install loki and promtail
LOKI_RELEASE=$(curl -sX GET "https://api.github.com/repos/grafana/loki/releases/latest" | jq -r .tag_name)
LOKI_VER=${LOKI_RELEASE#v}
mkdir -p /tmp \
    && cd /tmp
curl -sL "https://github.com/grafana/loki/releases/download/v${LOKI_VER}/loki-linux-amd64.zip" -o /tmp/loki.zip \
    && unzip /tmp/loki.zip \
    && chmod a+x loki-linux-amd64 \
    && mv loki-linux-amd64 /usr/sbin/loki \
    && rm -f /tmp/loki.zip
curl -SL "https://github.com/grafana/loki/releases/download/v${LOKI_VER}/promtail-linux-amd64.zip" -o /tmp/promtail.zip \
    && unzip /tmp/promtail.zip \
    && chmod a+x promtail-linux-amd64 \
    && mv promtail-linux-amd64 /usr/sbin/promtail \
    && rm -f promtail-linux-amd64
echo "$(date "+%d.%m.%Y %T") Added loki and promtail binary version ${LOKI_VER}" >> /build.info

## Clean up ##
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

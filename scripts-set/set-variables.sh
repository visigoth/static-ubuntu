#!/bin/bash

## Set runtime variables depending on whether app is installed ##
echo '[info] Set runtime variables'

if [[ -f "/app/launcher/index.html" ]]
then
    LAUNCHER_PORT=${LAUNCHER_GUI_PORT}
    LAUNCHER_IP=${SERVER_IP}
fi

if [[ -f "/usr/bin/stubby" ]]
then
    DNS_PORT=${DNS_SERVER_PORT}
    # DoT port is fixed due to TLS protocol
    DOT_PORT=853
fi

if [[ -f "/usr/sbin/danted" ]]
then
    DANTE_PORT=${SOCKS_PROXY_PORT}
fi

if [[ -f "/usr/bin/tinyproxy" ]]
then
    TINYPROXY_PORT=${HTTP_PROXY_PORT}
fi

if [[ -f "/usr/sbin/tor" ]]
then
    TORSOCKS_PORT=${TOR_SOCKS_PORT}
    PRIVOXY_PORT=${TOR_HTTP_PORT}
fi

if [[ -f "/usr/bin/sabnzbdplus" ]]
then
    SAB_PORT_A=${USENET_HTTP_PORT}
    SAB_PORT_B=${USENET_HTTPS_PORT}
fi

if [[ -f "/usr/bin/flood" ]]
then
    FLOOD_IP=${SERVER_IP}
    FLOOD_PORT=${TORRENT_GUI_PORT}
fi

if [[ -f "/app/nzbhydra2/package_info" ]]
then
    HYDRA_PORT=${SEARCHER_GUI_PORT}
fi

if [[ -f "/app/sonarr/package_info" ]]
then
    SONARR_PORT=${PVR_TV_PORT}
fi

if [[ -f "/app/radarr/package_info" ]]
then
    RADARR_PORT=${PVR_MOVIE_PORT}
fi

if [[ -f "/app/prowlarr/package_info" ]]
then
    PROWLARR_PORT=${INDEXER_PORT}
fi

if [[ -f "/app/jackett/jackett" ]]
then
    JACKETT_PORT=${TORZNAB_PORT}
fi

if [[ -f "/usr/sbin/openvpn" ]]
then
    source /static-ubuntu/scripts-set/set-variables-ovpn-port-proto.sh
    source /static-ubuntu/scripts-set/set-variables-ovpn-eth0.sh
fi

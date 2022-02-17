#!/bin/bash

### DNS and DoT ports are fixed ###
echo '[info] Set runtime variables'

if [[ -f "" ]]
then
    LAUNCHER_PORT=${LAUNCHER_GUI_PORT}
    LAUNCHER_IP=${SERVER_IP}
fi

if [[ -f "" ]]
then
    DNS_PORT=${DNS_SERVER_PORT}
fi

if [[ -f "" ]]
then
    DANTE_PORT=${SOCKS_PROXY_PORT}
fi

if [[ -f "" ]]
then
    TINYPROXY_PORT=${HTTP_PROXY_PORT}
fi

if [[ -f "" ]]
then
    TORSOCKS_PORT=${TOR_SOCKS_PORT}
    PRIVOXY_PORT=${TOR_HTTP_PORT}
fi

if [[ -f "" ]]
then
    SAB_PORT_A=${USENET_HTTP_PORT}
    SAB_PORT_B=${USENET_HTTPS_PORT}
fi

if [[ -f "" ]]
then
    FLOOD_IP=${SERVER_IP}
    FLOOD_PORT=${TORRENT_GUI_PORT}
fi

if [[ -f "" ]]
then
    HYDRA_PORT=${SEARCHER_GUI_PORT}
fi

if [[ -f "" ]]
then
    SONARR_PORT=${PVR_TV_PORT}
fi

if [[ -f "" ]]
then
    RADARR_PORT=${PVR_MOVIE_PORT}
fi

if [[ -f "" ]]
then
    PROWLARR_PORT=${INDEXER_PORT}
fi

if [[ -f "" ]]
then
    JACKETT_PORT=${TORZNAB_PORT}
fi

# DoT port is fixed due to TLS protocol
DOT_PORT=853

### static scripts ###
source /static/scripts/set_variables_ovpn_port_proto.sh
source /static/scripts/set_variables_eth0.sh

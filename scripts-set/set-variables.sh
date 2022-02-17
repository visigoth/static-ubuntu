#!/bin/bash

## Check app is installed before performing tasks ##
echo '[info] Set runtime variables and fix configs'

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
    source /static-ubuntu/scripts-fix/fix-stubby.sh
fi

if [[ -f "/usr/sbin/danted" ]]
then
    DANTE_PORT=${SOCKS_PROXY_PORT}
    source /static-ubuntu/scripts-fix/fix-dante.sh
fi

if [[ -f "/usr/bin/tinyproxy" ]]
then
    TINYPROXY_PORT=${HTTP_PROXY_PORT}
    source /static-ubuntu/scripts-fix/fix-tinyproxy.sh
fi

if [[ -f "/usr/sbin/tor" ]]
then
    TORSOCKS_PORT=${TOR_SOCKS_PORT}
    source /static-ubuntu/scripts-fix/fix-torsocks.sh
    PRIVOXY_PORT=${TOR_HTTP_PORT}
    source /static-ubuntu/scripts-fix/fix-privoxy.sh
fi

if [[ -f "/usr/bin/sabnzbdplus" ]]
then
    SAB_PORT_A=${USENET_HTTP_PORT}
    SAB_PORT_B=${USENET_HTTPS_PORT}
    source /static-ubuntu/scripts-fix/fix-sabnzbdplus.sh
fi

if [[ -f "/usr/bin/flood" ]]
then
    FLOOD_IP=${SERVER_IP}
    FLOOD_PORT=${TORRENT_GUI_PORT}
    source /static-ubuntu/scripts-fix/fix-flood.sh
    source /static-ubuntu/scripts-fix/fix-transmission.sh
fi

if [[ -f "/app/nzbhydra2/package_info" ]]
then
    HYDRA_PORT=${SEARCHER_GUI_PORT}
    source /static-ubuntu/scripts-fix/fix-nzbhydra2.sh
fi

if [[ -f "/app/sonarr/package_info" ]]
then
    SONARR_PORT=${PVR_TV_PORT}
    source /static-ubuntu/scripts-fix/fix-sonarr.sh
fi

if [[ -f "/app/radarr/package_info" ]]
then
    RADARR_PORT=${PVR_MOVIE_PORT}
    source /static-ubuntu/scripts-fix/fix-radarr.sh
    source /static-ubuntu/scripts-fix/fix-prowlarr.sh
fi

if [[ -f "/app/prowlarr/package_info" ]]
then
    PROWLARR_PORT=${INDEXER_PORT}
fi

if [[ -f "/app/jackett/jackett" ]]
then
    JACKETT_PORT=${TORZNAB_PORT}
    source /static-ubuntu/scripts-fix/fix-jackett.sh
fi

if [[ -f "/usr/sbin/openvpn" ]]
then
    source /static-ubuntu/scripts-set/set-variables-ovpn-port-proto.sh
    source /static-ubuntu/scripts-set/set-variables-ovpn-eth0.sh
fi

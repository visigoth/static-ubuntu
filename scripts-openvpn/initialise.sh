#!/bin/bash

## Check app is installed before performing tasks ##
echo '[info] Set runtime variables and fix configs'

# Fix nftables if installed. Kill docker otherwise. #
if [[ -f "/usr/sbin/nft" ]]
then
    source /static-ubuntu/scripts-fix/fix-nftables.sh
else
    kill $(pgrep entrypoint.sh)
fi


if [[ -f "/usr/bin/stubby" ]]
then
    source /static-ubuntu/scripts-fix/fix-stubby.sh
fi

if [[ -f "/usr/sbin/danted" ]]
then
    source /static-ubuntu/scripts-fix/fix-dante.sh
fi

if [[ -f "/usr/bin/tinyproxy" ]]
then
    source /static-ubuntu/scripts-fix/fix-tinyproxy.sh
fi

if [[ -f "/usr/sbin/tor" ]]
then
    source /static-ubuntu/scripts-fix/fix-torsocks.sh
fi

if [[ -f "/usr/sbin/privoxy" ]]
then
    source /static-ubuntu/scripts-fix/fix-privoxy.sh
fi

# Always fix launcher before webapps to create index.html #
if [[ -f "/app/launcher/index.html" ]]
then
    source /static-ubuntu/scripts-fix/fix-launcher.sh
fi

if [[ -f "/usr/bin/sabnzbdplus" ]]
then
    source /static-ubuntu/scripts-fix/fix-sabnzbdplus.sh
fi

if [[ -f "/usr/bin/flood" ]]
then
    source /static-ubuntu/scripts-fix/fix-flood.sh
fi

if [[ -f "/usr/bin/transmission-daemon" ]]
then
    source /static-ubuntu/scripts-fix/fix-transmission.sh
fi

if [[ -f "/app/nzbhydra2/package_info" ]]
then
    source /static-ubuntu/scripts-fix/fix-nzbhydra2.sh
fi

if [[ -f "/app/sonarr/package_info" ]]
then
    source /static-ubuntu/scripts-fix/fix-sonarr.sh
fi

if [[ -f "/app/radarr/package_info" ]]
then
    source /static-ubuntu/scripts-fix/fix-radarr.sh
fi

if [[ -f "/app/prowlarr/package_info" ]]
then
    source /static-ubuntu/scripts-fix/fix-prowlarr.sh
fi

if [[ -f "/app/jackett/jackett" ]]
then
    source /static-ubuntu/scripts-fix/fix-jackett.sh
fi

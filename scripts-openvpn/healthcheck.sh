#!/bin/bash

## No healthcheck if disable_healthcheck is set ##
if [[ -f "/config/disable_healthcheck" ]]
then
    echo '[info] Healthcheck disabled when openvpn is connecting...'
else
    # Critical - kill docker if openvpn crashed #
    pidlist=$(pidof openvpn)
    if [ -z "$pidlist" ]
    then
        # killing init script to kill docker
        kill $(pgrep entrypoint.sh)
        exit 1
    fi
    
    # Block concurrent runs #
    touch /config/disable_healthcheck

    # Autoheal #
    crashed=0

    pidlist=$(pidof stubby)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/bin/stubby" ]]
        then
            crashed=$(( $crashed + 1 ))
            stubby -g -C /config/stubby/stubby.yml
        fi
    fi

    pidlist=$(pidof danted)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/sbin/danted" ]]
        then
            crashed=$(( $crashed + 1 ))
            danted -D -f /config/dante/danted.conf
        fi
    fi

    pidlist=$(pidof tinyproxy)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/bin/tinyproxy" ]]
        then
            crashed=$(( $crashed + 1 ))
            tinyproxy -c /config/tinyproxy/tinyproxy.conf
        fi
    fi

    pidlist=$(pidof tor)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/sbin/tor" ]]
        then
            crashed=$(( $crashed + 1 ))
            start-stop-daemon --start --background --name tor --exec /usr/bin/tor -- -f /config/tor/torrc
        fi
    fi

    pidlist=$(pidof privoxy)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/sbin/privoxy" ]]
        then
            crashed=$(( $crashed + 1 ))
            privoxy /config/privoxy/config
        fi
    fi

    pidlist=$(pgrep sabnzbdplus)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/bin/sabnzbdplus" ]]
        then
            crashed=$(( $crashed + 1 ))
            sabnzbdplus --daemon --config-file /config/sabnzbdplus/sabnzbdplus.ini --pidfile /config/sabnzbdplus/sabnzbd.pid
        fi
    fi

    pidlist=$(pgrep nzbhydra2)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/nzbhydra2/package_info" ]]
        then
            crashed=$(( $crashed + 1 ))
            /app/nzbhydra2/nzbhydra2 --daemon --nobrowser --java /usr/lib/jvm/java-11-openjdk-amd64/bin/java --datafolder /config/nzbhydra2 --pidfile /config/nzbhydra2/nzbhydra2.pid
        fi
    fi

    pidlist=$(pidof transmission-daemon)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/bin/transmission-daemon" ]]
        then
            crashed=$(( $crashed + 1 ))
            transmission-daemon --config-dir=/config/transmission
        fi
    fi

    # Flood #
    pidlist=$(pidof node)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/bin/flood" ]]
        then
            crashed=$(( $crashed + 1 ))
            start-stop-daemon --start --background --name flood --chdir /usr/bin --exec flood -- --rundir=/config/flood --host=${SERVER_IP} --port=${TORRENT_GUI_PORT}
        fi
    fi

    pidlist=$(pidof jackett)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/jackett/jackett" ]]
        then
            crashed=$(( $crashed + 1 ))
            start-stop-daemon --start --background --chuid nobody --name jackett --chdir /app/jackett --exec /app/jackett/jackett -- --DataFolder=/config/jackett
        fi
    fi

    pidlist=$(pidof mono-sonarr)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/sonarr/package_info" ]]
        then
            crashed=$(( $crashed + 1 ))
            start-stop-daemon --start --background --name sonarr --chdir /app/sonarr --exec /usr/bin/mono-sonarr -- --debug Sonarr.exe -nobrowser -data=/config/sonarr
        fi
    fi

    pidlist=$(pidof Radarr)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/radarr/package_info" ]]
        then
            crashed=$(( $crashed + 1 ))
            start-stop-daemon --start --background --name radarr --chdir /app/radarr --exec /app/radarr/Radarr -- -nobrowser -data=/config/radarr
        fi
    fi

    pidlist=$(pidof Prowlarr)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/prowlarr/package_info" ]]
        then
            crashed=$(( $crashed + 1 ))
            start-stop-daemon --start --background --name prowlarr --chdir /app/prowlarr --exec /app/prowlarr/Prowlarr -- -nobrowser -data=/config/prowlarr
        fi
    fi

    pidlist=$(pidof python3-launcher)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/launcher/index.html" ]]
        then
            crashed=$(( $crashed + 1 ))
            start-stop-daemon --start --background --name launcher --chdir /app/launcher --exec /app/launcher/launcher-python3.sh
        fi
    fi
    
    # Remove blockage #
    rm -f /config/disable_healthcheck
    
    # Return exit code for healthcheck #
    if (( $crashed > 0 ))
    then
        exit 1
    else
        exit 0
    fi
fi

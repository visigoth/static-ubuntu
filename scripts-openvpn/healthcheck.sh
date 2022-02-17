#!/bin/bash

## No healthcheck if healthcheck-disable is set ##
if [[ -f "/config/healthcheck-disable" ]]
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
    touch /config/healthcheck-disable

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
            echo "[info] Run danted in background on port $DANTE_PORT"
            danted -D -f /config/dante/danted.conf
        fi
    fi

    pidlist=$(pidof tinyproxy)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/bin/tinyproxy" ]]
        then
            crashed=$(( $crashed + 1 ))
            echo "[info] Run tinyproxy in background with no log on port $TINYPROXY_PORT"
            tinyproxy -c /config/tinyproxy/tinyproxy.conf
        fi
    fi

    pidlist=$(pidof tor)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/sbin/tor" ]]
        then
            crashed=$(( $crashed + 1 ))
            echo "[info] Run tor in background on port $TORSOCKS_PORT"
            start-stop-daemon --start --background --name tor --exec /usr/bin/tor -- -f /config/tor/torrc
        fi
    fi

    pidlist=$(pidof privoxy)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/sbin/privoxy" ]]
        then
            crashed=$(( $crashed + 1 ))
            echo "[info] Run privoxy in background on port $PRIVOXY_PORT"
            privoxy /config/privoxy/config
        fi
    fi

    pidlist=$(pgrep sabnzbdplus)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/bin/sabnzbdplus" ]]
        then
            crashed=$(( $crashed + 1 ))
            echo "[info] Run sabnzbdplus in background on HTTP port $SAB_PORT_A and HTTPS port $SAB_PORT_B"
            sabnzbdplus --daemon --config-file /config/sabnzbdplus/sabnzbdplus.ini --pidfile /config/sabnzbdplus/sabnzbd.pid
        fi
    fi

    pidlist=$(pgrep nzbhydra2)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/nzbhydra2/package_info" ]]
        then
            crashed=$(( $crashed + 1 ))
            echo "[info] Run nzbhydra2 in background on port $HYDRA_PORT"
            /app/nzbhydra2/bin/nzbhydra2 --daemon --nobrowser --java /usr/lib/jvm/java-11-openjdk-amd64/bin/java --datafolder /config/nzbhydra2 --pidfile /config/nzbhydra2/nzbhydra2.pid
        fi
    fi

    pidlist=$(pidof transmission-daemon)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/bin/transmission-daemon" ]]
        then
            crashed=$(( $crashed + 1 ))
            TUN0_IP=$(ip addr show tun0 | grep inet | awk '{print $2}' | cut -d'/' -f 1)
            if [ -z $TUN0_IP ]; then
                echo "[CRITICAL] Tunnel not found. Will not start transmission"
            else
                echo "[info] Run transmission-daemon in background with tun0 ipv4 bind at $TUN0_IP and disabled ipv6 bind"
                transmission-daemon --config-dir=/config/transmission --bind-address-ipv4=$TUN0_IP --bind-address-ipv6=fe80::
            fi
        fi
    fi

    # Flood #
    pidlist=$(pidof node)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/bin/flood" ]]
        then
            crashed=$(( $crashed + 1 ))
            echo "[info] Run flood in background at $FLOOD_IP:$FLOOD_PORT"
            start-stop-daemon --start --background --name flood --chdir /usr/bin --exec /usr/bin/flood -- --rundir=/config/flood --host=${SERVER_IP} --port=${TORRENT_GUI_PORT}
        fi
    fi

    pidlist=$(pidof jackett)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/jackett/jackett" ]]
        then
            crashed=$(( $crashed + 1 ))
            echo "[info] Run jackett in background on port $JACKETT_PORT"
            start-stop-daemon --start --background --chuid nobody --name jackett --chdir /app/jackett --exec /app/jackett/jackett -- --DataFolder=/config/jackett
        fi
    fi

    pidlist=$(pidof mono-sonarr)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/sonarr/package_info" ]]
        then
            crashed=$(( $crashed + 1 ))
            echo "[info] Run sonarr in background on port $SONARR_PORT"
            start-stop-daemon --start --background --name sonarr --chdir /app/sonarr/bin --exec /usr/bin/mono-sonarr -- --debug Sonarr.exe -nobrowser -data=/config/sonarr
        fi
    fi

    pidlist=$(pidof Radarr)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/radarr/package_info" ]]
        then
            crashed=$(( $crashed + 1 ))
            echo "[info] Run radarr in background on port $RADARR_PORT"
            start-stop-daemon --start --background --name radarr --chdir /app/radarr/bin --exec /app/radarr/bin/Radarr -- -nobrowser -data=/config/radarr
        fi
    fi

    pidlist=$(pidof Prowlarr)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/prowlarr/package_info" ]]
        then
            crashed=$(( $crashed + 1 ))
            echo "[info] Run prowlarr in background on port $PROWLARR_PORT"
            start-stop-daemon --start --background --name prowlarr --chdir /app/prowlarr/bin --exec /app/prowlarr/bin/Prowlarr -- -nobrowser -data=/config/prowlarr
        fi
    fi

    pidlist=$(pidof python3-launcher)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/launcher/index.html" ]]
        then
            crashed=$(( $crashed + 1 ))
            echo "[info] Run WebUI launcher in background at $LAUNCHER_IP:$LAUNCHER_PORT"
            start-stop-daemon --start --background --name launcher --chdir /app/launcher --exec /app/launcher/launcher-python3.sh
        fi
    fi
    
    # Remove blockage #
    rm -f /config/healthcheck-disable
    
    # No error if healthcheck-no-error is set #
    if [[ -f "/config/healthcheck-no-error" ]]
    then
        echo ''
    else
        # Return exit code for healthcheck #
        if (( $crashed > 0 ))
        then
            touch "/config/healthcheck-failure-at-$(date "+%d.%m.%Y_%T")"
            exit 1
        else
            exit 0
        fi
    fi
fi

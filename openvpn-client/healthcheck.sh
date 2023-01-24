#!/bin/bash

## No healthcheck if healthcheck-disable is set ##
if [[ -f "/config/healthcheck-disable" ]]
then
    # return unhealthy state if openvpn is still connecting #
    if [[ -f "/config/openvpn-connecting" ]]
    then
        exit 1
    fi
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
            if [[ -f "/config/healthcheck-no-error" ]]
            then
                echo ''
            else
                crashed=$(( $crashed + 1 ))
                touch "/config/healthcheck-failure-stubby-at-$(date "+%d.%m.%Y_%T")"
            fi
            stubby -g -C /config/stubby/stubby.yml
        fi
    fi

    pidlist=$(pidof danted)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/sbin/danted" ]]
        then
            if [[ -f "/config/healthcheck-no-error" ]]
            then
                echo ''
            else
                crashed=$(( $crashed + 1 ))
                touch "/config/healthcheck-failure-danted-at-$(date "+%d.%m.%Y_%T")"
            fi
            echo "[info] Run danted in background on port $DANTE_PORT"
            danted -D -f /config/dante/danted.conf
        fi
    fi

    pidlist=$(pidof tinyproxy)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/bin/tinyproxy" ]]
        then
            if [[ -f "/config/healthcheck-no-error" ]]
            then
                echo ''
            else
                crashed=$(( $crashed + 1 ))
                touch "/config/healthcheck-failure-tinyproxy-at-$(date "+%d.%m.%Y_%T")"
            fi
            echo "[info] Run tinyproxy in background with no log on port $TINYPROXY_PORT"
            tinyproxy -c /config/tinyproxy/tinyproxy.conf
        fi
    fi

    if [[ -f "/usr/sbin/tor" ]]
    then
        pidlist=$(pidof tor)
        if [ -z "$pidlist" ]
        then
            if [[ -f "/config/healthcheck-no-error" ]]
            then
                echo ''
            else
                crashed=$(( $crashed + 1 ))
                touch "/config/healthcheck-failure-tor-at-$(date "+%d.%m.%Y_%T")"
            fi
            echo "[info] Run tor in background on port $TORSOCKS_PORT"
            tor --hush --runasdaemon 1 -f /config/tor/torrc
        fi
    fi

    if [[ -f "/usr/sbin/privoxy" ]]
    then
        pidlist=$(pidof privoxy)
        if [ -z "$pidlist" ]
        then
            if [[ -f "/config/healthcheck-no-error" ]]
            then
                echo ''
            else
                crashed=$(( $crashed + 1 ))
                touch "/config/healthcheck-failure-privoxy-at-$(date "+%d.%m.%Y_%T")"
            fi
            echo "[info] Run privoxy in background on port $PRIVOXY_PORT"
            privoxy /config/privoxy/config
        fi
    fi

    pidlist=$(pgrep sabnzbdplus)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/bin/sabnzbdplus" ]]
        then
            if [[ -f "/config/healthcheck-no-error" ]]
            then
                echo ''
            else
                crashed=$(( $crashed + 1 ))
                touch "/config/healthcheck-failure-sabnzbdplus-at-$(date "+%d.%m.%Y_%T")"
            fi
            echo "[info] Run sabnzbdplus in background on HTTP port $SAB_PORT_A and HTTPS port $SAB_PORT_B"
            sabnzbdplus --daemon --config-file /config/sabnzbdplus/sabnzbdplus.ini --pidfile /config/sabnzbdplus/sabnzbd.pid
        fi
    fi

    #pidlist=$(pgrep nzbhydra2)
    pidlist=$(pidof python3-nzbhydra2)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/nzbhydra2/package_info" ]]
        then
            if [[ -f "/config/healthcheck-no-error" ]]
            then
                echo ''
            else
                crashed=$(( $crashed + 1 ))
                touch "/config/healthcheck-failure-nzbhydra2-at-$(date "+%d.%m.%Y_%T")"
            fi
            echo "[info] Run nzbhydra2 in background on port $HYDRA_PORT"
            ## v5 requires running in the same folder as the python wrapper ##
            cd /app/nzbhydra2/bin
            ## v5 doesn't need java but only for amd64 and arm64 ##
            ARCHI=$(uname -m)
            if [[ $ARCHI =~ "armv7l" ]]
            then
                python3-nzbhydra2 /app/nzbhydra2/bin/nzbhydra2wrapperPy3.py --daemon --nobrowser --java /usr/lib/jvm/java-11-openjdk-armhf/bin/java --datafolder /config/nzbhydra2 --pidfile /config/nzbhydra2/nzbhydra2.pid
            elif [[ $ARCHI =~ "aarch64" ]]
            then
                #python3-nzbhydra2 /app/nzbhydra2/bin/nzbhydra2wrapperPy3.py --daemon --nobrowser --java /usr/lib/jvm/java-11-openjdk-arm64/bin/java --datafolder /config/nzbhydra2 --pidfile /config/nzbhydra2/nzbhydra2.pid
                python3-nzbhydra2 /app/nzbhydra2/bin/nzbhydra2wrapperPy3.py --daemon --nobrowser --datafolder /config/nzbhydra2 --pidfile /config/nzbhydra2/nzbhydra2.pid
            elif [[ $ARCHI =~ "x86_64" ]]
            then
                #python3-nzbhydra2 /app/nzbhydra2/bin/nzbhydra2wrapperPy3.py --daemon --nobrowser --java /usr/lib/jvm/java-11-openjdk-amd64/bin/java --datafolder /config/nzbhydra2 --pidfile /config/nzbhydra2/nzbhydra2.pid
                python3-nzbhydra2 /app/nzbhydra2/bin/nzbhydra2wrapperPy3.py --daemon --nobrowser --datafolder /config/nzbhydra2 --pidfile /config/nzbhydra2/nzbhydra2.pid
            else
                touch "/config/debug-ARCHI_is_$ARCHI-$(date "+%d.%m.%Y_%T")"
            fi
        fi
    fi

    pidlist=$(pidof transmission-daemon)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/usr/bin/transmission-daemon" ]]
        then
            if [[ -f "/config/healthcheck-no-error" ]]
            then
                echo ''
            else
                crashed=$(( $crashed + 1 ))
                touch "/config/healthcheck-failure-transmission-at-$(date "+%d.%m.%Y_%T")"
            fi
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
            if [[ -f "/config/healthcheck-no-error" ]]
            then
                echo ''
            else
                crashed=$(( $crashed + 1 ))
                touch "/config/healthcheck-failure-flood-at-$(date "+%d.%m.%Y_%T")"
            fi
            echo "[info] Run flood in background at $FLOOD_IP:$FLOOD_PORT"
            start-stop-daemon --start --background --name flood --chdir /usr/bin --exec /usr/bin/flood -- --rundir=/config/flood --host=${SERVER_IP} --port=${TORRENT_GUI_PORT}
        fi
    fi

    pidlist=$(pidof jackett)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/jackett/jackett" ]]
        then
            if [[ -f "/config/healthcheck-no-error" ]]
                then
                    echo ''
                else
                    crashed=$(( $crashed + 1 ))
                    touch "/config/healthcheck-failure-jackett-at-$(date "+%d.%m.%Y_%T")"
                fi
            echo "[info] Run jackett in background on port $JACKETT_PORT"
            start-stop-daemon --start --background --chuid nobody --name jackett --chdir /app/jackett --exec /app/jackett/jackett -- --DataFolder=/config/jackett
        fi
    fi

    pidlist=$(pidof mono-sonarr)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/sonarr/package_info" ]]
        then
            if [[ -f "/config/healthcheck-no-error" ]]
            then
                echo ''
            else
                crashed=$(( $crashed + 1 ))
                touch "/config/healthcheck-failure-sonarr-at-$(date "+%d.%m.%Y_%T")"
            fi
            echo "[info] Run sonarr in background on port $SONARR_PORT"
            start-stop-daemon --start --background --name sonarr --chdir /app/sonarr/bin --exec /usr/bin/mono-sonarr -- --debug Sonarr.exe -nobrowser -data=/config/sonarr
        fi
    fi

    pidlist=$(pidof Radarr)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/radarr/package_info" ]]
        then
            if [[ -f "/config/healthcheck-no-error" ]]
            then
                echo ''
            else
                crashed=$(( $crashed + 1 ))
                touch "/config/healthcheck-failure-radarr-at-$(date "+%d.%m.%Y_%T")"
            fi
            echo "[info] Run radarr in background on port $RADARR_PORT"
            start-stop-daemon --start --background --name radarr --chdir /app/radarr/bin --exec /app/radarr/bin/Radarr -- -nobrowser -data=/config/radarr
        fi
    fi

    pidlist=$(pidof Prowlarr)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/prowlarr/package_info" ]]
        then
            if [[ -f "/config/healthcheck-no-error" ]]
            then
                echo ''
            else
                crashed=$(( $crashed + 1 ))
                touch "/config/healthcheck-failure-prowlarr-at-$(date "+%d.%m.%Y_%T")"
            fi
            echo "[info] Run prowlarr in background on port $PROWLARR_PORT"
            start-stop-daemon --start --background --name prowlarr --chdir /app/prowlarr/bin --exec /app/prowlarr/bin/Prowlarr -- -nobrowser -data=/config/prowlarr
        fi
    fi

    pidlist=$(pidof python3-launcher)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/app/launcher/index.html" ]]
        then
            if [[ -f "/config/healthcheck-no-error" ]]
            then
                echo ''
            else
                crashed=$(( $crashed + 1 ))
                touch "/config/healthcheck-failure-launcher-at-$(date "+%d.%m.%Y_%T")"
            fi
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
            #touch "/config/debug-healthcheck-failure-at-$(date "+%d.%m.%Y_%T")"
            exit 1
        else
            exit 0
        fi
    fi
fi

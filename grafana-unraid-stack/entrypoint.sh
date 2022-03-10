#!/bin/bash

# Initilise apps #
echo ''
echo '[info] Initialisation started...'
source static-ubuntu/grafana-unraid-stack/initialise.sh
echo '[info] Initialisation complete'

# Run apps #
echo ''
echo "[info] Runing apps..."
touch /config/healthcheck-no-error
source /static-ubuntu/scripts-openvpn/healthcheck.sh
rm -f /config/healthcheck-no-error
echo "[info] All done"

### Infinite loop to stop docker from stopping ###
sleep_time=3600
while true
do
    echo ''

    pidlist=$(pidof influxd)
    if [ -z "$pidlist" ]
    then
        echo '[error] influxdb crashed!'
    else
        echo "[info] influxdb PID: $pidlist"
    fi

    pidlist=$(pidof loki)
    if [ -z "$pidlist" ]
    then
        echo '[error] loki crashed!'
    else
        echo "[info] loki PID: $pidlist"
    fi

    if [[ $USE_HDDTEMP =~ "yes" ]]
    then
        pidlist=$(pidof hddtemp)
        if [ -z "$pidlist" ]
        then
            echo '[error] hddtemp crashed!'
        else
            echo "[info] hddtemp PID: $pidlist"
        fi
    else
        echo "[info] Skip hddtemp due to USE_HDDTEMP set to $USE_HDDTEMP"
    fi

    pidlist=$(pidof telegraf)
    if [ -z "$pidlist" ]
    then
        echo '[error] telegraf crashed!'
    else
        echo "[info] telegraf PID: $pidlist"
    fi

    pidlist=$(pidof promtail)
    if [ -z "$pidlist" ]
    then
        echo '[error] promtail crashed!'
    else
        echo "[info] promtail PID: $pidlist"
    fi

    pidlist=$(pidof grafana-server)
    if [ -z "$pidlist" ]
    then
        echo '[error] grafana crashed!'
    else
        echo "[info] grafana PID: $pidlist"
    fi

    sleep $sleep_time
done

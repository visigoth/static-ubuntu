#!/bin/bash
set -e

# Initialise apps #
echo ''
echo '[info] Initialisation started...'
/static-ubuntu/grafana-unraid-stack/initialise.sh
echo '[info] Initialisation complete'

# Run apps #
echo ''
echo "[info] Running apps..."
/static-ubuntu/grafana-unraid-stack/healthcheck.sh
echo "[info] All done"

### Infinite loop to stop docker from stopping ###
sleep_time=3600
while true
do
    echo ''

    pidlist=$(pidof influxd || echo "")
    if [ -z "$pidlist" ]
    then
        echo '[error] influxdb crashed!'
    else
        echo "[info] influxdb PID: $pidlist"
    fi

    pidlist=$(pidof loki || echo "")
    if [ -z "$pidlist" ]
    then
        echo '[error] loki crashed!'
    else
        echo "[info] loki PID: $pidlist"
    fi

    if [[ $USE_HDDTEMP =~ "yes" ]]
    then
        pidlist=$(pidof hddtemp || echo "")
        if [ -z "$pidlist" ]
        then
            echo '[error] hddtemp crashed!'
        else
            echo "[info] hddtemp PID: $pidlist"
        fi
    else
        echo "[info] Skip hddtemp due to USE_HDDTEMP set to $USE_HDDTEMP"
    fi

    pidlist=$(pidof telegraf || echo "")
    if [ -z "$pidlist" ]
    then
        echo '[error] telegraf crashed!'
    else
        echo "[info] telegraf PID: $pidlist"
    fi

    pidlist=$(pidof promtail || echo "")
    if [ -z "$pidlist" ]
    then
        echo '[error] promtail crashed!'
    else
        echo "[info] promtail PID: $pidlist"
    fi

    if service grafana-server status >/dev/null 2>&1
    then
        echo "[info] grafana-server is running"
    else
        echo '[error] grafana-server crashed!'
    fi

    sleep $sleep_time
done

#!/bin/bash

# Autoheal #
crashed=0

pidlist=$(pidof influxd)
if [ -z "$pidlist" ]
then
    crashed=$(( $crashed + 1 ))
    echo "[info] Run influxdb as service on port $INFLUXDB_HTTP_PORT"
    service influxdb start
fi

pidlist=$(pidof loki)
if [ -z "$pidlist" ]
then
    crashed=$(( $crashed + 1 ))
    echo "[info] Run loki as daemon on port $LOKI_PORT"
    start-stop-daemon --start -b --exec /usr/sbin/loki -- -config.file=/config/loki/loki-local-config.yaml
fi

if [[ $USE_HDDTEMP =~ "yes" ]]
then
    pidlist=$(pidof hddtemp)
    if [ -z "$pidlist" ]
    then
        crashed=$(( $crashed + 1 ))
        echo "[info] Running hddtemp as daemon due to USE_HDDTEMP set to $USE_HDDTEMP"
        hddtemp --quiet --daemon --file=/config/hddtemp/hddtemp.db --listen='127.0.0.1' --port=7634 /rootfs/dev/disk/by-id/ata*
    fi
fi

pidlist=$(pidof telegraf)
if [ -z "$pidlist" ]
then
    crashed=$(( $crashed + 1 ))
    echo "[info] Run telegraf as service"
    service telegraf start
fi

pidlist=$(pidof promtail)
if [ -z "$pidlist" ]
then
    crashed=$(( $crashed + 1 ))
    echo "[info] Run promtail as daemon on port $PROMTAIL_PORT"
    start-stop-daemon --start -b --exec /usr/sbin/promtail -- -config.file=/config/promtail/promtail.yml
fi

pidlist=$(pidof grafana-server)
if [ -z "$pidlist" ]
then
    crashed=$(( $crashed + 1 ))
    echo "[info] Run grafana as service on port $GRAFANA_PORT"
    service grafana-server start
fi

# Return exit code for healthcheck #
if (( $crashed > 0 ))
then
    exit 1
else
    exit 0
fi

#!/bin/bash
set -e

# Check and start influxdb if not running
pidlist=$(pidof influxd)
if [ -z "$pidlist" ]
then
    echo "[info] Run influxdb as service on port $INFLUXDB_HTTP_PORT"
    service influxdb start
fi

# Check and start loki if not running
pidlist=$(pidof loki)
if [ -z "$pidlist" ]
then
    echo "[info] Run loki as daemon on port $LOKI_PORT"
    start-stop-daemon --start -b --exec /usr/sbin/loki -- -config.file=/config/loki/loki-local-config.yaml
fi

# Check and start hddtemp if enabled and not running
if [[ $USE_HDDTEMP =~ "yes" ]]
then
    pidlist=$(pidof hddtemp)
    if [ -z "$pidlist" ]
    then
        echo "[info] Running hddtemp as daemon due to USE_HDDTEMP set to $USE_HDDTEMP"
        hddtemp --quiet --daemon --file=/config/hddtemp/hddtemp.db --listen='127.0.0.1' --port=7634 /rootfs/dev/disk/by-id/ata*
    fi
fi

# Check and start telegraf if not running
pidlist=$(pidof telegraf)
if [ -z "$pidlist" ]
then
    echo "[info] Run telegraf as service"
    service telegraf start
fi

# Check and start promtail if not running
pidlist=$(pidof promtail)
if [ -z "$pidlist" ]
then
    echo "[info] Run promtail as daemon on port $PROMTAIL_PORT"
    start-stop-daemon --start -b --exec /usr/sbin/promtail -- -config.file=/config/promtail/promtail.yml
fi

# Check and start grafana-server if not running
pidlist=$(pidof grafana-server)
if [ -z "$pidlist" ]
then
    echo "[info] Run grafana as service on port $GRAFANA_PORT"
    service grafana-server start
fi
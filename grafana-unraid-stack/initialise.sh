#!/bin/bash
set -e

mkdir -p /config/influxdb \
    && mkdir -p /data/influxdb/data \
    && mkdir -p /data/influxdb/meta \
    && mkdir -p /data/influxdb/wal \
    && rm -f /config/influxdb/influxd.pid \
    && rm -f /config/influxdb/influxd.log \
    && cp -n /static-ubuntu/grafana-unraid-stack/influxdb/influxdb.conf /config/influxdb/
sed -i "s|:8086|:$INFLUXDB_HTTP_PORT|g" '/config/influxdb/influxdb.conf'
sed -i "s|:8088|:$INFLUXDB_RPC_PORT|g" '/config/influxdb/influxdb.conf'
echo '[info] influxdb fixed.'

mkdir -p /config/loki \
    && mkdir -p /data/loki/chunks \
    && mkdir -p /data/loki/index \
    && cp -n /static-ubuntu/grafana-unraid-stack/loki/loki-local-config.yaml /config/loki/
sed -i "s|: 3100|: $LOKI_PORT|g" '/config/loki/loki-local-config.yaml'
echo '[info] loki fixed.'

mkdir -p /config/telegraf/telegraf.d \
    && rm -f /config/telegraf/telegraf.pid
if [[ $USE_HDDTEMP =~ "yes" ]]
then
    mkdir -p /config/hddtemp \
        && cp -n /static-ubuntu/grafana-unraid-stack/hddtemp/hddtemp.db /config/hddtemp/
    echo '[info] hddtemp fixed.'
    cp -n /static-ubuntu/grafana-unraid-stack/telegraf/telegraf-hddtemp.conf /config/telegraf/telegraf.conf
else
    cp -n /static-ubuntu/grafana-unraid-stack/telegraf/telegraf-smart.conf /config/telegraf/telegraf.conf
fi
sed -i "s|127\.0\.0\.1:8086|127\.0\.0\.1:$INFLUXDB_HTTP_PORT|g" '/config/telegraf/telegraf.conf'
echo '[info] telegraf fixed.'

mkdir -p /config/promtail \
    && mkdir -p /data/promtail \
    && cp -n /static-ubuntu/grafana-unraid-stack/promtail/promtail.yml /config/promtail/
sed -i "s|127\.0\.0\.1:3100|127\.0\.0\.1:$LOKI_PORT|g" '/config/promtail/promtail.yml'
sed -i "s|http_listen_port: 9080|http_listen_port: $PROMTAIL_PORT|g" '/config/promtail/promtail.yml'
echo '[info] promtail fixed.'

mkdir -p /config/grafana/data/plugins \
    && mkdir -p /config/grafana/log \
    && mkdir -p /config/grafana/data/dashboards \
    && mkdir -p /config/grafana/provisioning/dashboards \
    && mkdir -p /config/grafana/provisioning/datasources \
    && mkdir -p /config/grafana/provisioning/notifiers \
    && mkdir -p /config/grafana/provisioning/plugins \
    && rm -f /config/grafana/grafana-server.pid \
    && cp -n /static-ubuntu/grafana-unraid-stack/grafana/provisioning/datasources/* /config/grafana/provisioning/datasources/ \
    && cp -n /static-ubuntu/grafana-unraid-stack/grafana/provisioning/dashboards/* /config/grafana/provisioning/dashboards/ \
    && cp -n /static-ubuntu/grafana-unraid-stack/grafana/data/dashboards/* /config/grafana/data/dashboards/ \
    && cp -n /static-ubuntu/grafana-unraid-stack/grafana/grafana.ini /config/grafana/
sed -i "s| 3000| $GRAFANA_PORT|g" '/config/grafana/grafana.ini'
sed -i "s|:8086|:$INFLUXDB_HTTP_PORT|g" '/config/grafana/provisioning/datasources/InfluxDB-Telegraf.yml'
sed -i "s|:3100|:$LOKI_PORT|g" '/config/grafana/provisioning/datasources/Loki.yml'
sed -i 's|"value": "/boot"|"value": "/rootfs/boot"|g' '/config/grafana/data/dashboards/UUD.json'
sed -i 's|"value": "/mnt|"value": "/rootfs/mnt|g' '/config/grafana/data/dashboards/UUD.json'
sed -i 's|"value": "\/rootfs\*\/"|"value": "\/disabled\*\/"|g' '/config/grafana/data/dashboards/UUD.json'
echo '[info] grafana fixed.'

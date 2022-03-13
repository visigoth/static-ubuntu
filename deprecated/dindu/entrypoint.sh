#!/bin/bash

# Initilise apps #
echo ''
echo '[info] Initialisation started...'
source /static-ubuntu/dindu/initialise.sh
echo '[info] Initialisation complete'

# Run apps #
echo ''
echo "[info] Runing apps..."
touch /config/healthcheck-no-error
source /static-ubuntu/dindu/healthcheck.sh
rm -f /config/healthcheck-no-error
echo "[info] All done"

### Infinite loop to stop docker from stopping ###
sleep_time=3600
while true
do
    echo ''

    pidlist=$(pgrep docker)
    if [ -z "$pidlist" ]
    then
        echo '[error] dockerd crashed!'
    else
        echo "[info] dockerd PID: $pidlist"
    fi

    sleep $sleep_time
done

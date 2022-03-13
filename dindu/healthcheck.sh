#!/bin/bash

## No healthcheck if healthcheck-disable is set ##
if [[ -f "/config/healthcheck-disable" ]]
then
    touch /config/healthcheck-disable
else    
    # Block concurrent runs #
    touch /config/healthcheck-disable

    # Autoheal #
    crashed=0
    
    pidlist=$(pgrep docker)
    if [ -z "$pidlist" ]
    then
        if [[ -f "/config/healthcheck-no-error" ]]
        then
            touch /config/healthcheck-no-error
        else
            crashed=$(( $crashed + 1 ))
            touch "/config/healthcheck-failure-dockerd-at-$(date "+%d.%m.%Y_%T")"
        fi
        echo "[info] Run dockerd as service on port $DOCKER_TCP"
        service docker start
    fi

    # Remove blockage #
    rm -f /config/healthcheck-disable
    
    # No error if healthcheck-no-error is set #
    if [[ -f "/config/healthcheck-no-error" ]]
    then
        touch /config/healthcheck-no-error
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

#!/bin/bash

## Check ovpn in /etc ##
if [[ -f "/etc/openvpn/openvpn.ovpn" ]]
then
    # Check ovpn in /config #
    if [[ -f "/config/openvpn/openvpn.ovpn" ]]
    then
        echo '[warn] OpenVPN config file detected in both /etc and /config'
    else
        echo '[warn] OpenVPN config file detected in /etc/openvpn'
        echo '[warn] Please remap container /config to a host folder and place openvpn config files under [host folder]/openvpn'
        echo '[info] Copying config from /etc to /config'
        mkdir -p /config
        cp -rn /etc/openvpn /config/
        echo '[info] Complete'
    fi
    echo '[warn] Only config file at /config will be used'
fi

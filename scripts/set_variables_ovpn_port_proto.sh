#!/bin/bash

### Dynamically determine OpenVPN port and protocol ###
echo '[info] Determine openvpn port from config file'
OPENVPN_PORT=$(grep -m 1 "remote " /etc/openvpn/openvpn.ovpn) ; OPENVPN_PORT="$(echo $OPENVPN_PORT | sed 's/ /   /g')" ; OPENVPN_PORT=${OPENVPN_PORT:(-5)} ; OPENVPN_PORT="$(echo $OPENVPN_PORT | sed 's/ //g')" ; OPENVPN_PORT="$(echo $OPENVPN_PORT | sed 's/[^0-9]*//g')"
echo '[info] Determine openvpn protocol from config file'
OPENVPN_PROTO=$(grep -m 1 "proto " /etc/openvpn/openvpn.ovpn) ; OPENVPN_PROTO="$(echo $OPENVPN_PROTO | sed 's/proto //g')"
echo "[info] Will connect openvpn on port=$OPENVPN_PORT proto=$OPENVPN_PROTO"

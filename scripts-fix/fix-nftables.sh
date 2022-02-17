#!/bin/bash

## Dynamically determine OpenVPN port and protocol ##
echo '[info] Determine openvpn port from config file'
OPENVPN_PORT=$(grep -m 1 "remote " /etc/openvpn/openvpn.ovpn) ; OPENVPN_PORT="$(echo $OPENVPN_PORT | sed 's/ /   /g')" ; OPENVPN_PORT=${OPENVPN_PORT:(-5)} ; OPENVPN_PORT="$(echo $OPENVPN_PORT | sed 's/ //g')" ; OPENVPN_PORT="$(echo $OPENVPN_PORT | sed 's/[^0-9]*//g')"
echo '[info] Determine openvpn protocol from config file'
OPENVPN_PROTO=$(grep -m 1 "proto " /etc/openvpn/openvpn.ovpn) ; OPENVPN_PROTO="$(echo $OPENVPN_PROTO | sed 's/proto //g')"
echo "[info] Will connect openvpn on port=$OPENVPN_PORT proto=$OPENVPN_PROTO"

## Dynamically determine eth0 network for nftables ##
echo '[info] Determine eth0 network for nftables'
#eth0 IP
ETH0_IP="$(ip addr show eth0 | grep 'inet ' | cut -f2 | awk '{ print $2}')"
#IP CIDR range
ETH0_RANGE=${ETH0_IP:(-3)}
#Length of IP (to derive network from sipcalc)
ETH0_IPLEN=${#ETH0_IP} ; let ETH0_IPLEN-=3
#Use sipcalc to get first IP (.0) of network and sed to clean up resulting string when eth0 IP longer than first IP e.g. .100 vs .0
ETH0_NET0="$(sipcalc $ETH0_IP | grep 'Network address')" ; ETH0_NET0=${ETH0_NET0:(-$ETH0_IPLEN)} ; ETH0_NET0="$(echo $ETH0_NET0 | sed 's/ //g')" ; ETH0_NET0="$(echo $ETH0_NET0 | sed 's/-//g')"
#Network in CIDR format
ETH0_IP=${ETH0_IP:0:$ETH0_IPLEN}
ETH0_NET="$ETH0_NET0$ETH0_RANGE"
echo "[info] eth0 IP is $ETH0_IP in network $ETH0_NET"

## Editing ruleset ##
echo '[info] Editing base ruleset'
rm -f /nftables.rules
cp -f /static-ubuntu/etc/nftables.raw /nftables.rules
sed -i "s|_ETH0_NET_|$ETH0_NET|g" '/nftables.rules'
sed -i "s|_HOST_NETWORK_|${HOST_NETWORK}|g" '/nftables.rules'
sed -i "s|_OPENVPN_PROTO_|$OPENVPN_PROTO|g" '/nftables.rules'
sed -i "s|_OPENVPN_PORT_|$OPENVPN_PORT|g" '/nftables.rules'

## Run TOR+Privoxy depending on build ##
if [[ -f "/usr/sbin/tor" ]]; then
    echo '[info] Tor build detected. Editing tor + privoxy ruleset'
    sed -i "s|_TORSOCKS_PORT_|$TORSOCKS_PORT|g" '/nftables.rules'
    sed -i "s|_PRIVOXY_PORT_|$PRIVOXY_PORT|g" '/nftables.rules'
else
    echo '[info] Torless build detected. Removing tor + privoxy ruleset'
    sed -i 's|add rule ip filter INPUT iifname "eth0" tcp dport _TORSOCKS_PORT_ ct state new,established counter accept||g' '/nftables.rules'
    sed -i 's|add rule ip filter INPUT iifname "eth0" tcp dport _PRIVOXY_PORT_ ct state new,established counter accept||g' '/nftables.rules'
    sed -i 's|add rule ip filter OUTPUT oifname "eth0" tcp sport _TORSOCKS_PORT_ ct state established counter accept||g' '/nftables.rules'
    sed -i 's|add rule ip filter OUTPUT oifname "eth0" tcp sport _PRIVOXY_PORT_ ct state established counter accept||g' '/nftables.rules'
fi

## Flusing ruleset and add missing route ##
echo '[info] Flusing ruleset'
nft flush ruleset
add_route="$(ip route | grep 'default')" ; add_route="$(sed "s|default|$HOST_NETWORK|g" <<< $add_route)"
ip route add $add_route
echo "[info] Added route $add_route"

## Apply rules ##
echo '[info] Apply rules'
nft -f /nftables.rules
rm /nftables.rules

## Quick block test ##
source /static-ubuntu/scripts-debug/quick_block_test.sh

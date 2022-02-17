#!/bin/bash

echo ''
echo '[check] IPv6'
ip a | grep inet6
echo '[check] IPv6 - good = nothing shows'

echo ''
echo '[check] Listening'
ss -lpn | grep 'users\|Local'
echo '[check] Listening - End'

echo ''
echo '[check] Other '
ss -pn | grep 'users\|Local'
echo '[check] Other - End'

#!/bin/bash

## Run required install scripts. More complex dependencies run first.##
source /testdasi/scripts-install/install-openvpn-plus.sh

## wipe openvpn etc config ##
rm -Rf /etc/openvpn

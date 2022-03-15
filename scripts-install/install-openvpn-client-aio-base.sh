#!/bin/bash

## Run required install scripts. More complex dependencies run first.##
source /testdasi/scripts-install/install-openvpn-plus.sh

## Install PIA PF script ##
source /testdasi/scripts-install/install-pia-script.sh

## compatibility marker ##
touch /openvpn-only

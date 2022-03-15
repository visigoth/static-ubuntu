#!/bin/bash

## Run required install scripts. More complex dependencies run first.##
source /testdasi/scripts-install/install-openvpn-plus.sh
source /testdasi/scripts-install/install-jackett.sh
source /testdasi/scripts-install/install-flood-transmission.sh
source /testdasi/scripts-install/install-nzbhydra2.sh
source /testdasi/scripts-install/install-radarr.sh
source /testdasi/scripts-install/install-sonarr.sh
source /testdasi/scripts-install/install-prowlarr.sh
# always run sab last due needing multiverse repo #
source /testdasi/scripts-install/install-sabnzbdplus.sh

## Install PIA PF script ##
source /testdasi/scripts-install/install-pia-script.sh

## Finally add web launcher ##
source /testdasi/scripts-install/install-launcher.sh

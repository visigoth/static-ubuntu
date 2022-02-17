#!/bin/bash

## Run required install scripts. More complex dependencies run first.##
source /testdasi/scripts-install/install-openvpn-client-aio.sh
source /testdasi/scripts-install/install-nzbhydra2.sh
source /testdasi/scripts-install/install-radarr.sh
source /testdasi/scripts-install/install-sonarr.sh
source /testdasi/scripts-install/install-prowlarr.sh
source /testdasi/scripts-install/install-jackett.sh
source /testdasi/scripts-install/install-flood-transmission.sh
# always run sab last due needing multiverse repo #
source /testdasi/scripts-install/install-sabnzbdplus.sh

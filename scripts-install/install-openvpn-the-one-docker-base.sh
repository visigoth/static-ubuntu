#!/bin/bash

## Run required install scripts ##
source /testdasi/scripts-install/install-flood-transmission.sh
source /testdasi/scripts-install/install-jackett.sh
source /testdasi/scripts-install/install-prowlarr.sh
source /testdasi/scripts-install/install-radarr.sh
source /testdasi/scripts-install/install-sonarr.sh
source /testdasi/scripts-install/install-nzbhydra2.sh
# always run sab last due to a lot of dependencies #
source /testdasi/scripts-install/install-sabnzbdplus.sh
#source /testdasi/scripts-install/

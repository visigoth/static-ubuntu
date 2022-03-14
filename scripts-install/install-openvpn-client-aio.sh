#!/bin/bash

## add tor and privoxy depending on torless build opt ##
if [[ ${BUILD_OPT} =~ "torless" ]]
then
    echo "$(date "+%d.%m.%Y %T") Skip onion pack due to build option ${BUILD_OPT}" >> /build.info
else
    echo "$(date "+%d.%m.%Y %T") Adding onion pack due to build option ${BUILD_OPT}" >> /build.info
    source /testdasi/scripts-install/install-tor.sh
fi

if [[ ${BUILD_OPT} =~ "plus" ]]
then
    echo "$(date "+%d.%m.%Y %T") Adding plus pack due to build option ${BUILD_OPT}" >> /build.info
    source /testdasi/scripts-install/install-jackett.sh
    source /testdasi/scripts-install/install-nzbhydra2.sh
    source /testdasi/scripts-install/install-flood-transmission.sh
    source /testdasi/scripts-install/install-sabnzbdplus.sh
    source /testdasi/scripts-install/install-launcher.sh
    # dup python3 binary #
    cp /usr/bin/python3 /usr/bin/python3-launcher \
        && chmod +x /usr/bin/python3-launcher
    cp /usr/bin/python3 /usr/bin/python3-nzbhydra2 \
        && chmod +x /usr/bin/python3-nzbhydra2
else
    echo "$(date "+%d.%m.%Y %T") Skip plus pack due to build option ${BUILD_OPT}" >> /build.info
fi

## Install PIA PF script ##
source /testdasi/scripts-install/install-pia-script.sh

## Make copy of static folder ##
mkdir -p /static-ubuntu
cp -rf /testdasi/scripts-debug /static-ubuntu/
cp -rf /testdasi/openvpn-client /static-ubuntu/

# Improve comptability with old versions #
rm -Rf /etc/openvpn
cp -n /static-ubuntu/openvpn-client/entrypoint.sh /
cp -n /static-ubuntu/openvpn-client/healthcheck.sh /

## chmod scripts ##
chmod +x /*.sh
chmod +x /static-ubuntu/scripts-debug/*.sh
chmod +x /static-ubuntu/openvpn-client/*.sh
chmod +x /static-ubuntu/openvpn-client/scripts-fix/*.sh

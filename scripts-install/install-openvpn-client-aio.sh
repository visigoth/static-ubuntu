#!/bin/bash

## add tor and privoxy depending on torless build opt ##
if [[ ${BUILD_OPT} =~ "torless" ]]
then
    echo "$(date "+%d.%m.%Y %T") Skip torsocks and privoxy due to build option ${BUILD_OPT}" >> /build.info
else
    source /testdasi/scripts-install/install-tor.sh
fi

## Make copy of static folder ##
cp -rf /testdasi /static-ubuntu

# Selectively delete redundant files #
rm -Rf /static-ubuntu/deprecated

# Improve comptability with old versions #
rm -Rf /etc/openvpn
cp -n /static-ubuntu/scripts-openvpn/entrypoint.sh /
cp -n /static-ubuntu/scripts-openvpn/healthcheck.sh /

## chmod scripts ##
chmod +x /*.sh
chmod +x /static-ubuntu/scripts-debug/*.sh
chmod +x /static-ubuntu/scripts-fix/*.sh
chmod +x /static-ubuntu/scripts-install/*.sh
chmod +x /static-ubuntu/scripts-openvpn/*.sh

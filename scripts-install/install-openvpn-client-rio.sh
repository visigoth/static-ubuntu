#!/bin/bash

## Rename script folders ##
mv /testdasi /static-ubuntu

# Selectively delete redundant files
rm -Rf /static-ubuntu/deprecated

# Set permission
chmod +x /static-ubuntu/scripts-debug/*.sh
chmod +x /static-ubuntu/scripts-fix/*.sh
chmod +x /static-ubuntu/scripts-install/*.sh
chmod +x /static-ubuntu/scripts-openvpn/*.sh

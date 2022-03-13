#!/bin/bash

## Make copy of static folder ##
mkdir -p /static-ubuntu
cp -rf /testdasi/scripts-debug /static-ubuntu/
cp -rf /testdasi/dindu /static-ubuntu/

## chmod scripts ##
chmod +x /*.sh
chmod +x /static-ubuntu/scripts-debug/*.sh
chmod +x /static-ubuntu/dindu/*.sh

#!/bin/bash

apt -y update
cp -f /testdasi/scripts-debug/* / 
chmod +x /*.sh
touch /container-in-debug-mode

#!/bin/bash

## Clear out default configs ##
rm -rf /etc/webmin
rm -rf /etc/dhcp

## Fix preroot so that webmin can run as root ##
sed -i "s|preroot|#preroot|g" '/etc/webmin-orig/miniserv.conf'


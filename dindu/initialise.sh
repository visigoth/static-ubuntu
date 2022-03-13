#!/bin/bash

rm -f /etc/init.d/docker
cp /static-ubuntu/dindu/etc/init.d/docker /etc/init.d
chmod +x /etc/init.d/docker
echo '[info] docker service fixed.'

#!/bin/bash

mkdir -p /config/flood/db \
    && cp -n /static-ubuntu/etc/flood.db /config/flood/db/users.db
echo '[info] flood fixed.'

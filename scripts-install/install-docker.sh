#!/bin/bash

apt update -y \
    && apt upgrade -y \
    && apt full-upgrade -y \
    && apt autoremove -y \
    && apt install -y apt-utils

curl -sSL https://get.docker.com | sh
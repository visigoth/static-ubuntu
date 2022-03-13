#!/bin/bash

## Install dependencies ##
apt -y update \
    && apt -y install git 

## Run required install scripts. More complex dependencies run first.##
source /testdasi/scripts-install/install-docker.sh

# Clean up
apt -y autoremove \
    && apt -y autoclean \
    && apt -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

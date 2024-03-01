#!/bin/bash

web_root="/var/www"

if [ ! -d "$web_root" ]; then
    sudo mkdir -p "$web_root"
    sudo chown -R ubuntu:ubuntu "$web_root"
fi

rm -f /var/www/*

echo "/var/www dir is ready"
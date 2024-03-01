#!/bin/bash

sudo cp -f /var/www/ci-cd.service /etc/systemd/system/ci-cd.service

sudo systemctl enable ci-cd
systemctl start ci-cd
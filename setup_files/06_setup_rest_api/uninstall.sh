#!/bin/bash

# Delete the devid-api service
sudo systemctl stop devid-api.service
sudo systemctl disable devid-api.service
sudo rm /etc/systemd/system/devid-api.service
sudo rm /etc/systemd/system/devid-api.service
sudo rm /usr/lib/systemd/system/devid-api.service
sudo rm /usr/lib/systemd/system/devid-api.service
sudo systemctl daemon-reload
sudo systemctl reset-failed
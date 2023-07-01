#!/bin/bash

# Delete a service
sudo systemctl stop devid-gui.service
sudo systemctl disable devid-gui.service
sudo rm /etc/systemd/system/devid-gui.service
sudo rm /etc/systemd/system/devid-gui.service
sudo rm /usr/lib/systemd/system/devid-gui.service
sudo rm /usr/lib/systemd/system/devid-gui.service
sudo systemctl daemon-reload
sudo systemctl reset-failed
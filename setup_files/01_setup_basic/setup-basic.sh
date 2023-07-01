#!/bin/bash

# curl -sSL https://raw.githubusercontent.com/FHKatCSW/devid_raspi/main/raspberry_setup/setup_basic/setup-basic.sh | bash


# update and upgrade the device
sudo apt-get update && sudo apt-get upgrade -y

# install relevant packages
sudo apt install libpcsclite-dev pcscd pcsc-tools libssl-dev libengine-pkcs11-openssl autoconf libtool openssl git python3-venv -y

# Upgrade pip
sudo python3 -m pip install --upgrade pip

# Clone the devid_api repository
git clone https://github.com/FHKatCSW/devid_api.git
git clone https://github.com/FHKatCSW/devid_raspi.git
git clone https://github.com/FHKatCSW/devid_nameplate.git

# Define the static IP address settings
IP_ADDRESS="192.168.1.2/24"
GATEWAY="192.168.1.1"
DNS_SERVERS="192.168.1.3"

# Backup the existing dhcpcd.conf file
sudo cp /etc/dhcpcd.conf /etc/dhcpcd.conf.backup

# Update the dhcpcd.conf file with static IP address settings
sudo tee -a /etc/dhcpcd.conf > /dev/null << EOL

# Added by script to configure static IP address
interface eth0
static ip_address=$IP_ADDRESS
static routers=$GATEWAY
static domain_name_servers=$DNS_SERVERS
EOL

echo "Static IP address has been configured in /etc/dhcpcd.conf!"


echo "✅ basic setup finished"
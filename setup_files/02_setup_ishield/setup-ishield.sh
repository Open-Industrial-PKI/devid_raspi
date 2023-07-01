#!/bin/bash

# Load OpenSC
sudo wget https://github.com/swissbit-eis/OpenSC/archive/refs/tags/0.23.0-swissbit.tar.gz

# Bootstrap OpenSC
tar -xf 0.23.0-swissbit.tar.gz
cd OpenSC-0.23.0-swissbit/
sudo ./bootstrap
./configure --prefix=/usr
sudo make -j4 install

# Check status of the service
systemctl status pcscd

# Detect the location of the openssl configuration file
OPENSSL_CONF=$(openssl version -d | awk '{print $NF}' | tr -d '"')/openssl.cnf

# Add content to the beginning of the openssl configuration file
sudo sed -i '1i\
openssl_conf = openssl_init\n\n[openssl_init]\nengines = engine_section\n\n[engine_section]\npkcs11 = pkcs11_section\n\n[pkcs11_section]\nengine_id = pkcs11\nMODULE_PATH = /usr/lib/opensc-pkcs11.so\ndynamic_path = /usr/lib/aarch64-linux-gnu/engines-1.1/pkcs11.so\ninit = 0\n' $OPENSSL_CONF

echo "✅ iShield setup finished"
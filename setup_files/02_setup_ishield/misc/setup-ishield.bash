#!/bin/bash

echo ------
echo Setup prequesites for iShield
echo ------

echo iShield prerequisites: Install packages
sudo apt install libpcsclite-dev pcscd pcsc-tools libssl-dev libengine-pkcs11-openssl autoconf libtool openssl -y

cd /usr

echo iShield prerequisites: get package for armv7
sudo wget https://www.swissbit.com/files/public/data/security/ishield-hsm/armv7.tar.gz
sudo tar -xf armv7.tar.gz
sudo rm armv7.tar.gz

echo iShield prerequisites: Copy content to /usr
sudo cp armv7/. . -r

export LD_LIBRARY_PATH=/usr/lib
export OPENSSL_ENGINES=/usr/lib/engines-1.1
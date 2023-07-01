#!/bin/bash

# Set user
username="$1"

pip install azure-iot-device

sudo apt-get install -y git cmake build-essential curl libcurl4-openssl-dev libssl-dev uuid-dev ca-certificates

git clone -b lts_07_2022 https://github.com/Azure/azure-iot-sdk-c.git /home/$username/azure-iot-sdk-c/

cd /home/$username/azure-iot-sdk-c

git submodule update –-init

mkdir cmake
cd cmake
cmake ..
cmake --build .
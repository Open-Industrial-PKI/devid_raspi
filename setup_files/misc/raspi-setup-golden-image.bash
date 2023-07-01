#!/bin/bash

echo "------"
echo "Create a golden image for the raspberry"
echo "Product: Raspberry Pi 4 Model B Rev 1.1"
echo "PRETTY_NAME=Debian GNU/Linux 11 (bullseye)"
echo "------"

echo "Create golden image: Install git"
sudo apt-get install git

echo "Create golden image: update & upgrade"
sudo apt-get update && sudo apt-get upgrade -y

echo "Create golden image: Clone Azure-Samples/iotedge-tpm2cloud repository"
git clone https://github.com/Azure-Samples/iotedge-tpm2cloud.git

echo "Create golden image: Change directory"
cd iotedge-tpm2cloud/scripts-stack/

echo "Create golden image: Change permissions for build script(s)"
chmod +x ./build.sh
chmod +x ./ibmswtpm2/build.sh
chmod +x ./tpm2-abrmd-hwtpm/build.sh
chmod +x ./tpm2-abrmd-ibmswtpm2/build.sh
chmod +x ./tpm2-pkcs11/build.sh
chmod +x ./tpm2-tools/build.sh
chmod +x ./tpm2-tss/build.sh
chmod +x ./tpm2-tss-engine/build.sh

echo "Create golden image: Build debian package and store it"
sudo bash ./build.sh debian11_armhf 1
echo "Create golden image: Package build and stored in packages/iotedge-tpm2cloud_5_debian-raspberry_amd64.tar.gz"

echo "Create golden image: Copy the tar.gz"
echo "Therefore execute the following command on your remote machine"
echo
echo "scp admin@hmipidev2.local:/home/admin/iotedge-tpm2cloud/packages/iotedge-tpm2cloud_01_debian11_armhf_armhf.tar.gz /Users/florianhandke/Downloads/"
echo
echo "Create golden image: Place it on the target machine"

exit 1

echo "Location of the files"
path_image=/home/admin/iotedge-tpm2cloud/packages/iotedge-tpm2cloud_01_debian11_armhf_armhf.tar.gz
path_script=/home/admin/iotedge-tpm2cloud/scripts-provisioning/tpm2-stack-install.sh

sudo tar -xf iotedge-tpm2cloud_01_debian11_armhf_armhf.tar.gz

sudo dpkg -i ibmswtpm2_1661-01_debian11_armhf_armhf.deb
sudo dpkg -i tpm2-abrmd-hwtpm_2.4.0-01_debian11_armhf_armhf.deb
sudo dpkg -i tpm2-tools_5.2-01_debian11_armhf_armhf.deb
sudo dpkg -i tpm2-tss_3.1.0-01_debian11_armhf_armhf.deb
sudo dpkg -i tpm2-tss-engine_1.1.0-01_debian11_armhf_armhf.d


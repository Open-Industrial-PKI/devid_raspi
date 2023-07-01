#!/bin/bash

function header {
    echo "****"
    echo "$1"
    echo "****"
    echo
}

function warn {
    echo "!!!!"
    echo "$1"
    echo "!!!!"
    echo
}

username="$1"


if ! command -v git &> /dev/null; then
    echo "Install git"
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install git
fi

if [[ ! -d "/home/$username/devid_raspi" ]]; then
    echo "Clone devid_raspi repository"
    git clone https://github.com/FHKatCSW/devid_raspi.git
fi

header Basic setup
bash /home/"$username"/devid_raspi/setup_files/01_setup_basic/setup-basic.sh

header Setup the iShield
bash /home/"$username"/devid_raspi/setup_files/02_setup_ishield/setup-ishield.sh

header Setup py-hsm
bash /home/"$username"/devid_raspi/setup_files/03_setup_pyhsm/setup-pyhsm.sh $username

#header Setup HSM Log service
#bash /home/"$username"/devid_raspi/setup_files/04_setup_hsm_log_service/setup-hsm-logger.sh

header Setup Certificate Storage
bash /home/"$username"/devid_raspi/setup_files/05_setup_certificate_storage/setup-certificate-storgae.sh

header Setup REST API
bash /home/"$username"/devid_raspi/setup_files/06_setup_rest_api/setup-rest-api.sh $username

header Setup GUI
bash /home/"$username"/devid_raspi/setup_files/07_setup_gui/setup-gui.sh $username

#header Setup azure
#bash /home/"$username"/devid_raspi/setup_files/08_setup_azure/setup-azure.sh $username

header Setup p11tool
bash /home/"$username"/devid_raspi/setup_files/09_setup_p11tool/setup-p11tool.sh

warn This is the last step: Raspberry will reboot afterwards
header Setup Display
bash /home/"$username"/devid_raspi/setup_files/10_setup_display/setup-display.sh
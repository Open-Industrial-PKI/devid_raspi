# devid_raspi
Repo to setup the swissbit iShield, pyhsm, a REST API and a GUI for a Raspberry Pi

## Raspberry

Please be aware that changes in the OS or the packages used can affect the setup. 

We used a Raspberry OS Full (64-bit) with a Desktop environment (Debian GNU/Linux 11 (bullseye))

## How to get started

You can setup the whole raspberry with a oneliner:

⚠️ Beware: This will start a bash script ⚠️

```
curl -sSL https://raw.githubusercontent.com/Open-Industrial-PKI/devid_raspi/main/setup_raspberry.sh | bash -s "admin"
```

or load the Repository

```
git clone https://github.com/Open-Industrial-PKI/devid_raspi.git
```

and execute the setup 

```
sudo bash ./devid_raspi/setup_raspberry.sh
```

## Project Structure

```bash
devid_raspi/
├── setup_files
│   └── 01_setup_basic
│    └── setup-basic.sh
│   └── 02_setup_ishield
│    └── setup-ishield.sh
│   └── 03_setup_pyhsm
│    └── setup-pyhsm.sh
│   └── 04_setup_hsm_log_service
│    └── setup-hsm-logger.sh
│   └── 05_setup_certificate_storage
│    └── setup-certificate-storage.sh
│   └── 06_setup_rest_api
│    └── setup-rest-api.sh
│   └── 07_setup_gui
│    └── setup-gui-novenv.sh
│   └── 08_setup_display
│    └── setup-display.sh
├── README.md
├── setup_raspberry.sh
```
<br />




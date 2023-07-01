#!/bin/bash

# Set user
username="$1"

function service_instruction {
  echo "Service name: $1"
  echo "👍 Status: systemctl status $1.service"
  echo "📄 Logs: journalctl --unit=$1.service -n 100 --no-pager"
  echo "↩️ Restart: sudo systemctl restart $1.service"
}

# Set the working directory for the PyQt application
APP_WORKDIR="/home/$username/devid_nameplate"

# Install python3-pyqt5
sudo apt-get install python3-pyqt5

# Install the requirements
pip install -r "$APP_WORKDIR/requirements.txt"
# pip install -r "/home/admin/devid_nameplate/requirements.txt"

# Define the path to the Flask app within the virtual environment
APP_PATH="/home/$username/devid_nameplate/run.py"

# Define service name
SERVICE_NAME="devid-gui"

# Define the path to the systemd service file
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

echo "[Unit]
Description=IEEE 802.1 AR GUI
After=graphical.target

[Service]
WorkingDirectory=$APP_WORKDIR
Environment="QT_DEBUG_PLUGINS=1"
Environment="DISPLAY=:0.0"
Environment="XAUTHORITY=/home/"$username"/.Xauthority"
ExecStart=/usr/bin/python $APP_PATH
Restart=on-failure
StartLimitBurst=100
StartLimitInterval=5min

[Install]
WantedBy=graphical.target" | sudo tee $SERVICE_FILE


# Reload systemd and start the PyQT application service
sudo systemctl daemon-reload
sudo systemctl start devid-gui.service

# Enable the PyQT application service to start on boot
sudo systemctl enable devid-gui.service

service_instruction $SERVICE_NAME

echo "✅ GUI setup finished"


# -------------------------
# Additional commands
# -------------------------

# Show the last 100 logs
# journalctl --unit=devid-gui.service -n 100 --no-pager

# Restart the service
# sudo systemctl restart devid-gui.service


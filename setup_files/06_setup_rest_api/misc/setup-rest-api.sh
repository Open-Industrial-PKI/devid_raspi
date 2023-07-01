#!/bin/bash

# Set the working directory for the PyQt application
APP_WORKDIR="/home/$SUDO_USER/devid_api"

# Define the path to the virtual environment
VENV_PATH="/home/$SUDO_USER/devid_api/env"

# Define the path to the systemd service file
SERVICE_FILE="/etc/systemd/system/devid-api.service"

# Define the path to the Flask app within the virtual environment
APP_PATH="/home/$SUDO_USER/devid_api/run.py"

# Define the IP address and port for the Flask app to run on
IP_ADDRESS="0.0.0.0"
PORT="5000"

python -m venv "$VENV_PATH"

# Activate the virtual environment
source "$VENV_PATH/bin/activate"

# Install the requirements
pip install -r "$APP_WORKDIR/requirements.txt"

# Write the systemd service file
echo "[Unit]
Description=IEEE 802.1 AR REST API
After=network.target

[Service]
User=$SUDO_USER
Environment="FLASK_APP=run.py"
WorkingDirectory=$APP_WORKDIR
ExecStart=$VENV_PATH/bin/flask run --host=$IP_ADDRESS --port=$PORT
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE

# Reload the systemd daemon to read the new service file
sudo systemctl daemon-reload

# Start the devid API service
sudo systemctl start devid-api

# Enable the devid API service to start automatically on boot
sudo systemctl enable devid-api

# -------------------------
# Additional commands
# -------------------------

# Show the last 100 logs
# journalctl --unit=devid-api.service -n 100 --no-pager

# Restart the service
# sudo systemctl restart devid-api.service



pip install --upgrade pyopenssl
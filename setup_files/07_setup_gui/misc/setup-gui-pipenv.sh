#!/bin/bash

# Define the path to the Flask app within the virtual environment
APP_PATH="/home/admin/devid_nameplate/run.py"

# Define the path to the systemd service file
SERVICE_FILE="/etc/systemd/system/pyqt_application.service"

# Set the working directory for the PyQt application
APP_WORKDIR="/home/admin/devid_nameplate"

# Set up virtual environment
pip install pipenv
pipenv lock --clear
pipenv --python 3.9
pipenv install -r "$APP_WORKDIR/requirements.txt" --skip-lock

# Create systemd service file
echo "[Unit]
Description=Your Python service

[Service]
WorkingDirectory=$APP_WORKDIR
ExecStart=/usr/bin/bash -c 'source $(pipenv --venv)/bin/activate && python run.py'
Restart=always
User=admin

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE

# Reload systemd and start the PyQT application service
sudo systemctl daemon-reload
sudo systemctl start pyqt_application.service

# Enable the PyQT application service to start on boot
sudo systemctl enable pyqt_application.service
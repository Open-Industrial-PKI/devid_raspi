#!/bin/bash

function service_instruction {
  echo "Service name: $1"
  echo "👍 Status: systemctl status $1.service"
  echo "📄 Logs: journalctl --unit=$1.service -n 100 --no-pager"
  echo "↩️ Restart: sudo systemctl restart $1.service"
}

# Define service name
SERVICE_NAME="hsm-logger"

# Create systemd service file
cat <<EOF | sudo tee /etc/systemd/system/hsm-logger.service
[Unit]
Description=HSM Communication Logger

[Service]
ExecStart=/usr/local/bin/hsm-logger.sh
Restart=on-failure
StartLimitBurst=10
StartLimitInterval=5min

[Install]
WantedBy=multi-user.target
EOF

# Create logger script
cat <<EOF | sudo tee /usr/local/bin/hsm-logger.sh
#!/bin/bash

LOG_FILE="/var/log/hsm.log"

# Create log file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
fi

# Monitor communication to HSM and write to log file
while true; do
    socat -x /dev/hsm >> "$LOG_FILE" 2>&1
done
EOF

# Make logger script executable
sudo chmod +x /usr/local/bin/hsm-logger.sh

# Reload systemd daemon
sudo systemctl daemon-reload

# Enable and start service
sudo systemctl enable hsm-logger.service
sudo systemctl start hsm-logger.service

service_instruction $SERVICE_NAME

echo "✅ HSM logger setup finished"

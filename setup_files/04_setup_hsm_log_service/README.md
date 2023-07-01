# Setup HSM logger

You can setup the logger manually or setup via a bash script

## For the bash script:

make the script executable:

```
chmod +x setup-hsm-logger.sh
```

Run the script 

```
sudo ./setup-hsm-logger.sh
```

## For the manual setup


Create a new file called hsm-logger.service in the /etc/systemd/system/ directory:

```
sudo nano /etc/systemd/system/hsm-logger.service
```

Add the following contents to the file:

```
[Unit]
Description=HSM Communication Logger

[Service]
ExecStart=/usr/local/bin/hsm-logger.sh

[Install]
WantedBy=multi-user.target
```

Save and close the file.

Create a new file called hsm-logger.sh in the /usr/local/bin/ directory:

```
sudo nano /usr/local/bin/hsm-logger.sh
```

Add the following contents to the file:

```
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
```

Save and close the file.

Make the script executable:

```
sudo chmod +x /usr/local/bin/hsm-logger.sh
```

eload the systemd daemon:

```
sudo systemctl daemon-reload
```

Start the service:

```
sudo systemctl start hsm-logger.service
```

Verify that the service is running:

```
sudo systemctl status hsm-logger.service
```

Enable the service to start automatically at boot time:

```
sudo systemctl enable hsm-logger.service
```

You can view the log file using a text editor or the tail command:

```
sudo tail -f /var/log/hsm.log
```
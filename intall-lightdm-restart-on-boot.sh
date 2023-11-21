#!/bin/bash

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Create the systemd service file
cat > /etc/systemd/system/restart-lightdm-once.service <<EOL
[Unit]
Description=Restart LightDM Once after Loaded with a delay
After=lightdm.service
Requires=lightdm.service

[Service]
Type=oneshot
ExecStartPre=/bin/sleep 3
ExecStart=/bin/systemctl restart lightdm.service
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd, enable and start the service
systemctl daemon-reload
systemctl enable restart-lightdm-once.service
systemctl start restart-lightdm-once.service

echo "Service installed and started successfully!"


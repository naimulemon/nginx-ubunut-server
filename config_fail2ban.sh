#!/bin/bash

# Install Fail2Ban if not installed
if ! dpkg -s fail2ban >/dev/null 2>&1; then
    echo "Installing Fail2Ban..."
    sudo apt-get update
    sudo apt-get install -y fail2ban
fi

# Create a local copy of the default configuration file
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Configure Fail2Ban to ban IP addresses after 7 failed login attempts
sudo sed -i 's/maxretry = 5/maxretry = 7/' /etc/fail2ban/jail.local
sudo sed -i 's/bantime = 600/bantime = 7200/' /etc/fail2ban/jail.local

# Enable Fail2Ban to start at system boot
sudo systemctl enable fail2ban

# Create a systemd service to restart Fail2Ban after reboot
cat << EOF | sudo tee /etc/systemd/system/restart-fail2ban.service
[Unit]
Description=Restart Fail2Ban after reboot
After=network-online.target

[Service]
ExecStart=/bin/sh -c 'systemctl restart fail2ban'
Type=oneshot

[Install]
WantedBy=multi-user.target
EOF

# Enable the restart-fail2ban service
sudo systemctl enable restart-fail2ban.service

# Restart Fail2Ban to apply the new configuration
sudo systemctl restart fail2ban

echo "Fail2Ban configured to ban IP addresses for 2 hours after 7 failed login attempts."
echo "Fail2Ban will automatically restart after system reboot."
#!/bin/bash

# Install required packages
echo "Installing required packages..."
sudo apt-get update
sudo apt-get install -y nginx certbot python3-certbot-nginx

# Configure Nginx to use SSL/TLS
echo "Configuring Nginx to use SSL/TLS..."
sudo certbot --nginx

# Configure firewall to allow only HTTPS traffic
echo "Configuring firewall to allow only HTTPS traffic..."
sudo ufw allow 'Nginx HTTPS'
sudo ufw enable

# Set up automatic certificate renewal
echo "Setting up automatic certificate renewal..."
sudo certbot renew --dry-run

# Create a systemd service to renew the certificate
cat << EOF | sudo tee /etc/systemd/system/renew-letsencrypt.service
[Unit]
Description=Renew Let's Encrypt SSL Certificate
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/certbot renew --quiet --renew-hook "/bin/systemctl reload nginx"

[Install]
WantedBy=multi-user.target
EOF

# Enable the renew-letsencrypt service
sudo systemctl enable renew-letsencrypt.service

# Create a systemd timer to run the renewal service periodically
cat << EOF | sudo tee /etc/systemd/system/renew-letsencrypt.timer
[Unit]
Description=Periodically renew Let's Encrypt SSL Certificate

[Timer]
OnCalendar=weekly
RandomizedDelaySec=1h
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Enable the renew-letsencrypt timer
sudo systemctl enable renew-letsencrypt.timer

# Restart Nginx to apply the new configuration
sudo systemctl restart nginx

echo "SSL/TLS certificate installed and configured."
echo "Firewall configured to allow only HTTPS traffic."
echo "Automatic certificate renewal enabled and will persist after system reboot."
#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Prompt user for swap size
read -p "Enter the size of swap memory to add (in megabytes): " swap_size

# Check if swap size is provided
if [[ -z "$swap_size" ]]; then
    echo "Swap size cannot be empty"
    exit 1
fi

# Add swap space
fallocate -l ${swap_size}M /swapfile

# Set permissions
chmod 600 /swapfile

# Set up swap space
mkswap /swapfile

# Enable swap space
swapon /swapfile

# Persist swap space across reboots by adding an entry to /etc/fstab
echo "/swapfile none swap sw 0 0" >> /etc/fstab

# Display confirmation message
echo "Swap space of ${swap_size} MB added successfully"

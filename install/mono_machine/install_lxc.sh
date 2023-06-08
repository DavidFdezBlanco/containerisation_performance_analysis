#!/bin/bash

# Update package list
echo "Updating the system libraries..."
sudo apt update

# Install LXC
echo "Installing LXC..."
sudo apt install lxc -y

# Configure LXC
echo "Configuring LXC..."
sudo lxc init

# Add the current user to the lxd group
echo "Adding current user to the lxd group..."
sudo usermod -aG lxd $USER

# Restart the system
echo "Restarting the system..."
sudo reboot
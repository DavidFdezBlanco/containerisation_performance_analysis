#!/bin/bash

# Update package list
echo "Updating the system libraries..."
sudo apt update -y

# Install LXC
echo "Installing LXC..."
sudo apt install lxc -y

# Configure LXC
echo "Configuring LXC..."
sudo lxc init

# Restart the system
echo "Restarting the system..."
sudo reboot
#!/bin/bash

set -e

# Update the system
echo "Updating the system..."
sudo apt update -qq
sudo apt upgrade -y -qq

# Install LXD
echo "Installing LXD..."
sudo apt install lxd -y -qq

# Verify LXD installation
echo "Verifying LXD installation..."
lxd --version

# Initialize LXD
echo "Initializing LXD..."
sudo lxd init --auto

# Add the current user to the lxd group
echo "Adding current user to the lxd group..."
sudo usermod -aG lxd $USER

echo "LXD installation completed successfully!"
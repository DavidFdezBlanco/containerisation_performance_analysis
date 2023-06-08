#!/bin/bash

set -e

# Update the package list
echo "Updating the system libraries"
sudo apt update -qq

# Install Docker
echo "Installing Docker"
curl -sSL https://get.docker.com | sh

# Add current user to the docker group to allow running Docker without sudo
echo "Adding current user to the docker group"
sudo usermod -aG docker $USER

# Install K3s with Docker as the container runtime
echo "Installing K3s and setting Docker as the container runtime"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="docker" sh -s -

# Check the status of K3s
sudo systemctl status k3s.service --no-pager

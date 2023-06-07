#!/bin/bash

# Update the package list
sudo apt update

# Install Docker
curl -sSL https://get.docker.com | sh

# Add current user to the docker group to allow running docker without sudo
sudo usermod -aG docker $USER

# Install K3s with Docker as the container runtime
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="docker" sh -

# Check the status of K3s
sudo systemctl status k3s.service
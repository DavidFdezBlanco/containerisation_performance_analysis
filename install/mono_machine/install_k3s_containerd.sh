#!/bin/bash

set -e

# Update the package list
echo "Updating the system libraries"
sudo apt update -qq -y

# Install docker on the Node
curl https://releases.rancher.com/install-docker/20.10.sh | sh

# Install K3s with Docker as the container runtime
echo "Installing K3s default install (CRIO runtime)"
curl -sfL https://get.k3s.io | sh -s - --docker

# Check the status of K3s
sudo systemctl status k3s.service

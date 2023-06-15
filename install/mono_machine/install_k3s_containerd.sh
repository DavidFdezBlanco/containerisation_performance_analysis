#!/bin/bash

set -e

# Update the package list
echo "Updating the system libraries"
sudo apt update -qq -y

# Install Docker
echo "Installing Docker"
curl -sSL https://get.docker.com | sh

# Add current user to the docker group to allow running Docker without sudo
echo "Adding current user to the docker group"
sudo usermod -aG docker $USER

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

sudo k3d cluster create mycluster
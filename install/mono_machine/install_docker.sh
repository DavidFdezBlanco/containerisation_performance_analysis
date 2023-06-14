#!/bin/bash

set -e

# Cleaning old instances
echo 'Cleaning old instances'

# Update package list
echo "Updating the system libraries..."
sudo apt-get update -y -qq

# Install necessary packages
echo "Installing needed libraries..."
sudo apt-get install ca-certificates curl gnupg -y -qq

# Add official Docker GPG key
echo 'Adding GPG Key...'
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository to list of package sources
echo "Adding Docker repository to list of package sources..."
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update packages list with Docker data
echo "Updating apt package list with Docker data..."
sudo apt-get update -y -qq

# Install Docker
echo "Installing Docker..."
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y -qq

# Check Docker version and operability
echo "Checking Docker version and operability..."
sudo docker -v
sudo docker ps
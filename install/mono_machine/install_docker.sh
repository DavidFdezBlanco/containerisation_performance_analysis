#!/bin/bash

set -e

# Cleaning old instances
echo 'Cleaning old instances'

# Update package list
echo "Updating the system libraries..."
sudo apt-get update -y -qq

# Install necessary packages
echo "Installing needed libraries..."
sudo apt-get install -y -qq apt-transport-https ca-certificates curl software-properties-common

# Add official Docker GPG key
echo 'Adding GPG Key...'
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository to list of package sources
echo "Adding Docker repository to list of package sources..."
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y

# Update packages list with Docker data
echo "Updating apt package list with Docker data..."
sudo apt-get update -qq

# Install Docker
echo "Installing Docker..."
sudo apt-get install -y -qq docker-ce

# Check Docker version and operability
echo "Checking Docker version and operability..."
sudo docker -v
sudo docker service ps
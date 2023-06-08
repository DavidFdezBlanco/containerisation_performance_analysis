#!/bin/bash

set -e

# Install CRI-o
echo "Adding CRI-o repository..."
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list > /dev/null
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/Release.key | sudo apt-key add - > /dev/null

echo "Updating the system..."
sudo apt update -qq

echo "Installing CRI-o"
sudo apt install -y -qq cri-o-1.22

# Configure CRI-o
echo "Configuring CRI-o..."
sudo sed -i 's/.*cgroup_manager =.*/cgroup_manager = "systemd"/' /etc/crio/crio.conf
sudo systemctl daemon-reload
sudo systemctl restart crio

# Install k3s
echo "Installing k3s..."
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.22.0 sh -s - > /dev/null

# Check services
echo "Checking k3s service..."
sudo systemctl status k3s --no-pager

echo "Checking CRI-o service..."
sudo systemctl status crio --no-pager

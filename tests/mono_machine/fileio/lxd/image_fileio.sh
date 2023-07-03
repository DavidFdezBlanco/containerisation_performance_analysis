#!/bin/bash

# Create a temporary LXD container based on the Ubuntu 22.04 image
echo "Creating LXD ubuntu 22.04 based image..."
sudo lxc launch images:ubuntu/22.04 temporary-container

# Install Sysbench inside the temporary container
echo "Install sysbench inside the container..."
sudo lxc exec temporary-container -- apt update -y
sudo lxc exec temporary-container -- apt install -y sysbench
sudo lxc exec temporary-container -- sysbench fileio prepare

# Create an LXD image based on the temporary container
echo "Create an LXD image based on the preconfigured container..."
sudo lxc stop temporary-container
sudo lxc publish temporary-container --alias image_lxd_fileio

# Delete the temporary container
echo "Delete the temporary container..."
sudo lxc delete temporary-container

echo "The sysbench LXD image with Sysbench and fileio prepare has been successfully created."
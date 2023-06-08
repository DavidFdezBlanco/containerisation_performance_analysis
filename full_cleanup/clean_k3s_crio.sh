#!/bin/bash

set -e

# Retrieve the K3s container runtime
CONTAINER_RUNTIME=$(sudo crictl info | grep "Runtime Name" | awk '{print $NF}')

if [[ $CONTAINER_RUNTIME != "crio" ]]; then
    echo "Error: K3s is not using CRI-O as the container runtime."
    exit 1
fi

# Stop and remove all K3s containers
echo "Stopping and removing all K3s containers..."
sudo crictl pods | awk 'NR>1 {print $1}' | xargs -r -I{} sudo crictl stopp {} && sudo crictl rmp $(sudo crictl pods -q)

# Delete all K3s images
echo "Deleting all K3s images..."
sudo crictl images | awk 'NR>1 {print $3}' | xargs -r -I{} sudo crictl rmi {}

# Remove K3s CRI-O data directories
echo "Removing K3s CRI-O data directories..."
sudo rm -rf /var/lib/rancher/k3s

echo "K3s data cleaning completed successfully!"
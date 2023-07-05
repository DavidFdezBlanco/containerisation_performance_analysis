#!/bin/bash

set -e

# Retrieve the K3s container runtime
CONTAINER_RUNTIME=$(sudo crictl info | grep "Runtime Name" | awk '{print $NF}')



# Stop and remove all K3s containers
echo "Stopping and removing all K3s containers..."
sudo crictl ps -a | awk '{print $1}' | xargs -r -I{} sudo crictl stop {} && sudo crictl rm $(sudo crictl ps -a -q)

# Delete all K3s images
echo "Deleting all K3s images..."
sudo crictl images -q | xargs -r -I{} sudo crictl rmi {}

# Remove K3s Docker data directories
echo "Removing K3s Docker data directories..."
sudo rm -rf /var/lib/rancher/k3s

echo "K3s data cleaning completed successfully!"

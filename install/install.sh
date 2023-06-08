#!/bin/bash

set -e

source ../.env

# Check the number of arguments
if [ $# -lt 2 ]; then
  echo "Usage: ./install.sh <node_ips> <container_engine>"
  echo "Example: ./install.sh 192.168.0.1,192.168.0.2 docker"
  exit 1
fi

# Verify the container engine argument
VALID_ENGINES=("docker" "k3s_containerd" "k3s_crio" "lxc" "lxd")
CONTAINER_ENGINE=$2

if [[ ! " ${VALID_ENGINES[@]} " =~ " ${CONTAINER_ENGINE} " ]]; then
  echo "Invalid container engine specified. Available options: ${VALID_ENGINES[@]}"
  exit 1
fi

# Extract the node IPs from the first argument
IFS=',' read -ra NODE_IPS <<< "$1"

# Validate the IP addresses
validate_ip() {
  local ip=$1
  local valid_ip_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

  if [[ ! $ip =~ $valid_ip_regex ]]; then
    echo "Error: Invalid IP address: $ip"
    exit 1
  fi
}

for NODE_IP in "${NODE_IPS[@]}"; do
  validate_ip "$NODE_IP"
done

# Mono machine
if [ "${#NODE_IPS[@]}" -eq 1 ]; then
    echo "Installing on only one node: $NODE_IP"

    # Copy the installation script to the target machine
    scp -i ../keys/$KEY1 "$(dirname "$0")/mono_machine/install_${CONTAINER_ENGINE}.sh" user@$NODE_IP:/tmp/install_${CONTAINER_ENGINE}.sh

    # SSH into the node and run the installation script
    ssh -i ../keys/$KEY1 user@$NODE_IP "chmod +x /tmp/install_${CONTAINER_ENGINE}.sh && /tmp/install_${CONTAINER_ENGINE}.sh"

    # Remove the copied installation script from the target machine
    ssh -i ../keys/$KEY1 user@$NODE_IP "rm /tmp/install_${CONTAINER_ENGINE}.sh"
else
    echo "Installing $CONTAINER_ENGINE in a subset of following nodes. The master node will be the first of the list."

    for NODE_IP in "${NODE_IPS[@]}"; do
        echo "Installing on node: $NODE_IP"

        # Copy the installation script to the target machine
        scp -i ../keys/$KEY1 "$(dirname "$0")/multi_machine/install_${CONTAINER_ENGINE}.sh" user@$NODE_IP:/tmp/install_${CONTAINER_ENGINE}.sh

        # SSH into the node and run the installation script
        ssh -i ../keys/$KEY1 user@$NODE_IP "chmod +x /tmp/install_${CONTAINER_ENGINE}.sh && /tmp/install_${CONTAINER_ENGINE}.sh"

        # Remove the copied installation script from the target machine
        ssh -i ../keys/$KEY1 user@$NODE_IP "rm /tmp/install_${CONTAINER_ENGINE}.sh"
    done
fi

  # SSH into the node and run the configuration script
  ../configure/configure.sh $1 $2
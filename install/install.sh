#!/bin/bash

set -e

source ../.env
flags=""
if [[ $USE_ENV == true ]]; then
  echo "Using .env"
  flags="-F $PATH_TO_SSH_CONFIG -i $PATH_TO_KEY"
else
  echo "Not using .env"
fi

source ../.topography

# Check the number of arguments
if [ $# -lt 2 ]; then
  echo "Please update the topography file if you haven't done it yet to contain the authorized IPs."
  echo "Usage: ./install.sh <node_ips> <container_engine>"
  echo "Example: ./install.sh device110,device111 docker (for this to work, both device110 and 111 need to be declared within the topography DOCKER_NODES)" 
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
IFS=',' read -ra NODE_HOSTNAMES <<< "$1"
engine_node_variable_name=${CONTAINER_ENGINE^^}_NODES
IFS=',' read -ra VALID_HOSTNAMES <<< "${!engine_node_variable_name}"

# Validate the hostnames
validate_host_permissions() {
  local hostname=$1
  valid=false

  for VALID_HOSTNAME in "${VALID_HOSTNAMES[@]}"; do
    # VALID_HOSTNAME=$(echo $VALID_HOSTNAME | sed 's/.$//') put it if your line sequence is CRLF instead of LF
    if [[ "$hostname" == "$VALID_HOSTNAME" ]]; then
      valid=true
      break
    fi
  done

  if [[ $valid == false ]]; then
    echo "Invalid hostname. You are trying to install a $CONTAINER_ENGINE engine on a host with hostname $hostname, which is not within the authorized topography."
    exit 1
  fi
}

for NODE_HOSTNAME in "${NODE_HOSTNAMES[@]}"; do
  validate_host_permissions "$NODE_HOSTNAME"

  echo "Installing $CONTAINER_ENGINE on node: $NODE_HOSTNAME"

  # Copy the installation script to the target machine
  scp $flags "$(dirname "$0")/mono_machine/install_${CONTAINER_ENGINE}.sh" $NODE_HOSTNAME:/tmp/perf_study/install_${CONTAINER_ENGINE}.sh

  # SSH into the node and run the installation script
  ssh $flags $NODE_HOSTNAME "chmod +x /tmp/perf_study/install_${CONTAINER_ENGINE}.sh && /tmp/perf_study/install_${CONTAINER_ENGINE}.sh"

  # Remove the copied installation script from the target machine
  ssh $flags $NODE_HOSTNAME "rm /tmp/perf_study/install_${CONTAINER_ENGINE}.sh"

  echo "Install on $NODE_HOSTNAME ended."
done
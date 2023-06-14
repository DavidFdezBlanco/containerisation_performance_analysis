#!/bin/bash

set -e

source ../.env

# Check the number of arguments
if [ $# -lt 4 ]; then
  echo "Usage: ./test_choice.sh <node_ips> <container_engine> <test> <repetitions>"
  echo "Example: ./test_choice.sh 192.168.0.1,192.168.0.2 docker cpu_overhead 5"
  exit 1
fi

# Verify the container engine argument
VALID_ENGINES=("docker" "lxc_lxd" "k3s_default" "k3s_containerd")
CONTAINER_ENGINE=$2

if [[ ! " ${VALID_ENGINES[@]} " =~ " ${CONTAINER_ENGINE} " ]]; then
  echo "Invalid container engine specified. Available options: ${VALID_ENGINES[@]}"
  exit 1
fi

# Verify the test argument
VALID_TESTS=("cpu_overhead" "memory_overhead" "threads" "fileio" "mutex_coordination" "start_time" "build_time" "fibonacci")
TEST=$3

if [[ ! " ${VALID_TESTS[@]} " =~ " ${TEST} " ]]; then
  echo "Invalid test specified. Available options: ${VALID_TESTS[@]}"
  exit 1
fi

# Verify the repetitions argument
REPETITIONS=$4

if ! [[ $REPETITIONS =~ ^[0-9]+$ ]]; then
  echo "Invalid repetitions specified. Please provide a valid positive integer."
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

# Clean the machine if specified
if [ "$CLEAN_MACHINE" == "true" ]; then
  echo "Cleaning the machine"

  case $CONTAINER_ENGINE in
    docker)
      # Clean Docker containers, volumes, and networks
      ssh -i ../keys/$KEY1 user@$NODE_IP "docker system prune --all --volumes --force"
      ;;
    lxc_lxd)
      # Clean LXC/LXD containers
      ssh -i ../keys/$KEY1 user@$NODE_IP "lxc list | awk '{if(NR>2)print \$2}' | xargs -I% lxc delete %"
      ;;
    k3s_default)
      # Clean K3s containers and resources
      ssh -i ../keys/$KEY1 user@$NODE_IP "k3s kubectl delete all --all"
      ;;
    k3s_containerd)
      # Clean K3s containers and resources
      ssh -i ../keys/$KEY1 user@$NODE_IP "k3s crictl rmp --all"
      ;;
    *)
      echo "Cleaning is not supported for the chosen container engine."
      ;;
  esac
fi

# Run the test on each node
for NODE_IP in "${NODE_IPS[@]}"; do
  echo "Running test on node: $NODE_IP"

  # Copy the technology folder to the target machine
  scp -i ../keys/$KEY1 -r "$(dirname "$0")/tests/mono_machine/$TEST/$CONTAINER_ENGINE" user@$NODE_IP:/tmp

  # Run the test script
  ssh -i ../keys/$KEY1 user@$NODE_IP "cd /tmp/$CONTAINER_ENGINE; bash test.sh $REPETITIONS"

  # Run the collect_and_treat_result script
  ssh -i ../keys/$KEY1 user@$NODE_IP "cd /tmp/$CONTAINER_ENGINE; bash collect_and_treat_result.sh"
done

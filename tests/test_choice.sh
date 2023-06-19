#!/bin/bash

set -e

source ../.env

PATH_CONFIG_MAIN="/mnt/c/Users/amirr/.ssh/config"
echo "length is ${#PATH_CONFIG_MAIN}"
echo "length is ${#PATH_TO_SSH_CONFIG}"

flags=""
if [[ $USE_ENV == true ]]; then
  echo "Using .env"
  flags="-F $PATH_TO_SSH_CONFIG -i $PATH_TO_KEY"
else
  echo "Not using .env"
fi
echo $flags

source ../.topography

# Check the number of arguments
if [ $# -lt 4 ]; then
  echo "Please update the topography file if you haven't done it yet to contain the authorized IPs."
  echo "Usage: ./test_choice.sh <node_ips> <container_engine> <test> <repetitions> [-c]"
  echo "Example: ./test_choice.sh device110,device111 docker cpu_overhead 5 -c (for this to work, both device110 and 111 need to be declared within the topography DOCKER_NODES)"
  exit 1
fi

# Verify the container engine argument
VALID_ENGINES=("docker" "k3s_containerd" "k3s_crio" "lxc" "lxc_lxd" "node")
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
IFS=',' read -ra NODE_HOSTNAMES <<< "$1"
engine_node_variable_name=${CONTAINER_ENGINE^^}_NODES
IFS=',' read -ra VALID_HOSTNAMES <<< "${!engine_node_variable_name}"

# Validate the hostnames
validate_host_permissions() {
  local hostname=$1
  valid=false

  for VALID_HOSTNAME in "${VALID_HOSTNAMES[@]}"; do
    VALID_HOSTNAME=$(echo $VALID_HOSTNAME | sed 's/.$//')
    if [[ "$hostname" == "$VALID_HOSTNAME" ]]; then
      valid=true
      break
    fi
  done

  if [[ $valid == false ]]; then
    echo "Invalid hostname. You are trying to run a test on a host with hostname $hostname, which is not within the authorized topography."
    exit 1
  fi
}

for NODE_HOSTNAME in "${NODE_HOSTNAMES[@]}"; do
  validate_host_permissions "$NODE_HOSTNAME"
done

# Verify the clean argument
CLEAN_MACHINE=$5

# Clean the machine if specified
if [ "$CLEAN_MACHINE" == "-c" ]; then
  echo "Cleaning the machine"
  
  for NODE_HOSTNAME in "${NODE_HOSTNAMES[@]}"; do
    validate_host_permissions "$NODE_HOSTNAME"

    echo "Cleaning node: $NODE_HOSTNAME"

    case $CONTAINER_ENGINE in
      docker)
        # Clean Docker containers, volumes, and networks
        ssh $flags $NODE_HOSTNAME "docker system prune --all --volumes --force"
        ;;
      lxc)
        # Clean LXC containers
        ssh $flags $NODE_HOSTNAME "sudo lxc list | awk '{if(NR>2) print $2}' | xargs -I% lxc delete %; lxc image list | awk '{if(NR>2) print $2}' | xargs -I% lxc image delete %"
        ;;
      lxc_lxd)
        # Clean LXD containersexit
        ssh $flags $NODE_HOSTNAME "sudo apt-get remove --purge lxd lxd-client"
        ;;
      k3s_containerd)
        # Clean K3s containers and resources
        ssh $flags $NODE_HOSTNAME "k3s crictl rmp --all"
        ;;
      k3s_crio)
        # Clean K3s containers and resources
        ssh $flags $NODE_HOSTNAME "k3s crictl rmp --all"
        ;;
      *)
        echo "Cleaning is not supported for the chosen container engine."
        ;;
    esac
    # Remove all files in /tmp/test
    ssh $flags $NODE_HOSTNAME "rm -rf /tmp/test/*"
  done
fi

# Run the test on each node
for NODE_HOSTNAME in "${NODE_HOSTNAMES[@]}"; do
  validate_host_permissions "$NODE_HOSTNAME"

  echo "Running test on node: $NODE_HOSTNAME"

  # Copy the technology folder to the target machine
  scp $flags -r "/mnt/c/Users/amirr/STELLANTIS_these/containerisation_performance_analysis/tests/mono_machine/$TEST/$CONTAINER_ENGINE" $NODE_HOSTNAME:/tmp/test/$CONTAINER_ENGINE

  # Run the test script
  ssh $flags $NODE_HOSTNAME "cd /tmp/test/$CONTAINER_ENGINE; sudo bash test.sh $REPETITIONS"

  # Run the collect_and_treat_result script
  # ssh $flags $NODE_HOSTNAME "cd /tmp/$CONTAINER_ENGINE; bash collect_and_treat_result.sh"
done

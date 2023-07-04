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
echo $flags

source ../.topography

# Check the number of arguments
if [ $# -lt 4 ]; then
  echo "Please update the topography file if you haven't done it yet to contain the authorized IPs."
  echo "Usage: ./test_choice.sh <node_ips> <container_engine> <test> <repetitions> [-c]"
  echo "Example: ./test_choice.sh device110,device111 docker cpu_overhead 5 clean (for this to work, both device110 and 111 need to be declared within the topography DOCKER_NODES)"
  exit 1
fi

# Verify the container engine argument
VALID_ENGINES=("docker" "k3s_containerd" "k3s_crio" "lxd" "none")
CONTAINER_ENGINE=$2

if [[ ! " ${VALID_ENGINES[@]} " =~ " ${CONTAINER_ENGINE} " ]]; then
  echo "Invalid container engine specified. Available options: ${VALID_ENGINES[@]}"
  exit 1
fi

# Verify the test argument
VALID_TESTS=("cpu_overhead" "memory_overhead" "threads" "fileio" "mutex" "build_update_run_time")
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
    # VALID_HOSTNAME=$(echo $VALID_HOSTNAME | sed 's/.$//') put it if your line sequence is CRLF instead of LF
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
if [ "$CLEAN_MACHINE" == "clean" ]; then
  echo "Cleaning the machine"
  
  for NODE_HOSTNAME in "${NODE_HOSTNAMES[@]}"; do
    validate_host_permissions "$NODE_HOSTNAME"

    echo "Cleaning node: $NODE_HOSTNAME"

    ssh $flags $NODE_HOSTNAME "mkdir -p /tmp/perf_study/"
    # Copy the installation script to the target machine
    scp $flags "$(dirname "$0")/../full_cleanup/clean_${CONTAINER_ENGINE}.sh" $NODE_HOSTNAME:/tmp/perf_study/clean_${CONTAINER_ENGINE}.sh

    # SSH into the node and run the installation script
    ssh $flags $NODE_HOSTNAME "chmod +x /tmp/perf_study/clean_${CONTAINER_ENGINE}.sh && sudo /tmp/perf_study/clean_${CONTAINER_ENGINE}.sh"

    echo "Removing temp file..."
    ssh $flags $NODE_HOSTNAME "rm -rf /tmp/perf_study/*"
  done
fi

# Run the test on each node
for NODE_HOSTNAME in "${NODE_HOSTNAMES[@]}"; do
  validate_host_permissions "$NODE_HOSTNAME"

  echo "Running test on node: $NODE_HOSTNAME"

  ssh $flags $NODE_HOSTNAME "mkdir -p /tmp/perf_study/test/$CONTAINER_ENGINE"
  
  # Copy the technology folder to the target machine
  scp $flags -r "$(dirname "$0")/mono_machine/$TEST/$CONTAINER_ENGINE" $NODE_HOSTNAME:/tmp/perf_study/test/

  ssh $flags $NODE_HOSTNAME "mkdir -p /tmp/perf_study/test/$CONTAINER_ENGINE/results/"

  # SSH into the node and run the installation script
  ssh $flags $NODE_HOSTNAME "chmod +x /tmp/perf_study/test/$CONTAINER_ENGINE/test.sh && cd /tmp/perf_study/test/$CONTAINER_ENGINE/; sudo ./test.sh $REPETITIONS"
  
  # Run the collect_and_treat_result script
  scp $flags -r "$(dirname "$0")/mono_machine/$TEST/collect_and_treat_results.sh" $NODE_HOSTNAME:/tmp/perf_study/test/$CONTAINER_ENGINE/collect_and_treat_results.sh
  if [[ $TEST == "fileio" || $TEST == "threads" || $TEST == "mutex" ]]; then
    scp $flags -r "$(dirname "$0")/mono_machine/$TEST/collect_and_treat_results_each.sh" $NODE_HOSTNAME:/tmp/perf_study/test/$CONTAINER_ENGINE/collect_and_treat_results_each.sh
  fi

  OUTPUT_FILE_NAME_LOCAL="$(dirname "$0")/tmp/results/${CONTAINER_ENGINE}_${TEST}_result.csv"
  OUTPUT_FILE_NAME_MACHINE="/tmp/perf_study/test/${CONTAINER_ENGINE}/results/${CONTAINER_ENGINE}_${TEST}_result.csv"
  ssh $flags $NODE_HOSTNAME "bash /tmp/perf_study/test/${CONTAINER_ENGINE}/collect_and_treat_results.sh $REPETITIONS $OUTPUT_FILE_NAME_MACHINE $CONTAINER_ENGINE"

  mkdir -p $(dirname "$0")/tmp/results/
  scp $flags -r $NODE_HOSTNAME:$OUTPUT_FILE_NAME_MACHINE $OUTPUT_FILE_NAME_LOCAL
done
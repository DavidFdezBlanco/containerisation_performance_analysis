#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
number=$2
node=$3

for i in $(seq 1 $repetitions); do
    # Create new containers based on the "image_lxd_threads" image
    echo "Launching image_lxd_threads Image..."
    sudo lxc launch image_lxd_threads lxdThreads$number$i --target $node

    # Run Sysbench threads test for each container and save the result in a textfile outside the container
    echo "Executing threads sysbench command over image_lxd_fileio..."
    sudo lxc exec lxdThreads$number$i -- sysbench threads --threads=$number run > /tmp/perf_study/test/lxd/results/untreated_lxd_${node}_threads_${number}_$i.txt

    # Stop and delete container
    echo "Stoping lxdThreads$number$i..."
    sudo lxc stop lxdThreads$number$i
    echo "Cleaning lxdThreads$number$i..."
    sudo lxc delete lxdThreads$number$i
done
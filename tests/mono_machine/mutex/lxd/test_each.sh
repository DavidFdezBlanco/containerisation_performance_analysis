#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
number=$2

for i in $(seq 1 $repetitions); do
    # Create new containers based on the "image_lxd_threads" image
    echo "Launching image_lxd_mutex Image..."
    sudo lxc launch image_lxd_mutex lxdMutex$number$i

    # Run Sysbench threads test for each container and save the result in a textfile outside the container
    echo "Executing threads sysbench command over image_lxd_fileio..."
    sudo lxc exec lxdMutex$number$i -- sysbench mutex --threads=$number run > /tmp/perf_study/test/lxd/results/untreated_lxd_mutex_${number}_$i.txt

    # Stop and delete container
    echo "Stoping lxdMutex$number$i..."
    sudo lxc stop lxdMutex$number$i
    echo "Cleaning lxdMutex$number$i..."
    sudo lxc delete lxdMutex$number$i
done
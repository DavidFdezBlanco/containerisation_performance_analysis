#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1

# Creating LXD Image
echo "Creating LXD Image..."
./image_cpu.sh

# Create new containers based on the "cpu_overhead_lxd" image, run Sysbench CPU test for each container, 
# store the output in a text file outside the container, and then delete each container.
for i in $(seq 1 $repetitions); do
    # Create new containers based on the "cpu_overhead_lxd" image
    echo "Launching image_lxd_cpu_overhead Image..."
    sudo lxc launch image_lxd_cpu_overhead lxdCPUOverhead$i

    # Run Sysbench CPU test for each container and save the result in a textfile outside the container
    echo "Executing cpu sysbench command over image_lxd_cpu_overhead..."
    sudo lxc exec lxdCPUOverhead$i -- sysbench cpu run > /tmp/perf_study/test/lxd/results/untreated_lxd_cpu_overhead_$i.txt

    # Stop and delete container
    echo "Stoping lxdCPUOverhead$i..."
    sudo lxc stop lxdCPUOverhead$i
    echo "Cleaning lxdCPUOverhead$i..."
    sudo lxc delete lxdCPUOverhead$i
done
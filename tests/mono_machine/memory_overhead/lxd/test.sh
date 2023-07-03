#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1

# Creating LXD Image
echo "Creating LXD Image..."
/tmp/perf_study/test/lxd/image_memory.sh

# Create new containers based on the "memory_overhead_lxd" image, run Sysbench memory test for each container, 
# store the output in a text file outside the container, and then delete each container.
for i in $(seq 1 $repetitions); do
    # Create new containers based on the "memory_overhead_lxd" image
    echo "Launching image_lxd_memory_overhead Image..."
    sudo lxc launch image_lxd_memory_overhead lxdmemoryOverhead$i

    # Run Sysbench memory test for each container and save the result in a textfile outside the container
    echo "Executing memory sysbench command over image_lxd_memory_overhead..."
    sudo lxc exec lxdmemoryOverhead$i -- sysbench memory run > /tmp/perf_study/test/lxd/results/untreated_lxd_memory_overhead_$i.txt

    # Stop and delete container
    echo "Stoping lxdmemoryOverhead$i..."
    sudo lxc stop lxdmemoryOverhead$i
    echo "Cleaning lxdmemoryOverhead$i..."
    sudo lxc delete lxdmemoryOverhead$i
done
#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
filetestmode=$2
node=$3

for i in $(seq 1 $repetitions); do
    # Create new containers based on the "image_lxd_fileio" image
    echo "Launching image_lxd_fileio Image..."
    sudo lxc launch image_lxd_fileio lxdFileio$filetestmode$i --target $node

    # Run Sysbench FILEIO test for each container and save the result in a textfile outside the container
    echo "Executing fileio sysbench command over image_lxd_fileio..."
    sudo lxc exec lxdFileio$filetestmode$i -- sysbench fileio --file-test-mode=$filetestmode run > /tmp/perf_study/test/lxd/results/untreated_lxd_${node}_fileio_${filetestmode}_$i.txt

    # Stop and delete container
    echo "Stoping lxdFileio$filetestmode$i..."
    sudo lxc stop lxdFileio$filetestmode$i
    echo "Cleaning lxdFileio$filetestmode$i..."
    sudo lxc delete lxdFileio$filetestmode$i
done
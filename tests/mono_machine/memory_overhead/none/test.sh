#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y sysbench

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1

for i in $(seq 1 $repetitions); do
    echo "Sysbench Run $i"
    sudo sysbench memory run >> /tmp/perf_study/test/none/results/untreated_none_memory_overhead_$i.txt
done
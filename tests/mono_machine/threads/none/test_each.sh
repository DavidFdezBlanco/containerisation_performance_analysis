#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
number=$2

for i in $(seq 1 $repetitions); do
    echo "Sysbench Run $i"
    sudo sysbench threads --threads=$number run > /tmp/perf_study/test/none/results/untreated_none_threads_${number}_$i.txt
done
#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
filetestmode=$2

for i in $(seq 1 $repetitions); do
    echo "Sysbench Run $i"
    sudo sysbench fileio --file-test-mode=$filetestmode run > /tmp/perf_study/test/none/results/untreated_none_fileio_${filetestmode}_$i.txt
done
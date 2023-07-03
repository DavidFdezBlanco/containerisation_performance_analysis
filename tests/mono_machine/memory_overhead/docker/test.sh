#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1

sudo docker build -t sysbench-memory .

# Create specified number of containers from the sysbench-memory image
for i in $(seq 1 $repetitions); do
    sudo docker run -d --name=sysbench-memory-$i sysbench-memory

    echo "Running test $i"

    sudo docker wait sysbench-memory-$i

    sudo docker logs sysbench-memory-$i >> /tmp/perf_study/test/docker/results/untreated_docker_memory_overhead_$i.txt

    sudo docker rm sysbench-memory-$i
done
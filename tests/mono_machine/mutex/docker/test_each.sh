#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
number=$2

sudo docker build -t sysbench-mutex-threads-$number -f dockerfile_$number .

# Create specified number of containers from the sysbench-memory image
for i in $(seq 1 $repetitions); do
    sudo docker run -d --name=sysbench-mutex-threads-$number-$i sysbench-mutex-threads-$number

    echo "Running test $i"

    sudo docker wait sysbench-mutex-threads-$number-$i

    sudo docker logs sysbench-mutex-threads-$number-$i >> /tmp/perf_study/test/docker/results/untreated_docker_mutex_${number}_$i.txt

    sudo docker rm sysbench-mutex-threads-$number-$i
done
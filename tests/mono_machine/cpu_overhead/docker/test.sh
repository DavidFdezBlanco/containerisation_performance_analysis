#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1

docker build -t sysbench-cpu .

# Create specified number of containers from the sysbench-cpu image
for i in $(seq 1 $repetitions); do
    docker run -d --name=sysbench-cpu-$i sysbench-cpu

    echo "Running test $i"

    docker wait sysbench-cpu-$i

    docker logs sysbench-cpu-$i >> resultat_cpu$i.txt

    docker rm sysbench-cpu-$i
done


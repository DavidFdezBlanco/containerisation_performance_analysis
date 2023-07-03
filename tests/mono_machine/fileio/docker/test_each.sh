#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
filetestmode=$2

sudo docker build -t sysbench-fileio-$filetestmode -f dockerfile_$filetestmode .

# Create specified number of containers from the sysbench-memory image
for i in $(seq 1 $repetitions); do
    sudo docker run -d --name=sysbench-fileio-$filetestmode-$i sysbench-fileio-$filetestmode

    echo "Running test $i"

    sudo docker wait sysbench-fileio-$filetestmode-$i

    sudo docker logs sysbench-fileio-$filetestmode-$i >> /tmp/perf_study/test/docker/results/untreated_docker_fileio_${filetestmode}_$i.txt

    sudo docker rm sysbench-fileio-$filetestmode-$i
done
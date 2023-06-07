#!/bin/bash

docker build -t sysbench-cpu .
# Create 20 container frome sysbench-cpu image
for i in {1..20}; do
    docker run -d --name=sysbench-cpu-$i sysbench-cpu

    docker logs sysbench-cpu-$i >> resultat_cpu$i.txt

    docker rm sysbench-cpu-$i
done




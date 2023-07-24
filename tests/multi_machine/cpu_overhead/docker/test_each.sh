#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
node=$2

# Définir la variable d'environnement NODE_NAME avec le nom du nœud passé en argument
export NODE_NAME="raspberry-3Bplus-1-$node"

# Construire l'image sysbench-cpu à partir du Dockerfile
docker-compose build

# Créer le nombre spécifié de conteneurs Sysbench à partir de l'image sysbench-cpu
for i in $(seq 1 $repetitions); do
    docker stack deploy --compose-file docker-compose.yml sysbench-cpu-$i
    echo "Running test $i"

    while [ -z "$(docker service ps sysbench-cpu-${i}_sysbench-cpu | grep "sysbench-cpu" | grep "Complete")" ]; do
      echo "Not found, waiting."
      sleep 1
    done
    # Attendre que le conteneur Sysbench termine son test
    docker service logs sysbench-cpu-${i}_sysbench-cpu > ./results/untreated_docker_${node}_cpu_overhead_$i.txt

    # Supprimer le conteneur Sysbench
    docker stack rm sysbench-cpu-$i

    sleep 5
done
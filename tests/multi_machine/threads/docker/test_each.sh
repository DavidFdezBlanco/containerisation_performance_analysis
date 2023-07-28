#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
number=$2
node=$3

# Définir la variable d'environnement NODE_NAME avec le nom du nœud passé en argument
export NODE_NAME="raspberry-3Bplus-1-$node"
export NUMBER="$number"

# Construire l'image sysbench-threads à partir du Dockerfile
docker-compose build

# Créer le nombre spécifié de conteneurs Sysbench à partir de l'image sysbench-threads
for i in $(seq 1 $repetitions); do
    docker stack deploy --compose-file docker-compose.yml sysbench-threads-$i
    echo "Running test $i"

    while [ -z "$(docker service ps sysbench-threads-${i}_sysbench-threads | grep "sysbench-threads" | grep "Complete")" ]; do
      echo "Not found, waiting."
      sleep 1
    done
    # Attendre que le conteneur Sysbench termine son test
    docker service logs sysbench-threads-${i}_sysbench-threads > ./results/untreated_docker_${node}_threads_${number}_$i.txt

    # Supprimer le conteneur Sysbench
    docker stack rm sysbench-threads-$i

    sleep 5
done
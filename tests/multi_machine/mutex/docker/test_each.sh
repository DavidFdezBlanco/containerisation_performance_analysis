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

# Construire l'image sysbench-mutex à partir du Dockerfile
docker-compose build


# Créer le nombre spécifié de conteneurs Sysbench à partir de l'image sysbench-mutex
for i in $(seq 1 $repetitions); do
    docker stack deploy --compose-file docker-compose.yml sysbench-mutex-$i
    echo "Running test $i"

    while [ -z "$(docker service ps sysbench-mutex-${i}_sysbench-mutex | grep "sysbench-mutex" | grep "Complete")" ]; do
      echo "Not found, waiting."
      sleep 1
    done
    # Attendre que le conteneur Sysbench termine son test
    docker service logs sysbench-mutex-${i}_sysbench-mutex > ./results/untreated_docker_${node}_mutex_${number}_$i.txt

    # Supprimer le conteneur Sysbench
    docker stack rm sysbench-mutex-$i

    sleep 5
done
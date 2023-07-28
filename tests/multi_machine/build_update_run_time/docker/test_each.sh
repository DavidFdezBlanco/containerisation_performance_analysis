#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
script=$2
node=$3
number_cluster=$4

# Définir la variable d'environnement NODE_NAME avec le nom du nœud passé en argument
export NODE_NAME="raspberry-3Bplus-1-$node"
export SCRIPT="$script"


output_file="/tmp/perf_study/test/docker/results/untreated_docker_${node}_build_update_run_time.txt"
echo -e "number of cluster,machine,index,Script,Build,Update no cache,Update cache,Run" >> "$output_file"


# Créer le nombre spécifié de conteneurs Sysbench à partir de l'image sysbench-build
for i in $(seq 1 $repetitions); do
    # Construire l'image sysbench-build à partir du Dockerfile
    echo "Building image $script"
    BEFORE=$(date +'%s.%N')
    docker-compose build --no-cache
    docker push 10.0.1.110:5000/build_update_run_time-$script
    AFTER=$(date +'%s.%N')
    ELAPSED_BUILD=$(echo "scale=9; $AFTER - $BEFORE" | bc)
    echo "Temps de build : $ELAPSED_BUILD secondes"

    echo "Update cache image $script"
    BEFORE=$(date +'%s.%N')
    docker-compose build 
    docker push 10.0.1.110:5000/build_update_run_time-$script
    AFTER=$(date +'%s.%N')
    ELAPSED_UPDATE_CACHE=$(echo "scale=9; $AFTER - $BEFORE" | bc)
    echo "Temps update cache : $ELAPSED_UPDATE_CACHE secondes"


    #run 
    echo "Running image $script"
    docker stack deploy --compose-file docker-compose.yml build_update_run_time-$script-$i
    

    while [ -z "$(docker service ps build_update_run_time-${script}-${i}_build_update_run_time | grep "build_update_run_time" | grep "seconds ago")" ]; do
      echo "Not found, waiting."
      sleep 1
    done
    created="$(sudo docker service inspect --format '{{json .CreatedAt}}' build_update_run_time-${script}-${i}_build_update_run_time)"
    started="$(sudo docker service inspect --format '{{json .UpdatedAt}}' build_update_run_time-${script}-${i}_build_update_run_time)"
    echo "Created at $created"
    echo "Started at $started"
    ELAPSED_RUN=$(echo "$created - $started")
    echo "Temps run : $ELAPSED_RUN secondes"


    # Supprimer le conteneur 
    docker stack rm build_update_run_time-$script-$i

    ELAPSED_UPDATE_NO_CACHE="Not possible"

    echo -e "$number_cluster,$node,$i,$script,$ELAPSED_BUILD,$ELAPSED_UPDATE_NO_CACHE,$ELAPSED_UPDATE_CACHE,$ELAPSED_RUN" >> "$output_file"
    sleep 5
done
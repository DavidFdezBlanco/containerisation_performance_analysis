#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
script=$2
output_file="/tmp/perf_study/test/docker/results/untreated_docker_build_update_run_time.txt"
echo -e "index,Script,Build,Update no cache,Update cache,Run,Remove" > "$output_file"

for i in $(seq 1 $repetitions); do
  
  BEFORE=$(date +'%s')
  sudo docker build --no_cache -t test-$script -f dockerfile_$script .
  AFTER=$(date +'%s')
  ELAPSED_BUILD=$((AFTER - BEFORE))
  echo "Temps d'exécution : $ELAPSED_BUILD secondes"

  BEFORE=$(date +'%s')
  sudo docker build -t test-${script}-update -f dockerfile_${script}_update .
  AFTER=$(date +'%s')
  ELAPSED_UPDATE_CACHE=$((AFTER - BEFORE))
  echo "Temps d'exécution : $ELAPSED_UPDATE_CACHE secondes"

  BEFORE=$(date +'%s')
  sudo docker build --no_cache -t test-${script}-update -f dockerfile_${script}_update .
  AFTER=$(date +'%s')
  ELAPSED_UPDATE_NO_CACHE=$((AFTER - BEFORE))
  echo "Temps d'exécution : $ELAPSED_UPDATE_NO_CACHE secondes"

  BEFORE=$(date +'%s')
  sudo docker run -d --name=test-$script-$i test-${script}
  sudo docker wait test-$script-$i
  AFTER=$(date +'%s')
  ELAPSED_RUN=$((AFTER - BEFORE))
  echo "Temps d'exécution : $ELAPSED_RUN secondes"
  
  BEFORE=$(date +'%s')
  sudo docker rm test-$script-$i
  AFTER=$(date +'%s')
  ELAPSED_REMOVE=$((AFTER - BEFORE))
  echo "Temps d'exécution : $ELAPSED_REMOVE secondes"

  echo -e "$i,$script,$ELAPSED_BUILD,$ELAPSED_UPDATE_NO_CACHE,$ELAPSED_UPDATE_CACHE,$ELAPSED_RUN,$ELAPSED_REMOVE" > "$output_file"
done
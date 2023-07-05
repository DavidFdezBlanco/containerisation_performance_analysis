#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
script=$2
output_file="/tmp/perf_study/test/docker/results/untreated_docker_build_update_run_time.txt"
echo -e "index,Script,Build,Update no cache,Update cache,Run" >> "$output_file"

for i in $(seq 1 $repetitions); do
  echo "Building image $script"
  BEFORE=$(date +'%s.%N')
  sudo lxc launch images:ubuntu/22.04 test-$script-$i
  sudo lxc file push $script test-$script-$i/
  sudo lxc exec test-$script-$i -- /bin/bash -c "apt-get update && apt-get install -y gcc && gcc -o $script $script.c"
  sudo lxc publish test-$script-$i --alias image-test-$script-$i
  sudo lxc delete test-$script-$i --force
  AFTER=$(date +'%s.%N')
  ELAPSED_BUILD=$(echo "scale=9; $AFTER - $BEFORE" | bc)
  echo "Temps de build : $ELAPSED_BUILD secondes"
# Supprimer le conteneur LXD

  
  

for i in $(seq 1 $repetitions); do
  echo "Building image $script"
  BEFORE=$(date +'%s.%N')
  sudo docker build --no-cache -t test-$script-$i -f dockerfile_$script .
  AFTER=$(date +'%s.%N')
  ELAPSED_BUILD=$(echo "scale=9; $AFTER - $BEFORE" | bc)
  echo "Temps de build : $ELAPSED_BUILD secondes"

  echo "Update cache image $script"
  BEFORE=$(date +'%s.%N')
  sudo docker build -t test-${script}-update-$i -f dockerfile_${script}_update .
  AFTER=$(date +'%s.%N')
  ELAPSED_UPDATE_CACHE=$(echo "scale=9; $AFTER - $BEFORE" | bc)
  echo "Temps update cache : $ELAPSED_UPDATE_CACHE secondes"

  echo "Update no cache image $script"
  BEFORE=$(date +'%s.%N')
  sudo docker build --no-cache -t test-${script}-update-$i -f dockerfile_${script}_update .
  AFTER=$(date +'%s.%N')
  ELAPSED_UPDATE_NO_CACHE=$(echo "scale=9; $AFTER - $BEFORE" | bc)
  echo "Temps update no cache : $ELAPSED_UPDATE_NO_CACHE secondes"

  echo "Running image $script"
  sudo docker run -d --name=test-$script-$i test-${script}-$i
  sleep 5s
  created="$(sudo docker inspect --format '{{json .Created}}' test-$script-$i)"
  started="$(sudo docker inspect --format '{{json .State.StartedAt}}' test-$script-$i)"
  echo "Created at $created"
  echo "Started at $started"
  ELAPSED_RUN=$(echo "$created - $started")
  echo "Temps run : $ELAPSED_RUN secondes"

  echo -e "$i,$script,$ELAPSED_BUILD,$ELAPSED_UPDATE_NO_CACHE,$ELAPSED_UPDATE_CACHE,$ELAPSED_RUN" >> "$output_file"
done
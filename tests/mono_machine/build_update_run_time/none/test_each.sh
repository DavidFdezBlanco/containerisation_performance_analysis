#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
script=$2
output_file="/tmp/perf_study/test/lxd/results/untreated_none_build_update_run_time.txt"
echo -e "index,Script,Build,Update no cache,Update cache,Run" >> "$output_file"

for i in $(seq 1 $repetitions); do
  echo "Building image $script"
  BEFORE=$(date +'%s.%N')
  gcc $script.c -o $script
  AFTER=$(date +'%s.%N')
  ELAPSED_BUILD=$(echo "scale=9; $AFTER - $BEFORE" | bc)
  echo "Temps de build : $ELAPSED_BUILD secondes"

  echo "Running image $script"
  BEFORE=$(date +'%s.%N')
  ./$script
  AFTER=$(date +'%s.%N')
  ELAPSED_RUN=$(echo "scale=9; $AFTER - $BEFORE" | bc)
  echo "Temps run : $ELAPSED_RUN secondes"

  echo "Update image no cache $script"
  BEFORE=$(date +'%s.%N')
  gcc $script_update.c -o $script-update
  AFTER=$(date +'%s.%N')
  ELAPSED_UPDATE_NO_CACHE=$(echo "scale=9; $AFTER - $BEFORE" | bc)
  echo "Temps de build : $ELAPSED_UPDATE_NO_CACHE secondes"

  rm $script
  rm $script-update

  $ELAPSED_UPDATE_NO_CACHE="Not possible"

  echo -e "$i,$script,$ELAPSED_BUILD,$ELAPSED_UPDATE_NO_CACHE,$ELAPSED_UPDATE_CACHE,$ELAPSED_RUN" >> "$output_file"
done
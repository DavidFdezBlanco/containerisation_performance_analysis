#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
script=$2
output_file="/tmp/perf_study/test/lxd/results/untreated_lxd_build_update_run_time.txt"
echo -e "index,Script,Build,Update no cache,Update cache,Run" >> "$output_file"

for i in $(seq 1 $repetitions); do
  echo "Building image $script"
  BEFORE=$(date +'%s.%N')
  sudo lxc launch images:ubuntu/22.04 test-$script-$i
  sudo lxc file push $script.c test-$script-$i/
  sudo lxc exec test-$script-$i -- /bin/bash -c "apt-get update && apt-get install -y gcc && gcc -o $script $script.c"
  sudo lxc stop test-$script-$i
  sudo lxc publish test-$script-$i --alias image-test-$script-$i
  sudo lxc delete test-$script-$i --force
  AFTER=$(date +'%s.%N')
  ELAPSED_BUILD=$(echo "scale=9; $AFTER - $BEFORE" | bc)
  echo "Temps de build : $ELAPSED_BUILD secondes"

  echo "Running image $script"
  BEFORE=$(date +'%s.%N')
  sudo lxc launch image-test-$script-$i cont-test-$script-$i
  sudo lxc exec image-test-$script-$i -- /$script
  AFTER=$(date +'%s.%N')
  ELAPSED_RUN=$(echo "scale=9; $AFTER - $BEFORE" | bc)
  echo "Temps run : $ELAPSED_RUN secondes"

  echo "Update image no cache $script"
  BEFORE=$(date +'%s.%N')
  sudo lxc launch images:ubuntu/22.04 test-$script-upd-$i
  sudo lxc file push ${script}_update.c test-$script-upd-$i/
  sudo lxc exec test-$script-upd-$i -- /bin/bash -c "apt-get update -y && apt-get install -y gcc"
  sudo lxc exec test-$script-upd-$i -- /bin/bash -c "gcc -o $script $script.c"
  sudo lxc stop test-$script-upd-$i
  sudo lxc publish test-$script-upd-$i --alias image-test-$script-upd-$i
  sudo lxc delete test-$script-upd-$i --force
  AFTER=$(date +'%s.%N')
  ELAPSED_UPDATE_NO_CACHE=$(echo "scale=9; $AFTER - $BEFORE" | bc)
  echo "Temps de build : $ELAPSED_UPDATE_NO_CACHE secondes"

  ELAPSED_UPDATE_CACHE="Not possible"

  echo -e "$i,$script,$ELAPSED_BUILD,$ELAPSED_UPDATE_NO_CACHE,$ELAPSED_UPDATE_CACHE,$ELAPSED_RUN" >> "$output_file"
done
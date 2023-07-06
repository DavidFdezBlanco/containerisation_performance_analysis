#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
script=$2
output_file="/tmp/perf_study/test/k3s_containerd/results/untreated_k3s_containerd_build_update_run_time.txt"
echo -e "index,Script,Build,Update no cache,Update cache,Run" >> "$output_file"

for i in $(seq 1 $repetitions); do
  echo "Building image $script"
  BEFORE=$(date +'%s.%N')
  #execution du pod
  kubectl run test-$script-$i --image=ubuntu:22.04 --command -- sleep infinity
  
  # Attente que le pod soit prêt
  kubectl wait --for=condition=Ready pod/test-$script-$i

  # Exécution du test Sysbench CPU et redirection de la sortie
  kubectl exec -it test-$script-$i -- apt-get update 

  kubectl exec -it test-$script-$i -- apt-get install -y gcc 
  # copie script vers container
  kubectl cp /tmp/perf_study/test/k3s_containerd/$script.c test-$script-$i:/tmp
  # compilation script c
  kubectl exec -it test-$script-$i -- gcc -o $script /tmp/$script.c 
  AFTER=$(date +'%s.%N')
  ELAPSED_BUILD=$(echo "scale=9; $AFTER - $BEFORE" | bc)
  echo "Temps de build : $ELAPSED_BUILD secondes"


  echo "Running image $script"
  BEFORE=$(date +'%s.%N')
  #faire play container
  kubectl exec -it test-$script-$i  -- /$script
  AFTER=$(date +'%s.%N')
  ELAPSED_RUN=$(echo "scale=9; $AFTER - $BEFORE" | bc)
  echo "Temps run : $ELAPSED_RUN secondes"

  kubectl delete pod test-$script-$i

  echo "Update image no cache $script"
  BEFORE=$(date +'%s.%N')
  #execution du pod
  kubectl run test-$script-$i --image=ubuntu:22.04 --command -- sleep infinity
  
  # Attente que le pod soit prêt
  kubectl wait --for=condition=Ready pod/test-$script-$i

  # Exécution du test Sysbench CPU et redirection de la sortie
  kubectl exec -it test-$script-$i -- apt-get update 

  kubectl exec -it test-$script-$i -- apt-get install -y gcc 
  # copie script vers container
  kubectl cp /tmp/perf_study/test/k3s_containerd/$script.c test-$script-$i:/tmp
  # compilation script c
  kubectl exec -it test-$script-$i -- gcc -o $script /tmp/$script.c
  AFTER=$(date +'%s.%N')
  ELAPSED_UPDATE_NO_CACHE=$(echo "scale=9; $AFTER - $BEFORE" | bc)
  echo "Temps de build : $ELAPSED_UPDATE_NO_CACHE secondes"
  kubectl delete pod test-$script-$i
  ELAPSED_UPDATE_CACHE="Not possible"

  echo -e "$i,$script,$ELAPSED_BUILD,$ELAPSED_UPDATE_NO_CACHE,$ELAPSED_UPDATE_CACHE,$ELAPSED_RUN" >> "$output_file"
done
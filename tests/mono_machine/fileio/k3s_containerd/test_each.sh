#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
filetestmode=$2

# Répétition de la séquence x fois
for i in $(seq 1 $repetitions); do
  # Création du pod
  container_name="container$i"
  kubectl run "$container_name" --image=ubuntu:22.04 --command -- sleep infinity
  sleep 5

  # Attente que le pod soit prêt
  kubectl wait --for=condition=Ready pod/"$container_name"

  # Exécution du test Sysbench CPU et redirection de la sortie
  kubectl exec -it "$container_name" -- apt update > /dev/null

  kubectl exec -it "$container_name" -- apt install -y sysbench > /dev/null

  kubectl exec -it "$container_name" -- sysbench fileio prepare > /dev/null

  kubectl exec -it "$container_name" -- sysbench fileio --file-test-mode=$filetestmode run > /tmp/perf_study/test/k3s_containerd/results/untreated_k3s_containerd_fileio_${filetestmode}_$i.txt

  # Suppression du pod
  kubectl delete pod "$container_name"

  # Attente de quelques secondes avant la prochaine itération
  sleep 5
done

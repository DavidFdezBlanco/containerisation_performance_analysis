#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1

# Répétition de la séquence x fois
for i in $(seq 1 $repetitions); do
  # Exécution du test Sysbench CPU et redirection de la sortie vers un fichier
  sysbench cpu run > "cpu$i.txt"
done

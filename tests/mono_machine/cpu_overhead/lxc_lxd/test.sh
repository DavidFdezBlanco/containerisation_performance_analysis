#!/bin/bash


if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1

./image_cpu.sh 

# Créer de nouveaux conteneurs basés sur l'image "TestSys", exécuter le test Sysbench CPU run pour chaque conteneur, stocker la sortie dans un fichier texte en dehors du conteneur, puis supprimer chaque conteneur
for i in $(seq 1 $repetitions); do
    # Créer un nouveau conteneur basé sur l'image "TestSys"
    lxc launch testSys test-container$i


    # Exécuter le test Sysbench CPU run dans le conteneur et stocker la sortie dans un fichier texte en dehors du conteneur
    lxc exec test-container$i -- sysbench cpu run > resultat_cpu$i.txt

    # Supprimer le conteneur
    lxc stop test-container$i
    lxc delete test-container$i
done
#!/bin/bash

# Créer 30 nouveaux conteneurs basés sur l'image "TestSys", exécuter le test Sysbench CPU run pour chaque conteneur,>
for i in $(seq 1 20); do
    # Créer un nouveau conteneur basé sur l'image "TestSys"
    lxc launch TestSys test-container$i

    # Attendre que le conteneur soit en cours d'exécution
    lxc info test-container$i | grep -q "Status:.*Running" || sleep 1

    # Exécuter le test Sysbench CPU run dans le conteneur et stocker la sortie dans un fichier texte en dehors du co>
    lxc exec test-container$i -- sysbench fileio --file-test-mode=seqwr run > seqwr$i.txt

    # Supprimer le conteneur
    lxc stop test-container$i
    lxc delete test-container$i
done

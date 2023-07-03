#!/bin/bash

# Nom du conteneur LXD
container_name="fibonacci"

# Nom de l'image LXD
image_name="fibonacci-image"

# Temps de début
start_time=$(date +%s.%N)

# Créer le conteneur LXD
sudo lxc launch images:ubuntu/22.04 $container_name

# Copier le fichier source dans le conteneur
sudo lxc file push main.c $container_name/

# Exécuter les commandes de compilation dans le conteneur
sudo lxc exec $container_name -- /bin/bash -c 'apt-get update && apt-get install -y gcc && gcc -o fibonacci main.c'

# Publier l'image LXD
sudo lxc publish $container_name --alias $image_name

# Supprimer le conteneur LXD
sudo lxc delete $container_name --force

# Temps de fin
end_time=$(date +%s.%N)

# Calculer le temps écoulé
elapsed_time=$(echo "$end_time - $start_time" | bc)

echo "Temps de construction de l'image LXD : $elapsed_time secondes"

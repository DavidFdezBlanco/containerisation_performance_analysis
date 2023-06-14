#!/bin/bash

# Nom de l'image LXD
image_name="hello-world"

# Nom du conteneur LXD
container_name="test"

# Temps de début
start_time=$(date +%s.%N)

# Lancer le conteneur LXD à partir de l'image existante
sudo lxc launch $image_name $container_name

# Exécuter le binaire "hello_world" à l'intérieur du conteneur
sudo lxc exec $container_name -- /hello_world

# Temps de fin
end_time=$(date +%s.%N)

# Calculer le temps écoulé
elapsed_time=$(echo "$end_time - $start_time" | bc)

echo "Temps d'exécution du conteneur LXD : $elapsed_time secondes"

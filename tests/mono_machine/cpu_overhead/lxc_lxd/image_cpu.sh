#!/bin/bash

# Créer un conteneur LXD temporaire basé sur l'image Ubuntu 22.04
lxc launch images:ubuntu/22.04 temporary-container

# Installer Sysbench dans le conteneur temporaire
lxc exec temporary-container -- apt-get update
lxc exec temporary-container -- apt-get install -y sysbench

# Créer une image LXD basée sur le conteneur temporaire
lxc stop temporary-container
lxc publish temporary-container --alias testSys

# Supprimer le conteneur temporaire
lxc delete temporary-container

echo "L'image LXD testSys avec Sysbench a été créée avec succès."

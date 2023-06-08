#!/bin/bash

BEFORE=$(date +'%s')

docker run --name test fibonacci

AFTER=$(date +'%s')
ELAPSED=$((AFTER - BEFORE))

echo "Temps d'exécution : $ELAPSED secondes"


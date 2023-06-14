#!/bin/bash

BEFORE=$(date +'%s')

docker run --name test helloworld

AFTER=$(date +'%s')
ELAPSED=$((AFTER - BEFORE))

echo "Temps d'exécution : $ELAPSED secondes"


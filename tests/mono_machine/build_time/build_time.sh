#!/bin/bash

BEFORE=$(date +'%s')

docker build -t helloworld .

AFTER=$(date +'%s')
ELAPSED=$((AFTER - BEFORE))

echo "Temps d'exécution : $ELAPSED secondes"
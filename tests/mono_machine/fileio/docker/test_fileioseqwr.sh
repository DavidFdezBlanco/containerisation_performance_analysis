#!/bin/bash


if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1


# Build the Docker image from the Dockerfile
docker build -t seqwr-test -f dockerFileSeqwr .


# Loop to create other containers
for i in $(seq 1 $repetitions); do
  container_id=$(docker run -d --name "conteneur$i" seqwr-test)

  # Wait for the container to exit
  docker container wait "$container_id"

  # Get the logs from the new container and save them to a file
  docker logs --tail all "$container_id" > "seqwr$i.txt"

  # Remove the container
  docker container rm "$container_id"

done



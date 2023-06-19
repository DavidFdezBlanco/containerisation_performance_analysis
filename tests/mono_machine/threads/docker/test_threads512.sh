#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1

# Build the Docker image from the Dockerfile
docker build -t threads512-test -f dockerThreads512 .


for i in $(seq 1 $repetitions); do
  # Create a new container
  container_id=$(docker run -d --name "conteneur$i" threads512-test)

  # Wait for the container to exit
  docker container wait "$container_id"

  # Get the logs from the new container and save them to a file
  docker logs --tail all "$container_id" > "512_threads$i.txt"

  # Remove the container
  docker container rm "$container_id"
  
done



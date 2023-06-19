#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <repetitions>"
  exit 1
fi

repetitions=$1
# Build the Docker image from the Dockerfile
docker build -t mutex-test10 .

# Create 40 containers
for i in $(seq 1 $repetitions); do
  # Create a new container
  container_id=$(docker run -d --name "conteneur$i" mutex-test10)

  # Get the logs from the container and save them to a file
  docker logs "$container_id" > "10_mutex$i.txt"

  # Remove the container
  docker rm "$container_id"
done

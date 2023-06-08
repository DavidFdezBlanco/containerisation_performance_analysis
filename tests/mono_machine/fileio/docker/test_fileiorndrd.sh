#!/bin/bash

# Build the Docker image from the Dockerfile
docker build -t rndrd-test -f dockerFileRndrd .


# Loop to create other containers
for i in {1..30}
do
  # Create a new container
  container_id=$(docker run -d --name "conteneur$i" rndrd-test)

  # Wait for the container to exit
  docker container wait "$container_id"

  # Get the logs from the new container and save them to a file
  docker logs --tail all "$container_id" > "rndrd$i.txt"

  # Remove the container
  docker container rm "$container_id"
done

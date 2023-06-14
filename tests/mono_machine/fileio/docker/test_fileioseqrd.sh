#!/bin/bash

# Build the Docker image from the Dockerfile
docker build -t seqrd-test -f dockerFileSeqrd .


# Loop to create other containers
for i in {1..30}
do
  container_id=$(docker run -d --name "conteneur$i" seqrd-test)

  # Wait for the container to exit
  docker container wait "$container_id"

  # Get the logs from the new container and save them to a file
  docker logs --tail all "$container_id" > "seqrd$i.txt"

  # Remove the container
  docker container rm "$container_id"
done



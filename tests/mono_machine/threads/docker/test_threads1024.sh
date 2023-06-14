#!/bin/bash

# Build the Docker image from the Dockerfile
docker build -t threads1024-test -f dockerThreads1024 .


for i in {1..20}
do
  # Create a new container
  container_id=$(docker run -d --name "conteneur$i" threads1024-test)

  # Wait for the container to exit
  docker container wait "$container_id"

  # Get the logs from the new container and save them to a file
  docker logs --tail all "$container_id" > "1024_threads$i.txt"

  # Remove the container
  docker container rm "$container_id"
  
done

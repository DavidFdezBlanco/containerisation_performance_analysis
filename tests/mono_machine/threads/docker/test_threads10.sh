#!/bin/bash

# Build the Docker image from the Dockerfile
docker build -t threads10-test -f dockerThreads10 .


for i in {1..20}
do
  # Create a new container
  container_id=$(docker run -d --name "conteneur$i" threads10-test)

  # Wait for the container to exit
  docker container wait "$container_id"

  # Get the logs from the new container and save them to a file
  docker logs --tail all "$container_id" > "10_threads$i.txt"

  # Remove the container
  docker container rm "$container_id"

done



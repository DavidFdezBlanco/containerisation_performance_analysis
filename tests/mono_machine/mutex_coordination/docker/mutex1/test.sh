#!/bin/bash

# Build the Docker image from the Dockerfile
docker build -t mutex-test1 .

# Create 40 containers
for i in {1..40}
do
  # Create a new container
  container_id=$(docker run -d --name "conteneur$i" mutex-test1)

  # Get the logs from the container and save them to a file
  docker logs "$container_id" > "1_mutex$i.txt"

  # Remove the container
  docker rm "$container_id"
done
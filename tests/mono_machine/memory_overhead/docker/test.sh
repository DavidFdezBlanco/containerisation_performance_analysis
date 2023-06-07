#!/bin/bash

# Build the Docker image from the Dockerfile
docker build -t memory-test .

# Create 40 containers
for i in {1..40}
do
  # Create a new container
  container_id=$(docker run -d memory-test)

  # Get the logs from the container and save them to a file
  docker logs $container_id > "memory$i.txt"

  # Delete the container
  docker rm -f $container_id
done


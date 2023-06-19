#!/bin/bash

set -e

if [ $(docker ps -aq) ]; then
    # Stop all running containers
    echo "Stopping all running containers..."
    docker stop $(docker ps -aq)

    # Remove all containers
    echo "Removing all containers..."
    docker rm $(docker ps -aq)
fi

if [ $(docker images -aq) ]; then
    # Remove all images
    echo "Removing all images..."
    docker rmi $(docker images -aq)
fi

if [ $(docker volume ls -q) ]; then
    # Remove all volumes
    echo "Removing all volumes..."
    docker volume rm $(docker volume ls -q)
fi

if [ $(docker volume ls -q) ]; then
    # Remove all networks
    echo "Removing all networks..."
    docker network rm $(docker network ls -q)
fi

# Remove unused Docker data
echo "Removing unused Docker data..."
docker system prune --all --volumes -f 

echo "Docker data cleaning completed successfully!"
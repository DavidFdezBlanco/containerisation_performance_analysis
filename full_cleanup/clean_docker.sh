#!/bin/bash

set -e

if [ $(sudo docker ps -aq) ]; then
    # Stop all running containers
    echo "Stopping all running containers..."
    sudo docker stop $(sudo docker ps -aq)

    # Remove all containers
    echo "Removing all containers..."
    sudo docker rm $(sudo docker ps -aq)
fi

if [ $(sudo docker images -aq) ]; then
    # Remove all images
    echo "Removing all images..."
    sudo docker rmi $(sudo docker images -aq)
fi

if [ $(sudo docker volume ls -q) ]; then
    # Remove all volumes
    echo "Removing all volumes..."
    sudo docker volume rm $(sudo docker volume ls -q)
fi

if [ $(sudo docker volume ls -q) ]; then
    # Remove all networks
    echo "Removing all networks..."
    sudo docker network rm $(sudo docker network ls -q)
fi

# Remove unused sudo docker data
echo "Removing unused sudo docker data..."
sudo docker system prune --all --volumes -f 

echo "sudo docker data cleaning completed successfully!"
#!/bin/bash

set -e

# Stop and delete all LXD containers
echo "Stopping and deleting LXD containers..."
sudo lxc list --format csv -c ns | grep -vE '^$' | cut -d, -f1 | xargs -r -I{} sudo lxc delete {} --force --quiet

# Delete all LXD images
echo "Deleting LXD images..."
sudo lxc image list --format csv -c f | grep -vE '^$' | cut -d, -f1 | xargs -r -I{} sudo lxc image delete {} --force-local --quiet

echo "LXD data cleaning completed successfully!"
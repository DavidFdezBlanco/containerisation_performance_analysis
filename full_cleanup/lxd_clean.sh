#!/bin/bash

set -e

# Stop and delete all LXD containers
echo "Stopping and deleting LXD containers..."
lxc list --format csv -c ns | grep -vE '^$' | cut -d, -f1 | xargs -r -I{} lxc delete {} --force --quiet

# Delete all LXD images
echo "Deleting LXD images..."
lxc image list --format csv -c ns | grep -vE '^$' | cut -d, -f1 | xargs -r -I{} lxc image delete {} --force --quiet

# Delete all LXD storage pools
echo "Deleting LXD storage pools..."
lxc storage list --format csv -c ns | grep -vE '^$' | cut -d, -f1 | xargs -r -I{} lxc storage delete {} --force --quiet

echo "LXD data cleaning completed successfully!"
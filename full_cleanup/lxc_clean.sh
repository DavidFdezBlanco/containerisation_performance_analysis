#!/bin/bash

# Stop and delete all LXC containers
echo "Stopping and deleting LXC containers..."
lxc list --format csv -c ns | grep -E 'RUNNING|FROZEN' | cut -d, -f1 | xargs -r -I{} lxc stop {} --force --quiet
lxc list --format csv -c ns | grep -vE '^NAME$' | cut -d, -f1 | xargs -r -I{} lxc delete {} --force --quiet

# Delete all LXC images
echo "Deleting LXC images..."
lxc image list --format csv -c ns | grep -vE '^ALIAS$' | cut -d, -f1 | xargs -r -I{} lxc image delete {} --force --quiet

# Delete all LXC storage pools
echo "Deleting LXC storage pools..."
lxc storage list --format csv -c ns | grep -vE '^NAME$' | cut -d, -f1 | xargs -r -I{} lxc storage delete {} --force --quiet

echo "LXC data cleaning completed successfully!"
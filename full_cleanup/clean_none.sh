#!/bin/bash

set -e

# Stop and delete all LXD containers
echo "Cleaning tmp folder"
rm /tmp/perf_study/test/none/* -rf
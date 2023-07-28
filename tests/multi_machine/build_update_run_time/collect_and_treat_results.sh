#!/bin/bash

# Arguments
repetitions=$1
output_file=$2
engine=$3
number_cluster=$4

previous_file=$(cat /tmp/perf_study/test/${engine}/results/untreated_${engine}_*_build_update_run_time.txt)

echo -e "$previous_file" >> "$output_file"

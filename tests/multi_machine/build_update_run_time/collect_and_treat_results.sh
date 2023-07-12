#!/bin/bash

# Arguments
repetitions=$1
output_file=$2
engine=$3
number_cluster=$4

previous_file="/tmp/perf_study/test/${engine}/results/untreated_lxd_${node}_build_update_run_time.txt"

cp $previous_file $output_file
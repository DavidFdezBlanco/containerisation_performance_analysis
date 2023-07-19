#!/bin/bash

# Arguments
number_executions=$1
output_file=$2
engine=$3
number_cluster=$4

/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 171
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 172
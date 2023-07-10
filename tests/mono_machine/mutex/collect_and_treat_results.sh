#!/bin/bash

# Arguments
number_executions=$1
output_file=$2
engine=$3

/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 1
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 8
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 16
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 32
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 64
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 128
# /tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 256
# /tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 512
# /tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 1024
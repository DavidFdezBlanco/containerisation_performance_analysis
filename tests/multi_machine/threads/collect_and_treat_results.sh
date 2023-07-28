#!/bin/bash

# Arguments
number_executions=$1
output_file=$2
engine=$3
number_cluster=$4

/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 1 110
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 8 110
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 16 110
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 32 110
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 64 110
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 128 110
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 256 110
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 512 110
#/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 1024 110

/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 1 111
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 8 111
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 16 111
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 32 111
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 64 111
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 128 111
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 256 111
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 512 111
#/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 1024 111
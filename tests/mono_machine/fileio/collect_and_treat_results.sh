#!/bin/bash

# Arguments
number_executions=$1
output_file=$2
engine=$3

/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 seqwr
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 seqrd
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 rndwr
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 rndrd
#!/bin/bash

# Arguments
number_executions=$1
output_file=$2
engine=$3
number_cluster=$4

/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 seqwr 171
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 seqrd 171
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 rndwr 171
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 rndrd 171

/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 seqwr 172
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 seqrd 172
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 rndwr 172
/tmp/perf_study/test/$engine/collect_and_treat_results_each.sh $1 $2 $3 $4 rndrd 172
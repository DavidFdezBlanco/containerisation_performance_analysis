#!/bin/bash
repetitions=$1
number_cluster=$2

/tmp/perf_study/test/lxd/test_each.sh $repetitions fibonacci 110 $2
/tmp/perf_study/test/lxd/test_each.sh $repetitions helloworld 110 $2
#/tmp/perf_study/test/lxd/test_each.sh $repetitions http_server 110 $2

/tmp/perf_study/test/lxd/test_each.sh $repetitions fibonacci 111 $2
/tmp/perf_study/test/lxd/test_each.sh $repetitions helloworld 111 $2
#/tmp/perf_study/test/lxd/test_each.sh $repetitions http_server 111 $2
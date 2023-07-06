#!/bin/bash
repetitions=$1

sudo apt-get update -y
sudo apt-get install -y sysbench

/tmp/perf_study/test/none/test_each.sh $repetitions 1
/tmp/perf_study/test/none/test_each.sh $repetitions 8
/tmp/perf_study/test/none/test_each.sh $repetitions 16
/tmp/perf_study/test/none/test_each.sh $repetitions 32
/tmp/perf_study/test/none/test_each.sh $repetitions 64
/tmp/perf_study/test/none/test_each.sh $repetitions 128
/tmp/perf_study/test/none/test_each.sh $repetitions 256
/tmp/perf_study/test/none/test_each.sh $repetitions 512
/tmp/perf_study/test/none/test_each.sh $repetitions 1024
#!/bin/bash
repetitions=$1

sudo apt-get update -y
sudo apt-get install -y sysbench
sysbench fileio prepare

/tmp/perf_study/test/none/test_each.sh $repetitions seqrd
/tmp/perf_study/test/none/test_each.sh $repetitions rndrd
/tmp/perf_study/test/none/test_each.sh $repetitions seqwr
/tmp/perf_study/test/none/test_each.sh $repetitions rndwr

sysbench fileio cleanup
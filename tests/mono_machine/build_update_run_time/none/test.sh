#!/bin/bash
repetitions=$1

apt-get install -y gcc
/tmp/perf_study/test/none/test_each.sh $repetitions fibonacci
/tmp/perf_study/test/none/test_each.sh $repetitions helloworld
/tmp/perf_study/test/lxd/test_each.sh $repetitions http_server
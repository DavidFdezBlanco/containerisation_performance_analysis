#!/bin/bash
repetitions=$1

/tmp/perf_study/test/docker/test_each.sh $repetitions 110
/tmp/perf_study/test/docker/test_each.sh $repetitions 111
#!/bin/bash
repetitions=$1

/tmp/perf_study/test/docker/test_each.sh $repetitions 1 110
/tmp/perf_study/test/docker/test_each.sh $repetitions 8 110
/tmp/perf_study/test/docker/test_each.sh $repetitions 16 110
/tmp/perf_study/test/docker/test_each.sh $repetitions 32 110
/tmp/perf_study/test/docker/test_each.sh $repetitions 64 110
/tmp/perf_study/test/docker/test_each.sh $repetitions 128 110
/tmp/perf_study/test/docker/test_each.sh $repetitions 256 110
#/tmp/perf_study/test/docker/test_each.sh $repetitions 512 110
#/tmp/perf_study/test/docker/test_each.sh $repetitions 1024 110

/tmp/perf_study/test/docker/test_each.sh $repetitions 1 111
/tmp/perf_study/test/docker/test_each.sh $repetitions 8 111
/tmp/perf_study/test/docker/test_each.sh $repetitions 16 111
/tmp/perf_study/test/docker/test_each.sh $repetitions 32 111
/tmp/perf_study/test/docker/test_each.sh $repetitions 64 111
/tmp/perf_study/test/docker/test_each.sh $repetitions 128 111
/tmp/perf_study/test/docker/test_each.sh $repetitions 256 111
#/tmp/perf_study/test/docker/test_each.sh $repetitions 512 111
#/tmp/perf_study/test/docker/test_each.sh $repetitions 1024 111
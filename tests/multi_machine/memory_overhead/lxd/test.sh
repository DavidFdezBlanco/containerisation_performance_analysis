#!/bin/bash
repetitions=$1

/tmp/perf_study/test/lxd/image_memory.sh

/tmp/perf_study/test/lxd/test_each.sh $repetitions 171
/tmp/perf_study/test/lxd/test_each.sh $repetitions 172

#!/bin/bash
repetitions=$1

#/tmp/perf_study/test/lxd/image_cpu.sh

/tmp/perf_study/test/lxd/test_each.sh $repetitions 110
/tmp/perf_study/test/lxd/test_each.sh $repetitions 111

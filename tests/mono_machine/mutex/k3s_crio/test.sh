#!/bin/bash
repetitions=$1

/tmp/perf_study/test/k3s_crio/test_each.sh $repetitions 1
/tmp/perf_study/test/k3s_crio/test_each.sh $repetitions 8
/tmp/perf_study/test/k3s_crio/test_each.sh $repetitions 16
/tmp/perf_study/test/k3s_crio/test_each.sh $repetitions 32
/tmp/perf_study/test/k3s_crio/test_each.sh $repetitions 64
/tmp/perf_study/test/k3s_crio/test_each.sh $repetitions 128
/tmp/perf_study/test/k3s_crio/test_each.sh $repetitions 256
/tmp/perf_study/test/k3s_crio/test_each.sh $repetitions 512
/tmp/perf_study/test/k3s_crio/test_each.sh $repetitions 1024
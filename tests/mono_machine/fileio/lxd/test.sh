#!/bin/bash
repetitions=$1

/tmp/perf_study/test/lxd/image_fileio.sh

/tmp/perf_study/test/lxd/test_each.sh $repetitions seqwr
/tmp/perf_study/test/lxd/test_each.sh $repetitions seqrd
/tmp/perf_study/test/lxd/test_each.sh $repetitions rndwr
/tmp/perf_study/test/lxd/test_each.sh $repetitions rndrd
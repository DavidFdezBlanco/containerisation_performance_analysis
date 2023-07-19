#!/bin/bash
repetitions=$1

/tmp/perf_study/test/lxd/image_fileio.sh

/tmp/perf_study/test/lxd/test_each.sh $repetitions seqwr 171
/tmp/perf_study/test/lxd/test_each.sh $repetitions seqrd 171
/tmp/perf_study/test/lxd/test_each.sh $repetitions rndwr 171
/tmp/perf_study/test/lxd/test_each.sh $repetitions rndrd 171

/tmp/perf_study/test/lxd/test_each.sh $repetitions seqwr 172
/tmp/perf_study/test/lxd/test_each.sh $repetitions seqrd 172
/tmp/perf_study/test/lxd/test_each.sh $repetitions rndwr 172
/tmp/perf_study/test/lxd/test_each.sh $repetitions rndrd 172
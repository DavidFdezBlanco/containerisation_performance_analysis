#!/bin/bash
repetitions=$1

/tmp/perf_study/test/lxd/image_fileio.sh

/tmp/perf_study/test/lxd/test_each.sh $repetitions seqwr 110
/tmp/perf_study/test/lxd/test_each.sh $repetitions seqrd 110
/tmp/perf_study/test/lxd/test_each.sh $repetitions rndwr 110
/tmp/perf_study/test/lxd/test_each.sh $repetitions rndrd 110

/tmp/perf_study/test/lxd/test_each.sh $repetitions seqwr 111
/tmp/perf_study/test/lxd/test_each.sh $repetitions seqrd 111
/tmp/perf_study/test/lxd/test_each.sh $repetitions rndwr 111
/tmp/perf_study/test/lxd/test_each.sh $repetitions rndrd 111
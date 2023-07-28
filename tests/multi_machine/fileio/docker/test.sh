#!/bin/bash
repetitions=$1

/tmp/perf_study/test/docker/test_each.sh $repetitions seqwr 110
/tmp/perf_study/test/docker/test_each.sh $repetitions seqrd 110
/tmp/perf_study/test/docker/test_each.sh $repetitions rndwr 110
/tmp/perf_study/test/docker/test_each.sh $repetitions rndrd 110

/tmp/perf_study/test/docker/test_each.sh $repetitions seqwr 111
/tmp/perf_study/test/docker/test_each.sh $repetitions seqrd 111
/tmp/perf_study/test/docker/test_each.sh $repetitions rndwr 111
/tmp/perf_study/test/docker/test_each.sh $repetitions rndrd 111
#!/bin/bash

# Arguments
testfiles=$1
output_file=$2
engine=$3


# File initialisation
echo "Initialising result file..."
echo -e "index,Events per Second,Total Time,95th Percentile" > "$output_file"

for ((i=1; i<=$1; i++))
do

    file="/tmp/perf_study/test/$engine/results/untreated_${engine}_cpu_overhead_$i.txt"
    echo "Treating test result file: $file ..."
    events_per_sec=$(grep -oP 'events per second:\s+\K[0-9.]+' "$file")
    total_time=$(grep -oP 'total time:\s+\K[0-9.]+' "$file")
    percentile95=$(grep -oP '95th percentile:\s+\K[0-9.]+' "$file")

    echo "Got: "
    echo "Index: $i"
    echo "Events par sec: $events_per_sec" 
    echo "Total time: $events_per_sec" 
    echo "95th percentile: $percentile95"

    # Writting data in excel file
    echo -e "$i,$events_per_sec,$total_time,$percentile95" >> "$output_file"
    rm $file
done
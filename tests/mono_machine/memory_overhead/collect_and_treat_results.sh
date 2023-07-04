#!/bin/bash

# Arguments
number_executions=$1
output_file=$2
engine=$3

# File initialization
echo "Initializing result file..."
echo -e "index,Total time,Total operations,Operations per second,MiB/sec" > "$output_file"


echo -e "index,Events per Second,Total Time,95th Percentile" > "$output_file"
for ((i = 1; i <= number_executions; i++))
do
    filename="/tmp/perf_study/test/$engine/results/untreated_${engine}_memory_overhead_$i.txt"
    echo "Treating test result file: $filename ..."
    content=$(cat "$filename")

    total_time=$(echo "$content" | grep -oP 'total time:\s+\K[\d.]+' | head -n 1)
    total_operations=$(echo "$content" | grep -oP 'Total operations:\s+\K\d+' | head -n 1)
    operations_per_second=$(echo "$content" | grep -oP 'Total operations:\s+\d+\s+\(\K[\d.]+' | head -n 1)
    mib_per_sec=$(echo "$content" | grep -oP '\K[\d.]+\s+MiB/sec' | head -n 1 | awk '{print $1}')

    echo "Got: "
    echo "Nom fichier: $filename"
    echo "Total time: $total_time"
    echo "Total operations: $total_operations"
    echo "Operations per second: $operations_per_second"
    echo "MiB/sec: $mib_per_sec"

    echo -e "$i,$total_time,$total_operations,$operations_per_second,$mib_per_sec" >> "$output_file"
    rm "$filename"
done
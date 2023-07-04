#!/bin/bash

# Arguments
number_executions=$1
output_file=$2
engine=$3
filetestmode=$4

# File initialization
echo "Initializing result file..."
echo -e "test,index,Throughput read MiB/s,Throughput written MiB/s" >> "$output_file"

for ((i = 1; i <= number_executions; i++))
do
    filename="/tmp/perf_study/test/$engine/results/untreated_${engine}_fileio_${filetestmode}_$i.txt"
    echo "Treating test result file: $filename ..."
    content=$(cat "$filename")

    while IFS= read -r line; do
        if [[ $line == *"read, MiB/s:"* ]]; then
            echo "Found 'read, MiB/s:' in line: $line"
        elif [[ $line == *"written, MiB/s:"* ]]; then
            echo "Found 'written, MiB/s:' in line: $line"
        fi
    done <<< "$content"

    read_throughput=$(echo "$content" | grep -oP 'read, MiB/s:\s+\K[0-9.]+' | head -n 1)
    written_throughput=$(echo "$content" | grep -oP 'written, MiB/s:\s+\K[0-9.]+' | head -n 1)

    echo "Got: "
    echo "Index: $i"
    echo "Throughput read MiB/s: $read_throughput"
    echo "Throughput written MiB/s: $written_throughput"

    echo -e "$filetestmode,$i,$read_throughput,$written_throughput" >> "$output_file"
    rm "$filename"
done
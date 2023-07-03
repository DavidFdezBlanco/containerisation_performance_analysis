#!/bin/bash

# Arguments
number_executions=$1
output_file=$2
engine=$3
number=$4

# File initialization
echo "Initializing result file..."
echo -e "test_number,index,Total time,Total events,Thread fairness total events,Thread fairness exec time" >> "$output_file"

for ((i = 1; i <= number_executions; i++))
do
    filename="/tmp/perf_study/test/$engine/results/untreated_${engine}_threads_${number}_$i.txt"
    echo "Treating test result file: $filename ..."
    content=$(cat "$filename")

    total_time=$(echo "$content" | grep -oP 'total time:\s+\K[0-9.]+' | head -n 1)
    total_events=$(echo "$content" | grep -oP 'total number of events:\s+\K[0-9.]+' | head -n 1)
    thread_fairness_events=$(echo "$content" | grep -oP 'events \(avg/stddev\):\s+\K[0-9.]+' | head -n 1)
    thread_fairness_exec_time=$(echo "$content" | grep -oP 'execution time \(avg/stddev\):\s+\K[0-9.]+' | head -n 1)

    echo "Got: "
    echo "Index: $i"
    echo "total_time: $total_time"
    echo "total_events: $total_events"
    echo "thread_fairness_events: $thread_fairness_events"
    echo "thread_fairness_exec_time: $thread_fairness_exec_time"

    # Ajouter les valeurs extraites à une nouvelle ligne dans le fichier Excel
    echo -e "$number,$i,$total_time,$total_events,$thread_fairness_events,$thread_fairness_exec_time" >> "$output_file"
    rm "$filename"
done
#!/bin/bash

# Nom des fichiers de résultats
result_files=(resultat_cpu{1..26}.txt)

# Nom du fichier Excel de sortie
output_file="resultats_cpu.xlsx"

# Création du fichier Excel avec les titres de colonnes
echo -e "Fichier\tEvents per Second\tTotal Time\t95th Percentile" > "$output_file"

# Parcours de tous les fichiers de résultats
for file in "${result_files[@]}"; do
    # Récupération des données du fichier
    events_per_sec=$(grep -oP 'events per second:\s+\K[0-9.]+' "$file")
    total_time=$(grep -oP 'total time:\s+\K[0-9.]+' "$file")
    percentile95=$(grep -oP '95th percentile:\s+\K[0-9.]+' "$file")

    # Écriture des données dans le fichier Excel
    echo -e "$file\t$events_per_sec\t$total_time\t$percentile95" >> "$output_file"
done

# Alignement des colonnes dans le fichier de sortie
column -t -s $'\t' "$output_file" > temp.txt
mv temp.txt "$output_file"

echo "Terminé ! Les résultats ont été écrits dans le fichier $output_file."

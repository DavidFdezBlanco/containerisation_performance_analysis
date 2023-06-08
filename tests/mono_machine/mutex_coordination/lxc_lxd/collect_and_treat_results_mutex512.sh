#!/bin/bash

# Nom des fichiers de résultats
result_files=(512_mutex*.txt)

# Nom du fichier Excel de sortie
output_file="resultats_mutex512.xlsx"

# Création du fichier Excel avec les titres de colonnes
echo -e "Fichier\tTotal Time\tReads/s\tRead, MiB/s\tTotal Number of Events\tEvents (avg)\tEvents (stddev)\tExecution Time (avg)\tExecution Time (stddev)" > "$output_file"

# Parcours de tous les fichiers de résultats
for file in "${result_files[@]}"; do
    # Récupération des données du fichier
    total_time=$(grep "total time:" "$file" | awk '{print $3}' | sed 's/s$//')
    
    
    # Écriture des données dans le fichier Excel
    echo -e "$file\t$total_time" >> "$output_file"
done

echo "Terminé ! Les résultats ont été écrits dans le fichier $output_file."



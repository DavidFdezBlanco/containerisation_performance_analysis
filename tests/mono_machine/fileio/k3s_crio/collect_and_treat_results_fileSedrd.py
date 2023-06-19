import os
import openpyxl

# Répertoire contenant les fichiers de résultat
result_dir = "./"  # Modifier le répertoire si nécessaire

# Nom du fichier Excel de sortie
output_file = "resultats_seqrd.xlsx"

# Création du fichier Excel avec les titres de colonnes
wb = openpyxl.Workbook()
ws = wb.active
ws.append(["Fichier", "Total Time", "Reads/s", "read, MiB/s", "Total Number of Events", "Events (avg)", "Events (stddev)", "Execution Time (avg)", "Execution Time (stddev)"])

# Liste pour stocker les noms de fichiers pour le tri
file_names = []

# Parcours de tous les fichiers de résultat dans le répertoire
for i in range(1, 31):
    filename = f"seqrd{i}.txt"
    if os.path.isfile(os.path.join(result_dir, filename)):
        file_names.append(filename)

# Tri des noms de fichiers par ordre croissant
file_names.sort()

# Parcours des fichiers triés
for filename in file_names:
    # Lecture du fichier de résultat
    with open(os.path.join(result_dir, filename), "r") as f:
        lines = f.readlines()

        # Extraction des données
        total_time = None
        read_s = None
        read_mib_s = None
        total_events = None
        events_avg = None
        events_stddev = None
        execution_time_avg = None
        execution_time_stddev = None

        for line in lines:
            if "total time:" in line:
                total_time = line.split(":")[1].strip().replace("s", "")
            elif "reads/s:" in line:
                read_s = line.split(":")[1].strip()
            elif "read, MiB/s:" in line:
                read_mib_s = line.split(":")[1].strip()
            elif "total number of events:" in line:
                total_events = line.split(":")[1].strip()
            elif "events (avg/stddev):" in line:
                events_avg, events_stddev = line.split(":")[1].strip().split("/")
            elif "execution time (avg/stddev):" in line:
                execution_time_avg, execution_time_stddev = line.split(":")[1].strip().split("/")

            # Sortir de la boucle si toutes les données ont été trouvées
            if total_time and read_s and read_mib_s and total_events and events_avg and events_stddev and execution_time_avg and execution_time_stddev:
                break

        # Écriture des données dans le fichier Excel
        ws.append([filename, total_time, read_s, read_mib_s, total_events, events_avg, events_stddev, execution_time_avg, execution_time_stddev])

# Sauvegarde du fichier Excel
wb.save(output_file)

print(f"Terminé ! Les résultats ont été écrits dans le fichier {output_file}.")

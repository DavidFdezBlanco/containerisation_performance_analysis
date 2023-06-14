import os
import re
import openpyxl

# Créer un nouveau fichier Excel et ajouter une ligne d'en-tête
xlsx_file = "resultatsMemory.xlsx"
wb = openpyxl.Workbook()
ws = wb.active
ws.append(["Nom fichier", "Total time", "Total operations", "Operations per second", "MiB/sec"])

# Parcourir tous les fichiers .txt dans le répertoire en cours
for i in range(1, 30):
    filename = f"memory{i}.txt"
    with open(filename, "r") as f:
        content = f.read()
        # Extraire les valeurs à l'aide d'expressions régulières
        total_time_match = re.search(r"total time:\s+([\d.]+)s", content)
        if total_time_match is not None:
            total_time = float(total_time_match.group(1))
        else:
            total_time = None
        total_operations_match = re.search(r"Total operations:\s+(\d+)", content)
        if total_operations_match is not None:
            total_operations = int(total_operations_match.group(1))
        else:
            total_operations = None
        operations_per_second_match = re.search(r"Total operations:\s+\d+\s+\(([\d.]+)", content)
        if operations_per_second_match is not None:
            operations_per_second = float(operations_per_second_match.group(1))
        else:
            operations_per_second = None
        mib_per_sec_match = re.search(r"([\d.]+)\s+MiB/sec", content)
        if mib_per_sec_match is not None:
            mib_per_sec = float(mib_per_sec_match.group(1))
        else:
            mib_per_sec = None
        # Ajouter les valeurs extraites à une nouvelle ligne dans le fichier Excel
        ws.append([filename, total_time, total_operations, operations_per_second, mib_per_sec])

# Enregistrer le fichier Excel
wb.save(xlsx_file)

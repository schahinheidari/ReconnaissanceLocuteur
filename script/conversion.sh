#!/bin/bash

# Déplacement dans le dossier du fichier files.tsv
cd ../I322/DATA

# Création du dossier pour les fichiers après conversion
echo "Création des dossiers pour les fichiers .raw..."
mkdir RAW_DATA_TEST
mkdir RAW_DATA_DEV

# Fait la conversion des .mp3 en .raw et les déplace dans le dossier DATA
echo "Conversion des fichiers en .raw en cours... (peut prendre un moment)"

# Récupération des fichiers avec accent suisse
awk -F '\t' '$8=="switzerland"{system("sox -v 0.9 -r 48000 -c 1 -b 8 clips/"$2".mp3" " " "RAW_DATA_DEV/"$2".raw")}' files.tsv

# Déplacement dans le dossier des fichiers .raw de dev
cd RAW_DATA_DEV

# Nombre de fichiers avec accent suisse
nbFichierSuisse=($( ls | wc -l))

# Récupération des fichiers avec accents belge et français pour en avoir le même
# nombre que de suisse
awk -F '\t' '$8=="belgium"{system("sox -v 0.9 -r 48000 -c 1 -b 16 ../clips/"$2".mp3" " " "../RAW_DATA_DEV/"$2".raw"); cpt++; if(cpt==84){exit}}' ../files.tsv
awk -F '\t' '$8=="france"{system("sox -v 0.9 -r 48000 -c 1 -b 16 ../clips/"$2".mp3" " " "../RAW_DATA_DEV/"$2".raw"); cpt++; if(cpt==84){exit}}' ../files.tsv

# Récupère le nombre de fichier pour pouvoir séparer le test du dev
nbFichier=($(ls | wc -l))
nbTest=$(( $nbFichier*30/100 ))

# Déplacement de 30% des fichier dans RAW_DATA_TEST 
cpt=0
for file in *;
do
    if [ "$cpt" -gt "$nbTest" ]; then break; fi
    mv "$file" ../RAW_DATA_TEST
    cpt=$((cpt+1))
done
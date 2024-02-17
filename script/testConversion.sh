#!/bin/bash

# Déplacement dans le dossier du fichier files.tsv
cd ../I322/DATA

# Création du dossier pour les fichiers après conversion
echo "Création des dossiers pour les fichiers .raw..."
mkdir RAW_DATA_TEST
mkdir RAW_DATA_DEV

# Fait la conversion des .mp3 en .raw et les déplace dans le dossier DATA
echo "Conversion des fichiers en cours... (peut prendre un moment)"

# Récupère le nombre de fichier dans files.tsv pour pouvoir séparer le test du dev
nbFichier=($(wc -l < files.tsv))
nbTest=$(( $nbFichier*70/100 ))

# Boucle en fonction du nombre de fichier dans files.tsv
# Change le dossier de destination après 70% du nombre de fichier pour séparer le test du dev
cpt=0
while read line
do
    echo $cpt
    if [ $cpt -lt $nbTest ]; then
        sox -v 0.9 "clips/"$line".mp3" "RAW_DATA_TEST/"$line".raw"
    else
        sox -v 0.9 "clips/"$line".mp3" "RAW_DATA_DEV/"$line".raw"
    fi
    let cpt++
done < <(awk '{print $2}' files.tsv | sed '1d')

echo "Fin de la conversion."


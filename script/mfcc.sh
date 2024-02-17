#!/bin/bash

echo "Création des MFCC..."

if test -f "codetr.scp"; then
    rm codetr.scp
fi
touch codetr.scp

# Ecriture des fichiers pour le passage à HCopy
find ../I322/DATA/RAW_DATA_DEV/ -type f -name "*.raw" -printf "%f\n" | while read f
do
    echo $f "${f%%.*}.mfc" >> codetr.scp
done

# Déplacement dans le dossier contenant les fichiers d'apprentissage
cd ../I322/DATA/RAW_DATA_DEV

# Codage avec HCopy
./../../HTK/HTKTools/HCopy -C ../../../miniprojet_sys_de_reco/config -S ../../../miniprojet_sys_de_reco/codetr.scp


# Même opération pour les fichiers de test
cd ../../../miniprojet_sys_de_reco

if test -f "codetest.scp"; then
    rm codetest.scp
fi
touch codetest.scp

# Ecriture des fichiers pour le passage à HCopy
find ../I322/DATA/RAW_DATA_TEST/ -type f -name "*.raw" -printf "%f\n" | while read f
do
    echo $f "${f%%.*}.mfc" >> codetest.scp
done

# Déplacement dans le dossier contenant les fichiers d'apprentissage
cd ../I322/DATA/RAW_DATA_TEST

# Codage avec HCopy
./../../HTK/HTKTools/HCopy -C ../../../miniprojet_sys_de_reco/config -S ../../../miniprojet_sys_de_reco/codetest.scp

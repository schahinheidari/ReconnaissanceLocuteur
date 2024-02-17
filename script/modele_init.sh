# Liste des fichiers .mfcc de train dans un fichier pour la suite
if test -f "train.scp"; then
    rm train.scp
fi
touch train.scp

find ../I322/DATA/RAW_DATA_DEV/ -type f -name "*.mfc" -printf "%f\n" | while read f
do
    echo $f >> train.scp
done

# Même opération pour les fichiers .mfcc pour le test
if test -f "test.scp"; then
    rm test.scp
fi
touch test.scp

find ../I322/DATA/RAW_DATA_TEST/ -type f -name "*.mfc" -printf "%f\n" | while read f
do
    echo $f >> test.scp
done



# Génération du fichier MLF des fichiers train
echo "Génération des fichier .MLF en cours... (peut prendre un moment)"

if test -f "mlf.mmf"; then
    rm mlf.mmf
fi
touch mlf.mmf

echo "#!MLF!#" >> mlf.mmf
find ../I322/DATA/RAW_DATA_DEV/ -type f -printf "%f\n" | while read f
do
    echo "\"${f%%.*}.lab\"" >> mlf.mmf
    awk -v nomFichier="${f%%.*}" -F '\t' '$2==nomFichier{system("echo "$8" >> mlf.mmf");}' ../I322/DATA/files.tsv
    echo "." >> mlf.mmf
done



# Génération du fichier MLF des fichiers test
if test -f "mlf_test.mmf"; then
    rm mlf_test.mmf
fi
touch mlf_test.mmf

echo "#!MLF!#" >> mlf_test.mmf
find ../I322/DATA/RAW_DATA_TEST/ -type f -printf "%f\n" | while read f
do
    echo "\"${f%%.*}.lab\"" >> mlf_test.mmf
    awk -v nomFichier="${f%%.*}" -F '\t' '$2==nomFichier{system("echo "$8" >> mlf_test.mmf");}' ../I322/DATA/files.tsv
    echo "." >> mlf_test.mmf
done



# Déplacement dans le dossier contenant les fichiers d'apprentissage
cd ../I322/DATA/RAW_DATA_DEV

mkdir ../HMM0


# Estimation du modèle initial avec HCompV 
echo "Estimation du modèle initial..."

./../../HTK/HTKTools/HCompV -C ../../../miniprojet_sys_de_reco/config -f 0.01 -I ../../../miniprojet_sys_de_reco/mlf.mmf -m -S ../../../miniprojet_sys_de_reco/train.scp -M ../HMM0 ../../../miniprojet_sys_de_reco/proto


# Création des fichier macros et hmmdefs
cd ../HMM0

if test -f "macros"; then
    rm macros
fi
touch macros

echo '~o <MFCC_0> <VecSize> 13' >> macros
cat vFloors >> macros


if test -f "hmmdefs"; then
    rm hmmdefs
fi
touch hmmdefs

echo '~h "france"' >> hmmdefs
tail --lines=+5 proto >> hmmdefs

echo '~h "switzerland"' >> hmmdefs
tail --lines=+5 proto >> hmmdefs

echo '~h "belgium"' >> hmmdefs
tail --lines=+5 proto >> hmmdefs
echo "Phase de reconnaissance..."

# Déplacement dans le dossier HMM
cd ../I322/DATA/RAW_DATA_TEST

# Génération du wdnet
./../../HTK/HTKTools/HParse ../../../miniprojet_sys_de_reco/grammaire ../HMM/wdnet.slf

# Phase de reconnaissance avec HVite
./../../HTK/HTKTools/HVite -C ../../../miniprojet_sys_de_reco/config -H ../HMM/hmmdefs -i ../../../miniprojet_sys_de_reco/recout.mlf -S ../../../miniprojet_sys_de_reco/test.scp -w ../HMM/wdnet.slf ../../../miniprojet_sys_de_reco/lexique ../../../miniprojet_sys_de_reco/monophones0
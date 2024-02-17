# Déplacement dans le dossier contenant le modèle initial
cd ../I322/DATA/RAW_DATA_DEV

# Estimation des paramètres des modèles avec HERest 
echo "Estimation des paramètres des modèles..."

mkdir ../HMM
./../../HTK/HTKTools/HERest -C ../../../miniprojet_sys_de_reco/config -I ../../../miniprojet_sys_de_reco/mlf.mmf -t 250.0 150.0 1000.0 -H ../HMM0/macros -H ../HMM0/hmmdefs -S ../../../miniprojet_sys_de_reco/train.scp -M ../HMM ../../../miniprojet_sys_de_reco/monophones0


for i in {0..2}
do
    ./../../HTK/HTKTools/HERest -C ../../../miniprojet_sys_de_reco/config -I ../../../miniprojet_sys_de_reco/mlf.mmf -t 250.0 150.0 1000.0 -H ../HMM/macros -H ../HMM/hmmdefs -S ../../../miniprojet_sys_de_reco/train.scp -M ../HMM ../../../miniprojet_sys_de_reco/monophones0
done

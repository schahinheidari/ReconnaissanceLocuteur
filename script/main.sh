#!/bin/bash

# Conversion des .mp3 en .raw dans les dossiers de test et de dev
./conversion.sh

# Création des MFCC
./mfcc.sh

# Définition de la structure des modèles
./modele_init.sh

# Estimation des paramètres des modèles
./estimation_modeles.sh

# Phase de reconnaissance
./reconnaissance.sh

# Evaluation
./resultats.sh
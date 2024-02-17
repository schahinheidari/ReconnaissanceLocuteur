# ReconnaissanceLocuteur
Mise en place d'un système de reconnaissance d'accents dans des fichiers audio


Préparation:

    - Le dossier du projet et le dossier I322 contenant DATA et HTK doivent être au même niveau dans l'arborescence.
    - Chaque script .sh du projet doit avoir les droits d'exécution


Pour démarrer le projet, lancez la commande "./main.sh" qui démarre un script main.sh contenant les appels des scripts du projet.

### Contexte du Projet
Le projet est structuré en plusieurs phases, y compris l'apprentissage, le développement, la
mise au point des paramètres et l'évaluation finale. Nous effectuerons des tests sur des corpus
indépendants pour mesurer la précision de notre système. Si nécessaire, nous utiliserons une
validation croisée pour augmenter la robustesse de nos résultats.
Le projet de reconnaissance vocale a été entrepris pour répondre à la demande croissante de
systèmes automatisés capables de transcrire des fichiers audio en texte. Cette technologie
trouve des applications dans divers domaines tels que la transcription d'enregistrements, la
commande vocale, etc.
Dans l'ensemble, ce mini-projet offre une opportunité passionnante d'appliquer des concepts
théoriques à des problèmes du monde réel dans le domaine de la reconnaissance vocale. Nous
espérons que notre travail contribuera à la compréhension et à l'amélioration des systèmes de
reconnaissance vocale pour des applications diverses et variées.
Pour atteindre cet objectif, nous travaillerons avec un ensemble de données provenant du projet
open-source Common Voice de Mozilla, qui comprend des fichiers audio représentant une
diversité de locuteurs et de contextes linguistiques. Notre travail impliquera la manipulation de
données audio, l'extraction de caractéristiques pertinentes, la modélisation statistique et la mise
en œuvre d'un système de reconnaissance.
### Objectifs
Les objectifs principaux du projet étaient les suivants :
- Développer un système de reconnaissance vocale fonctionnel.
- Atteindre une précision élevée dans la conversion des fichiers audio en transcriptions
textuelles.
- Explorer les différentes étapes du processus, de la conversion initiale à l'évaluation des
résultats.

## Guide
extraction des données avec awk (homme/femme)
MP3 -> RAW avec sox -v pour réduire volume des données , -r taux d'echantillonage  , -c nbre de canaux , -b nbre bits par echantillon
HCopy génération des fichiers mfc (MFCC -> 13 coef cepstraux) avec fichier de config. (séparation apprentissage et test 70/30)
HCompv permet de faire une premiere estimation des parametres de notre modèle -> -I fichier mlf (Master label file) contenant les labels pour chaque MFCC, -C fichier de config , -S fichier qui indique les MFCC pour l'apprentissage, -H hmm de départ (GMM à un seul état) , -M répertoire pour la sortie , fichier du nom du hmm (proto)
création de la HMMListe -> vfloors va dans le fichier macros (variances générées par HCompv) , création des HMM (hmmdefs) générés par HCompv pour les hommes et les femmes
HErest apprentissage de notre modèle -> initialisation avec le fichier de config, -H macros généré avec HCompv, -H hmmdefs généré avec HCompv, -S fichier qui indique les MFCC pour l'apprentissage, -I fichier mlf (Master label file) contenant les labels pour chaque MFCC, -t seuil de fonctionnement , monophones0 les labels (male/female), -M répertoire pour la sortie
-> ensuite 2 autres itérations en prenant cette fois-ci le fichier hmmdef généré avec HErest juste avant et en ne prenant pas le fichier macros.
HVite sert à faire une prédiction des données de test -> -C fichier de config, -H hmmdefs généré par HErest, -i fichier de sortie de la prédiction .mlf, -S fichier qui indique les MFCC pour le test, -w réseau de traitement de la grammaire avec un fichier auto généré par HParse sur grammaire.txt, lexique.txt mot que le modèle doit prédire, monophones0 le dictionnaire.
HEresult donne le taux de précision des prédictions à un référentiel -> -I labels de référence, hmmdefs modèle final, fichier contenant les prédictions. 80%

## verification que mfcc est bon:

  $soxy <fichier.mp3> => récupération des metadonnées (fréquence, taille)
nb vecteur attendu:
  durée: taille fichier RAW/(fréquence d'echantillonage*nombre d'octet de codage)
  nb_vecteur_theorique: durée(en ms)/echantillonage cible (pour les vecteurs)
  taille_total: nb_vecteur_theorique * nb_coeff_cepstraux * nb_octet_codage = taille fichier raw

confirmation:
  nb_vecteur_reel: (taille fichier raw - entête) / nb_coeff_cepstraux * nb_octet_codage
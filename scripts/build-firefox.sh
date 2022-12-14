#!/bin/bash

if [ ! command -v web-ext &> /dev/null ]
then
    echo "web-ext n'est pas installé. Veuillez l'installer avec la commande suivante :"
    echo "  $ npm install -g web-ext"
    exit
fi

if [ -f "./build/firefox.zip" ]
then
  echo "Suppression de l'ancien fichier ZIP pour Mozilla Firefox"
  rm -rf ./build/firefox.zip
fi

echo "Création du fichier ZIP pour Mozilla Firefox"

# Copying to random tmp directory
uuid=$(uuidgen)
mkdir ./scripts/tmp/$uuid

# Building to tmp directory
cd app
yarn build --outDir=../scripts/tmp/$uuid
cd ..

# Removing Manifest V3
rm ./scripts/tmp/$uuid/manifest.json
# Renaming Manifest V2
mv ./scripts/tmp/$uuid/manifest.v2.json ./scripts/tmp/$uuid/manifest.json

# Building ZIP file
web-ext build --source-dir=./scripts/tmp/$uuid --artifacts-dir=./build --filename=firefox.zip
# Cleaning tmp directory
rm -rf ./scripts/tmp/$uuid

echo "Terminé !"
#!/bin/bash

if [ -f "./build/firefox.zip" ]
then
  echo "Suppression de l'ancien fichier ZIP pour Mozilla Firefox"
  rm -rf ./build/firefox.zip
fi

echo "Création du fichier ZIP pour Mozilla Firefox"

# Copying to random tmp directory
uuid=$(uuidgen)
cp -r ./source ./tmp/$uuid

# Removing Manifest V3
rm ./tmp/$uuid/manifest.json
# Renaming Manifest V2
mv ./tmp/$uuid/manifest.v2.json ./tmp/$uuid/manifest.json

# Building ZIP file
web-ext build --source-dir=./tmp/$uuid --artifacts-dir=./build --filename=firefox.zip
# Cleaning tmp directory
rm -rf ./tmp/$uuid

echo "Terminé !"
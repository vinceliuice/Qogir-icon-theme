#!/bin/bash

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.local/share/icons"
fi

cp -r dist/ $DEST_DIR/Qogir-cursors
cp -r dist-Dark/ $DEST_DIR/Qogir-white-cursors
cp -r dist-Ubuntu/ $DEST_DIR/Qogir-Ubuntu-cursors
cp -r dist-Ubuntu-Dark/ $DEST_DIR/Qogir-Ubuntu-white-cursors
cp -r dist-Manjaro/ $DEST_DIR/Qogir-Manjaro-cursors
cp -r dist-Manjaro-Dark/ $DEST_DIR/Qogir-Manjaro-white-cursors

echo "Finished..."


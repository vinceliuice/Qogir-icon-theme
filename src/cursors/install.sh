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
cp -r dist/ $DEST_DIR/Qogir-elementary-cursors
cp -r dist-dark/ $DEST_DIR/Qogir-white-cursors
cp -r dist-dark/ $DEST_DIR/Qogir-elementary-white-cursors
cp -r dist-ubuntu/ $DEST_DIR/Qogir-ubuntu-cursors
cp -r dist-ubuntu-dark/ $DEST_DIR/Qogir-ubuntu-white-cursors
cp -r dist-manjaro/ $DEST_DIR/Qogir-manjaro-cursors
cp -r dist-manjaro-dark/ $DEST_DIR/Qogir-manjaro-white-cursors

echo "Finished..."


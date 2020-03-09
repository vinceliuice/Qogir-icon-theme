#!/bin/bash

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.local/share/icons"
fi

if [ -d "$DEST_DIR/Qogir-cursors" ]; then
  rm -rf "$DEST_DIR/Qogir-cursors"
fi

if [ -d "$DEST_DIR/Qogir-white-cursors" ]; then
  rm -rf "$DEST_DIR/Qogir-white-cursors"
fi

cp -r dist/ $DEST_DIR/Qogir-cursors
cp -r dist-dark/ $DEST_DIR/Qogir-white-cursors

echo "Finished..."


#!/bin/bash

function create {
	cd "$SRC"
	mkdir -p x1 x1_25 x1_5 x2

	cd "$SRC"/$1
	find . -name "*.svg" -type f -exec sh -c 'inkscape -z -e "../x1/${0%.svg}.png" -w 32 -h 32 $0' {} \;
	find . -name "*.svg" -type f -exec sh -c 'inkscape -z -e "../x1_25/${0%.svg}.png" -w 40 -w 40 $0' {} \;
	find . -name "*.svg" -type f -exec sh -c 'inkscape -z -e "../x1_5/${0%.svg}.png" -w 48 -w 48 $0' {} \;
	find . -name "*.svg" -type f -exec sh -c 'inkscape -z -e "../x2/${0%.svg}.png" -w 64 -w 64 $0' {} \;

	cd "$SRC"

	OUTPUT="$BUILD"/cursors
	ALIASES="$SRC"/cursorList

	if [ ! -d "$BUILD" ]; then
		mkdir "$BUILD"
	fi
	if [ ! -d "$OUTPUT" ]; then
		mkdir "$OUTPUT"
	fi

	echo -ne "Generating cursor theme...\\r"
	for CUR in config/*.cursor; do
		BASENAME="$CUR"
		BASENAME="${BASENAME##*/}"
		BASENAME="${BASENAME%.*}"
		
		xcursorgen "$CUR" "$OUTPUT/$BASENAME"
	done
	echo -e "Generating cursor theme... DONE"

	cd "$OUTPUT"

	#generate aliases
	echo -ne "Generating shortcuts...\\r"
	while read ALIAS; do
		FROM="${ALIAS#* }"
		TO="${ALIAS% *}"

		if [ -e $TO ]; then
			continue
		fi
		ln -sr "$FROM" "$TO"
	done < "$ALIASES"
	echo -e "Generating shortcuts... DONE"

	cd "$PWD"

	echo -ne "Generating Theme Index...\\r"
	INDEX="$OUTPUT/../index.theme"
	if [ ! -e "$OUTPUT/../$INDEX" ]; then
		touch "$INDEX"
		echo -e "[Icon Theme]\nName=$THEME\n" > "$INDEX"
	fi
	echo -e "Generating Theme Index... DONE"
}

# generate pixmaps from svg source
SRC=$PWD/src

cd "$SRC"
rm -rf elementary ubuntu manjaro ubuntu-white manjaro-white
cp -r svg elementary
cp -r svg ubuntu
cp -r svg manjaro
cp -r svg-white elementary-white
cp -r svg-white ubuntu-white
cp -r svg-white manjaro-white
cd "$SRC"/ubuntu && sed -i "s/#5294e2/#fb8441/g" `ls`
cd "$SRC"/manjaro && sed -i "s/#5294e2/#2eb398/g" `ls`
cd "$SRC"/ubuntu-white && sed -i "s/#5294e2/#fb8441/g" `ls`
cd "$SRC"/manjaro-white && sed -i "s/#5294e2/#2eb398/g" `ls`

THEME="Qogir Cursors"
BUILD="$SRC/../dist"
create svg

THEME="Qogir-white Cursors"
BUILD="$SRC/../dist-dark"
create svg-white

THEME="Qogir-elementary Cursors"
BUILD="$SRC/../dist-elementary"
create elementary

THEME="Qogir-elementary-white Cursors"
BUILD="$SRC/../dist-elementary-dark"
create elementary-white

THEME="Qogir-ubuntu Cursors"
BUILD="$SRC/../dist-ubuntu"
create ubuntu

THEME="Qogir-ubuntu-white Cursors"
BUILD="$SRC/../dist-ubuntu-dark"
create ubuntu-white

THEME="Qogir-manjaro Cursors"
BUILD="$SRC/../dist-manjaro"
create manjaro

THEME="Qogir-manjaro-white Cursors"
BUILD="$SRC/../dist-manjaro-dark"
create manjaro-white

cd "$SRC"
rm -rf elementary ubuntu manjaro elementary-white ubuntu-white manjaro-white x1 x1_25 x1_5 x2

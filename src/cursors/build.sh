#!/bin/bash

function create {
	cd "$SRC"
	mkdir -p 24x24 32x32 48x48 64x64 72x72 96x96

	cd "$SRC"/$1
	find . -name "*.svg" -type f -exec sh -c 'inkscape -o "../24x24/${0%.svg}.png" -w 24 -h 24 $0' {} \;
	find . -name "*.svg" -type f -exec sh -c 'inkscape -o "../32x32/${0%.svg}.png" -w 32 -h 32 $0' {} \;
	find . -name "*.svg" -type f -exec sh -c 'inkscape -o "../48x48/${0%.svg}.png" -w 48 -w 48 $0' {} \;
	find . -name "*.svg" -type f -exec sh -c 'inkscape -o "../64x64/${0%.svg}.png" -w 64 -w 64 $0' {} \;
	find . -name "*.svg" -type f -exec sh -c 'inkscape -o "../72x72/${0%.svg}.png" -w 72 -w 72 $0' {} \;
	find . -name "*.svg" -type f -exec sh -c 'inkscape -o "../96x96/${0%.svg}.png" -w 96 -w 96 $0' {} \;

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

SRC="$PWD/src"

rm -rf "$SRC"/{svg-Ubuntu,svg-Manjaro,svg-Ubuntu-Dark,svg-Manjaro-Dark}
cp -r "$SRC"/svg "$SRC"/svg-Ubuntu
cp -r "$SRC"/svg "$SRC"/svg-Manjaro
cp -r "$SRC"/svg-Dark "$SRC"/svg-Ubuntu-Dark
cp -r "$SRC"/svg-Dark "$SRC"/svg-Manjaro-Dark
sed -i "s/#5294e2/#fb8441/g" "$SRC"/svg-Ubuntu/*.svg
sed -i "s/#5294e2/#2eb398/g" "$SRC"/svg-Manjaro/*.svg
sed -i "s/#5294e2/#fb8441/g" "$SRC"/svg-Ubuntu-Dark/*.svg
sed -i "s/#5294e2/#2eb398/g" "$SRC"/svg-Manjaro-Dark/*.svg

THEME="Qogir Cursors"
BUILD="$SRC/../dist"
create svg

THEME="Qogir-white Cursors"
BUILD="$SRC/../dist-Dark"
create svg-Dark

THEME="Qogir-ubuntu Cursors"
BUILD="$SRC/../dist-Ubuntu"
create Ubuntu

THEME="Qogir-ubuntu-white Cursors"
BUILD="$SRC/../dist-Ubuntu-Dark"
create Ubuntu-Dark

THEME="Qogir-manjaro Cursors"
BUILD="$SRC/../dist-Manjaro"
create Manjaro

THEME="Qogir-manjaro-white Cursors"
BUILD="$SRC/../dist-Manjaro-Dark"
create Manjaro-Dark

#cd "$SRC"
#rm -rf ubuntu manjaro ubuntu-white manjaro-white 24x24 32x32 48x48 64x64 72x72 96x96

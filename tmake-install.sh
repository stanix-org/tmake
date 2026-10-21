#!/bin/sh

TMAKE_VERSION="0.1.0"

tmake_install_file () {
	if grep -r "include \$(TMAKE_DIR)/$1" > /dev/null; then
		echo "installing $1 ..."
		cat "$PROLOGUE" "$TMAKE_SRC/$1" >> "make/$1"
	fi
}

tmake_generate_prologue () {
	PROLOGUE="${TMPDIR:="/tmp"}/$$.prologue"
	echo "# this file comes from tmake $TMAKE_VERSION
# see https://github.com/stanix-org/tmake for latest version
" > "$PROLOGUE"
}

THIS="$(realpath "$0")"
TMAKE_SRC="$(dirname "$THIS")/make"

echo "tmake src is $TMAKE_SRC"

if test -n "$1" ; then
	cd "$1" || exit 1
fi

tmake_generate_prologue

# reset tmake dir
mkdir -p "make"
rm -f make/tmake-*.mk

# install tmake files
# keep this in dependencies order
for FILE in \
	"tmake-init.mk" \
	"tmake-version.mk" \
	"tmake-prog.mk" \
	"tmake-lib.mk" \
	"tmake-locale.mk" \
	"tmake-incs.mk" \
	"tmake-files.mk" \
	"tmake-subdir.mk" \
	"tmake-compile.mk" \
; do
	tmake_install_file "$FILE"
done

rm "$PROLOGUE"

#!/bin/sh
# Thierry Laronde <tlaronde@polynum.com>
#
# Generating files used at building time but needing tools not
# necessarily present on MATRIX. (For example, running tex(1) for
# webmerging).
#

: ${TMPDIR:=/tmp}

# It has to be run at the root of our sources.
#
test -s conf/KERTEX_T\
	|| { echo "You must run me from KERTEX_T root dir!" >&2; exit 1; }

( cd tex/bin1; sh ../../tools/webmerge_tex.sh; )
( cd mf/bin1; sh ../../tools/webmerge_mf.sh; )
( cd mp/bin1; sh ../../tools/webmerge_mp.sh; )
( cd etex/bin1; sh ../../tools/webmerge_etex.sh; )
( cd prote/bin1; sh ../../tools/webmerge_prote.sh; )
( cd texware/bin1/bibtex; sh ../../../tools/webmerge_bibtex.sh; )

version=$(sed -n 's/^VERSION:[ 	]*\([0-9.][0-9.]*\)[ 	]*$/\1/p' CID)

rm -f kertex_T_$version.tar.gz

git archive --prefix=kertex_T/ -o kertex_T_$version.tar main

mkdir -p "$TMPDIR/$$/kertex_T" || {
	echo "Unable to create '$TMPDIR/$$/kertex_T'" >&2
	exit 1
}

tar -cf - tex/bin1/webmerged*.ch \
	mf/bin1/webmerged*.ch \
	mp/bin1/webmerged*.ch \
	etex/bin1/webmerged*.ch \
	prote/bin1/webmerged*.ch \
	texware/bin1/bibtex/webmerged*.ch \
	| ( cd "$TMPDIR/$$/kertex_T" && tar -xf - )

hic="$PWD"
( cd "$TMPDIR/$$" && tar -rf "$hic/kertex_T_$version.tar" kertex_T )

rm -fr "$TMPDIR/$$/"

gzip kertex_T_$version.tar

# Creating the pkgtools.zip.
#
tools/mk_pkgtools_zip


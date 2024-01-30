#!/bin/sh
# Thierry Laronde <tlaronde@polynum.com>
#
# Generating files used at building time but needing tools not
# necessarily present on MATRIX. (For example, running tex(1) for
# webmerging).
#

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

# Creating the pkgtools.zip.
#
tools/mk_pkgtools_zip


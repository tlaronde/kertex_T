#!/bin/sh
# C) 2012 Thierry Laronde <tlaronde@polynum.com>
#
# Must be run in texware/bin1/bibtex.
#
# Invoking webmerge for the concatenation of the change files for the
# kerTeX distribution.
# This is not done at generation time, since it uses a running tex(1).
#
# We use the name webmerged* for the result, tex.ch being the system
# change file, and the remaining being tuning for variants (BIG, TRIP).
#
unset KERTEXINPUTS # be sure to take system canonical paths

BIBTEX_SRC_DIR=/data/src/bibtex

test -f bibtex.h || { echo "Not in texware/bin1/bibtex dir!" >&2; exit 1; }

# This first is for "symetry": useless since only comment removing...
#
echo "Generating webmerged.ch for the vanilla variant" >&2

rm -f webmerged.ch

cat <<EOT | tex
\input webmerge
\webfile{$BIBTEX_SRC_DIR/bibtex.web}    % master web file
\changefile{kertex.ch}                  % 1. system change file
\outfile{webmerged.ch}                  % output file, start processing
EOT
rm texput.log tmp.tmp

echo "Generating webmergedBIG.ch" >&2

rm webmergedBIG.ch

cat <<EOT | tex
\input webmerge
\webfile{$BIBTEX_SRC_DIR/bibtex.web}    % master web file
\changefile{kertex.ch}                  % 1. system change file
\changefile{BIG.ch}                     % 2. Increasing capacities
\outfile{webmergedBIG.ch}               % output file, start processing
EOT
rm texput.log tmp.tmp

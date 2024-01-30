#!/bin/sh
# C) 2011 Thierry Laronde <tlaronde@polynum.com>
#
# Must be run in tex/bin1.
#
# Invoking webmerge for the concatenation of the change files for the
# kerTeX distribution.
# This is not done at generation time, since it uses a running tex(1).
#
# We use the name webmerged* for the result, tex.ch being the system
# change file, and the remaining being tuning for variants (BIG, TRIP).
#
#
unset KERTEXINPUTS # be sure to take system canonical paths

KNUTH_SRC_DIR=/data/src/knuth

test -d initex || { echo "Not in tex/bin1 dir!" >&2; exit 1; }

# This first is for "symetry": useless since only comment removing...
#
echo "Generating webmerged.ch for the vanilla variant" >&2

rm -f webmerged.ch

cat <<EOT | tex
\input webmerge
\webfile{$KNUTH_SRC_DIR/tex/tex.web}    % master web file
\changefile{filename.ch}                % 1. bug fix
\changefile{batchmode.ch}               % 2. adding a newline
\changefile{kertex_common.ch}           % 3. system change file
\changefile{kertex.ch}                  % 4. TeX local adjustements
\outfile{webmerged.ch}                  % output file, start processing
EOT
rm texput.log tmp.tmp

echo "Generating webmergedBIG.ch" >&2

rm -f webmergedBIG.ch

cat <<EOT | tex
\input webmerge
\webfile{$KNUTH_SRC_DIR/tex/tex.web}    % master web file
\changefile{filename.ch}                % 1. bug fix
\changefile{batchmode.ch}               % 2. adding a newline
\changefile{kertex_common.ch}           % 3. system change file
\changefile{kertex.ch}                  % 4. TeX local adjustements
\changefile{BIG.ch}                     % 5. Increasing capacities
\outfile{webmergedBIG.ch}               % output file, start processing
EOT
rm texput.log tmp.tmp

echo "Generating webmergedTRIP.ch" >&2

rm -f webmergedTRIP.ch

cat <<EOT | tex
\input webmerge
\webfile{$KNUTH_SRC_DIR/tex/tex.web}    % master web file
\changefile{filename.ch}                % 1. bug fix
\changefile{kertex_common.ch}           % 2. system change file
\changefile{kertex.ch}                  % 3. TeX local adjustements
\changefile{TRIP.ch}                    % 4. Torture test
\outfile{webmergedTRIP.ch}              % output file, start processing
EOT
rm texput.log tmp.tmp

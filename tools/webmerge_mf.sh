#!/bin/sh
# C) 2011, 2021 Thierry Laronde <tlaronde@polynum.com>
#
# Must be run in mf/bin1.
#
# Invoking webmerge for the concatenation of the change files for the
# kerTeX distribution.
# This is not done at generation time, since it uses a running tex(1).
#
# We use the name webmerged* for the result, mf.ch being the system
# change file, and the remaining being tuning for variants (BIG, TRAP).
#
unset KERTEXINPUTS # be sure to take system canonical paths

KNUTH_SRC_DIR=/data/src/knuth

test -d inimf || { echo "Not in mf/bin1 dir!" >&2; exit 1; }

# This first is for "symetry": useless since only comment removing...
#
echo "Generating webmerged.ch for the vanilla variant" >&2

rm -f webmerged.ch

cat <<EOT | tex
\input webmerge
\webfile{$KNUTH_SRC_DIR/mf/mf.web}    % master web file
\changefile{filename.ch}              % 0. bug fix 
\changefile{kertex.ch}                % 1. system change file
\changefile{ogo.ch}                   % 2. 2D routines
\outfile{webmerged.ch}                % output file, start processing
EOT
rm texput.log tmp.tmp

cat <<EOT | tex
\input webmerge
\webfile{$KNUTH_SRC_DIR/mf/mf.web}    % master web file
\changefile{filename.ch}              % 0. bug fix 
\changefile{kertex.ch}                % 1. system change file
\outfile{webmergedIni.ch}                % output file, start processing
EOT
rm texput.log tmp.tmp

echo "Generating webmergedBIG.ch" >&2

rm -f webmergedBIG.ch

cat <<EOT | tex
\input webmerge
\webfile{$KNUTH_SRC_DIR/mf/mf.web}    % master web file
\changefile{filename.ch}              % 0. bug fix 
\changefile{kertex.ch}                % 1. system change file
\changefile{BIG.ch}                   % 2. Increasing capacities
\changefile{ogo.ch}                   % 3. 2D routines
\outfile{webmergedBIG.ch}             % output file, start processing
EOT
rm texput.log tmp.tmp

cat <<EOT | tex
\input webmerge
\webfile{$KNUTH_SRC_DIR/mf/mf.web}    % master web file
\changefile{filename.ch}              % 0. bug fix 
\changefile{kertex.ch}                % 1. system change file
\changefile{BIG.ch}                   % 3. Increasing capacities
\outfile{webmergedIniBIG.ch}             % output file, start processing
EOT
rm texput.log tmp.tmp

echo "Generating webmergedTRAP.ch" >&2

rm -f webmergedTRAP.ch

cat <<EOT | tex
\input webmerge
\webfile{$KNUTH_SRC_DIR/mf/mf.web}    % master web file
\changefile{filename.ch}              % 0. bug fix 
\changefile{kertex.ch}                % 1. system change file
\changefile{TRAP.ch}                  % 2. Torture test
\outfile{webmergedTRAP.ch}            % output file, start processing
EOT
rm texput.log tmp.tmp

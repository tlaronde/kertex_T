#!/bin/sh
# C) 2011, 2021 Thierry Laronde <tlaronde@polynum.com>
#
# Must be run in mp/bin1.
#
# Invoking webmerge for the concatenation of the change files for the
# kerTeX distribution.
# This is not done at generation time, since it uses a running tex(1).
#
# We use the name webmerged* for the result, mp.ch being the system
# change file, and the remaining being tuning for variants (BIG, TWIST).
#
#
unset KERTEXINPUTS # be sure to take system canonical paths

test -d inimp || { echo "Not in mp/bin1 dir!" >&2; exit 1; }

# This first is for "symetry": useless since only comment removing...
#
echo "Generating webmerged.ch for the vanilla variant" >&2

rm -f webmerged.ch

cat <<EOT | tex
\input webmerge
\webfile{mp.web}                      % master web file
\changefile{filename.ch}              % 0. bug fix 
\changefile{kertex.ch}                % 1. system change file
\outfile{webmerged.ch}                % output file, start processing
EOT
rm texput.log tmp.tmp

echo "Generating webmergedBIG.ch" >&2

rm -f webmergedBIG.ch

cat <<EOT | tex
\input webmerge
\webfile{mp.web}                      % master web file
\changefile{filename.ch}              % 0. bug fix 
\changefile{kertex.ch}                % 1. system change file
\changefile{BIG.ch}                   % 2. Increasing capacities
\outfile{webmergedBIG.ch}             % output file, start processing
EOT
rm texput.log tmp.tmp

echo "Generating webmergedHUGE.ch" >&2

rm -f webmergedHUGE.ch

cat <<EOT | tex
\input webmerge
\webfile{mp.web}                      % master web file
\changefile{filename.ch}              % 0. bug fix 
\changefile{kertex.ch}                % 1. system change file
\changefile{HUGE.ch}                   % 2. Increasing capacities
\outfile{webmergedHUGE.ch}             % output file, start processing
EOT
rm texput.log tmp.tmp

echo "Generating webmergedTWIST.ch" >&2

rm -f webmergedTWIST.ch

cat <<EOT | tex
\input webmerge
\webfile{mp.web}                      % master web file
\changefile{filename.ch}              % 0. bug fix 
\changefile{kertex.ch}                % 1. system change file
\changefile{TWIST.ch}                 % 2. Torture test
\outfile{webmergedTWIST.ch}           % output file, start processing
EOT
rm texput.log tmp.tmp

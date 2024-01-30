#!/bin/sh
# C) 2011, 2021 Thierry Laronde <tlaronde@polynum.com>
#
# Must be run in etex/bin1.
#
# Invoking webmerge for the concatenation of the change files for the
# kerTeX distribution.
# This is not done at generation time, since it uses a running tex(1).
#
# We use the name webmerged* for the result, etex.ch being the master
# original file bringing another TeX, and the remaining being system
# adjustements or tuning for variants (BIG, ETRIP).
#
#
unset KERTEXINPUTS # be sure to take system canonical paths

KNUTH_SRC_DIR=/data/src/knuth
ETEX_SRC_DIR=/data/src/etex

test -d einitex || { echo "Not in etex/bin1 dir!" >&2; exit 1; }

echo "Generating webmerged.ch for the vanilla variant" >&2

rm -f webmerged.ch

cat <<EOT | etex
\input webmerge
\webfile{$KNUTH_SRC_DIR/tex/tex.web}    % master web file
\changefile{../../tex/bin1/filename.ch} % 1. bug fix
\changefile{../../tex/bin1/batchmode.ch}% 2. adding a newline
\changefile{$ETEX_SRC_DIR/etex.ch}      % 3. etex master change file
\changefile{../../tex/bin1/kertex_common.ch}   % 4. TeX system dependent
\changefile{kertex.ch}                  % 5. e-TeX system dependent
\outfile{webmerged.ch}                  % output file, start processing
EOT
rm texput.log tmp.tmp

echo "Generating webmergedBIG.ch" >&2

rm -f webmergedBIG.ch

cat <<EOT | etex
\input webmerge
\webfile{$KNUTH_SRC_DIR/tex/tex.web}    % master web file
\changefile{../../tex/bin1/filename.ch} % 1. bug fix
\changefile{../../tex/bin1/batchmode.ch}% 2. adding a newline
\changefile{$ETEX_SRC_DIR/etex.ch}      % 3. etex master change file
\changefile{../../tex/bin1/kertex_common.ch}   % 4. TeX system dependent
\changefile{../../tex/bin1/BIG.ch}      % 5. Increasing capacities
\changefile{kertex.ch}                  % 6. e-TeX system dependent change file
\outfile{webmergedBIG.ch}               % output file, start processing
EOT
rm texput.log tmp.tmp

echo "Generating webmergedETRIP.ch" >&2

rm -f webmergedETRIP.ch

cat <<EOT | etex
\input webmerge
\webfile{$KNUTH_SRC_DIR/tex/tex.web}    % web file
\changefile{../../tex/bin1/filename.ch} % 1. bug fix
\changefile{$ETEX_SRC_DIR/etex.ch}      % 2. etex master change file
\changefile{../../tex/bin1/kertex_common.ch}   % 3. TeX system dependent
\changefile{../../tex/bin1/TRIP.ch}     % 4. TRIP compatible
\changefile{ETRIP.ch}                   % 5. ETRIP adjustments
\changefile{kertex.ch}                  % 6. e-TeX system dependent
\outfile{webmergedETRIP.ch}             % output file, start processing
EOT
rm texput.log tmp.tmp

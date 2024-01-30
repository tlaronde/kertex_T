#!/bin/sh
# C) 2021 Thierry Laronde <tlaronde@polynum.com>
#
# Must be run in prote/bin1.
#
# Invoking webmerge for the concatenation of the change files for the
# kerTeX distribution.
# This is not done at generation time, since it uses a running tex(1).
#
# We use the name webmerged* for the result, etex.ch being the master
# original file bringing another TeX, and the remaining being system
# adjustements or tuning for variants (BIG, SELLETTE).
#
#
unset KERTEXINPUTS # be sure to take system canonical paths

KNUTH_SRC_DIR=/data/src/knuth
ETEX_SRC_DIR=/data/src/etex

test -f prote.ch || { echo "Not in prote/bin1 dir!" >&2; exit 1; }

echo "Generating webmerged.ch for the vanilla variant" >&2

rm -f webmerged.ch

cat <<EOT | etex
\input webmerge
\webfile{$KNUTH_SRC_DIR/tex/tex.web}    % master web file
\changefile{../../tex/bin1/filename.ch} % 1. bug fix
\changefile{../../tex/bin1/batchmode.ch}% 2. adding a newline
\changefile{$ETEX_SRC_DIR/etex.ch}      % 3. etex master change file
\changefile{prote.ch}                   % 4. ProtE additions
\changefile{../../tex/bin1/kertex_common.ch}   % 5. system dependent TeX
\changefile{input.ch}                   % 6. filename handling
\changefile{kertex.ch}                  % 7. system dependent Prote
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
\changefile{prote.ch}                   % 4. Prote additions
\changefile{../../tex/bin1/kertex_common.ch}   % 5. system dependent TeX
\changefile{kertex.ch}                  % 6. system dependent Prote
\changefile{input.ch}                   % 7. filename handling
\changefile{../../tex/bin1/BIG.ch}      % 8. Increasing capacities
\outfile{webmergedBIG.ch}               % output file, start processing
EOT
rm texput.log tmp.tmp

echo "Generating webmergedSELLETTE.ch" >&2

rm -f webmergedSELLETTE.ch

cat <<EOT | etex
\input webmerge
\webfile{$KNUTH_SRC_DIR/tex/tex.web}    % web file
\changefile{../../tex/bin1/filename.ch} % 1. bug fix
\changefile{$ETEX_SRC_DIR/etex.ch}      % 2. etex master change file
\changefile{prote.ch}                   % 3. Prote additions
\changefile{../../tex/bin1/kertex_common.ch}   % 4. system dependent TeX
\changefile{kertex.ch}                  % 5. system dependent Prote
\changefile{../../tex/bin1/TRIP.ch}     % 6. TRIP compatible
\changefile{SELLETTE.ch}                % 7. SELLETTE adjustments for Prote
\outfile{webmergedSELLETTE.ch}             % output file, start processing
EOT
rm texput.log tmp.tmp

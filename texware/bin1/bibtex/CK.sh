#!/bin/sh
# Checking the installation of Oren Patashnik's BibTeX in kerTeX.
#
# C 2011 Thierry Laronde <tlaronde@polynum.com>
# 

: ${TMPDIR:=/tmp}
: ${KERTEXBIN:=/usr/pkg/bin/kertex}


echo "Extracting the sample plain TeX test file" >&2
junk="$(command -v $0)"
ed -s $junk <<EOT
/^##BEGINTEX/+,/^##ENDTEX/-w $TMPDIR/ckbibtex.tex
q
EOT

cd $TMPDIR
echo "Processing the sample" >&2
$KERTEXBIN/tex ckbibtex
$KERTEXBIN/bibtex ckbibtex
$KERTEXBIN/tex ckbibtex
$KERTEXBIN/tex ckbibtex

exit
# The data is embedded here since processing has stopped above.
##BEGINTEX
\input btxmac
Donald E. Knuth's work in progress~\cite{inbook-crossref} is still a
reference.
\medskip
\leftline{\bf References}
\bibliography{xampl}
\bibliographystyle{plain}
\bye
##ENDTEX

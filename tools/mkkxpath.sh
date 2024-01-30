#!/bin/sh
# Make a KXPATH file in a root dir (for alien files).
# C) 2013 Thierry LARONDE <tlaronde@polynum.com>
#
# All rights reserved and no warranty! Use at your own risk!
# Tous droits r�serv�s et aucune garantie ! Utilisez � vos risques et
# p�rils !
#
set -eux

# Refuse to create if already existing.
#
test ! -f KXPATH || { printf "KXPATH already existing!" >&2; exit 1; }

find . -type d -printx >KXPATH

ed KXPATH<<"EOT"
g/^\.\//s//
g/$/s//;/
1i
;
.
1,$j
w
q
EOT

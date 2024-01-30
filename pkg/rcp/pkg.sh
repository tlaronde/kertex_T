#
# This is a pseudo package to download all the "recipes" (this
# very kind of type of Bourne shell chunk) available (to download all
# the packages meaning here, only, all the instructions to build the
# packages).
#
# C) 2020
#	Thierry Laronde <tlaronde@polynum.com>
# KerTeX Public Licence version 1.0.
# Use at your own risks! Absolutely no warranty!
#

# Needed post action (build, apply, remove) routines.
#
pkg_post_build()
{
	return 0 # From spec, the compound list can not be empty.
}

pkg_post_apply()
{
	pkg_log
	pkg_log "All the recipes have been downloaded in:"
	pkg_log "$KERTEX_LIBDIR/pkg/rcp/"
	pkg_log 
}

pkg_post_remove()
{
	return 0 # From spec, the compound list can not be empty.
}

#==================== AUTOMATIC PROCESSING
# First include the pecularities of the TeX kernel system host.
#
. which_kertex >&2

# Then we now how to find the library that defines routines and does
# some checks, argument processing and initializations. See the file
# directly for explanations.
#
. $KERTEX_BINDIR/lib/pkglib.sh

#==================== CUSTOM PROCESSING: we are in TMPDIR
#
#
pkg_get

#===== CUSTOM PROCESSING FINISHED
#
# Time to do whether the build or the install.
#
pkg_do_action

# not reached
exit 0

# Since we have exited above, no need to comment out the CID.

BEGIN_CID
NAME: pkg/rcp
VERSION: 2024-01-14
KERTEX_VERSION: 0.99.22.0
SOURCES:
http://downloads.kergis.com/kertex/pkg/
	LCD HOME/
	GET rcp/ /[^.]\.sh$/
END:
END_CID

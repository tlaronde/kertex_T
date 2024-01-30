#
# This is a pseudo package to update the PKG framework, that is
# to download up to date versions of pkglib.sh and sys.sh and to
# install them, interpolating the customized chunk in sys.sh from the
# existing version.
#
# So we are using are own facilities to update part of the system...
#
# Another version is used to verify that incorect settings do fail.
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
	pkg_log "Up to date pkg framework installed."
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

# This is special: to be able to update we in fact unzip at TMPDIR,
# and only specially process lib.sh.
#
$PKG_UNZIP pkgtools.zip

# Comparing the versions: if what we downloaded is a previous or the
# same, we stop here.
#
echo "$PKG_LIB_VERSION" | $PKG_SED 's/\./ /g' >"$TMPDIR"/.version
read hmaj hmin hrev <"$TMPDIR"/.version

$PKG_SED -n 's/^PKG_LIB_VERSION=\([0-9.][0-9.]*\).*$/\1/p' lib.sh\
	| $PKG_SED 's/\./ /g' >"$TMPDIR"/.version
read dmaj dmin drev <"$TMPDIR"/.version

pkg_log "Present version: $hmaj $hmin $hrev; downloaded: $dmaj $dmin $drev"

{ test "$dmaj" -gt "$hmaj" \
	|| { test "$dmaj" -eq "$hmaj" && test "$dmin" -gt "$hmin"; } \
	|| { test "$dmaj" -eq "$hmaj" && test "$dmin" -eq "$hmin" \
		&& test "$drev" -gt "$hrev"; } \
	} || {
	pkg_log "Pkg tools are up to date compared to downloaded version!"
	pkg_clean_tmp
	exit 0
}

# pkglib.sh is already in place. We just need to interpolate the
# customized chunk, taken from the local version of the sys.sh
# file.
#
$PKG_SED -n '/^##BEGIN_SYS_CUSTOMIZED/,/^##END_SYS_CUSTOMIZED/p' \
	$KERTEX_BINDIR/lib/sys.sh >.customized

ed $KERTEX_HOST_TYPE.data <<EOT
/^##BEGIN_SYS_CUSTOMIZED/,/^##END_SYS_CUSTOMIZED/d
0r .customized
w
q
EOT

mkdir $TMPDIR/bin/lib
mv lib.sh $TMPDIR/bin/lib/pkglib.sh
mv $KERTEX_HOST_TYPE.data $TMPDIR/bin/lib/sys.sh

#===== CUSTOM PROCESSING FINISHED
#
# Time to do whether the build or the install.
#
pkg_do_action

# not reached
exit 0

# Since we have exited above, no need to comment out the CID.

BEGIN_CID
NAME: pkg/tools
VERSION: 2024-01-14
KERTEX_VERSION: 0.99.22.0
SOURCES:
http://downloads.kergis.com/kertex/pkg/src/
	GET pkgtools.zip
END:
END_CID

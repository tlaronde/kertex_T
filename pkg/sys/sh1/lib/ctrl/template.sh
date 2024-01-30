#
# This is a strictly POSIX 1003.2 shell (Bourne shell) script but
# using only a very limited subset of POSIX.2 utilities with
# defined system dependent additions, to be used for the addition of
# data to the kerTeX TeX kernel system: to create a package.
#
# No shebang, since there is a bootstrapping problem: this script has
# to run on whatever host the kerTeX system runs on.
# It has to be invoked with whatever Bourne shell like interpreter is
# present on the host.
#
# This script is used to control the implementation, exercing mainly
# the downloading of the sources and it has to succeed.
#
# Another version is used to verify that incorect settings do fail.
#
# C) 2020
#	Thierry Laronde <tlaronde@polynum.com>
# All rights reserved and absolutely no warranty! Use at your own 
# risks.
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
	pkg_log "The control succeeded."
	pkg_log 
}

pkg_post_remove()
{
	return 0 # From spec, the compound list can not be empty.
}

#==================== AUTOMATIC PROCESSING
# First include the pecularities of the TeX kernel system host.
#
. which_kertex

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
NAME: pkg/tools
VERSION: 2020-10-18
KERTEX_VERSION: 0.99.7.0
KXPATH:
	pkg tools
NOTES:
	SOURCES, SOURCES_FTP and SOURCES_HTTP shall obtain the same files
	in differing ways. SOURCES is set here to file://.
	For testing purposes, set a ftpd on your localhost (in
	/etc/inetd.conf; /etc/ftpd.conf); set a httpd on your localhost
	(/etc/rc.conf and /usr/pkg/etc/httpd/httpd.conf for example), and 
	make the two servers serve a local copy of the data.

	When building a new package:
	- Try the -p ftp download to obtain the data; then move the sources
		somewhere locally so that, after, you can test the pkg with
		local sources (file:// protocol);
	- Try the -x show action to obtain the downloading commands, with
		regexp explanation for SOURCES_HTTP.

	When controling:
	- Change the protocol and the http and ftp clients on the different
	KERTEX_HOST_TYPE systems.
SOURCES:
file:///data/m/src/kertex_T/
# one file in TMPDIR/lib/pkg specified as relative to HOME (lib/pkg/tools/)
	LCD HOME/..
	GET /pkg/sh1/tools/pkg.sh
# a dir with regexp in TMPDIR
 	LCD /
	GET ../../sys/sh1/lib/ /^.*\.data$/
# a file changing dir in "remote", and then getting another file in
# the same remote dir, creating TMPDIR/1.
	LCD 1
	GET /tex/bin1/virtex/Makefile.ker
	GET extra.c
SOURCES_FTP:
ftp://localhost/kertex_T/
# one file in TMPDIR/lib/pkg specified as relative to HOME (lib/pkg/tools/)
	LCD HOME/..
	GET /pkg/sh1/tools/pkg.sh
# a dir with regexp in TMPDIR
 	LCD /
	GET ../../sys/sh1/lib/ /^.*\.data$/
# a file changing dir in "remote", and then getting another file in
# the same remote dir, creating TMPDIR/1.
	LCD 1
	GET /tex/bin1/virtex/Makefile.ker
	GET extra.c
SOURCES_HTTP:
http://localhost/kertex_T/
# one file in TMPDIR/lib/pkg specified as relative to HOME (lib/pkg/tools/)
	LCD HOME/..
	GET /pkg/sh1/tools/pkg.sh
# a dir with regexp in TMPDIR
 	LCD /
	GET ../../sys/sh1/lib/ /^.*\.data$/
# a file changing dir in "remote", and then getting another file in
# the same remote dir, creating TMPDIR/1.
	LCD 1
	GET /tex/bin1/virtex/Makefile.ker
	GET extra.c
SOURCES_X_TEMPLATE:
http://localhost/kertex_T/
	LCD HOME/..
	GET /pkg/sh1/tools/pkg.sh 
	LCD /
	GET /pkg/sys/sh1/lib/plan9.data
	GET unix.data
	LCD 1
	GET /tex/bin1/virtex/Makefile.ker 
	GET extra.c 
END:
END_CID

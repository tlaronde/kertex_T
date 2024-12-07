# The library of pkg sh routines.
#
# C) 2011--2014, 2016--2017, 2019--2020, 2022, 2024
#	Thierry Laronde <tlaronde@polynum.com>
#
# All right reserved and no warranties: use at your own risks!

#===== CUSTOMIZABLE
#
: ${TMPDIR:=${PREFIX:-}/tmp} # PREFIX is for Android/termux
: ${KERTEX_PKG_SRC_SRV:=http://mirrors.ctan.org/}
: ${KERTEX_PKG_RCP_DIR:=$KERTEX_LIBDIR/pkg/rcp}

#===== NOTHING TO CHANGE BELOW!
#
PKG_LIB_VERSION=0.99.14

set -e

usage="

$(basename $0) [-h|help] [-V] [-acdf] \\
	[
	status
	| [-x] show [dependencies]
	| download [dir]
	| build
	| install
	| apply [pkg]
	| remove
	]

	if no action is specified, does show.

	flags:
		-a	Add (install) automatically missing
			dependencies.
		-c	use the Cache on kergis.com for src srv
			(http://downloads.kergis.com/kertex/pkg/src/)
		-d	Debug (tracing).
		-f	Force using KERTEX_PKG_SRC_SRV whatever the
			package may set as URL
        	-h	Display this usage and exit.
		-V	display pkglib Version and exit.

	action:
        	help
			Display this usage and exit.
		status
			Return 0 if installed; 1 if not.
		show [dependencies]
			print the CID or the dependencies (if option
			specified), of the package on stdout.
			If -x is specified, show instead the
			'eXplicated' list of files (no
			wildcards i.e.  regexp) to download, or, for
			dependencies, show the nickname of the
			dependencies.
		download [dest_dir]
			De dicto: downloads the pkg sources in a way reflecting
			the hierarchy on the server and then stops. This is
			a developer feature. The sources are downloaded
			in the specified dest_dir or '\$TMPDIR/src/'
			if not specified.
		build
			build the pkg from sources and create the tarball
			in \$TMPDIR (defaults to: '\$PREFIX/tmp').
		install
			build the pkg from sources and locally install, removing
			previous installed version if it exists.
		apply [pkg]
			install the pkg tarball. If pkg is not
			specified, the canonical name is looked in
			the working directory.
		remove
			remove the installed package.

	Caveats:
		Works in a subdir of TMPDIR used as is if set, or defaulting to
		\$PREFIX/tmp (\$PREFIX is for Android/termux) if not. This 
		temporary space must have room enough for the building to proceed.

"
	
#===== THIS LIBRARY
#
# This library has the routines for returning status, showing, building
# and installing and has to be dot'ted by pkg_* scripts.
#
# It does some mandatory steps and provide means for the customized
# process.
#
# A typical pkg_myname.sh script does this:
#
#	. which_kertex
#	. "$KERTEX_BINDIR"/lib/pkglib.sh
#
# So these are ne varietur from now on (defined by sourcing
# which_kertex).
#
readonly KERTEX_VERSION KERTEX_HOST KERTEX_SHELL KERTEX_BINDIR
readonly KERTEX_LIBDIR KERTEX_MANDIR USER0 GROUP0

# Safety: before storing (creating/deleting) starts, the TMPDIR shall
# not be created, but the general pkg_error() routine calls 
# pkg_clean_tmp(). That shall only kill an on-purpose created by us
# TMPDIR (the "root" i.e. starting definition of TMPDIR is saved in
# a readonly variable: _tmpdirroot. We use indeed a readonly copy of 
# the defined for us TMPDIR: _tmpdir in order to be safe if the package
# does something unexpected with the definition of TMPDIR. If 
# _tmpdir is not set, or null or doesn't exist, pkg_clean_tmp()
# does nothing. Be sure it does something only when OK:
#
_tmpdirroot="$TMPDIR" # has been set to default above
readonly _tmpdirroot
unset _tmpdir || true # unset should not fail but some sh do

# Some actions (status, show, apply and remove) do not need further 
# processing (except calling pkg provided pkg_post_*() routines); but
# the remaining of the script will not be executed.
#
# In case of: "build" or "install", after the library handling,
# processing will continue with the packager code.
#
# This library has not only definitions of routines, but also some
# default actions performed at inclusion:
#	1) Stop if root on host where this notion exists if it is not
#	getting status, showing, removing or applying.
#	2) Check if the var are defined or stop.
#	3) Save initial PWD since relative path in environment depend on
#		that.
#	4) Set TMPDIR to a non existent directory to allow the routines to
#	 	work (if they need to write) and to allow to clean a freshly
#	 	specially created hierarchy.
#		TMPDIR is sketched with the	mandatory bin/, lib/ and---later---
#		lib/$PKG_NAME/.
#	5) Save initial launch values : PKG_FQ_SCRIPT.
#	6) Check that we are a hosted system: KERTEX_BINLIB and KERTEX_LIBDIR
#		are dedicated subdirectories where we can make write or rm 
#		blunders...
#	7) Get the arguments.
#	8) Set PKG_CID, PKG_NAME, PKG_NICKNAME,
#
# After doing the action, the tmp directory is removed. Before, for
# build, a packager pkg_post_build() routine is run (may be empty); for
# install and apply, pkg_post_apply() is run (install is a short cut
# for building then applying).
#
#===== NAMESPACE
#
# The '_' prefix is reserved, as well as "pkg", "PKG", "sys" and "SYS".
# Furthermore, a filename or dirname with a leading dot '.' is reserved
# for this library and shall not be used in custom sections of a pkg
# script.
#
#===== PORTABILITY
#
# The system dependent chunks as known for the systems supported till
# now are tagged with SYSTEM DEPENDENT. To port to a new system, 
# these have probably to be observed first. But the whole has to be
# scrutinized. 
#
# The most system dependant is the url retriever since it is not
# specified by POSIX.2 and varies from system to system. Other
# variations are for some routines: listing, removing an empty dir,
# unzipping.
#
#
# Utilities to be used by packagers are prefixed: "pkg_". The "_pkg"
# are subroutines called by higher level routines and should not be
# used by packagers in normal work.
#
# All variables in CAPITALS are reserved and must be used for their
# purpose. Packager can use at will lower case ones (except '_' prefixed
# as stated above.
#
# The SYSTEM DEPENDENT routines are interpolated in this file by
# dot'ing the system dependent chunk.
#
# When "porting", just create the ad hoc SYSTEM DEPENDENT chunk. What
# needs to be set is explained after. (We need PKG_SED early, to it is
# dot'ed here.)
#
. $KERTEX_BINDIR/lib/sys.sh

# Tokenizing.
# We have to accept that a host has whites in filenames (this includes
# dirnames). But this is acceptable only for the host part, not for 
# kerTeX proper: kerTeX shall NOT have whites in filenames. As long
# as a pkg deals inside the kerTeX hierarchy, it has not to be defeated
# by whites.
#
unset IFS || true # set to default sp, ht and nl.

_pkg_nb_token()
{
	echo $# # this relies on IFS; obviously called without quoting.
}

_pkg_get_opt()
{
	junk=${1#-}
	test "${junk:-}" || pkg_error "Incorrect flag. $usage"
	while test "${junk:-}"; do
		case "$(echo $junk | sed 's/^\(.\).*$/\1/')" in
			a) PKG_ADD_MISSING_DEPENDENCIES=YES;;
			c) KERTEX_PKG_SRC_SRV="http://downloads.kergis.com/kertex/pkg/src/";;
			d) set -x; PKG_DEBUG=YES;;
			f) PKG_FORCE_SRC_SRV=YES;;
			h) echo "$usage"; pkg_clean_tmp; exit 0;;
			x) PKG_X_SPEC=YES;;
			V) echo $PKG_LIB_VERSION; pkg_clean_tmp; exit 0;;
			*) pkg_error "Incorrect flag. $usage";;
		esac
		junk=${junk#?}
	done
}

#========== THE PKG FRAMEWORK
#
# PKG: DEFINITION.
#
# A pkg is identified by its pathname recording its identity and part
# of its dependencies. All components of the dirnames begin by a lower
# case letter and have only lower case letters, digits or underscore ('_').
#
# The pkg name is primilarily a mandatory directory in the kerTeX lib
# hierarchy. Say package mistex depends on format i-tex. The directory
# KERTEX_LIBDIR/itex/mistex/ will exist. In this pkgdir, one file is
# mandatory: the CID, that stands for Carte d'IDentit\'e in french, but
# also Criminal Investigation Departement to identify who is responsible
# for this $@###??!!!!!
#
# If installed, the pathname exists with a CID.
#
# call: pkg_name
# end: 0 if installed; 1 if not.
# caveats: returned value must be tested if "-e" is set.
#
pkg_is_installed()
{
	test $# -eq 1 && test "x$1" != x\
		|| pkg_error "pkg_is_installed called without a pkgname argument."
	if test -s "$KERTEX_LIBDIR"/$1/CID; then
		return 0
	else
		return 1
	fi
}

# The CID has records delimited by first a label alone on a line:
#	^[A-Z][A-Z0-9_]+:
# the content being the next lines until the next such identifier.
#
# To ease the parsing, an ending tag is appended to the file:
#
#	END:
#
# Sections:
# KXPATH: root pathspec
#	will add/remove to/from $KERTEX_LIBDIR/$root/KXPATH the pathspec.
#	In order to be able to share a pkg between distinct root instances,
#	if root does not exist, it is created.
#
# DVIPS: block
#	will add/remove block to/from $KERTEX_LIBDIR/dvips/dvips.cnf 
#	(mainly used for font maps).
#
# PKG_CID varies: we need the values to set PKG_NAME before creating
# dir hierarchy and moving the file. PKG_CID is set with correct
# pathname for the step.
#
_pkg_x_cid()
{
	ed "$PKG_FQ_SCRIPT" <<EOT >$PKG_NULL_FILE 2>&1
/^BEGIN_CID/+,/^END_CID/-w $PKG_CID
q
EOT
	if test ! -s "$PKG_CID" \
		|| test "x$($PKG_SED -n '$p' $PKG_CID)" != "xEND:"; then 
		pkg_error "Incorrect CID!"
	fi
}

# All packages have at least one dependency: on the TeX
# kernel. So the system is considered the root, and all packages install
# exclusively under the lib and bin areas of kerTeX.
#
# But packages that do not depend on something else than the TeX kernel
# are for the packaging purposes root ones. They have then a KXPATH
# (perhaps empty).
#
# call: a pkg name
# end: 0 if root pkg; 1 if not.
# caveats: returned value must be tested if "-e" is set.
#
pkg_is_root()
{
	test $# -eq 1 && test "x$1" != x\
			|| pkg_error "pkg_is_root called without a pkgname argument."

	if test "x$(echo $1| $PKG_SED -n 's!/[^/]*$!!p')" = x; then
		return 0
	else
		return 1
	fi
}

# The dependencies have to be satisfied for building and installing. Not
# for other actions. Hence the routines are test ones and a return 
# value not 0 is not a failure.
#
# The list shall include the main dependency and the direct
# sub-depedencies.
#
# call: nothing (uses PKG_NAME)
# doesn't return something but $TMPDIR/.dependencies is set.
#
pkg_dependencies_get()
{
	# First the main dependencies.
	echo $PKG_NAME | $PKG_SED -n 's!/[^/]*$!!p' >$TMPDIR/.tmp1
	pkg_get_rec DEPENDENCIES >>$TMPDIR/.tmp1
	echo -n "" >$TMPDIR/.tmp2
	while read junkn; do
		case $junkn in
			fonts|mf|mp|tex|pkg/core) junkn="pkg/core";;
			pkg|pkg/*) continue;;
			*) ;;
		esac
		junkn=$(pkg_setck_nickname $junkn)
		test -f "$KERTEX_PKG_RCP_DIR/$junkn.sh"\
			|| pkg_error "Missing dependency rcp '$junkn.sh'"
		$KERTEX_SHELL $KERTEX_PKG_RCP_DIR/$junkn.sh \
			show dependencies 2>$PKG_NULL_FILE >>$TMPDIR/.tmp2
	done <$TMPDIR/.tmp1
	junkp=
	cat $TMPDIR/.tmp1 $TMPDIR/.tmp2 | sort | while read junkn; do
		if test "$junkn" = "$PKG_NAME"; then
			pkg_error "Circular dependency detected!"
		fi
		if test "$junkn" != "$junkp"; then
			echo $junkn
			junkp=$junkn
		fi
	done >$TMPDIR/.dependencies
}

# Verify that dependencies are installed.
#
# call: nothing (uses PKG_NAME)
# end: 0 if dependencies installed; 1 if not.
# caveats: returned value must be tested if "-e" is set.
#
pkg_dependencies_are_installed()
{
	junk=0
	while read junkn; do
		if pkg_is_installed $junkn; then
			pkg_log "$junkn: FOUND."
		else
			pkg_log "$junkn: NOT FOUND."
			junk=1
		fi
	done <$TMPDIR/.dependencies

	return $junk
}

# The dependencies have to be satisfied for building and installing. If
# instructed to do so, missing dependencies can be installed.
#
# call: nothing (uses PKG_NAME)
# end: 0 if dependencies installed; 1 if not.
# caveats: returned value must be tested if "-e" is set.
#
pkg_dependencies_install_missing()
{
	junk=0	 
	while read junkn; do
		if pkg_is_installed $junkn; then
			continue
		else
			pkg_log "$junkn: NOT FOUND. Installing..."
			(
				junkn=$(pkg_setck_nickname $junkn)
				export KERTEX_PKG_SRC_SRV
				flags="-a"
				test $PKG_DEBUG != "YES"\
					|| flags="${flags}d"
				test $PKG_FORCE_SRC_SRV != "YES"\
					|| flags="${flags}f"
				$KERTEX_SHELL "$KERTEX_PKG_RCP_DIR"/$junkn.sh $flags install
			) || junk=1
			if test $junk -eq 1; then
				pkg_log "Failed to install dependency '$junkn'!"
				return $junk
			fi
		fi
	done <$TMPDIR/.dependencies

	return $junk
}

# One can show dependencies, by their pathname hierarchical name
# or by their nickname.
#
# call: nothing (uses PKG_NAME)
# end: 0 if dependencies installed; 1 if not.
# caveats: pkg_dependencies_get() has to be called before using this.
#
pkg_dependencies_show()
{
	while read junk; do
		if test $PKG_X_SPEC = "YES"; then
			junk=$(pkg_setck_nickname $junk)
		fi
		echo $junk
	done <$TMPDIR/.dependencies
}

# Since a pathname can not be used as part of a name of a file (cmd),
# when dealing with pkg programs the '/' is replaced by a '@' and the
# order is reversed: itex/mistex -> mistex@itex. The pkgname is the
# pathname; the transcription above being just a transcription.
#
# call: the canonical pathname like
# echoes the rcp nickname (without the suffix ".sh")
#
pkg_setck_nickname()
{
	junk=$1
	while echo $junk | grep '/' >$PKG_NULL_FILE 2>&1; do
		junk=$(echo $junk | $PKG_SED 's!\([^/][^/]*\)/\([^@]*\)!\2@\1!')
	done
	echo $junk
}

## SYSTEM DEPENDENT
#
# The system dependent code shall use _sys_ and _SYS_ prefix for
# special internal functions and variables not used by the present
# common code. The pkg_* and PKG_* listed here, and used by packages
# scripts, shall be implemented.
#
# The sys_ or SYS_ prefixed functions or variables, used internally
# by the library shall be implemented (for the moment these are 
# relative to data download; see below).
#
# PKG_NULL_FILE: a /dev/null for Unices or Plan9. This would be
# NUL (or encoded \\.\NUL) on Windows. And if on some system, this is
# unsupported, a junk file in the TMPDIR, to be removed when finished.
# (We could also simply open a 3 descriptor redirecting to whatever
# null file and redirect output to this descriptor.)
#
# The following utilities are defined as variables to allow the use in
# sudoed # scripts:
#
# PKG_RMDIR: removing an empty directory.
# PKG_UNZIP: unzipping a file.
# PKG_SED: a sed compliant with an old POSIX syntax.
#
# These are subroutines:
#
# pkg_stop_if_root: exit'ing with error if special user. Shall not do
# 	anything except printing error and exiting.
# pkg_user0_cmd: executing under special user.
# pkg_lstree: getting the listing of the current dir.
#
# GETTING DATA
#
# A dir is identified by a trailing '/'. Even dot shall be spelled:
#	./
# to be recognized correctly.
#
# One thing is very system dependent: the program allowing to retrieve
# an url, for http and ftp protocols, in a non interactive way. But
# this is not simply the program, this can be the syntax too. The
# following variable is for Unices to adapt. Plan9 has a different
# approach.
#

# The specification must be:
#
# - a line beginning with '#' is a comment and is ignored;

# - an empty line is ignored;
# - a line consisting of a URI (the trailing "/" is mandatory):
#	scheme ":" ["//" authority] path "/"
#   with one of the following scheme:
#	file
#	ftp
#	http
#	https
#   is a connecting url, overwriting what is specified in the env
#   variable KERTEX_PKG_SRC_SRV or the previously set server.
#   The following files will be retrieved from this specified URL
#   instead of the previously defined one.
#   Examples:
#
#	file:///root/[path/] # the third '/' is for "/root"
#	ftp://user:passwd@server/[path/]
#	http://[user:passw@]server/[path/]
#
# Sole commands supported: LCD and GET.
#
# LCD specifies where the stuff (_under TMPDIR_) will be put (and
# we create them, as long as they stay under TMPDIR). We always CD
# pathname, GET basename on the server. An absolute path is taken
# as TMPDIR/path. Relative paths can be used, the routines taking
# care of not being confronted with the escaping club. Syntax:
#
#	LCD dirname
#	LCD HOME/[subdirname]
#	LCD /subdirname
#
# In the first case, the dir is relative to lcd (current local).
# HOME is a reserved name and specifies a subdir in lib/PKG_NAME.
# / relates to TMPDIR.
#
# By default, we start retrieving at / (==TMPDIR) as LCD.
#
# GET can get a uniq file or get files according to a regexp in a
# directory (for this to work with http, we rely on the httpd to send
# a htmpl file with a listing where filenames are given in <a>*</a>
# entries).
# 
# In this "mget" case, there must be as a second argument, a REGEXP
# acceptable by legacy sed(1). This is considered a regexp only
# if the first argument is a directory identified by a trailing '/'.
# The regexp is enclosed in '/' since this shall match only basenames
# and not a dirname. With a filename (no trailing /), the second
# argument is taken to mean the target filename. We always basename(1)
# since one must LCD to a local dir and deal only with filenames.
# Syntax:
#	GET pathdir/	/regex/		/* may fail with the httpd conf */
#	GET rfilename	[lfilename]
#
# As a side effect, when retrieving a file in a remote directory, we
# first cd to this directory. This means that the first GET command
# needs to specify the remote dir, the following GET being done 
# implicitely in the previously specified remote dir.
#
# A local name can not begin with a dot '.' if in "root" (TMPDIR) since
# these names are reserved for internal handling. LCD below in the
# hierarchy if really needed.
#

# pkg_setck_url():
# from the url passed as an argument. Exit on error.
#
# call: url
# sets: PKG_URL, PKG_RPROTO, PKG_RUSER, PKG_RPWD, PKG_RHOST (the server
# for ftp and http; empty for file) and PKG_RROOT (PKG_URL minus
# the protocol for file; the root server dir, prepended to the rcd,
# for http and ftp).
# return: exits on error
#
PKG_URL=
PKG_RPROTO=
PKG_RUSER=
PKG_RPWD=
PKG_RHOST= # the server name for ftp and http; no trailing '/'
PKG_RROOT= # shall have a trailing '/'

pkg_setck_url()
{
	PKG_URL="$1"
	PKG_RPROTO=$(echo $1 | $PKG_SED -n 's!^\(..*\)://.*$!\1!p')
	junk=$(echo $1 | $PKG_SED -n 's!^..*://\(.*\)$!\1!p')
	PKG_RUSER=$(echo $junk | $PKG_SED -n 's!^\(..*\):.*$!\1!p')
	if test "x$PKG_RUSER" != x; then
		junk=$(echo $junk | $PKG_SED -n 's!^..*:\(.*\)$!\1!p')
		PKG_RPWD=$(echo $junk | $PKG_SED -n 's!^\([^@]*\)@.*$!\1!p')
		junk=$(echo $junk | $PKG_SED -n 's!^[^@]*@\(.*\)$!\1!p')
	else
		PKG_RPWD=""
		PKG_RUSER=$(echo $junk | $PKG_SED -n 's!^\([^@]*\)@.*$!\1!p')
		if test "x$PKG_RUSER" != x; then
			junk=$(echo $junk | $PKG_SED -n 's!^[^@]*@\(.*\)$!\1!p')
		fi
	fi
	# With a file protocole, the RHOST can be root '/'.
	#
	PKG_RHOST=$(echo $junk | $PKG_SED -n 's!^\(.*/\)$!\1!p')
	case "${PKG_RPROTO:-}" in
		ftp|http|file) ;;
		*) pkg_error "Insupported protocol in url '$1'!";;
	esac
	test "x$PKG_RHOST" != x\
		|| pkg_error "Remote host not specified in '$1'!"
	if test $PKG_RPROTO = ftp; then
		test "x$PKG_RUSER" != x || PKG_RUSER=anonymous
		if test "$PKG_RUSER" = "anonymous" || test "$PKG_RUSER" = "ftp"; then
			PKG_RPWD=kerTeX
		elif test "x$PKG_RPWD" = x; then
			pkg_error "ftp url: rpwd not set in '$1'!"
		fi
		PKG_RROOT="$(echo $PKG_RHOST | sed 's!^[^/]*/!/!')"
		PKG_RHOST="$(echo $PKG_RHOST | sed 's!^\([^/]*\)/.*$!\1!')"
	elif test $PKG_RPROTO = http; then
		PKG_RROOT="$(echo $PKG_RHOST | sed 's!^[^/]*/!/!')"
		PKG_RHOST="$(echo $PKG_RHOST | sed 's!^\([^/]*\)/.*$!\1!')"
	else # file
		PKG_RROOT="$PKG_RHOST"
		PKG_RHOST=""
	fi
}

# pkg_exp_getspec: 'explicate' a getspec specification in a list of
#	shell commands able to retrieve what has to be. The resulting
#	script, written in:
#
#	$TMPDIR/.getcmd
#
#	will simply be executed (as well as $TMPDIR/.mget for retrieving
#	a list of filenames to be choosen according to a regexp).
#
# usage: pkg_exp_getspec specfile
#
#	exit on error (trying to escape TMPDIR or incorrect spec).
#
# The commands are written in $TMPDIR/.getcmd .
# The SYSTEM DEPENDENT code shall implement the following functions with
# the following contract:
#	- pkg_setck_url has been called, hence PKG_URL, PKG_RPROTO, 
#		PKG_RUSER, PKG_RPWD, PKG_RHOST are defined;
#	- rdir is absolutely qualified i.e. it begins with a '/' with
#		path as prefix for http or ftp, or /root/path for file
#		protocol;
#	- the commands have to be sent to stdout.
#
# sys_${PKG_RPROTO}_cnx_open() sends to stdout the cmds necessary to open
# the cnx.  Will be called after pkg_setck_url().
#
# sys_${PKG_RPROTO}_lcd(ldir)
# Change the local directory.
#
# sys_${PKG_RPROTO}_ls(rdir)
# list the remote dir.
#
# sys_${PKG_RPROTO}_get(rdir, rfile, lfile)
# echoes the cmd to get the rpath/rfile to the lfile.
#
# sys_${PKG_RPROTO}_cnx_close() echoes the command for closing the connection.
#
pkg_exp_getspec()
{
	spec="$1"
	lcd="$TMPDIR/"

	nline=1
	while read -r cmd arg1 arg2; do
		# The first line shall be the URL set by pkg_get()
		if test $nline = 1; then
			pkg_setck_url $cmd # exits on error
			rcd="$PKG_RROOT"
	
			eval sys_${PKG_RPROTO}_cnx_open >$TMPDIR/.getcmd
	
			if test $PKG_X_SPEC = YES; then
				echo "SOURCES_X_TEMPLATE:"
				echo "http://template_srv$PKG_RROOT"
			fi
	
			nline=$(($nline + 1))
			continue
		fi

		# Not the connection
		#
		test "${cmd:-}" && test "${cmd###}" = $cmd || continue

		# Treating each command (not srv) in turn.
		#
		case $cmd in
			LCD) test $PKG_X_SPEC = NO || echo "	LCD $arg1"
				if test $PKG_COPY_SRC != YES; then
					arg1=$(echo $arg1 | $PKG_SED "s!^/!$TMPDIR/!") 
					arg1=$(echo $arg1 | $PKG_SED "s!^HOME/*!$TMPDIR/lib/$PKG_NAME/!") 
					arg1="$arg1/" # mutiple // will be skeezed by pkg_derel
					lcd=$(pkg_derel $lcd $arg1)
					if test "x${lcd#$TMPDIR/}" = "x$lcd"; then
						pkg_error "Trying to create dir '$lcd' outside of $TMPDIR!"
					fi
					mkdir -p $lcd
					eval sys_${PKG_RPROTO}_lcd $lcd >>$TMPDIR/.getcmd
				fi
				;;

			GET) # change rcd only if dirname is not empty.
				 #
				if test "x$(echo $arg1 | $PKG_SED 's![^/]*$!!')" != x; then
				junk="$(echo $arg1 | $PKG_SED 's![^/]*$!!')"
					# prepend root if '/' prefixed.
					test "x${junk#/}" = "x$junk"\
						|| junk="$PKG_RROOT${junk#/}"
					rcd=$(pkg_derel $rcd $junk)
				fi
				if test "x${rcd#$PKG_RROOT}" = "x$rcd"; then
					pkg_error "Trying to get a dir '$rcd' outside of $PKG_RROOT!"
				fi
				rfile=$(echo $arg1 | $PKG_SED 's!^.*/!!')

				# COPY_SRC: do not optimize: lcd is changed in LCD) so 
				# the value may match rcd while the instruction 
				# 'cd $lcd' was never given.
				#
				if test $PKG_COPY_SRC = YES; then
					lcd="$PKG_COPY_DIR/${rcd#$PKG_RROOT}"
					mkdir -p $lcd
					eval sys_${PKG_RPROTO}_lcd $lcd >>$TMPDIR/.getcmd
				fi
				if test "x$rfile" = "x"; then # getting a dir
					if test "x$arg2" = x; then
						pkg_error "Trying to get dir '$rcd' without specifying regex!"
					fi
					eval sys_${PKG_RPROTO}_cnx_open >$TMPDIR/.mget
					eval sys_${PKG_RPROTO}_ls $rcd >>$TMPDIR/.mget
					eval sys_${PKG_RPROTO}_cnx_close >>$TMPDIR/.mget
					test $PKG_X_SPEC = YES\
						|| pkg_log "Retrieving files list from '$PKG_URL${rcd#/}'. Please wait..."
					$KERTEX_SHELL $TMPDIR/.mget\
						| $PKG_SED -n -e 's!^\./!!' -e '/^\.\.*$/d' -e '/^[^/][^/]*$/p'\
						| $PKG_SED -n -e '/^\.[^/]/d' -e "${arg2}p"\
						| { 
							iline=0; while read rfile; do
								iline=$(($iline + 1))
								if test $PKG_X_SPEC = NO; then
									eval sys_${PKG_RPROTO}_get $rcd $rfile $rfile >>$TMPDIR/.getcmd
								elif test $iline -eq 1; then
									echo "	GET /${rcd#$PKG_RROOT}$rfile"
								else # still X_SPEC, with not first get
									echo "	GET $rfile"
								fi
							done
						}
				else
					test $PKG_X_SPEC = NO\
						|| echo "	GET $arg1 $arg2"
					if test "x$arg2" = x; then
						lfile="$rfile"
					else
				 		lfile=$(echo $arg2 | $PKG_SED 's!^.*/!!')
					fi
					if test $lcd = $TMPDIR && { 
						{ test "x$lfile" != "x" && test ${lfile#.} != $lfile; }\
						|| { test "x$lfile" = "x" && test ${rfile#.} != $rfile; }
						}; then
						pkg_error "Trying to get a ".file" in root!"
					fi
					eval sys_${PKG_RPROTO}_get $rcd $rfile $lfile >>$TMPDIR/.getcmd
				fi
				;;
		esac
		nline=$(($nline + 1))
	done <$spec
	eval sys_${PKG_RPROTO}_cnx_close >>$TMPDIR/.getcmd
}

# This wrapper routine just handles the loop to retrieve from each
# server declared, calling subroutines to expand the spec.
# 
pkg_get()
{
	# / is always here at beginning.
	#
	cd $TMPDIR

	# The list as specified by the package.
	#
	pkg_get_rec SOURCES >$TMPDIR/.sources

	# Split by server the commands lists.
	# The default server is used and may be overwritten.
	#
	nserver=1
	rm -f $TMPDIR/.get.$nserver
	echo $KERTEX_PKG_SRC_SRV >$TMPDIR/.get.$nserver
	while read -r line; do
		test "x$(echo $line | $PKG_SED 's/[ 	]*//g')" != x || continue
		test "$line" != '#' || continue
		if test "x$(echo $line | $PKG_SED -n -e '/^[ 	]*[fh]tt*p:\/\//p' \
			-e '/^[ 	]*file:\/\/\//p')" != x; then
			if test $PKG_FORCE_SRC_SRV = "NO"; then
				nserver=$(($nserver + 1))
				rm -f $TMPDIR/.get.$nserver
				echo "$line" >$TMPDIR/.get.$nserver
			else
				continue # ignore and keep server
			fi
		else
			echo "$line" >>$TMPDIR/.get.$nserver
		fi
	done <$TMPDIR/.sources
	
	while test $nserver -gt 0; do
		if test "$($PKG_SED -n '$=' $TMPDIR/.get.$nserver)" -gt 1; then
			pkg_exp_getspec $TMPDIR/.get.$nserver
			if test $PKG_X_SPEC = NO; then
				$KERTEX_SHELL -e $TMPDIR/.getcmd >&2\
					|| pkg_error "Failed to retrieve the needed files!"
			fi
		fi
		nserver=$(($nserver - 1))
	done

	# http does cd. Return to pkg build root dir.
	#
	cd $TMPDIR
}

## MANIPULATING THE RECORDS IN THE CID FILE.
#
# To illustrate, here are the sed scripts for retrieving a record, or
# deleting a record. The embedded commands shall stay here!

#BEGIN_GET_REC_SEDCMD
#/^TAG:[ 	]*/ {
#	s///
#	/^$/!p
#:tag
#	n
#	/^[A-Z][A-Z0-9_]*:/b
#	p
#	b tag
#}
#END_GET_REC_SEDCMD

# Extracting will be done at initialization.
#
_pkg_x_get_rec_sedcmd()
{
	$PKG_SED -n -e '/^#BEGIN_GET_REC_SEDCMD/,/^#END_GET_REC_SEDCMD/s/^#//p' \
		"$KERTEX_BINDIR/lib/pkglib.sh"\
 		| $PKG_SED -e '/^BEGIN/d' -e '/^END/d'\
		>$TMPDIR/.get_rec_sedcmd
}

# pkg_get_rec take a tag as $1 in PKG_CID and send to stdout the 
# record.
#
# The .get_record has been created from the extraction of the chunk
# above at initialization time.
#
# call: TAG
#
pkg_get_rec()
{
	test $# -eq 1 || pkg_error "pkg_get_rec called without correct argument."
	ed $TMPDIR/.get_rec_sedcmd <<EOT >$PKG_NULL_FILE 2>&1
/^\\/[\\^][A-Z][A-Z0-9_]*:/s!!/^$1:!
w
q
EOT
	$PKG_SED -n -f $TMPDIR/.get_rec_sedcmd $PKG_CID
}

#BEGIN_DEL_REC_SEDCMD
#/^TAG:[ 	]*/ {
#:tag
#	n
#	/^[A-Z][A-Z0-9_]*:/b other
#	b tag
#}
#:other
#p
#END_DEL_REC_SEDCMD

# Extracting will be done at initialization.
#
_pkg_x_del_rec_sedcmd()
{
	$PKG_SED -n -e '/^#BEGIN_DEL_REC_SEDCMD/,/^#END_DEL_REC_SEDCMD/s/^#//p' \
		 "$KERTEX_BINDIR"/lib/pkglib.sh\
		| $PKG_SED -e '/^BEGIN/d' -e '/^END/d'\
		>$TMPDIR/.del_rec_sedcmd
}

# pkg_del_rec take a tag as $1 in PKG_CID and send to stdout the 
# CID without the record.
#
# The .del_record has been created from the extraction of the chunk
# above at initialization time.
#
# call: TAG
#
pkg_del_rec()
{
	test $# -eq 1 || pkg_error "pkg_del_rec called without correct argument."
	ed $TMPDIR/.del_rec_sedcmd <<EOT >$PKG_NULL_FILE 2>&1
/^\\/[\\^][A-Z][A-Z0-9_]*:/s!!/^$1:!
w
q
EOT
	$PKG_SED -n -f $TMPDIR/.del_rec_sedcmd $PKG_CID
}

# LISTING THE FILES TO BE INSTALLED
#
# There are two chunks: machine dependent and machine independent. The
# files installed will be listed in the CID, as two records tagged:
#	BIN_FILES:
#	LIB_FILES:
#
# When making the package or before installing we list and add to the
# CID. This routine does echo the listing on stdout, so can be invoked
# at any moment. Only when dealing really with the package stdout will
# be redirected where it shall.
#
# call: pkg_list
#
pkg_list()
{
	for dir in bin lib; do
		echo "$(echo $dir | $PKG_SED y/binl/BINL/)_FILES:"
		cd $TMPDIR/$dir; pkg_lstree | $PKG_SED -e '/^\.$/d' -e 's!^\.!!'
	done
}

# DEALING WITH HOSTS AND VERSIONS
#
# In the CID are also recorded the KERTEX_VERSION and the identifier
# of the target host system KERTEX_HOST, that has the system name, the
# machine and the version.
#
# At installation time all the files installed are recorded. This is
# so to be able to deinstall easily.
#
# A package tarball is a gzipped compressed tar file of two not 
# compressed tarballs: one for machine independent (I will say: lib),
# and the other for system dependent (machine and system): bin.

# pkg_log simply writes messages to stderr, with a leading program 
# identifier.
#
pkg_log()
{
	echo "$(basename $0): " "$*" >&2
}

# Protect from trying to remove a not verified and not newly created
# tmpdir via ?.
#
pkg_clean_tmp()
{
	test -d "${_tmpdir:?}" || return 0
	if test "x$PKG_DEBUG" != "xYES"; then
		( cd "$_tmpdir"; rm -fr .[_a-zA-Z0-9-]* *; )
		$PKG_RMDIR "$_tmpdir"
	else
		pkg_log "TMPDIR created: '$_tmpdir'"
	fi
}

pkg_error()
{
	pkg_log "$*"
	pkg_clean_tmp
	exit 3
}

# This function is extracted from R.I.S.K.:librkcompsh.
#
# pkg_derel suppress the ./ and ../ in a path, trailing whites
# and return the result on stdout.
#
# A dir shall be suffixed with a trailing '/' that is preserved.
# The resulting will have a leading '/'.
#
# usage: pkg_derel WORKING_DIR PATH_TO_DERELATIVATE
#
pkg_derel()
{
	test $# -eq 2 || pkg_error "pkg_derel needs 2 arguments!"

	# If not begining with a slash, prepend WORKING_DIR.
	#
	derel_path=$(echo $2 | $PKG_SED 's@^\([^/]\)@'$1'/\1@')

	# Normalize: squeezing multiple //...; removing /./?.
	#
	derel_path=$(echo $derel_path | $PKG_SED -e 's@//*@/@g' -e 's@/\./@/@g' -e 's@/\.$@@')
	if echo $derel_path | grep '^/*\.\./' >/dev/null 2>&1; then
		pkg_error invalid_path $derel_path
	fi

	while echo $derel_path | grep '/\.\./' >/dev/null 2>&1; do
		# Just the first occurrence will be replaced. We work from left
		# to right.
		#
		derel_path=$(echo $derel_path | $PKG_SED -e 's@/[^/]*[^/.]/\.\./@/@')
		if echo $derel_path | grep '^/*\.\./' >/dev/null 2>&1; then
			pkg_error invalid_path $derel_path
		fi
	done
	
	# Remove trailing whites.
	#
	derel_path=$(echo $derel_path | $PKG_SED 's@[ 	]*$@@')

	# If there is a last '/..' take this into account.
	# Here, we are guaranteed that there is no more '/../' elsewhere
	# and that there is something before.
	#
	derel_path=$(echo $derel_path | $PKG_SED 's@/[^/][^/]*/\.\.$@/@')

	# Remove trailing whites (we have perhaps modified the path).
	#
	derel_path=$(echo $derel_path | $PKG_SED 's@[ 	]*$@@')

	echo $derel_path
}

# _pkg_add_list adds, after removing existing, the list of bin and lib
# files to the CID.
#
_pkg_add_list()
{
	pkg_del_rec BIN_FILES >$TMPDIR/.cid
	mv $TMPDIR/.cid $PKG_CID
	pkg_del_rec LIB_FILES >$TMPDIR/.cid
	mv $TMPDIR/.cid $PKG_CID
	pkg_list >$TMPDIR/.list
	ed $PKG_CID <<EOT >$PKG_NULL_FILE 2>&1
/^END:/-r $TMPDIR/.list
w
q
EOT
}

# When applying a tarball (the kerTeX version and host system can be
# defined by leading directories), we verify that this package is the
# correct one for the script---that may have to do pre or
# post-processing---. The regex for KERTEX_VERSION and KERTEX_HOST,
# perhaps modified by the packager have to match the package CID.
#
# Does exit on fatal errors. But return with 0 if OK, or 1 if not.
#
pkg_ck_compat()
{
	if test $# -eq 0; then
		junk="$PKG_INI_DIR/$PKG_NICKNAME.tar.gz"
	else
		junk="$1"
	fi
	test -s "$junk" || pkg_error "I can't find '$junk'!"	
	mkdir $TMPDIR/.apply
	cd $TMPDIR/.apply

	# We use this name but we verify what it is indeed before
	# applying...
	#
	gunzip -c "$junk" >$PKG_NICKNAME.tar

	tar xf $PKG_NICKNAME.tar
	rm $PKG_NICKNAME.tar || true
	test -s $PKG_NICKNAME-lib.tar || test -s $PKG_NICKNAME-bin.tar\
		|| pkg_error "The tarball has not the required subfiles!"
	tar xf $PKG_NICKNAME-lib.tar ./$PKG_NAME/CID \
		|| pkg_error "Applied package has an incorrect CID!"

	applied_name=$($PKG_SED -n 's/^NAME:[ 	] *\([^ 	][^ 	]*\)[ 	]*$/\1/p' $PKG_NAME/CID)
	applied_kversion=$($PKG_SED -n 's/^KERTEX_VERSION:[ 	] *\([^ 	][^ 	]*\)[ 	]*$/\1/p' $PKG_NAME/CID)
	applied_khost=$($PKG_SED -n 's/^KERTEX_HOST:[ 	] *\([^ 	][^ 	]*\)[ 	]*$/\1/p' $PKG_NAME/CID)

	cd $TMPDIR
	# For this preliminary version, no version handling.
	#
	return 0
}

# Doing: whether packaging, installing or applying. We do clean
# and exit after calling a packager provided routine doing whatever
# post-install actions.
#
pkg_apply()
{
	if test $# -eq 1; then
		PKG_BIN_NAME="$1"
	else
		PKG_BIN_NAME="$PKG_INI_DIR/$PKG_NICKNAME.tar.gz"
	fi
	pkg_ck_compat "$PKG_BIN_NAME" || pkg_error "Incompatible name, version or host!"
	# We must NOT remove our infrastructure: we overwrite.
	# Because we need the old files to install the new one.
	#
	test "$(echo $PKG_NAME | $PKG_SED -n '/^pkg\//p')"\
		|| ! pkg_is_installed $PKG_NAME\
		|| pkg_error "Pkg already installed. Remove it first!"

	# Still about @pkg stuff: we have renamed kertex.sh to core@pkg.sh.
	# Updating an earlier version, there is kertex/CID and
	# pkg/kertex.sh. We need to remove it, remove the recipe and the
	# directory to clean the stuff.
	#
	if test $PKG_NAME = "pkg/core" && pkg_is_installed "kertex"; then
		$KERTEX_SHELL "$KERTEX_LIBDIR"/pkg/kertex.sh remove
		rm "$KERTEX_LIBDIR"/kertex/CID || true
		rm "$KERTEX_LIBDIR"/kertex/KXPATH || true
		$PKG_RMDIR "$KERTEX_LIBDIR"/kertex || true
		rm "$KERTEX_LIBDIR"/pkg/kertex.sh || true
	fi

	pkg_dependencies_get
	if test $PKG_ADD_MISSING_DEPENDENCIES = "YES"; then
		pkg_dependencies_install_missing\
			|| pkg_error "Failed to install a needed dependencies!"
	else
		pkg_dependencies_are_installed || pkg_error "Missing dependencies!"
	fi
	cd $TMPDIR
	gunzip -c "$PKG_BIN_NAME" >$PKG_NICKNAME.tar
	tar xf $PKG_NICKNAME.tar
	rm $PKG_NICKNAME.tar || true
	cat <<EOT >$TMPDIR/.applycmd
cd "$KERTEX_BINDIR"; tar xvf $TMPDIR/$PKG_NICKNAME-bin.tar
cd "$KERTEX_LIBDIR"; tar xvf $TMPDIR/$PKG_NICKNAME-lib.tar
if test -s $TMPDIR/$PKG_NICKNAME.kxpath; then
	while read rootdir addpath; do
		mkdir -p "$KERTEX_LIBDIR"/\$rootdir/
		echo "Adding \$addpath to \$rootdir/KXPATH" >&2
		if test -s "$KERTEX_LIBDIR"/\$rootdir/KXPATH; then
			if ! grep ";\$addpath;" "$KERTEX_LIBDIR"/\$rootdir/KXPATH; then
				ed "$KERTEX_LIBDIR"/\$rootdir/KXPATH <<ENDEDSCRIPT >$PKG_NULL_FILE 2>&1
1s|\$|;\$addpath;|
w
q
ENDEDSCRIPT
			fi
		else # KXPATH didn't exist or was empty
			echo ";\$addpath;" >"$KERTEX_LIBDIR"/\$rootdir/KXPATH
		fi
	done <$TMPDIR/$PKG_NICKNAME.kxpath
fi
if test -s $TMPDIR/$PKG_NICKNAME.dvips; then
	echo "Adding dvips configuration to '$KERTEX_LIBDIR/dvips/dvips.cnf'" >&2
	echo >>"$KERTEX_LIBDIR"/dvips/dvips.cnf
	echo "%BEGIN $PKG_NICKNAME" >>"$KERTEX_LIBDIR"/dvips/dvips.cnf
	cat $TMPDIR/$PKG_NICKNAME.dvips | $PKG_SED 's/^[ 	]*//' >>"$KERTEX_LIBDIR"/dvips/dvips.cnf
	echo "%END $PKG_NICKNAME" >>"$KERTEX_LIBDIR"/dvips/dvips.cnf
fi
EOT

	if pkg_is_root $PKG_NAME; then
		cat <<EOT >>$TMPDIR/.applycmd
test -f "$KERTEX_LIBDIR/$PKG_NAME/KXPATH"\\
	|| : >"$KERTEX_LIBDIR/$PKG_NAME/KXPATH"
EOT
fi

	pkg_log "Switching to '$KERTEX_USER0' for INSTALLING pkg '$PKG_NAME':"
	( TMPDIR="$_tmpdirroot"; export TMPDIR; pkg_user0_cmd $_tmpdir/.applycmd )

	pkg_log "$PKG_NAME installed"
	pkg_post_apply
	pkg_clean_tmp
	exit 0
}

# When removing, we don't 'rm -fr', but we remove one by one files and
# then an empty directory. This is just a first approach, a correct
# implementation should also verify that we are not removing a kerTeX
# system file.
#
pkg_remove()
{
	if test $# -eq 0; then	
		PKG_CID="$KERTEX_LIBDIR/$PKG_NAME/CID"
	else
		PKG_CID="$KERTEX_LIBDIR/$1/CID"
	fi

	test -s $PKG_CID || pkg_error "$PKG_NAME is not installed!"

	# We must NOT remove our infrastructure: we overwrite.
	# Because we need the old files to install the new one.
	#
	if test "$(echo $PKG_NAME | $PKG_SED -n '/^pkg\//p')"; then
		pkg_log "This is a fundamental framework component."
		pkg_log "Just apply it for overwriting. I don't remove it."
		pkg_clean_tmp
		exit 0
	fi

	pkg_log "Checking the list for safety. Please wait..."	

	for rec in BIN_FILES LIB_FILES; do
		: >$TMPDIR/.remove_$rec
		pkg_get_rec $rec >$TMPDIR/.tmp1 \
			|| pkg_error "Failed to retrieve the list of files to remove!"
		# [S] We derel _subpaths_ _before_ prepending kerTeX dir.
		# We don't use /dev/null for portability.
		#
		: >$TMPDIR/.tmp2
		while read path; do
			echo $(pkg_derel / "$path") >>$TMPDIR/.tmp2
		done <$TMPDIR/.tmp1
		cat $TMPDIR/.tmp2 | sort -r >$TMPDIR/.remove_$rec
	done
	rm $TMPDIR/.tmp1 $TMPDIR/.tmp2

	# Extracting the kxpaths if any.
	#
	pkg_get_rec KXPATH >$TMPDIR/$PKG_NICKNAME.kxpath
	pkg_get_rec DVIPS >$TMPDIR/$PKG_NICKNAME.dvips

	cat <<EOT >$TMPDIR/.removecmd
while read path; do
	if test -d "$KERTEX_BINDIR/\$path"; then
		$PKG_RMDIR "$KERTEX_BINDIR/\$path" 2>$PKG_NULL_FILE || true
	else
		rm "$KERTEX_BINDIR/\$path"	2>$PKG_NULL_FILE || true
	fi
done <$TMPDIR/.remove_BIN_FILES
while read path; do
	if test -d "$KERTEX_LIBDIR/\$path"; then
		$PKG_RMDIR "$KERTEX_LIBDIR/\$path" 2>$PKG_NULL_FILE || true
	else
		rm "$KERTEX_LIBDIR/\$path" 2>$PKG_NULL_FILE || true
	fi
done <$TMPDIR/.remove_LIB_FILES
if test -s $TMPDIR/$PKG_NICKNAME.kxpath; then
	while read rootdir addpath; do
	test -f "$KERTEX_LIBDIR/\$rootdir/KXPATH" || continue 
		echo "Removing \$addpath from \$rootdir/KXPATH" >&2
		if test -s "$KERTEX_LIBDIR/\$rootdir/KXPATH"; then
			ed "$KERTEX_LIBDIR/\$rootdir/KXPATH" <<ENDEDSCRIPT >$PKG_NULL_FILE 2>&1
g|;\$addpath;|s|||
w
q
ENDEDSCRIPT
		fi
	done <$TMPDIR/$PKG_NICKNAME.kxpath
fi
if test -s $TMPDIR/$PKG_NICKNAME.dvips; then # New: block of lines
	echo "Removing dvips configuration from '$KERTEX_LIBDIR/dvips/dvips.cnf'" >&2
	if grep "^%BEGIN $PKG_NICKNAME\\\$" "$KERTEX_LIBDIR"/dvips/dvips.cnf >/dev/null 2>&1; then
		ed "$KERTEX_LIBDIR"/dvips/dvips.cnf <<EOFEDSCRIPT >$PKG_NULL_FILE 2>&1
/^%BEGIN $PKG_NICKNAME\\\$/-
/^\\\$/d
/^%BEGIN $PKG_NICKNAME\\\$/,/^%END $PKG_NICKNAME\\\$/d
w
q
EOFEDSCRIPT
	else # Obsolete : line by line
		while read line; do
			line=\$(echo \$line|$PKG_SED 's@/@\\/@g')
			ed "$KERTEX_LIBDIR"/dvips/dvips.cnfe <<EOFEDSCRIPT >$PKG_NULL_FILE 2>&1
g/^\$line\\\$/d
w
q
EOFEDSCRIPT
		done <$TMPDIR/$PKG_NICKNAME.dvips
	fi
fi
EOT

	pkg_log "Switching to '$KERTEX_USER0' for REMOVING pkg '$PKG_NAME':"
	( TMPDIR="$_tmpdirroot"; export TMPDIR; pkg_user0_cmd $_tmpdir/.removecmd )

	pkg_log "$PKG_NAME removed"
	pkg_post_remove
	pkg_clean_tmp
	exit 0
}

# Remove an obsolete recipe. This is not automatically done by 
# pkg_remove() since removing can be of one version of package, the
# recipe being the same (or updated) only the sources having changed.
#
# Call: the canonical name (not the nickname)
#
# Doesn't do what it should not but always returns 0.
#
pkg_remove_rcp_obsolete()
{
	test $# -eq 1 && test "$1" || return 0
	junk=$(pkg_setck_nickname "$1")
	test "$junk" || return 0
	test -f "$KERTEX_PKG_RCP_DIR/$junk.sh"\
		&& rm "$KERTEX_PKG_RCP_DIR/$junk.sh" || return 0
	return 0
}

# peu
# Indeed, we fallthrough: build and perhaps apply.
#
pkg_do_action()
{
	cd $TMPDIR

	test $PKG_ACTION = build || test $PKG_ACTION = install\
		|| pkg_error "Calling pkg_do_action with incorrect $PKG_ACTION!"

	# Building.
	#
	_pkg_add_list

	cd $TMPDIR/bin; tar cvf $TMPDIR/../$PKG_NICKNAME-bin.tar .

	# If not a pkg/ root, save the script in lib/pkg/rcp/ (will not be 
	# removed on removal since not in list).
	#
	if test "${PKG_NAME#pkg/}" = $PKG_NAME; then
		mkdir -p pkg/rcp; cp "$PKG_FQ_SCRIPT" pkg/rcp/$PKG_NICKNAME.sh
	fi

	cd $TMPDIR/lib; tar cvf $TMPDIR/../$PKG_NICKNAME-lib.tar .

	cd $TMPDIR/..;
	# Extracting the kxpath and dvips if any.
	#
	pkg_get_rec KXPATH >$PKG_NICKNAME.kxpath
	pkg_get_rec DVIPS >$PKG_NICKNAME.dvips

	tar cf $PKG_NICKNAME.tar $PKG_NICKNAME-bin.tar\
		$PKG_NICKNAME-lib.tar $PKG_NICKNAME.kxpath\
		$PKG_NICKNAME.dvips
	gzip -c $PKG_NICKNAME.tar >$PKG_NICKNAME.tar.gz
	rm $PKG_NICKNAME.tar
	cd $TMPDIR; rm -f ../$PKG_NICKNAME-bin.tar\
		../$PKG_NICKNAME-lib.tar ../$PKG_NICKNAME.kxpath\
		../$PKG_NICKNAME.dvips
	pkg_log "$(pkg_derel $TMPDIR ../$PKG_NICKNAME.tar.gz) created"

	if test "$PKG_ACTION" = install; then
		if pkg_is_installed $PKG_NAME; then
			pkg_log "Removing before installing new version..."
			"$KERTEX_SHELL" "$PKG_FQ_SCRIPT" remove
		fi
		(cd $TMPDIR/..; "$KERTEX_SHELL" "$PKG_FQ_SCRIPT" apply)
	else
		pkg_post_build
	fi
	pkg_clean_tmp
}


#========== PROCESSING

#--- Checking without storing.

#	2) Check if the var are defined or stop.
#
for var in KERTEX_VERSION KERTEX_HOST KERTEX_SHELL\
	KERTEX_BINDIR KERTEX_LIBDIR KERTEX_USER0 KERTEX_GROUP0; do
	eval : \${$var:?}
done

# 3) Save initial PWD.
#
PKG_INI_DIR="$PWD"
readonly PKG_INI_DIR

#	4) Set TMPDIR. We first set TMPDIR to a non already existent one, 
# in order to can safely call the routines that will whether need
# a tmp dir or clean the tmp dir, before actually doing anything.
#
#		TMPDIR is sketched with the	mandatory LIBDIR/$PKG_NAME/.
#
test $(_pkg_nb_token $TMPDIR) -eq 1\
	|| { pkg_log "Tmpdir '$TMPDIR' has whites! Forbidden!"; exit 1; }

TMPDIR="${TMPDIR%/}"
TMPDIR="$TMPDIR/$$"
test ! -d "$TMPDIR"\
	|| { pkg_log "My tmpdir '$TMPDIR' already exists!"; exit 2; } 

TMPDIR="$(pkg_derel "$PKG_INI_DIR" "$TMPDIR")"

#--- Starting storing.
#
# Now set and create.
#
_tmpdir="$TMPDIR" # what we do create and will use when removing
readonly _tmpdir
mkdir -p $TMPDIR/bin
mkdir -p $TMPDIR/lib

# Remove temporary files on HUP, INT, QUIT, PIPE, TERM.
#
trap " pkg_log 'Unexpected event. Try -d to debug'; pkg_clean_tmp; exit 127;"	HUP INT QUIT PIPE TERM

# 5) Save launch values.
#
if test -s $0; then
	PKG_FQ_SCRIPT=$(pkg_derel "$PKG_INI_DIR" $0)
else
	PKG_FQ_SCRIPT=$(pkg_derel "$PKG_INI_DIR" $(command -v $0))
fi
readonly PKG_FQ_SCRIPT


# 6) KerTeX is a hosted system. We must be in subdirectories of our own,
# when writing and removing.
#
for path in "$KERTEX_BINDIR" "$KERTEX_LIBDIR"; do
	junk="$(pkg_derel / "$path")"
	test -d "$junk" && test "x$(echo $junk | $PKG_SED -n '/\/kertex\/*$/p')" != x\
		|| pkg_error "KERTEX_BINDIR or KERTEX_LIBDIR is/are incorrect paths!"
done

#	7) Get the arguments.
#
test $# -ge 1 || pkg_error "Incorrect usage: $usage"

# Default action. PKG_ACTION will not be readonly since packager can
# "patch" a tarball to update it and switch to build or install.
#
PKG_ACTION=show
PKG_SHOW_DEPENDENCIES=NO
PKG_DEBUG=NO
PKG_X_SPEC=NO
PKG_ADD_MISSING_DEPENDENCIES=NO
PKG_COPY_SRC=NO
PKG_COPY_DIR="$TMPDIR/tmp"
PKG_FORCE_SRC_SRV=NO
PKG_BIN_NAME=
while test $# -gt 0; do
	case "$1" in
		-*) _pkg_get_opt $1;;
		help) echo "$usage"; exit 0;;
		status) PKG_ACTION=status
			break
			;;
		show) PKG_ACTION=show
			shift
			if test $# -gt 0; then
				case "$1" in
					dependencies) PKG_SHOW_DEPENDENCIES=YES;;
					*) pkg_error "Incorrect option. $usage";;
				esac
			fi
			;;
		download) PKG_ACTION=download
			shift
			if test $# -eq 1; then
				PKG_COPY_DIR="$1"
				test -d "$PKG_COPY_DIR" \
					|| pkg_error "Dest dir for copy '$PKG_COPY_DIR' doesn't exist."
			elif test $# -gt 1; then
				pkg_error "Incorrect option. $usage"
			fi;;
		build) PKG_ACTION=build;;
		install) PKG_ACTION=install;;
		apply) PKG_ACTION=apply
			shift
			if test $# -eq 1; then
				PKG_BIN_NAME="$1"
			fi
			;;
		remove) PKG_ACTION=remove;;
		*) pkg_error "Incorrect option. $usage";;
	esac
	test $# -eq 0 || shift
done

#
# 1) stop if root if not removing or applying.
#
if test $PKG_ACTION != "apply" && test $PKG_ACTION != "remove" \
	&& test $PKG_ACTION != "status" \
	&& test $PKG_ACTION != "show"; then
	pkg_stop_if_root
fi

#	8) Set PKG_CID, PKG_NAME and PKG_NICKNAME. 
# Extract the chunks and set PKG_NAME for further processing.
#
PKG_CID=$TMPDIR/CID
_pkg_x_cid
_pkg_x_get_rec_sedcmd
_pkg_x_del_rec_sedcmd
PKG_NAME="$(pkg_get_rec NAME)"

test $PKG_X_SPEC = NO || test $PKG_ACTION = show\
	|| pkg_error "-x only valid with show action. $usage"

test "x$PKG_NAME" != x || pkg_error "Incorrect CID: NAME not set!"
readonly PKG_NAME

PKG_NICKNAME=$(pkg_setck_nickname $PKG_NAME)
readonly PKG_NICKNAME

if test $PKG_ACTION = "status"; then
	if pkg_is_installed $PKG_NAME; then
		pkg_log "$PKG_NAME: installed"
		status=0
	else
		pkg_log "$PKG_NAME: NOT installed"
		status=1
	fi
	pkg_clean_tmp
	exit $status
fi

# The name can have dependencies i.e. subdirs.
#
mkdir -p $TMPDIR/lib/$PKG_NAME
PKG_CID=$TMPDIR/lib/$PKG_NAME/CID
mv $TMPDIR/CID "$PKG_CID"

# If showing, downloading, applying or removing, we're done.
#
if test $PKG_ACTION = show; then
	if test $PKG_SHOW_DEPENDENCIES = "YES"; then
		pkg_dependencies_get
		pkg_dependencies_show
	elif test $PKG_X_SPEC = NO; then
		cat $PKG_CID
	else
		pkg_get
	fi
	pkg_clean_tmp
	exit 0
elif test $PKG_ACTION = download; then
	PKG_COPY_SRC=YES
	pkg_get
	pkg_log "$pkgname sources downloaded in:"
	echo "$PKG_COPY_DIR"
	test "${PKG_COPY_DIR#$TMPDIR}" != $PKG_COPY_DIR || pkg_clean_tmp
	exit 0
elif test $PKG_ACTION = apply; then
	: ${PKG_BIN_NAME:="$PKG_INI_DIR/$PKG_NICKNAME.tar.gz"}
	pkg_apply "$PKG_BIN_NAME"
elif test $PKG_ACTION = remove; then
	pkg_remove
else
	pkg_dependencies_get
	if test $PKG_ADD_MISSING_DEPENDENCIES = "YES"; then
		pkg_dependencies_install_missing\
			|| pkg_error "Failed to install a needed dependencies!"
	else
		pkg_dependencies_are_installed || pkg_error "Missing dependencies!"
	fi
fi

# From now on, PKG_CID must not change.
#
readonly PKG_CID

# Add host and kerTeX version. The date will be the one on the file.
# The packager can in his script modify KERTEX_VERSION and KERTEX_HOST
# that are regex to allow installing the packages on a range of kerTeX
# versions and a range of system hosts.
#
pkg_del_rec KERTEX_VERSION >$TMPDIR/.cid
mv $TMPDIR/.cid $PKG_CID
pkg_del_rec KERTEX_HOST >$TMPDIR/.cid
mv $TMPDIR/.cid $PKG_CID
ed $PKG_CID <<EOT >$PKG_NULL_FILE 2>&1
2i
KERTEX_HOST: $KERTEX_HOST
KERTEX_VERSION: $KERTEX_VERSION
.
w
q
EOT


cd $TMPDIR

# Here continues with packager code.

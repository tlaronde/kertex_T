#!/bin/sh
# C) 2012-2014, 2016-2017, 2019--2024
#	Thierry Laronde <tlaronde@polynum.com>
# C) 2016 Mark van Atten : Debian uses lftp too.
#
# All rights reserved and no warranty! Run it at your risks!
#

: ${TMPDIR:=/tmp}

# Sources: what is in the tarball and must be present by default.
#
sources="knuth etex bibtex ams adobe kertex_M kertex_T risk_comp"
urldir="http://downloads.kergis.com/kertex/" # trailing '/' requested

# Stop if error
#
set -e

test $# -le 1 || { echo "Usage: $0 [conf_file]."; exit 1; }

dir="$(pwd)" # we will download there; must be set.

my_conf=
if test $# -eq 1; then
	test -s $1 || { echo "Incorrect conf file: $1."; exit 2; }
	my_conf="$1"
fi

cat <<EOT

This script is for a Unix like OS (including Interix), and for
equality building: TARGET and MATRIX are of the same type.
Cross-compilation can be made by R.I.S.K., but this wrapper is 
for a common case.

Be sure to run me in a dir where there is enough space for the
sources unpacked (40 Mb will do; I will _not_ remove the bundle).

During the build, don't be afraid of some compiler warnings: these
are purely cosmetic ones, because the translation of Pascal in C
doesn't put extra braces when indenting if/else; or because D.E.
Knuth and Silvio Levy have written the CWEB programs so that they
can compile even on pre-ANSI C compilers (old prototypes).

Don't worry: if something is really wrong, the build fails...

Don't run me as root (Local Domain Administrator) now! (R.I.S.K. and 
the kerTeX package framework will refuse.)

Press ENTER to continue...
EOT

read ans # junk

cat <<EOT
When I prompt for an answer, the value displayed between square
brackets is the default: [default]. Just hitting ENTER will keep
it as is.

Press ENTER to continue...
EOT

read ans # junk

# System peculiarities.
#
if test -s /etc/slackware-version\
	-o -s /etc/fedora-release\
	-o -s /etc/gentoo-release\
	-o -s /etc/debian_version\
	-o -s /etc/alpine-release\
	-o -d /system/etc; then
	: ${SYS_FTPC:=lftp}
	: ${SYS_HTTPC:=lftp}
elif test "$(uname)" = Darwin; then
	: ${SYS_FTPC:=curl}
	: ${SYS_HTTPC:=curl}
elif test "$(uname)" = FreeBSD; then
	: ${SYS_FTPC:=fech}
	: ${SYS_HTTPC:=ftp}
else
	: ${SYS_FTPC:=ftp}
	: ${SYS_HTTPC:=ftp}
fi

printf "Client to use to retrieve a ressource by http? [$SYS_HTTPC] "
read ans
test "x$ans" = x || SYS_HTTPC="$ans"
echo

printf "Client to use to retrieve a ressource by ftp? [$SYS_FTPC] "
read ans
test "x$ans" = x || SYS_FTPC="$ans"
echo

export SYS_FTPC SYS_HTTPC

# Offer the choice between local and remote access to sources.
#
echo "Do you want to retrieve the latest sources on the website or shall"
printf "I use sources in the file hierarchy (http|dir)? [http] "
read ans

# Access via filesystem.
#
if test "x$ans" = xdir; then
  printf "Specify the dir: [$dir] "
  read ans
  test "x$ans" = x || dir="$ans"
  cd "$dir"
  for src in $sources; do
  	test -d $src || { echo "The $dir/$src directory doesn't exist!"; exit 3; }
  done
else # remote
  echo
  printf "Which version of the install doc do you want (en|fr)? [en] "
  
  read ans
  if test "x$ans" = xfr; then
  	doc=LISEZ.MOI
  else
  	doc=README
  fi
  
  printf "Which version of the sources do you want (stable|dev)? [stable] "
  
  read ans
  if test "x$ans" = xdev; then
  	bundle=kertex_bundle_dev
  else
  	bundle=kertex_bundle
  fi
  # Getting the files.
  #
  case $SYS_HTTPC in
  	lftp) lftp -c "get $urldir$doc -o $doc"
  		lftp -c "get ${urldir}${bundle}.tar -o ${bundle}.tar"
  		;;
	curl) $SYS_HTTPC -O $urldir$doc
		$SYS_HTTPC -O ${urldir}${bundle}.tar
		;;
  	*) $SYS_HTTPC $urldir$doc
  		$SYS_HTTPC ${urldir}${bundle}.tar
  		;;
  esac
  
  test -s ${bundle}.tar\
  	|| { echo; echo "Getting the bundle failed..."; exit 3; }
  
	echo "Unpacking the bundle. Please wait..."
  tar xf ${bundle}.tar
  
  for src in $sources; do
    gunzip ${src}_*.tar.gz
  	tar xf ${src}_*.tar
  	rm ${src}_*.tar
  done
fi # remote

# We have downloaded here or cd $dir, so the sources are here.

# Offer the choice to customize user, group and installation dir.
#
target=$(uname | tr ' 	[A-Z]' '__[a-z]')

. risk_comp/sys/posix/lib/T_$target

cat <<EOT

You can customize USER0 and GROUP0 in order to do an unprivileged
_installation_ (the build can be made under whoever user): install 
under a dir USER0 owns, or in which GROUP0 has write access. The
directory under which I will put the stuff (including which_kertex(1))
can be customized too.

The installation will switch to USER0 who needs to be able to mkdir
under TARGETOPTDIR where the kerTeX hierarchy will be installed.
If (and this is recommended) you are not a super-user (elevated
administrator under Windows) and own some dirs, it will be fine to
put the installation there.

EOT

echo

echo "Do you want to generate a HUGE MetaPost (for m3D)---may not be"
printf "possible on small Android devices--- (YES or NO)? [NO] "
read ans
test "x$ans" = x || HUGETEX="$ans"

echo 
printf "Add 2D graphic output to METAFONT (WITH_2D_MF, YES or NO)? [YES] "
read ans
test "x$ans" = x || WITH_2D_MF="$ans"

this=""
while test -z "$this"; do
	echo
	printf "Who will own the kerTeX hierarchy? [$USER0] "
	read this
	if test -z "$this"; then
		this="$USER0"
	elif id "$this" >/dev/null; then
		USER0="$this"
	else
		printf "\n!!! The user '$this' does not exist!!!\n" >&2
		this=""
	fi
done

these=$(id -Gn "$USER0")
this=""
while test -z "$this"; do
	echo
	printf "What group will own the kerTeX hierarchy? [$GROUP0] "
	read this
	test "x$this" != "x" || this="$GROUP0"
	if echo " $these " | grep -q " $this "; then  
		GROUP0="$this"
	else
		printf "\n!!! '$USER0' is not a member of '$this'!!!\n" >&2
		this=""
	fi
done

echo
printf "Under what directory will I put kerTeX (TARGETOPTDIR)? [$TARGETOPTDIR] "
read ans
test "x$ans" = x || TARGETOPTDIR=$ans

cat <<EOT

=====================================================================
                         !!!IMPORTANT!!!

I will put which_kertex(1) in:

  $TARGETOPTDIR/bin

which_kertex(1) has to be somewhere in the path for all the users,
precisely to know where kerTeX is... And it is used by the packaging
system to discover where to find the data and programs.

If you are doing an unprivileged installation, move after, perhaps
under a more privileged user, which_kertex(1) somewhere it can
normally be found under PATH. I will for now adjust the PATH for 
the building and the installation...

=====================================================================

Press ENTER to continue...
EOT

read ans # junk

# Be sure we will found _this_ which_kertex(1) for further building...
#
PATH="$TARGETOPTDIR/bin:$PATH"
export PATH

# Be sure to use the filename as a token (whether TMPDIR has whites
# or not...)
#
test "x$my_conf" != x\
	|| { my_conf="$TMPDIR/$$.kertex.conf"; cat /dev/null >"$my_conf"; }

# Add to the conf.
#
cat >>"$my_conf" <<EOT
USER0=$USER0
GROUP0=$GROUP0
TARGETOPTDIR=$TARGETOPTDIR
OBJDIRPREFIX=${OBJDIRPREFIX:-$TMPDIR}
TARGET_SUBTYPE=$TARGET_SUBTYPE
WITH_2D_MF=${WITH_2D_MF:-YES}
HUGETEX=${HUGETEX:-NO}
EOT

# Offer the choice to keep the C files.
#
echo
echo "By default, I will remove intermediary products to use the"
echo "minimal amount of space. Answer: NO to the following to keep"
echo "them (C files) instead."
printf "Remove intermediary products (SAVE_SPACE) (YES|NO)? [YES] "
read ans

test "x$ans" != x || ans=YES
save_space="$ans"

# Start compiling kertex_M.
#
echo
echo "Starting compilation of kertex_M"
# By default, the name is deduced from kertex_T objdir. So give the
# conf, even if it is of no use.
#
cd kertex_M
objdir="$($TARGETSHELL ../risk_comp/sys/posix/sh1/rkconfig $my_conf)" || exit 4
cd $objdir
make SAVE_SPACE="$save_space" all

# Then compile kertex_T.
echo
echo "Starting compilation of kertex_T"

cd "$dir"
cd kertex_T
objdir="$($TARGETSHELL ../risk_comp/sys/posix/sh1/rkconfig $my_conf)" || exit 5
cd $objdir
make SAVE_SPACE="$save_space" all

echo
printf "Do you want to install kerTeX here now? [Yn] "

read ans

test "x$ans" != x || ans=YES

case $ans in
	n|N|no|NO) make SAVE_SPACE="$save_space" pkg || { echo "Failed to build the package!"; exit 6; };
		echo;
		echo "I have built the package here: $PWD/PKG.tar";
		exit 0;
		;;
esac

# We are installing...
#
make SAVE_SPACE="$save_space" local_install \
	|| { echo "Installation failed! Please debug..."; exit 7; }


echo
printf "Retrieving latest pkgtools to see if there is an update:"
. which_kertex;
$KERTEX_SHELL $KERTEX_LIBDIR/pkg/rcp/tools@pkg.sh install
echo "pkgtools update: DONE"

echo
printf "Do you want to generate the dumps and the fonts now? [Yn] "

read ans

test "x$ans" != x || ans=YES

case $ans in
	n|N|no|NO) echo; echo "You can generate them later running: pkg/rcp/core@pkg.sh";
		;;
	*) $KERTEX_SHELL $KERTEX_LIBDIR/pkg/rcp/core@pkg.sh install
		;;
esac

echo
printf "Do you want to download all the recipes (to build pkg)? [Yn] "

read ans

test "x$ans" != x || ans=YES

case $ans in
	n|N|no|NO) echo; echo "You can download them later running: pkg/rcp/rcp@pkg.sh";
		;;
	*) $KERTEX_SHELL $KERTEX_LIBDIR/pkg/rcp/rcp@pkg.sh install
		;;
esac

exit 0

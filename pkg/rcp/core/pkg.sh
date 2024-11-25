#
#  Copyright 2010--2011, 2020--2021, 2024
#    Thierry LARONDE <tlaronde@polynum.com>
#  All rights reserved. 
#  
#  This work is under the KerGIS Public Licence v1.1
# 
#  See the COPYRIGHT file at the root of the source directory or see
#  http://www.kergis.com/ for complete information.
# 
# !!!THIS SOFTWARE IS PROVIDED ``AS IS'' WITHOUT ANY WARRANTIES!!! 
#                      USE IT AT YOUR OWN RISK 

# Needed post action (build, apply, remove) routines.
#
pkg_post_build()
{
	return 0
}

pkg_post_apply()
{
	return 0
}

pkg_post_remove()
{
	return 0
}

# Now the bulk of the pkg framework.
#
. which_kertex >&2

# Add the routines and let the library do the initializations for us.
#
. $KERTEX_BINDIR/lib/pkglib.sh

TMP_LIBDIR=$TMPDIR/lib
TMP_BINDIR=$TMPDIR/bin

mkdir -p $TMP_BINDIR/lib

KERTEXINPUTS="$TMP_LIBDIR;$KERTEX_LIBDIR/fonts/ams;KERTEXSYS"
KERTEXDUMP="$TMP_BINDIR/lib;KERTEXSYS"
KERTEXFONTS="$TMP_LIBDIR/fonts;KERTEXSYS"

export KERTEXINPUTS KERTEXDUMP KERTEXFONTS

cd $TMPDIR

#===== Extracting the embedded chunks.
#
# The lists of parameters files, for fonts to be built from METAFONT
# sources, are embedded in the script. Retrieve them before changing directory.
#
cmlist=$TMPDIR/cm.$$
ed $PKG_FQ_SCRIPT <<EOT >$PKG_NULL_FILE 2>&1
/^BEGIN_CMPARM/+,/^END_CMPARM/-w $cmlist
q
EOT
amslist=$TMPDIR/ams.$$
ed $PKG_FQ_SCRIPT <<EOT >$PKG_NULL_FILE 2>&1
/^BEGIN_AMSPARM/+,/^END_AMSPARM/-w $amslist
q
EOT
pstextlist=$TMPDIR/pstext.$$
ed $PKG_FQ_SCRIPT <<EOT >$PKG_NULL_FILE 2>&1
/^BEGIN_PSTEXT/+,/^END_PSTEXT/-w $pstextlist
q
EOT
psttlist=$TMPDIR/pstt.$$
ed $PKG_FQ_SCRIPT <<EOT >$PKG_NULL_FILE 2>&1
/^BEGIN_PSTT/+,/^END_PSTT/-w $psttlist
q
EOT
pstextsclist=$TMPDIR/pstextsc.$$
ed $PKG_FQ_SCRIPT <<EOT >$PKG_NULL_FILE 2>&1
/^BEGIN_PSTEXT_SC/+,/^END_PSTEXT_SC/-w $pstextsclist
q
EOT
psrawlist=$TMPDIR/psraw.$$
ed $PKG_FQ_SCRIPT <<EOT >$PKG_NULL_FILE 2>&1
/^BEGIN_PSRAW/+,/^END_PSRAW/-w $psrawlist
q
EOT

#===== METAFONT

pkg_log ""
pkg_log "1. Compiling METAFONT base (with supplementary modes)"
pkg_log ""
#
echo '\input plain \input modes \dump' | $KERTEX_BINDIR/inimf
mv plain.base $TMP_BINDIR/lib
mv plain.log $TMP_BINDIR/lib/mf.log
cp $KERTEX_BINDIR/virmf $TMP_BINDIR/mf

#===== Computer Modern

pkg_log ""
pkg_log "2. Generating Donald E. Knuth's Computer Modern fonts"
pkg_log ""
#
# The fonts (tfm and gf, and then pk) are put in subdirectories in
# $KERTEX_LIBDIR/fonts.
#
mkdir -p $TMP_LIBDIR/fonts/gf
cd $TMP_LIBDIR/fonts/gf
while read parm; do
	$TMP_BINDIR/mf "\\mode=ljfour; scrollmode; input $parm"
done <$cmlist
rm $cmlist

#
# Putting everything in place.
#
mkdir -p $TMP_LIBDIR/fonts/tfm
mv *.tfm $TMP_LIBDIR/fonts/tfm

#
# Generate pk. But after, we remove the *.gf since dvips and dvitype
# can deal with pk format.
#
mkdir -p $TMP_LIBDIR/fonts/pk
for file in *.*gf; do
	$KERTEX_BINDIR/gftopk $file
	rm $file # pk is sufficient
done
mv *.*pk $TMP_LIBDIR/fonts/pk

#
# Cleaning.
#
rm *.log

#===== TeX

pkg_log ""
pkg_log "3. Compiling TeX format (using Prote)"
pkg_log ""

cd $TMPDIR

$KERTEX_BINDIR/iniprote '\input plain \dump'
mv plain.dgst $TMP_BINDIR/lib
mv plain.log $TMP_BINDIR/lib/tex.log
cp $KERTEX_BINDIR/virprote $TMP_BINDIR/tex

#===== Black and gray fonts

pkg_log ""
pkg_log "4. Generating black and gray fonts for ljfour"
pkg_log ""

for parm in black.mf gray.mf; do
	$TMP_BINDIR/mf "\\mode=ljfour; scrollmode; input $parm"
	parm=${parm%.mf}
	$KERTEX_BINDIR/gftopk $parm.600gf
	rm $parm.600gf # pk is sufficient
	mv $parm.600pk $TMP_LIBDIR/fonts/pk
	mv $parm.tfm $TMP_LIBDIR/fonts/tfm
done

#===== AMS mf fonts

pkg_log ""
pkg_log "5. Generating AMS fonts described in METAFONT source format"
pkg_log ""
#
# The fonts (tfm and gf, and then pk) are put in subdirectories in
# $KERTEX_LIBDIR/fonts.
#
mkdir -p $TMP_LIBDIR/fonts/ams/pk
mkdir -p $TMP_LIBDIR/fonts/ams/gf
mkdir -p $TMP_LIBDIR/fonts/ams/tfm
while read parm; do
	$TMP_BINDIR/mf "\\mode=ljfour; scrollmode; input $parm"
	parm=${parm%.mf}
	if test "$parm" != dummy; then
		$KERTEX_BINDIR/gftopk $parm.600gf
		rm $parm.600gf # pk is sufficient
		mv $parm.600pk $TMP_LIBDIR/fonts/ams/pk
	fi
	mv $parm.tfm $TMP_LIBDIR/fonts/ams/tfm
done <$amslist

# Cleaning.
#
rm $amslist *.log

#===== MetaPost

pkg_log ""
pkg_log "6. Compiling plain MetaPost"
pkg_log ""
#
cd $TMPDIR
echo '\input plain \dump' | $KERTEX_BINDIR/inimp
mv plain.mem $TMP_BINDIR/lib
mv plain.log $TMP_BINDIR/lib/mpost.log
cp $KERTEX_BINDIR/virmp $TMP_BINDIR/mpost

#===== Adobe AFM to TFM

pkg_log ""
pkg_log "7. Creating tfm for Adobe Core PostScript text fonts (afm to tfm)."
pkg_log ""
#
IFS='|'
cd $TMP_LIBDIR/fonts/tfm
mkdir -p $TMP_LIBDIR/fonts/tfm/tex-latin1
mkdir -p $TMP_LIBDIR/fonts/vf/tex-latin1
enc="tex_text.enc"

mkdir -p $TMP_LIBDIR/dvips

cat <<"EOT" >$TMP_LIBDIR/dvips/psfonts.map
% These are all variants using PostScript Core normal fonts. This file
% is shared by dvips(1) and MetaPost, but in this latter case, only
% when sketching an autonomous PostScript file with prologues.
% Don't add here not resident fonts!
%
EOT

while read font extension slant vpl tfm sfx; do
	# First "traditionnal"; second kerTeX.
	#
	if test "$extension"; then
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -e $extension -v $vpl $font >>$TMP_LIBDIR/dvips/psfonts.map
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -e $extension -u -v tex-latin1/$font$sfx.vpl -T $enc tex-latin1/$font$sfx.tfm \
			| $PKG_SED 's!^!tex-latin1/!' >>$TMP_LIBDIR/dvips/psfonts.map
	elif test "$slant"; then
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -s $slant -v $vpl $font >>$TMP_LIBDIR/dvips/psfonts.map
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -s $slant -u -v tex-latin1/$font$sfx.vpl -T $enc tex-latin1/$font$sfx.tfm\
			| $PKG_SED 's!^!tex-latin1/!' >>$TMP_LIBDIR/dvips/psfonts.map

	else
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -v $vpl $font >>$TMP_LIBDIR/dvips/psfonts.map
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -u -v tex-latin1/$font$sfx.vpl -T $enc tex-latin1/$font$sfx.tfm\
			| $PKG_SED 's!^!tex-latin1/!' >>$TMP_LIBDIR/dvips/psfonts.map
	fi
	$KERTEX_BINDIR/vptovf $vpl.vpl ../vf/$vpl.vf $vpl.tfm
	$KERTEX_BINDIR/vptovf tex-latin1/$font$sfx.vpl ../vf/tex-latin1/$font$sfx.vf tex-latin1/$font$sfx.tfm
done <$pstextlist
rm $pstextlist

pkg_log ""
pkg_log "8. Creating tfm for Adobe Core PostScript teletype fonts (afm to tfm)."
pkg_log ""
#
enc="tex_tt.enc"
while read font extension slant vpl tfm sfx; do
	# First "traditionnal"; second kerTeX.
	#
	if test "$extension"; then
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -e $extension -v $vpl $font >>$TMP_LIBDIR/dvips/psfonts.map
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -e $extension -u -v tex-latin1/$font$sfx.vpl -T $enc tex-latin1/$font$sfx.tfm\
			| $PKG_SED 's!^!tex-latin1/!' >>$TMP_LIBDIR/dvips/psfonts.map
	elif test "$slant"; then
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -s $slant -v $vpl $font >>$TMP_LIBDIR/dvips/psfonts.map
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -s $slant -u -v tex-latin1/$font$sfx.vpl -T $enc tex-latin1/$font$sfx.tfm\
			| $PKG_SED 's!^!tex-latin1/!' >>$TMP_LIBDIR/dvips/psfonts.map

	else
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -v $vpl $font >>$TMP_LIBDIR/dvips/psfonts.map
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -u -v tex-latin1/$font$sfx.vpl -T $enc tex-latin1/$font$sfx.tfm\
			| $PKG_SED 's!^!tex-latin1/!' >>$TMP_LIBDIR/dvips/psfonts.map
	fi
	$KERTEX_BINDIR/vptovf $vpl.vpl ../vf/$vpl.vf $vpl.tfm
	$KERTEX_BINDIR/vptovf tex-latin1/$font$sfx.vpl ../vf/tex-latin1/$font$sfx.vf tex-latin1/$font$sfx.tfm
done <$psttlist
rm $psttlist

pkg_log ""
pkg_log "9. Creating tfm for Adobe Core PostScript small caps fonts (afm to tfm)."
pkg_log ""
#
enc="tex_tt.enc"
while read font extension slant vpl tfm sfx; do
	# First "traditionnal"; second kerTeX.
	#
	if test "$extension"; then
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -e $extension -V $vpl $font >>$TMP_LIBDIR/dvips/psfonts.map
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -e $extension -u -V tex-latin1/$font$sfx.vpl -T $enc tex-latin1/$font$sfx\
			| $PKG_SED 's!^!tex-latin1/!' >>$TMP_LIBDIR/dvips/psfonts.map
	elif test "$slant"; then
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -s $slant -V $vpl $font >>$TMP_LIBDIR/dvips/psfonts.map
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -s $slant -u -V tex-latin1/$font$sfx.vpl -T $enc tex-latin1/$font$sfx.tfm\
			| $PKG_SED 's!^!tex-latin1/!' >>$TMP_LIBDIR/dvips/psfonts.map

	else
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -V $vpl $font >>$TMP_LIBDIR/dvips/psfonts.map
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -u -V tex-latin1/$font$sfx.vpl -T $enc tex-latin1/$font$sfx.tfm\
			| $PKG_SED 's!^!tex-latin1/!' >>$TMP_LIBDIR/dvips/psfonts.map
	fi
	$KERTEX_BINDIR/vptovf $vpl.vpl ../vf/$vpl.vf $vpl.tfm
	$KERTEX_BINDIR/vptovf tex-latin1/$font$sfx.vpl ../vf/tex-latin1/$font$sfx.vf tex-latin1/$font$sfx.tfm
done <$pstextsclist
rm $pstextsclist

pkg_log ""
pkg_log "10. Creating tfm for Adobe Core PostScript symbol fonts (afm to tfm)."
pkg_log ""
#
while read font extension slant vpl tfm sfx; do
	# Only "traditionnal"; no kerTeX variant for now.
	#
	if test "$extension"; then
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -e $extension -v $vpl $font >>$TMP_LIBDIR/dvips/psfonts.map
	elif test "$slant"; then
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -s $slant -v $vpl $font >>$TMP_LIBDIR/dvips/psfonts.map
	else
		$KERTEX_BINDIR/afm2tfm adobe/315/$font.afm -v $vpl $font >>$TMP_LIBDIR/dvips/psfonts.map
	fi
	$KERTEX_BINDIR/vptovf $vpl.vpl ../vf/$vpl.vf $vpl.tfm
done <$psrawlist
rm $psrawlist
unset IFS # back to default

#===== e-TeX

pkg_log ""
pkg_log "11a) Generating e-TeX font."
pkg_log ""
#
# The tfm.
#
mkdir $TMP_LIBDIR/fonts/gf/etex
cd $TMP_LIBDIR/fonts/gf/etex

$TMP_BINDIR/mf "\\mode=ljfour; scrollmode; input etex/xbmc10"

mkdir $TMP_LIBDIR/fonts/tfm/etex
mv xbmc10.tfm $TMP_LIBDIR/fonts/tfm/etex

# The pk.
#
$KERTEX_BINDIR/gftopk etex/xbmc10.600gf
rm $TMP_LIBDIR/fonts/gf/etex/xbmc10.600gf
mkdir $TMP_LIBDIR/fonts/pk/etex
mv xbmc10.600pk $TMP_LIBDIR/fonts/pk/etex

rm xbmc10.log

pkg_log ""
pkg_log "11b) Creating e-TeX digest (with Prote's extensions)."
pkg_log ""
#

$KERTEX_BINDIR/iniprote '**etex.src \dump'
mv etex.dgst $TMP_BINDIR/lib
mv etex.log $TMP_BINDIR/lib
cp $KERTEX_BINDIR/virprote $TMP_BINDIR/etex

pkg_do_action

exit 0

# This part is not processed by the shell, exiting above, and has our
# data. First the rcp CID; then the customized list of various 
# parameters to be processed by this very recipe.
#
BEGIN_CID
NAME: pkg/core
LICENCE: kerTeX Public Licence 1.0
DESCRIPTION: Compiling the dumps and generating the fonts for the core
of kerTeX.
KXPATH:
	fonts ams
END:
END_CID

BEGIN_CMPARM
cmb10.mf
cmbsy10.mf
cmbx10.mf
cmbx12.mf
cmbx5.mf
cmbx6.mf
cmbx7.mf
cmbx8.mf
cmbx9.mf
cmbxsl10.mf
cmbxti10.mf
cmcsc10.mf
cmdunh10.mf
cmex10.mf
cmff10.mf
cmfi10.mf
cmfib8.mf
cmitt10.mf
cmmi10.mf
cmmi12.mf
cmmi5.mf
cmmi6.mf
cmmi7.mf
cmmi8.mf
cmmi9.mf
cmmib10.mf
cmr10.mf
cmr12.mf
cmr17.mf
cmr5.mf
cmr6.mf
cmr7.mf
cmr8.mf
cmr9.mf
cmsl10.mf
cmsl12.mf
cmsl8.mf
cmsl9.mf
cmsltt10.mf
cmss10.mf
cmss12.mf
cmss17.mf
cmss8.mf
cmss9.mf
cmssbx10.mf
cmssdc10.mf
cmssi10.mf
cmssi12.mf
cmssi17.mf
cmssi8.mf
cmssi9.mf
cmssq8.mf
cmssqi8.mf
cmsy10.mf
cmsy5.mf
cmsy6.mf
cmsy7.mf
cmsy8.mf
cmsy9.mf
cmtcsc10.mf
cmtex10.mf
cmtex8.mf
cmtex9.mf
cmti10.mf
cmti12.mf
cmti7.mf
cmti8.mf
cmti9.mf
cmtt10.mf
cmtt12.mf
cmtt8.mf
cmtt9.mf
cmu10.mf
cmvtt10.mf
cminch.mf
manfnt.mf
logo8.mf
logo9.mf
logo10.mf
logobf10.mf
logosl10.mf
END_CMPARM

# Same thing for AMS fonts provided as METAFONT sources.
BEGIN_AMSPARM
wncyb10.mf
wncyb5.mf
wncyb6.mf
wncyb7.mf
wncyb8.mf
wncyb9.mf
wncyi10.mf
wncyi5.mf
wncyi6.mf
wncyi7.mf
wncyi8.mf
wncyi9.mf
wncyr10.mf
wncyr5.mf
wncyr6.mf
wncyr7.mf
wncyr8.mf
wncyr9.mf
wncysc10.mf
wncyss10.mf
wncyss8.mf
wncyss9.mf
cmmib9.mf
cmmib8.mf
cmmib7.mf
cmmib6.mf
cmmib5.mf
cmex9.mf
cmex8.mf
cmex7.mf
cmcsc8.mf
cmcsc9.mf
cmbsy9.mf
cmbsy8.mf
cmbsy7.mf
cmbsy6.mf
cmbsy5.mf
cmcsc8.mf
cmcsc9.mf
msbm10.mf
msbm5.mf
msbm6.mf
msbm7.mf
msbm8.mf
msbm9.mf
msam10.mf
msam5.mf
msam6.mf
msam7.mf
msam8.mf
msam9.mf
dummy.mf
END_AMSPARM

# We create virtual fonts and TFM files for PostScript core fonts (afm
# published by Adobe). The virtual fonts map the characters in the `raw'
# font so giving the opportunity to use whatever encoding at the TeX
# level.
BEGIN_PSTEXT
ITCAvantGarde-Book|||pagk|rpagk|
ITCAvantGarde-BookOblique|||pagko|rpagko|
ITCAvantGarde-Demi|||pagd|rpagd|
ITCAvantGarde-DemiOblique|||pagdo|rpagdo|
ITCBookman-Demi|||pbkd|rpbkd|
ITCBookman-DemiItalic|||pbkdi|rpbkdi|
ITCBookman-Light|||pbkl|rpbkl|
ITCBookman-LightItalic|||pbkli|rpbkli|
Helvetica-Bold|||phvb|rphvb|
Helvetica-BoldOblique|||phvbo|rphvbo|
Helvetica-Bold|.82||phvbrn|rphvbrn|_c
Helvetica-BoldOblique|.82||phvbon|rphvbon|_c
Helvetica-Oblique|.82||phvron|rphvron|_c
Helvetica|.82||phvrrn|rphvrrn|_c
Helvetica-Oblique|||phvro|rphvro|
Helvetica|||phvr|rphvr|
NewCenturySchlbk-Bold|||pncb|rpncb|
NewCenturySchlbk-BoldItalic|||pncbi|rpncbi|
NewCenturySchlbk-Italic|||pncri|rpncri|
NewCenturySchlbk-Roman|||pncr|rpncr|
Palatino-Bold|||pplb|rpplb|
Palatino-BoldItalic|||pplbi|rpplbi|
Palatino-BoldItalic||-.1763|pplbu|rpplbu|_u
Palatino-Roman|.82||pplrrn|rpplrrn|_c
Palatino-Roman|1.2||pplrre|rpplrre|_e
Palatino-Italic|||pplri|rpplri|
Palatino-Roman||.167|pplro|rpplro|_o
Palatino-Roman|||pplr|rpplr|
Palatino-Italic||-.1763|pplru|rpplru|_u
Times-Bold|||ptmb|rptmb|
Times-BoldItalic|||ptmbi|rptmbi|
Times-Roman|.8||ptmrrn|rptmrrn|_c
Times-Roman|1.2||ptmrre|rptmrre|_e
Times-Italic|||ptmri|rptmri|
Times-Roman||.167|ptmro|rptmro|_o
Times-Bold||.167|ptmbo|rptmbo|_o
Times-Roman|||ptmr|rptmr|
ITCZapfChancery-MediumItalic|||pzcmi|rpzcmi|
END_PSTEXT
BEGIN_PSTT
Courier-Bold|||pcrb|rpcrb|
Courier-BoldOblique|||pcrbo|rpcrbo|
Courier-Oblique|||pcrro|rpcrro|
Courier|||pcrr|rpcrr|
END_PSTT
BEGIN_PSTEXT_SC
ITCAvantGarde-Book|||pagkc|rpagk|_sc
ITCBookman-Light|||pbklc|rpbkl|_sc
NewCenturySchlbk-Roman|||pncrc|rpncr|_sc
Palatino-Roman|||pplrc|rpplr|_sc
Times-Roman|||ptmrc|rptmr|_sc
END_PSTEXT_SC
BEGIN_PSRAW
Symbol||.167|psyro|rpsyro|_o
Symbol|||psyr|rpsyr|
ZapfDingbats|||pzdr|rpzdr|
END_PSRAW

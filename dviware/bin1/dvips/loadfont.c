/*
 *	Here's the code to load a PK file into memory.
 *	Individual bitmaps won't be unpacked until they prove to be needed.
 */
#include "dvips.h" /* The copyright notice in that file is included too! */
char errbuf[200];
int lastresortsizes[40];
FILE *pkfile;

static void badpk(char *s);
static shalfword pkbyte(void);
static integer pkquad(void);
static integer pktrio(void);
static void lectureuser(void);
static Boolean pkopen(register fontdesctype *fd);

/*
 *	Now we have some routines to get stuff from the PK file.
 *	Subroutine pkbyte returns the next byte.
 */

void
badpk(char *s)
{
	(void)sprintf(errbuf,"! Bad PK file %s: %s",(char *)nameoffile+1,s);
	error(errbuf);
}

shalfword
pkbyte(void)
{
	register shalfword i;

	if ((i=getc(pkfile))==EOF)
		badpk("unexpected eof");
	return(i);
}

integer
pkquad(void)
{
	register integer i;

	i = pkbyte();
	if (i > 127)
		i -= 256;
	i = i * 256 + pkbyte();
	i = i * 256 + pkbyte();
	i = i * 256 + pkbyte();
	return(i);
}

integer
pktrio(void)
{
	register integer i;

	i = pkbyte();
	i = i * 256 + pkbyte();
	i = i * 256 + pkbyte();
	return(i);
}

Boolean do_makefont = false; /* if makefont fails once we won't try again */

void
lectureuser(void)
{
	static int userwarned = 0;

	if (! userwarned) {
		error("Such scaling will generate extremely poor output.");
		userwarned = 1;
	}
}

/* We first initialize the searching path. The hints embedded in the
	path are no longer supported (adjust directly the paths).
	If the name is an absolute pathname, no processing needs to be done.
	If it is not, after initialization, we search for the related file
	and make the font (if do_makefont is set) if not found. [TL]
 */
Boolean
pkopen(register fontdesctype *fd)
{
	unsigned int pathspec;

	/* initializations */
	if (fd->area != NULL && *fd->area != '\0') {
		free(dump);
		dump = pathSet(fd->area);
		pathspec = DUMPPATHSPEC;
	} else
		pathspec = FONTSPATHSPEC | PKSUBDIR;
	
	/* Try to find existing best resolution match. The name of the
		pk file (since it is raster glyphes and not strokes) is
		supposed to be encoded in the name. [TL]
	 */
	{
		int del;
		for (del=0; del<=RES_TOLERANCE(fd->dpi); del=del>0?-del:-del+1) {
			/* nameSet() by hand... */
			if (strlen(fd->name) > (filenamesize - 13))
				error("!Font file name too long!");
			(void)sprintf((char *)(nameoffile+1), "%s.%dpk", 
				fd->name, fd->dpi + del);
			namelength = strlen((char *)(nameoffile+1));
			if (Openin(&pkfile, pathspec, "rb") == true)
				return(1);
		}
	}

	/* We are here if we have not found an exact or approximate matching
	  resolution of the font. If we are allowed to try to make the
	  font, we will set the resolution from the
	  actualdpi without approximation and try to make it. [TL]
	*/
	if ( fd->area == NULL || *fd->area == '\0' ) {	/* FONTSPATHSPEC */
		/* nameSet() by hand... */
		if (strlen(fd->name) > (filenamesize - 13))
			error("!Font file name too long!");
		(void)sprintf((char *)(nameoffile+1), "%s.%dpk",
			fd->name, fd->dpi);
		namelength = strlen((char*)(nameoffile+1));
		makefont(fd->name, (int)fd->dpi, DPI); /* do only if do_makefont */
		if (Openin(&pkfile, pathspec, "rb") == true)
			return(1);
		do_makefont = false;		 /* failed so don't try anymore */
	}
/*
 *	If nothing above worked, then we get desparate.  We attempt to
 *	open the stupid font at one of a small set of predefined sizes,
 *	and then use PostScript scaling to generate the correct size.
 *
 *	We much prefer scaling up to scaling down, since scaling down
 *	can omit character features, so we try the larger sizes first,
 *	and then work down.
 */
	{
		int i, j;

		if (lastresortsizes[0] && fd->dpi < 30000) {
			for (i=0; lastresortsizes[i] < fd->dpi; i++);
			for (j = i-1; j >= 0; j--) {
				if (strlen(fd->name) > (filenamesize - 13))
					error("!Font file name too long!");
				(void)sprintf((char *)(nameoffile+1), "%s.%dpk",
					fd->name, lastresortsizes[j]);
				namelength = strlen((char *)(nameoffile+1));
				if (Openin(&pkfile, pathspec, "rb") == true) {
					fd->loadeddpi = lastresortsizes[j];
					fd->alreadyscaled = 0;
					(void)sprintf(errbuf,
						"Font %s at %d dpi not found; scaling %d instead.",
						fd->name, fd->dpi, lastresortsizes[j]);
					error(errbuf);
					lectureuser();
					return 1;
				}
			}
			for (j = i; lastresortsizes[j] < 30000; j++) {
				if (strlen(fd->name) > (filenamesize - 13))
					error("!Font file name too long!");
				(void)sprintf((char *)(nameoffile+1), "%s.%dpk",
					fd->name, lastresortsizes[j]);
				namelength = strlen((char *)(nameoffile+1));
				if (Openin(&pkfile, pathspec, "rb") == true) {
					fd->loadeddpi = lastresortsizes[j];
					fd->alreadyscaled = 0;
					(void)sprintf(errbuf,
						"Font %s at %d dpi not found; scaling %d instead.",
						(char *)nameoffile+1, fd->dpi, lastresortsizes[j]);
					error(errbuf);
					lectureuser();
					return 1;
				}
			}
		}
	}
	(void)sprintf(errbuf,
		"Font %s%s.%dpk not found, characters will be left blank.",
		(fd->area == NULL)? "<KERTEXFONTS>" : fd->area, fd->name, fd->dpi);
	error(errbuf);
	return(0);
}

/*
 *	Now our loadfont routine.  We return an integer indicating the
 *	highest character code in the font, so we know how much space
 *	to reserve for the character.  (It's returned in the font
 *	structure, along with everything else.)
 */
void
loadfont(register fontdesctype *curfnt)
{
	register shalfword i;
	register shalfword cmd;
	register integer k;
	register integer length = 0;
	register shalfword cc = 0;
	register integer scaledsize = curfnt->scaledsize;
	register quarterword *tempr;
	register chardesctype *cd = 0;
	int maxcc = 0;
	int munged = 0;
/*
 *	We clear out some pointers:
 */
	if (curfnt->loaded == 3) {
		for (i=0; i<256; i++) {
			curfnt->chardesc[i].TFMwidth = 0;
			curfnt->chardesc[i].packptr = NULL;
			curfnt->chardesc[i].pixelwidth = 0;
			curfnt->chardesc[i].flags &= EXISTS;
		}
	} else {
		for (i=0; i<256; i++) {
			curfnt->chardesc[i].TFMwidth = 0;
			curfnt->chardesc[i].packptr = NULL;
			curfnt->chardesc[i].pixelwidth = 0;
			curfnt->chardesc[i].flags = 0;
		}
	}
	curfnt->maxchars = 256; /* just in case we return before the end */
	if (!pkopen(curfnt)) {
		tfmload(curfnt);
		return;
	}
#ifdef DEBUG
	if (dd(D_FONTS))
		(void)fprintf(stderr,"Loading pk font %s at %.1fpt\n",
			(char *)nameoffile+1, (real)scaledsize/(alpha*0x100000));
#endif /* DEBUG */
	if (pkbyte()!=247)
		badpk("expected pre");
	if (pkbyte()!=89)
		badpk("wrong id byte");
	for(i=pkbyte(); i>0; i--)
		(void)pkbyte();
	k = (integer)(alpha * (real)pkquad());
	if (k > curfnt->designsize + fsizetol ||
		 k < curfnt->designsize - fsizetol) {
		(void)sprintf(errbuf,"Design size mismatch in font %s", 
		(char *)nameoffile+1);
		error(errbuf);
	}
	k = pkquad();
	if (k && curfnt->checksum)
		if (k!=curfnt->checksum) {
			(void)sprintf(errbuf,"Checksum mismatch in font %s", 
			(char *)nameoffile+1);
			error(errbuf);
		 }
	k = pkquad(); /* assume that hppp is correct in the PK file */
	k = pkquad(); /* assume that vppp is correct in the PK file */
/*
 *	Now we get down to the serious business of reading character definitions.
 */
	while ((cmd=pkbyte())!=245) {
		if (cmd < 240) {
			switch (cmd & 7) {
case 0: case 1: case 2: case 3:
				length = (cmd & 7) * 256 + pkbyte() - 3;
				cc = pkbyte();
				cd = curfnt->chardesc+cc;
				if (nosmallchars || curfnt->dpi != curfnt->loadeddpi)
					cd->flags |= BIGCHAR;
				cd->TFMwidth = scalewidth(pktrio(), scaledsize);
				cd->pixelwidth = pkbyte();
				break;
case 4: case 5: case 6:
				length = (cmd & 3) * 65536L + pkbyte() * 256L;
				length = length + pkbyte() - 4L;
				cc = pkbyte();
				cd = curfnt->chardesc+cc;
				cd->TFMwidth = scalewidth(pktrio(), scaledsize);
				cd->flags |= BIGCHAR;
				i = pkbyte();
				cd->pixelwidth = i * 256 + pkbyte();
				break;
case 7:
				length = pkquad() - 11;
				cc = pkquad();
				if (cc<0 || cc>255) badpk("character code out of range");
				cd = curfnt->chardesc + cc;
				cd->flags |= BIGCHAR;
				cd->TFMwidth = scalewidth(pkquad(), scaledsize);
				cd->pixelwidth = (pkquad() + 32768) >> 16;
				k = pkquad();
			}
			if (cd->pixelwidth == 0 && cd->TFMwidth != 0) {
				if (cd->TFMwidth > 0)
					k = (integer)(cd->TFMwidth * conv + 0.5);
				else
					k = -(integer)(-cd->TFMwidth * conv + 0.5);
				if (k != 0) {
					cd->pixelwidth = k;
					munged++;
				}
			}
			if (length <= 0)
				badpk("packet length too small");
			if (dopprescan && ((cd->flags & EXISTS) == 0)) {
				for (length--; length>0; length--)
					(void)pkbyte();
			} else {
				if (cc > maxcc)
					maxcc = cc;
				if (bytesleft < length || (length > MINCHUNK && compressed)) {
#ifdef DEBUG
					 if (dd(D_MEM))
						 (void)fprintf(stderr,
							 "Allocating new raster memory (%ld req, %ld left)\n",
											  (long)length, (long)bytesleft);
#endif /* DEBUG */
					 if (length > MINCHUNK) {
						 tempr = (quarterword *)mymalloc((size_t)length);
					 } else {
						 raster = (quarterword *)mymalloc(RASTERCHUNK);
						 tempr = raster;
						 bytesleft = RASTERCHUNK - length;
						 raster += length;
					}
				} else {
					tempr = raster;
					bytesleft -= length;
					raster += length;
				}
				cd->packptr = tempr;
				*tempr++ = cmd;
				for (length--; length>0; length--)
					*tempr++ = pkbyte();
			}
		} else {
			k = 0;
			switch (cmd) {
case 243:
				k = pkbyte();
				if (k > 127)
					k -= 256;
case 242:
				k = k * 256 + pkbyte();
case 241:
				k = k * 256 + pkbyte();
case 240:
				k = k * 256 + pkbyte();
				while (k-- > 0)
					i = pkbyte();
				break;
case 244:
				k = pkquad();
				break;
case 246:
				break;
default:
				badpk("! unexpected command");
			}
		}
	}
	(void)fclose(pkfile);
	curfnt->loaded = 1;
	curfnt->maxchars = maxcc + 1;
	if (munged > 0) {
		static int seen = 0;
		sprintf(errbuf,
			 "Font %s at %d dpi has most likely been made improperly;",
			  curfnt->name, curfnt->dpi);
		error(errbuf);
		if (seen)
			return;
		seen = 1;
		sprintf(errbuf,
	  "%d characters have 0 escapements but non-trivial TFM widths.", munged);
		error(errbuf);
		error(
			 "I'm stumbling along as best I can, but I recommend regenerating");
		error(
			 "these fonts; the problem is probably that they are non-CM fonts");
		error(
			 "(such as circle10 or line10) created with a MF with the CM base");
		error("preloaded .");
	}
}

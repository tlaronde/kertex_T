/*
 *	Here's the code to load a VF file into memory.
 *	Any resemblance between this file and loadfont.c is purely uncoincidental.
 */
#include "dvips.h" /* The copyright notice in that file is included too! */
/*
 *	Now we have some routines to get stuff from the VF file.
 *	Subroutine vfbyte returns the next byte.
 */
static FILE *vffile;

static void badvf(char *s);
static shalfword vfbyte(void);
static integer vfquad(void);
static integer vftrio(void);
static Boolean vfopen(register fontdesctype *fd);
static fontmaptype * vfontdef(integer s, int siz);

void
badvf(char *s)
{
	(void)sprintf(errbuf,"! Bad VF file %s: %s",(char *)nameoffile+1,s);
	error(errbuf);
}

shalfword
vfbyte(void)
{
	register shalfword i;

	if ((i=getc(vffile))==EOF)
		badvf("unexpected eof");
	return(i);
}

integer
vfquad(void)
{
	register integer i;

	i = vfbyte();
	if (i > 127)
		i -= 256;
	i = i * 256 + vfbyte();
	i = i * 256 + vfbyte();
	i = i * 256 + vfbyte();
	return(i);
}

integer
vftrio(void)
{
	register integer i;

	i = vfbyte();
	i = i * 256 + vfbyte();
	i = i * 256 + vfbyte();
	return(i);
}

Boolean
vfopen(register fontdesctype *fd)
{
	unsigned int pathspec;

	if (fd->area != NULL && *fd->area != '\0') {
		free(dump);
		dump = pathSet(fd->area);
		pathspec = DUMPPATHSPEC;
	} else
		pathspec = FONTSPATHSPEC | VFSUBDIR;
	
	/* nameSet() by hand... */
	if (strlen(fd->name) > (filenamesize - 3))
		error("!Font file name too long!");
	 (void)sprintf((char *)(nameoffile+1), "%s.vf", fd->name);
	namelength = strlen(fd->name) + 3;
	if (Openin(&vffile, pathspec, "rb") == true)
	 	return(1);
	return(0);
}

/*
 * The following routine is like fontdef, but for local fontdefs in VF files.
 */
fontmaptype *
vfontdef(integer s, int siz)
{
	register integer i, j, fn;
	register fontdesctype *fp;
	register fontmaptype *cfnt;
	char *nam, *area;
	integer cksum, scsize, dssize;

	fn = vfbyte();
	while (siz-- > 1)
		fn = (fn << 8) + vfbyte();
	cfnt = (fontmaptype *)mymalloc(sizeof(fontmaptype));
	cfnt->fontnum = fn;
	cksum = vfquad();
	scsize = scalewidth(s, vfquad());
	dssize = (integer)(alpha * (real)vfquad());
	i = vfbyte(); j = vfbyte();
	if (nextstring + i + j > maxstring)
		error("! out of string space");
	area = nextstring;
	*nextstring++ = 0;
	nam = nextstring;
	for (; i>0; i--)
		*nextstring++ = vfbyte();
	for (; j>0; j--)
		*nextstring++ = vfbyte();
	*nextstring++ = 0;
	fp = matchfont(nam, area, scsize, (char *)0);
	if (fp) {
		nextstring = nam;
		fp->checksum = cksum;
	} else {
		fp = newfontdesc(cksum, scsize, dssize, nam, area);
		fp->next = fonthead;
		fonthead = fp;
	}
	cfnt->desc = fp;
	return (cfnt);
}

/*
 *	Now our virtualfont routine.
 */
Boolean
virtualfont(register fontdesctype *curfnt)
{
	register shalfword i;
	register shalfword cmd;
	register integer k;
	register long length;
	register shalfword cc;
	register chardesctype *cd;
	integer scaledsize = curfnt->scaledsize;
	register quarterword *tempr;
	fontmaptype *fm, *newf;

	if (!vfopen(curfnt))
		return (0);
#ifdef DEBUG
	if (dd(D_FONTS))
		(void)fprintf(stderr,"Loading virtual font %s at %.1fpt\n",
			(char *)nameoffile+1, (real)scaledsize/(alpha*0x100000));
#endif /* DEBUG */

/*
 *	We clear out some pointers:
 */
	for (i=0; i<256; i++) {
		curfnt->chardesc[i].TFMwidth = 0;
		curfnt->chardesc[i].packptr = NULL;
		curfnt->chardesc[i].pixelwidth = 0;
		curfnt->chardesc[i].flags = 0;
	}
	if (vfbyte()!=247)
		badvf("expected pre");
	if (vfbyte()!=202)
		badvf("wrong id byte");
	for(i=vfbyte(); i>0; i--)
		(void)vfbyte();
	k = vfquad();
	if (k && curfnt->checksum)
		if (k!=curfnt->checksum) {
			(void)sprintf(errbuf,"Checksum mismatch in font %s",
			  (char *)nameoffile+1);
			error(errbuf);
		 }
	k = (integer)(alpha * (real)vfquad());
	if (k > curfnt->designsize + 2 || k < curfnt->designsize - 2) {
		(void)sprintf(errbuf,"Design size mismatch in font %s",
		  (char *)nameoffile+1);
		error(errbuf);
	}
/*
 * Now we look for font definitions.
 */
	fm = NULL;
	while ((cmd=vfbyte())>=243) {
		if (cmd>246)
			badvf("unexpected command in preamble");
		newf = vfontdef(scaledsize, cmd-242);
		if (fm)
			fm->next = newf;
		else curfnt->localfonts = newf;
		fm = newf;
		fm->next = NULL; /* FIFO */
	}
/*
 *	Now we get down to the serious business of reading character definitions.
 */
	do {
		if (cmd==242) {
			length = vfquad() + 2;
			if (length<2) badvf("negative length packet");
			if (length>65535) badvf("packet too long");
			cc = vfquad();
			if (cc<0 || cc>255) badvf("character code out of range");
			cd = curfnt->chardesc + cc;
			cd->TFMwidth = scalewidth(vfquad(), scaledsize);
		} else {
			length = cmd + 2;
			cc = vfbyte();
			cd = curfnt->chardesc + cc;
			cd->TFMwidth = scalewidth(vftrio(), scaledsize);
		}
		if (cd->TFMwidth >= 0)
			cd->pixelwidth = ((integer)(conv*cd->TFMwidth+0.5));
		else
			cd->pixelwidth = -((integer)(conv*-cd->TFMwidth+0.5));
		cd->flags = EXISTS;
		if (bytesleft < length) {
#ifdef DEBUG
			 if (dd(D_MEM))
				 (void)fprintf(stderr,
						 "Allocating new raster memory (%ld req, %ld left)\n",
										  length, bytesleft);
#endif /* DEBUG */
			 if (length > MINCHUNK) {
				 tempr = (quarterword *)mymalloc((size_t)length);
				 bytesleft = 0;
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
		length -= 2;
		*tempr++ = length / 256;
		*tempr++ = length % 256;
			for (; length>0; length--)
				*tempr++ = vfbyte();
		cmd = vfbyte();
	} while (cmd < 243);
	if (cmd != 248)
		badvf("missing postamble");
	(void)fclose(vffile);
	curfnt->loaded = 2;
	return (1);
}

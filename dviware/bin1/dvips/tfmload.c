/*
 *	Loads a tfm file.  It marks the characters as undefined.
 */
#include "dvips.h" /* The copyright notice in that file is included too! */

FILE *tfmfile; 

static shalfword tfmbyte(void);

/*
 *	Tries to open a tfm file.  Uses cmr10.tfm if unsuccessful,
 *	and complains loudly about it.
 */
void
tfmopen(register fontdesctype *fd)
{
	unsigned int pathspec;

	if (fd->area != NULL && *fd->area != '\0') {
		free(dump);
		dump = pathSet(fd->area);
		pathspec = DUMPPATHSPEC;
	} else
		pathspec = FONTSPATHSPEC | TFMSUBDIR;
	/* nameSet() by hand... */
	if (strlen(fd->name) > (filenamesize - 4))
		error("!Font file name too long!");
	(void)sprintf((char *)(nameoffile+1), "%s.tfm", fd->name);
	namelength = strlen((char *)(nameoffile+1));
	(void)Openin(&tfmfile, pathspec, "rb");
	if (tfmfile ==NULL) {
		(void)sprintf(errbuf, "Can't open font metric file %s/%s",
				 fd->area, (char *)nameoffile+1);
		error(errbuf);
		error("I will use cmr10.tfm instead, so expect bad output.");
		nameSet("cmr10.tfm");
		(void)Openin(&tfmfile, FONTSPATHSPEC | TFMSUBDIR, "rb");
		if (tfmfile == NULL)
			error(
			 "! I can't find cmr10.tfm; please reinstall me with proper paths");
	}
}

shalfword
tfmbyte(void)
{
  return(getc(tfmfile));
}

halfword
tfm16(void)
{
  register halfword a; 
  a = tfmbyte (); 
  return ( a * 256 + tfmbyte () ); 
} 

integer
tfm32(void)
{
  register integer a; 
  a = tfm16 (); 
  if (a > 32767) a -= 65536;
  return ( a * 65536 + tfm16 () ); 
} 

int
tfmload(register fontdesctype *curfnt)
{
	register shalfword i;
	register integer li;
	integer scaledsize;
	shalfword nw, hd;
	shalfword bc, ec;
	integer scaled[256];
	halfword chardat[256];
	int charcount = 0;

	tfmopen(curfnt);
/*
 *	Next, we read the font data from the tfm file, and store it in
 *	our own arrays.
 */
	li = tfm16(); hd = tfm16();
	bc = tfm16(); ec = tfm16();
	nw = tfm16();
	li = tfm32(); li = tfm32(); li = tfm32(); li = tfm16();
	li = tfm32();
	if (li && curfnt->checksum)
		if (li!=curfnt->checksum) {
			(void)sprintf(errbuf,"Checksum mismatch in %s", 
			  (char *)nameoffile+1);
			error(errbuf);
		 }
	li = (integer)(alpha * (real)tfm32());
	if (li > curfnt->designsize + fsizetol ||
		 li < curfnt->designsize - fsizetol) {
		(void)sprintf(errbuf,"Design size mismatch in %s",
		  (char *)nameoffile+1);
		error(errbuf);
	}
	for (i=2; i<hd; i++)
		li = tfm32();
	for (i=0; i<256; i++)
		chardat[i] = 256;
	for (i=bc; i<=ec; i++) {
		chardat[i] = tfmbyte();
		li = tfm16();
		li |= tfmbyte();
		if (li || chardat[i])
			charcount++;
	}
	scaledsize = curfnt->scaledsize;
	for (i=0; i<nw; i++)
		scaled[i] = scalewidth(tfm32(), scaledsize);
	(void)fclose(tfmfile);
	for (i=0; i<256; i++)
		if (chardat[i]!= 256) {
			li = scaled[chardat[i]];
			curfnt->chardesc[i].TFMwidth = li;
			if (li >= 0)
				curfnt->chardesc[i].pixelwidth = ((integer)(conv*li+0.5));
			else
				curfnt->chardesc[i].pixelwidth = -((integer)(conv*-li+0.5));
			curfnt->chardesc[i].flags = (curfnt->resfont ? EXISTS : 0);
		}
	curfnt->loaded = 1;
	return charcount;
}

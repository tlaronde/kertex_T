/*
 *	This is the main routine for the first (prescanning) pass.
 */
#include "dvips.h" /* The copyright notice in that file is included too! */
/*
 *	This routine handles the processing of the preamble in the dvi file.
 */
void
readpreamble(void)
{
	register int i;
	char *p;

	if (dvibyte()!=247) error("! Bad DVI file: first byte not preamble");
	if (dvibyte()!=2) error("! Bad DVI file: id byte not 2");
	num = signedquad();
	den = signedquad();
	if (overridemag > 0) (void)signedquad();
	else if (overridemag < 0) mag = (mag * signedquad() + 500) / 1000;
	else mag = signedquad();
	conv = (real) num * DPI * mag / ( den * 254000000.0 ); 
	vconv = (real) num * VDPI * mag / ( den * 254000000.0 ); 
	alpha = (((real)den / 7227.0) / 0x100000) * (25400000.0 / (real) num);
	fsizetol = 1 + (integer)(DPI/(72270.0 * conv));
	if (!pprescan) {
	  for (i=dvibyte(),p=preamblecomment;i>0;i--,p++) *p=dvibyte();
	  *p='\0';
	  if (!quiet) {
		  (void)fprintf(stderr, "'");
			if (strncmp(SYSTEM_ENCODING, RK_ICONV_EBCDIC, 6U) == 0) {
		  	for(p=preamblecomment;*p;p++) 
				(void)putc((char)ascii2ebcdic[(unsigned char)*p], stderr);
		} else {
		  	for(p=preamblecomment;*p;p++) (void)putc(*p, stderr)
				;
		}
		  (void)fprintf(stderr, "' -> %s\n", oname);
		}
	} else
		skipover(dvibyte());
}

/*
 *	Finally, here's our main prescan routine.
 */
static integer firstmatch = -1, lastmatch = -1;

void
prescanpages(void)
{
	register int cmd;
	short ret = 0;
	register long thispageloc, thissecloc;
	register fontdesctype *f;
	register shalfword c;
	register long thissectionmem = 0;
	integer mpagenum;
	integer pageseq = 0;
	int ntfirst = notfirst;

	readpreamble();
/*
 *	Now we look for the first page to process.  If we get to the end of
 *	the file before the page, we complain (fatally).
 *	Incidentally, we don't use the DVI file's bop backpointer to skip
 *	over pages at high speed, because we want to look to for special
 *	header that might be in skipped pages.
 */
	while (1) {
		cmd = skipnop();
		if (cmd==248)
			error("! End of document before first specified page");
		if (cmd!=139)
			error("! Bad DVI file: expected bop");
		thispageloc = ftell(dvifile); /* the location FOLLOWING the bop */
#ifdef DEBUG
		if (dd(D_PAGE))
		(void)fprintf(stderr,"bop at %ld\n", thispageloc);
#endif  /* DEBUG */
		pagenum = signedquad();
		pageseq++;
		mpagenum = abspage ? pageseq : pagenum;
		if (mpagenum == firstpage && ntfirst)
			firstmatch++;
		if (mpagenum == lastpage && notlast)
			lastmatch++;
		if (ntfirst && mpagenum == firstpage && firstmatch == firstseq)
			ntfirst = 0;
		if (ntfirst ||
	  ((evenpages && (pagenum & 1)) || (oddpages && (pagenum & 1)==0) ||
		(pagelist && !InPageList(pagenum)))) {
			skipover(40);
			skippage();
		} else {
			if (notlast && mpagenum == lastpage)
				lastmatch--;
			break;
		}
	}
/*
 *	Here we scan for each of the sections.  First we initialize some of
 *	the variables we need.
 */
	while (maxpages > 0 && cmd != 248) {
		for (f=fonthead; f; f=f->next) {
			f->psname = 0;
			if (f->loaded==1)
				for (c=255; c>=0; c--)
					f->chardesc[c].flags &= (STATUSFLAGS);
		}
		fontmem = swmem - OVERCOST;
		if (fontmem <= 1000)
			error("! Too little VM in printer");

/*	The section begins at the bop command just before thispageloc (which may
 *	be a page that was aborted because the previous section overflowed memory).
 */
		pagecount = 0;
		(void)fseek(dvifile, thispageloc, 0);
		pagenum = signedquad();
		skipover(40);
		thissecloc = thispageloc;
/*
 *	Now we have the loop that actually scans the pages.  The scanpage routine
 *	returns 1 if the page scans okay; it returns 2 if the memory ran out
 *	before any pages were completed (in which case we'll try to carry on
 *	and hope for the best); it returns 0 if a page was aborted for lack
 *	of memory. After each page, we mark the characters seen on that page
 *	as seen for this section so that they will be downloaded.
 */
		ret = 0;
		while (maxpages>0) {
	 if (!(evenpages && (pagenum & 1)) &&
				 !(oddpages && (pagenum & 1)==0) &&
				 !(pagelist && !InPageList(pagenum))) {
				ret = scanpage();
				if (ret == 0)
					break;
				pagecount++;
				maxpages--;
	 } else
				skippage();
			thissectionmem = swmem - fontmem - OVERCOST;
			mpagenum = abspage ? pageseq : pagenum;
			pageseq++;
			if (mpagenum == lastpage && notlast)
				lastmatch++;
			if (notlast && mpagenum == lastpage && lastmatch == lastseq)
				maxpages = -1; /* we are done after this page. */
			if (reverse)
				thissecloc = thispageloc;
			for (f=fonthead; f; f=f->next)
				if (f->loaded==1) {
					if (f->psflag & THISPAGE)
						f->psflag = PREVPAGE;
					for (c=255; c>=0; c--)
						if (f->chardesc[c].flags & THISPAGE)
							f->chardesc[c].flags = PREVPAGE |
					(f->chardesc[c].flags & (STATUSFLAGS));
				}
			cmd=skipnop();
			if (cmd==248) break;
			if (cmd!=139)
				error("! Bad DVI file: expected bop");
			thispageloc = ftell(dvifile);
#ifdef DEBUG
			if (dd(D_PAGE))
			(void)fprintf(stderr,"bop at %ld\n", thispageloc);
#endif  /* DEBUG */
			pagenum = signedquad();
			skipover(40);
			if (ret==2 || (maxsecsize && pagecount >= maxsecsize))
				break;
		}
/*
 *	Now we have reached the end of a section for some reason.
 *	If there are any pages, we save the pagecount, section location,
 *	and continue.
 */
		if (pagecount>0) {
			register int fc = 0;
			register sectiontype *sp;
			register charusetype *cp;

			totalpages += pagecount;
			for (f=fonthead; f; f=f->next)
				if (f->loaded==1 && f->psname)
					fc++;
			sp = (sectiontype *)mymalloc(sizeof(sectiontype) + 
				fc * sizeof(charusetype) + sizeof(fontdesctype *));
			sp->bos = thissecloc;
			if (reverse) {
				sp->next = sections;
				sections = sp;
			} else {
				register sectiontype *p;

				sp->next = NULL;
				if (sections == NULL)
					sections = sp;
				else {
					for (p=sections; p->next != NULL; p = p->next);
					p->next = sp;
				}
			}
			sp->numpages = pagecount;
#ifdef DEBUG
		  if (dd(D_PAGE))
			(void)fprintf(stderr,"Have a section: %ld pages at %ld fontmem %ld\n", 
			pagecount, thissecloc, thissectionmem);
#endif  /* DEBUG */
			cp = (charusetype *) (sp + 1);
			fc = 0;
			for (f=fonthead; f; f=f->next)
				if (f->loaded==1 && f->psname) {
					register halfword b, bit;

					cp->psfused = (f->psflag & PREVPAGE);
					f->psflag = 0;
					cp->fd = f;
					c = 0;
					for (b=0; b<16; b++) {
						cp->bitmap[b] = 0;
						for (bit=32768; bit!=0; bit>>=1) {
							if (f->chardesc[c].flags & PREVPAGE)
								cp->bitmap[b] |= bit;
						c++;
						}
					}
					cp++;
				}
			cp->fd = NULL;
		}
	}
}

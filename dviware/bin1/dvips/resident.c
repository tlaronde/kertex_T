/*
 *	This code reads in and handles the defaults for the program from the
 *	file dvips.cnf.  This entire file is a bit kludgy, sorry.
 */

#include "dvips.h" /* The copyright notice in that file is included too! */

/*
 *	This is the structure definition for resident fonts.  We use
 *	a small and simple hash table to handle these.  We don't need
 *	a big hash table.
 */
struct resfont *reshash[RESHASHPRIME];

/*
 *	To maintain a list of document fonts, we use the following
 *	pointer.
 */
struct header_list *ps_fonts_used;

static void bad_config(void);
static int hash(char *s);
static struct resfont * lookup(char *name);
static void add_entry(char *TeXname, char *PSname, char *Fontfile, char *Vectfile,			char *specinfo, char *downloadinfo);

int
hash(char *s)
{
	int h = 12;

	while (*s != 0)
		h = (h + h + *s++) % RESHASHPRIME;
	return(h);
}

/*
 *	Reverse the hash chains.
 */
void
revpslists(void)
{
	register int i;
	for (i=0; i<RESHASHPRIME; i++)
		reshash[i] = (struct resfont *)revlist(reshash[i]);
}

/*
 *	cleanres() marks all resident fonts as not being yet sent.
 */
void
cleanres(void)
{
	register int i;
	register struct resfont *p;
	for (i=0; i<RESHASHPRIME; i++)
		for (p=reshash[i]; p; p=p->next)
			p->sent = 0;
}

/*
 *	The routine that looks up a font name.
 */
struct resfont *
lookup(char *name)
{
	struct resfont *p;

	for (p=reshash[hash(name)]; p!=NULL; p=p->next)
		if (strcmp(p->Keyname, name)==0)
			return(p);
	return(NULL);
}

struct resfont *
findPSname(char *name)
{
	register int i;
	register struct resfont *p;
	for (i=0; i<RESHASHPRIME; i++)
		for (p=reshash[i]; p; p=p->next) {
			if (strcmp(p->PSname, name)==0)
				return p;
		}
	return NULL;
}

/*
 *	This routine adds an entry.
 */
void
add_entry(char *TeXname, char *PSname, char *Fontfile, char *Vectfile,
	char *specinfo, char *downloadinfo)
{
	struct resfont *p;
	int h;

/* (SPQR), no, the fontfiles are explicitly located.
	if (Fontfile == 0)
		Fontfile = downloadinfo;
 */
	if (PSname == NULL)
		PSname = TeXname;
	p = (struct resfont *)mymalloc(sizeof(struct resfont));
	p->Keyname = TeXname;
	p->PSname = PSname;
	p->Fontfile = Fontfile;
	p->Vectfile = Vectfile;
	p->TeXname = TeXname;
	p->specialinstructions = specinfo;
	if (downloadinfo && *downloadinfo)
		p->downloadheader = downloadinfo;
	else
		p->downloadheader = 0;
	h = hash(TeXname);
	p->next = reshash[h];
	p->sent = 0;
	reshash[h] = p;
}

/*
 *	Now our residentfont routine.  Returns the number of characters in
 *	this font, based on the TFM file.
 */
extern char *infont;

int
residentfont(register fontdesctype *curfnt)
{
	register shalfword i;
	struct resfont *p;

/*
 *	First we determine if we can find this font in the resident list.
 */
	if ((p=lookup(curfnt->name))==NULL)
		return 0;
/*
 *	This is not yet the correct way to do things, but it is useful as it
 *	is so we leave it in.  The problem:  if resident Times-Roman is
 *	re-encoded, then it will be downloaded as bitmaps; this is not
 *	right.  The solution will be to introduce two types of `<'
 *	directives, one that downloads fonts and one that downloads
 *	short headers that are innocuous.
 */
	if (p->Fontfile && downloadpspk) {
#ifdef DEBUG
		if (dd(D_FONTS))
			(void)fprintf(stderr,"Using PK font %s for <%s>.\n",
												 curfnt->name, p->PSname);
#endif  /* DEBUG */
		return 0;
	}
/*
 *	We clear out some pointers:
 */
#ifdef DEBUG
	if (dd(D_FONTS))
		  (void)fprintf(stderr,"Font %s <%s> is resident.\n",
												 curfnt->name, p->PSname);
#endif  /* DEBUG */
	curfnt->resfont = p;
	curfnt->name = p->TeXname;
	for (i=0; i<256; i++) {
		curfnt->chardesc[i].TFMwidth = 0;
		curfnt->chardesc[i].packptr = NULL;
		curfnt->chardesc[i].pixelwidth = 0;
		curfnt->chardesc[i].flags = 0;
	}
	add_name(p->PSname, &ps_fonts_used);
/*
 *	We include the font here.  But we only should need to include the
 *	font if we have a stupid spooler; smart spoolers should be able
 *	to supply it automatically.
 */
	if (p->downloadheader) {
		char *cp = p->downloadheader;
		char *q;

		infont = p->PSname;
		while (1) {
			q = cp;
			while (*cp && *cp != ' ')
				cp++;
			if (*cp) {
				*cp = 0;
				add_header(q);
				*cp++ = ' ';
			} else {
				if (strstr(q,".pfa")||strstr(q,".pfb")||
					 strstr(q,".PFA")||strstr(q,".PFB"))
					break;		 /* We don't add PS font file here */
				else {
				  add_header(q);
				  break;
				}
			}
			infont = 0;
		}
		infont = 0;
	}
	i = tfmload(curfnt);
	if (i < 0)
		i = 1;
	usesPSfonts = 1;
	return(i);
}

#define INLINE_SIZE (2000)
static char was_inline[INLINE_SIZE];

void
bad_config(void)
{
	error("Error in config file:");
	(void)fprintf(stderr, "%s\n", was_inline);
	exit(EXIT_FAILURE);
}

/*
 *	We use this function so we can support strings delimited by
 *	double quotes with spaces in them.  We also accept strings
 *	with spaces in them, but kill off any spaces at the end.
 */
char *
configstring(char *s, int nullok)
{
	char tstr[INLINE_SIZE];
	char *p = tstr;

	while (*s && *s <= ' ')
		s++;
	if (*s == '"') {
		s++;
		while (*s != 10 && *s != 0 && *s != '"' && p < tstr+290)
			*p++ = *s++;
	} else {
		while (*s && p < tstr+290)
			*p++ = *s++;
		while (*(p-1) <= ' ' && p > tstr)
			p--;
	}
	*p = 0;
	if (p == tstr && ! nullok)
		bad_config();
	return newstring(tstr);
}

static char *psmapfile = PSMAPFILE;

void
getdefaults(char *s)
{
	FILE *deffile;
	char PSname[INLINE_SIZE];
	register char *p;
	int i, j;
	integer hsiz, vsiz;
	int canaddtopaper = 0;

	if (printer == NULL) {
		if (s)
			strcpy(PSname, s);
		else
		strcpy(PSname, CONFIGFILE);
	} else {
		strcpy(PSname, printer);
		strcat(PSname, ".cnf");
	}
	nameSet(PSname);
	(void)Openin(&deffile, INPUTSPATHSPEC, "r");
	if (deffile != NULL) {
		while (fgets(was_inline, INLINE_SIZE, deffile)!=NULL) {
/*
 *	We need to get rid of the newline.
 */
		 for (p=was_inline; *p; p++);
		 if (p > was_inline) *(p-1) = 0;
		 if (was_inline[0] != '@')
			 canaddtopaper = 0;
		 switch (was_inline[0]) {
/*
 *	Handling paper size information:
 *
 *		If line is empty, then we clear out the paper size information
 *		we have so far.
 *
 *		If it is `@+', then we add to the current paper size info.
 *
 *		If it is `name hsize vsize', then we start a new definition.
 */
case '@' :
			p = was_inline + 1;
			while (*p && *p <= ' ') p++;
			if (*p == 0) {
				papsizes = 0; /* throw away memory */
			} else if (*p == '+') {
				if (canaddtopaper == 0)
					error(
		" @+ in config files must immediately following a @ lines");
				else {
					*(nextstring-1) = '\n';/* IBM: VM/CMS - changed 10 to "\n" */
					p++;
					while (*p && *p == ' ') p++;
					strcpy(nextstring, p);
					nextstring += strlen(p) + 1;
				}
			} else {
				struct papsiz *ps;
				
				ps = (struct papsiz *)mymalloc(sizeof(struct papsiz));
				ps->next = papsizes;
				papsizes = ps;
				ps->name = p;
				while (*p && *p > ' ')
					p++;
				*p++ = 0;
				ps->name = newstring(ps->name);
				while (*p && *p <= ' ') p++;
				handlepapersize(p, &hsiz, &vsiz);
				ps->xsize = hsiz;
				ps->ysize = vsiz;
				ps->specdat = nextstring++;
				canaddtopaper = 1;
			}
			break;
case 'a' :
			dopprescan = (was_inline[1] != '0');
			break;
case 'b':
			if (sscanf(was_inline+1, "%d", &pagecopies) != 1) bad_config();
			if (pagecopies < 1 || pagecopies > 1000)
				bad_config();
			break;
case 'm' :
			if (sscanf(was_inline+1, "%ld", &swmem) != 1) bad_config();
			swmem += fontmem; /* grab headers we've seen already */
			break;
case 'M' :
			mfmode = configstring(was_inline+1, 0);
			mflandmode = 0;
			{
				char *pp;
				for (pp=mfmode; pp && *pp>' '; pp++);
				if (pp && *pp == ' ') {
					*pp++ = 0;
					while (*pp && *pp <= ' ')
						pp++;
					if (*pp)
						mflandmode = pp;
				}
			}
			break;
case 'o' :
			oname = configstring(was_inline+1, 1);
			if (*oname && oname[strlen(oname)-1] == ':')
				sendcontrolD = 1; /* if we send to a device, *we* are spooler */
			break;
case 'O' :
			p = was_inline + 1;
			handlepapersize(p, &hoff, &voff);
			break;
case 'p' :
			p = was_inline + 1;
			while (*p && *p <= ' ')
				p++;
			if (*p == '+') {
				if (sscanf(p+1, "%s", PSname) != 1) bad_config();
				getpsinfo(PSname);
			} else if (*p) {
				psmapfile = configstring(was_inline+1, 0);
				getpsinfo(psmapfile); /* [TL 2017-08-22] */
			} else
			getpsinfo(NULL); /* will take default [TL 2017-08-22] */
			break;
case 's':
			safetyenclose = 1;
			break;
case '%': case ' ' : case '*' : case '#' : case ';' :
case '=' : case 0 : case '\n' :
			break;
case 'r' :
			reverse = (was_inline[1] != '0');
			break;
/*
 *	This case is for last resort font scaling; I hate this, but enough
 *	people have in no uncertain terms demanded it that I'll go ahead and
 *	add it.
 *
 *	This line must have numbers on it, resolutions, to search for the
 *	font as a last resort, and then the font will be scaled.  These
 *	resolutions should be in increasing order.
 *
 *	For most machines, just `300' is sufficient here; on the NeXT,
 *	`300 400' may be more appropriate.
 */
case 'R':
			i = 0;
			p = was_inline + 1;
			while (*p) {
				while (*p && *p <= ' ')
					p++;
				if ('0' <= *p && *p <= '9') {
					j = 0;
					while ('0' <= *p && *p <= '9')
						j = 10 * j + (*p++ - '0');
					if (i > 0)
						if (lastresortsizes[i-1] > j) {
							error("last resort sizes (R) must be sorted");
							bad_config();
						}
					lastresortsizes[i++] = j;
				} else {
					if (*p == 0)
						break;
					error("! only numbers expected on `R' line in config!");
				}
			}
			lastresortsizes[i] = 32000;
			break;
case 'D' :
			if (sscanf(was_inline+1, "%d", &actualdpi) != 1) bad_config();
			if (actualdpi < 10 || actualdpi > 10000) bad_config();
	 vactualdpi = actualdpi;
			break;
case 'K':
			removecomments = (was_inline[1] != '0');
			break;
case 'U':
			nosmallchars = (was_inline[1] != '0');
			break;
case 'W':
			for (p=was_inline+1; *p && *p <= ' '; p++);
			if (*p)
				warningmsg = newstring(p);
			else
				warningmsg = 0;
			break;
case 'X' :
			if (sscanf(was_inline+1, "%d", &actualdpi) != 1) bad_config();
			if (actualdpi < 10 || actualdpi > 10000) bad_config();
			break;
case 'Y' :
			if (sscanf(was_inline+1, "%d", &vactualdpi) != 1) bad_config();
			if (vactualdpi < 10 || vactualdpi > 10000) bad_config();
			break;
case 'x': case 'y':
			if (sscanf(was_inline+1, "%lg", &mag) != 1) bad_config();
			overridemag = (was_inline[0] == 'x') ? 1 : -1;
			break;
case 'e' :
			if (sscanf(was_inline+1, "%d", &maxdrift) != 1) bad_config();
			if (maxdrift < 0) bad_config();
	 vmaxdrift = maxdrift;
			break;
case 'q' : case 'Q' :
			quiet = (was_inline[1] != '0');
			break;
case 'f' : case 'F' :
			filter = (was_inline[1] != '0');
			break;
case 'h' : 
			if (sscanf(was_inline+1, "%s", PSname) != 1) bad_config();
			else (void)add_header(PSname);
			break;
case 'i' :
			if (sscanf(was_inline+1, "%d", &maxsecsize) != 1)
				maxsecsize = 0;
			sepfiles = 1;
			break;
case 'N' :
			disablecomments = (was_inline[1] != '0');
			break;
case 'Z' :
			compressed = (was_inline[1] != '0');
			break;
case 'j':
			partialdownload = (was_inline[1] != '0');
			break;
case 't' :
			if (sscanf(was_inline+1, "%s", PSname) != 1) bad_config();
			else {
			  if (strcmp(PSname, "landscape") == 0) {
					if (hpapersize || vpapersize)
						error(
				"both landscape and papersize specified; ignoring landscape");
					else
						landscape = 1;
				} else
					paperfmt = newstring(PSname);
			}
			break;
	case 'H': case 'I': case 'P': case 'S': case 'T': case 'V': case 'v':
			error("paths are exclusively specified via environment variables.");
		break;
default:
			bad_config();
		}
	  }
	  (void)fclose(deffile);
	} else {
		if (printer)
			error("! no such printer (can't find corresponding config file)");
	}
}

/*
*	If a character pointer is passed in, use that name; else, use the
*	default (possibly set) name.
*/
void
getpsinfo(char *name)
{
	 FILE *deffile;
	 register char *p;
	 char *specinfo, *downloadinfo;
	 char downbuf[200];
	 int slen;

	if (name == NULL)
		name = psmapfile;
	nameSet(name);
	(void)Openin(&deffile, FONTSPATHSPEC, "r");
	 if (deffile != NULL) {
		  while (fgets(was_inline, INLINE_SIZE, deffile)!=NULL) {
				p = was_inline;
				if (*p > ' ' && *p != '*' && *p != '#' && *p != ';'
				&& *p != '%') {
				char *temp = NULL;
				char *TeXname = NULL;
				char *PSname = NULL;
				char *Fontfile=NULL;
				char *Vectfile=NULL;
				specinfo = NULL;
				downloadinfo = NULL;
				downbuf[0] = 0;
				while (*p) {
					while (*p && *p <= ' ')
						p++;
					if (*p) {
						if (*p == '"')
							specinfo = p + 1;
						else if (*p == '<') {
							if (downloadinfo) {
								strcat(downbuf, downloadinfo);
								strcat(downbuf, " ");
							}
							while (p[1] == ' ' || p[1] == '\t')
								p++;
							temp = p + 1;
						} else if (TeXname) { /* Begin new condition */
							if(specinfo) {
								PSname = p;  /* Old condition */
							} else {
								PSname = p;
							}
						} else  /* End new condition */
							TeXname = p;
						if (*p == '"') {
							p++;
							while (*p != '"' && *p)
								p++;
						} else {
							while (*p > ' ')
								p++;
						}
						if (*p)
							*p++ = 0;
						if (temp) {
							if ( strstr(temp, ".pfb")
								|| strstr(temp,".pfa")
								|| strstr(temp, ".PFB")
								|| strstr(temp,".PFA") ) {
								Fontfile = temp;
								downloadinfo = NULL;
							}
							/* (SPQR) if it is a reencoding, pass on
								to FontPart, but download anyway */
							else if (strstr(temp, ".enc")) {
								Vectfile = temp;
								strcat(downbuf, Vectfile);
								strcat(downbuf, " ");
								downloadinfo = NULL;
							} else
								downloadinfo = temp; 
						}
					}
				}
				if (downloadinfo)
					strcat(downbuf, downloadinfo);
				slen=strlen(downbuf)-1;
				while (slen >= 0 && downbuf[slen]==' ') {
					downbuf[slen--]='\0';
				}
				if (TeXname) {
					TeXname = newstring(TeXname);
					specinfo = newstring(specinfo);
					PSname = newstring(PSname);
					Fontfile=newstring(Fontfile);
					Vectfile=newstring(Vectfile);
					downloadinfo = newstring(downbuf);
					add_entry(TeXname, PSname, Fontfile, Vectfile,
						specinfo, downloadinfo);
				}
			}
		  }
		  (void)fclose(deffile);
	 }
	 checkstrings();
}

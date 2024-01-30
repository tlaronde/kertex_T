/*
 *	This routine handles special commands;
 *	predospecial() is for the prescan, dospecial() for the real thing.
 */
#include "dvips.h" /* The copyright notice in that file is included too! */

static int specialerrors = 20;

struct bangspecial {
	struct bangspecial *next;
	char actualstuff[1]; /* more space will actually be allocated */
} *bangspecials = NULL;

static void specerror(char *s);
static void trytobreakout(register char *p);
static void dobs(register struct bangspecial *q);
static int IsSame(char *a, char *b);
static char * GetKeyVal(char *str, int *tno);

void
specerror(char *s)
{
	if (specialerrors > 0) {
		error(s);
		specialerrors--;
	} else if (specialerrors == 0) {
		error("more errors in special, being ignored . . .");
		specialerrors--;
	}
}

static void
trytobreakout(register char *p)
{
	register int i;
	register int instring = 0;
	int lastc = 0;

	i = 0;
	(void)putc('\n', bitfile);
	while (*p) {
		if (i > 65 && *p == ' ' && instring == 0) {
			(void)putc('\n', bitfile);
			i = 0;
		} else {
			(void)putc(*p, bitfile);
			i++;
		}
		if (*p == '(' && lastc != '\\')
			instring = 1;
		else if (*p == ')' && lastc != '\\')
			instring = 0;
		lastc = *p;
		p++;
	}
	(void)putc('\n', bitfile);
}

static void
dobs(register struct bangspecial *q)
{
	if (q) {
		dobs(q->next);
		trytobreakout(q->actualstuff);
	}
}

void
outbangspecials(void)
{
	if (bangspecials) {
		cmdout("TeXDict");
		cmdout("begin");
		cmdout("@defspecial\n");
		dobs(bangspecials);
		cmdout("\n@fedspecial");
		cmdout("end");
	}
}

/* We recommend that new specials be handled by the following general
 * (and extensible) scheme, in which the user specifies one or more
 * `key=value' pairs separated by spaces.
 * The known keys are given in KeyTab; they take values
 * of one of the following types:
 *
 * None: no value, just a keyword (in which case the = sign is omitted)
 * String: the value should be "<string without double-quotes"
 *								  or '<string without single-quotes'
 * Integer: the value should be a decimal integer (%d format)
 * Number: the value should be a decimal integer or real (%f format)
 * Dimension: like Number, but will be multiplied by the scaledsize
 *		 of the current font and converted to default PostScript units
 * (Actually, strings are allowed in all cases; the delimiting quotes
 *  are simply stripped off if present.)
 *
 */

typedef enum {None, String, Integer, Number, Dimension} ValTyp;
typedef struct {
	char	 *Entry;
	ValTyp  Type;
} KeyDesc;

#define NKEYS	 (sizeof(KeyTab)/sizeof(KeyTab[0]))

KeyDesc KeyTab[] = {{"psfile",  String}, /* j==0 in the routine below */
						  {"ifffile", String}, /* j==1 */
						  {"tekfile", String}, /* j==2 */
						  {"hsize",	Number},
						  {"vsize",	Number},
						  {"hoffset", Number},
						  {"voffset", Number},
						  {"hscale",  Number},
						  {"vscale",  Number},
						  {"angle",	Number},
						  {"llx", Number},
						  {"lly", Number},
						  {"urx", Number},
						  {"ury", Number},
						  {"rwi", Number},
						  {"rhi", Number},
						  {"clip", None}};

int
IsSame(char *a, char *b)
{
	for(; *a != '\0'; ) {
		if( tolower((int)*a) != tolower((int)*b) ) 
			return( 0 );
		a++;
		b++;
	}
	return( *b == '\0' );
}

char *KeyStr, *ValStr; /* Key and String values found */
long ValInt; /* Integer value found */
float ValNum; /* Number or Dimension value found */

/* returns NULL if none found, else next scan point.
	char *str: starting point for scan;
	int  *tno: table entry number of keyword, or -1 if keyword
	not found.
 */
char *
GetKeyVal(char *str, int *tno)
{
	register char *s;
	register int i;
	register char t;

	for (s=str; *s <= ' ' && *s; s++); /* skip over blanks */
	if (*s == '\0')
		return (NULL);
	KeyStr = s;
	while (*s>' ' && *s!='=') s++;
	if (0 != (t = *s))
		*s++ = 0;

	for(i=0; i<NKEYS; i++)
		if( IsSame(KeyStr, KeyTab[i].Entry) )
			goto found;
	*tno = -1;
	return (s);

found: *tno = i;
	if (KeyTab[i].Type == None)
		return (s);

	if (t && t <= ' ') {
		for (; *s <= ' ' && *s; s++); /* now look for the value part */
		if ((t = *s)=='=')
			s++;
	}
	ValStr = "";
	if ( t == '=' ) {
		while (*s <= ' ' && *s)
			s++;
		if (*s=='\'' || *s=='\"')
			t = *s++;					/* get string delimiter */
		else t = ' ';
		ValStr = s;
		while (*s!=t && *s)
			s++;
		if (*s)
			*s++ = 0;
	}
	switch (KeyTab[i].Type) {
 case Integer:
		if(sscanf(ValStr,"%ld",&ValInt)!=1) {
			 sprintf(errbuf,"Non-integer value (%s) given for keyword %s",
				  ValStr, KeyStr);
			 specerror(errbuf);
			 ValInt = 0;
		}
		break;
 case Number:
 case Dimension:
		if(sscanf(ValStr,"%f",&ValNum)!=1) {  
			 sprintf(errbuf,"Non-numeric value (%s) given for keyword %s",
				  ValStr, KeyStr);
			 specerror(errbuf);
			 ValNum = 0.0;
		}
		if (KeyTab[i].Type==Dimension) {
			if (curfnt==NULL)
				error("! No font selected");
			ValNum = ValNum * ((double)curfnt->scaledsize) * conv * 72 / DPI;
		}
		break;
 default: break;
	}
	return (s);
}

/*
 *	Now our routines.  We get the number of bytes specified and place them
 *	into the string buffer, and then parse it. Numerous conventions are
 *	supported here for historical reasons.
 *
 *	To support GNUplot's horribly long specials, we go ahead and malloc a
 *	new string buffer if necessary.
 */
void
predospecial(integer numbytes, Boolean scanning)
{
	register char *p = nextstring;
	register int i = 0;
	int j;

	if (nextstring + numbytes > maxstring) {
		p = nextstring = mymalloc((size_t)(1000 + 2 * numbytes));
		maxstring = nextstring + 2 * numbytes + 700;
	}
	for (i=numbytes; i>0; i--)
	if (strncmp(SYSTEM_ENCODING, RK_ICONV_EBCDIC, 6U) == 0)
		*p++ = (char)ascii2ebcdic[(unsigned char)dvibyte()];
	else
		*p++ = (char)dvibyte();
	if (pprescan)
		return;
	while (p[-1] <= ' ' && p > nextstring)
		p--; /* trim trailing blanks */
	if (p==nextstring) return; /* all blank is no-op */
	*p = 0;
	p = nextstring;
	while (*p <= ' ')
		p++;
#ifdef DEBUG
	if (dd(D_SPECIAL))
		(void)fprintf(stderr, "Preprocessing special: %s\n", p);
#endif

/*
 *	We use strncmp() here to also pass things like landscape()
 *	or landscape: or such.
 */

	switch (*p) {
case 'l':
	if (strncmp(p, "landscape", 9)==0) {
		if (hpapersize || vpapersize)
			error(
				 "both landscape and papersize specified:  ignoring landscape");
		else
			landscape = 1;
		return;
	}
	break;
case 'p':
	if (strncmp(p, "papersize", 9)==0) {
		p += 9;
		while (*p == '=' || *p == ' ')
			p++;
		if (hpapersize == 0 || vpapersize == 0) {
			if (landscape) {
				error(
				 "both landscape and papersize specified:  ignoring landscape");
				landscape = 0;
			}
			handlepapersize(p, &hpapersize, &vpapersize);
		}
		return;
	}
	break;
case 'x':
	if (strncmp(p, "xtex:", 5)==0) return;
	break;
case 'h':
	if (strncmp(p, "header", 6)==0) {
		char *q;
		p += 6;
		while ((*p <= ' ' || *p == '=' || *p == '(') && *p != 0)
			p++;
		q = p;  /* we will remove enclosing parentheses */
		p = p + strlen(p) - 1;
		while ((*p <= ' ' || *p == ')') && p >= q)
			p--;
		p[1] = 0;
		if (p >= q)
			(void)add_header(q);
	}
	break;
/* IBM: color - added section here for color header and color history */
case 'b':
	if (strncmp(p, "background", 10) == 0) {
		usescolor = 1;
		p +=11;
		while ( *p <= ' ' ) p++;
		background(p);
		return;
	}
	break;
case 'c':
	if (strncmp(p, "color", 5) == 0) {
		usescolor = 1;
		p += 6;
		while ( *p <= ' ' ) p++;
		if (strncmp(p, "push", 4) == 0 ) {
			p += 5;
			while ( *p <= ' ' ) p++;
			pushcolor(p, 0);
		} else if (strncmp(p, "pop", 3) == 0 ) {
			popcolor(0);
		} else {
			resetcolorstack(p,0);
		}
	}	/* IBM: color - end changes */
	break;
case '!':
	{
		register struct bangspecial *q;
		p++;
		q = (struct bangspecial *)mymalloc(
								 sizeof(struct bangspecial) + strlen(p));
		(void)strcpy(q->actualstuff, p);
		q->next = bangspecials;
		bangspecials = q;
		usesspecial = 1;
		return;
	}
	break;
default:
	break;
	}
	usesspecial = 1;  /* now the special prolog will be sent */
	if (scanning && *p != '"' && (p=GetKeyVal(p, &j)) != NULL && j==0)
		scanfontcomments(ValStr);
}

static char psfile[511]; 

void
dospecial(integer numbytes)
{
	register char *p = nextstring;
	register int i = 0;
	int j;
	register char *q;
	Boolean psfilewanted = 1;
	char cmdbuf[111]; 

if (HPS_FLAG && PAGEUS_INTERUPPTUS) {
	  HREF_COUNT--;
	  start_new_box();
	  PAGEUS_INTERUPPTUS = 0;
	  }
if (HPS_FLAG && NEED_NEW_BOX) {
		 vertical_in_hps();
		 NEED_NEW_BOX = 0;
		 }
	if (nextstring + numbytes > maxstring)
		error("! out of string space in dospecial");
	for (i=numbytes; i>0; i--)
#ifdef VMCMS /* IBM: VM/CMS */
		*p++ = (char)ascii2ebcdic[(char)dvibyte()];
#else
#ifdef MVSXA /* IBM: MVS/XA */
		*p++ = (char)ascii2ebcdic[(char)dvibyte()];
#else
		*p++ = (char)dvibyte();
#endif  /* IBM: VM/CMS */
#endif
	while (p[-1] <= ' ' && p > nextstring)
		p--; /* trim trailing blanks */
	if (p==nextstring) return; /* all blank is no-op */
	*p = 0;
	p = nextstring;
	while (*p <= ' ')
		p++;
#ifdef DEBUG
	if (dd(D_SPECIAL))
		(void)fprintf(stderr, "Processing special: %s\n", p);
#endif

	switch (*p) {
case 'p':
	if (strncmp(p, "ps:", 3)==0) {
		  psflush(); /* now anything can happen. */
		  if (p[3]==':') {
			  if (strncmp(p+4, "[begin]", 7) == 0) {
				  hvpos();
				  trytobreakout(&p[11]);
			  } else if (strncmp(p+4, "[end]", 5) == 0)
				  trytobreakout(&p[9]);
			  else trytobreakout(&p[4]);
		  } else if (strncmp(p+3, " plotfile ", 10) == 0) {
				 char *sfp;
				 hvpos();
				 p += 13;
			  /*
				*  Fixed to allow popen input for plotfile
				*  TJD 10/20/91
			*  popen specials are not handled anymore: we try to
			*  open a "file" (may be a named pipe) after the `''.
			*		[TL] 2010-08-20.
				*/
			  while (*p == ' ') p++;
			  if (*p == '"') {
				 p++;
				 for (sfp = p; *sfp && *sfp != '"'; sfp++);
			  } else {
				 for (sfp = p; *sfp && *sfp != ' '; sfp++);
			  }
			  *sfp = '\0';
			  if (*p == '`') 
				error("! Backtick commands \"`\" forbidden!"); /* fatal */
			  else
				 figcopyfile(p);
			  /* End TJD changes */
		  } else {
			  hvpos();
			  trytobreakout(&p[3]);
			  psflush();
			  hvpos();
		  }
		  return;
	}
	if (strncmp(p, "papersize", 9) == 0)
		return;
	break;
case 'l':
	if (strncmp(p, "landscape", 9)==0) return;
	break;
case '!':
	return;
case 'h':
	if (strncmp(p, "header", 6)==0) return;
	if (strncmp(p, "html:", 5)==0) {
	  if (! HPS_FLAG) return;
	 		p += 5;
			while (isspace((unsigned char)*p))
			p++;
			if (*p == '<') {
	 			char					*sp = p;
	 			char					*str;
	 			int					  ii=0;int len;int lower_len;

	 			while ((*p) && (*p != '>')) {
						ii++;
						p++;
				 }
	 		str = (char *)mymalloc((size_t)(ii+2));
				strncpy(str,sp+1,ii-1);
	 		str[ii-1] = 0;len=strlen(str);
				if(len>6) lower_len=6; else lower_len=len;
				for(ii=0;ii<lower_len;ii++)
					str[ii]=(unsigned char)tolower((unsigned char)str[ii]);
				do_html(str);
				free(str);
				} else {
	 			printf("Error in html special\n");
	 			return;
				}
	return;
	}
	break;
case 'w':
case 'W':
	if (strncmp(p+1, "arning", 6) == 0) {
		static int maxwarns = 50;
		if (maxwarns > 0) {
			error(p);
			maxwarns--;
		} else if (maxwarns == 0) {
			error(". . . rest of warnings suppressed");
			maxwarns--;
		}
		return;
	}
	break;
case 'b':
	if ( strncmp(p, "background", 10) == 0 )
		return; /* already handled in prescan */
	break;
case 'c':
	if (strncmp(p, "color", 5) == 0) {
		p += 6;
		while ( *p <= ' ' ) p++;
		if (strncmp(p, "push", 4) == 0 ) {
			p += 4;
			while ( *p <= ' ' ) p++;
			pushcolor(p,1);
		} else if (strncmp(p, "pop", 3) == 0 ) {
			popcolor(1);
		} else {
			resetcolorstack(p,1);
		}
		return;
	} /* IBM: color - end changes*/
	break;
case '"':
	hvpos();
	cmdout("@beginspecial");
	cmdout("@setspecial");
	trytobreakout(p+1);
	cmdout("\n@endspecial");
	return;
	break;
default:
	break;
	}
/* At last we get to the key/value conventions */
	psfile[0] = '\0';
	hvpos();
	cmdout("@beginspecial");

	while( (p=GetKeyVal(p,&j)) != NULL )
		switch (j) {
	case -1: 
		sprintf(errbuf, "Unknown keyword (%s) in \\special will be ignored",
			KeyStr);
		specerror(errbuf);
		break;
 case 0:
			if (psfile[0]) {
			  sprintf(errbuf, "More than one \\special %s given; %s ignored", 
						  "psfile",  ValStr);
			  specerror(errbuf);
			}
			else (void)strcpy(psfile,ValStr);
			break;
 default: /* most keywords are output as PostScript procedure calls */
			if (KeyTab[j].Type == Integer)
				numout((integer)ValInt);
			else if (KeyTab[j].Type == String)
				for (q=ValStr; *q; q++)
					scout(*q);
			else if (KeyTab[j].Type == None);
			else { /* Number or Dimension */
				ValInt = (integer)(ValNum<0? ValNum-0.5 : ValNum+0.5);
				if (ValInt-ValNum < 0.001 && ValInt-ValNum > -0.001)
					 numout((integer)ValInt);
				else {
					(void)sprintf(cmdbuf, "%f", ValNum);
					cmdout(cmdbuf);
				}
			}
		(void)sprintf(cmdbuf, "@%s", KeyStr);
		cmdout(cmdbuf);
		}

	cmdout("@setspecial");

	if(psfile[0]) {
		if (psfile[0]=='`') 
			error("! Backtick commands \"`\" forbidden!"); /* fatal */
		figcopyfile(psfile);
	} else if (psfilewanted)
		specerror("No \\special psfile was given; figure will be blank");

	cmdout("@endspecial");
}

/*
 *	Handles specials encountered during bounding box calculations.
 *	Currently we only deal with psfile's or PSfiles and only those
 *	that do not use rotations.
 */
static float rbbox[4];

float *
bbdospecial(int nbytes)
{
	char *p = nextstring;
	int i, j;
	char seen[NKEYS];
	float valseen[NKEYS];

	if (nextstring + nbytes > maxstring) {
		p = nextstring = mymalloc((size_t)(1000 + 2 * nbytes));
		maxstring = nextstring + 2 * nbytes + 700;
	}
	if (nextstring + nbytes > maxstring)
		error("! out of string space in bbdospecial");
	for (i=nbytes; i>0; i--)
#ifdef VMCMS /* IBM: VM/CMS */
		*p++ = (char)ascii2ebcdic[(char)dvibyte()];
#else
#ifdef MVSXA /* IBM: MVS/XA */
		*p++ = (char)ascii2ebcdic[(char)dvibyte()];
#else
		*p++ = (char)dvibyte();
#endif  /* IBM: VM/CMS */
#endif
	while (p[-1] <= ' ' && p > nextstring)
		p--; /* trim trailing blanks */
	if (p==nextstring) return 0; /* all blank is no-op */
	*p = 0;
	p = nextstring;
	while (*p <= ' ')
		p++;
	if (strncmp(p, "psfile", 6)==0 || strncmp(p, "PSfile", 6)==0) {
		float originx = 0, originy = 0, hscale = 1, vscale = 1,
				hsize = 0, vsize = 0;
		for (j=0; j<NKEYS; j++)
			seen[j] = 0;
		j = 0;
		while ((p=GetKeyVal(p, &j))) {
			if (j >= 0 && j < NKEYS && KeyTab[j].Type == Number) {
		 seen[j]++;
		 valseen[j] = ValNum;
			}
		}
		/*
		 *	This code mimics what happens in @setspecial.
		 */
		if (seen[3])
			hsize = valseen[3];
		if (seen[4])
			vsize = valseen[4];
		if (seen[5])
			originx = valseen[5];
		if (seen[6])
			originy = valseen[6];
		if (seen[7])
			hscale = valseen[7] / 100.0;
		if (seen[8])
			vscale = valseen[8] / 100.0;
		if (seen[10] && seen[12])
			hsize = valseen[12] - valseen[10];
		if (seen[11] && seen[13])
			vsize = valseen[13] - valseen[11];
		if (seen[14] || seen[15]) {
			if (seen[14] && seen[15] == 0) {
		 hscale = vscale = valseen[14] / (10.0 * hsize);
			} else if (seen[15] && seen[14] == 0) {
		 hscale = vscale = valseen[15] / (10.0 * vsize);
			} else {
				hscale = valseen[14] / (10.0 * hsize);
				vscale = valseen[15] / (10.0 * vsize);
			}
		}
		/* at this point, the bounding box in PostScript units relative to
			the current dvi point is
			  originx originy originx+hsize*hscale originy+vsize*vscale
			We'll let the bbox routine handle the remaining math.
		 */
		rbbox[0] = originx;
		rbbox[1] = originy;
		rbbox[2] = originx+hsize*hscale;
		rbbox[3] = originx+vsize*vscale;
		return rbbox;
	}
	return 0;
}

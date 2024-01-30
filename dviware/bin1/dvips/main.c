/* C89 and kerTeX cleaning, TL 2010-04-06
 */
#include <assert.h>
#include "dvips.h" /* The copyright notice there is included too! */

/* Here's some stuff for debugging dvips.
 */
#ifdef DEBUG
long debug_flag = 0;
#endif

/*
 *	First we define some globals.
 */
fontdesctype *fonthead;		/* list of all fonts mentioned so far */
fontdesctype *curfnt;		  /* the currently selected font */
sectiontype *sections;		 /* sections to process document in */
Boolean partialdownload = 1; /* turn on partial downloading */
Boolean manualfeed;			 /* manual feed? */
Boolean compressed;			 /* compressed? */
Boolean downloadpspk;		  /* use PK for downloaded PS fonts? */
Boolean safetyenclose;
								  /* enclose in save/restore for stupid spoolers? */
Boolean removecomments = 0;  /* remove comments from included PS? */
Boolean nosmallchars;		  /* disable small char optimization for X4045? */
Boolean cropmarks;			  /* add cropmarks? */
Boolean abspage = 0;			/* are page numbers absolute? */
Boolean tryepsf = 0;			/* should we try to make it espf? */
int collatedcopies = 1;		/* how many collated copies? */
static int sectioncopies = 1;		 /* how many times to repeat each section? */
int pagecopies = 1;			 /* how many times to repeat each page? */
shalfword linepos = 0;		 /* where are we on the line being output? */
int maxpages;				/* the maximum number of pages */
Boolean notfirst, notlast;	/* true if a first page was specified */
Boolean evenpages, oddpages; /* true if doing only even/only odd pages */
Boolean pagelist;				/* true if using page ranges */
Boolean sendcontrolD;		  /* should we send a control D at end? */
int firstpage;			  /* the number of the first page if specified */
int lastpage;
int firstseq;
int lastseq;
int hpapersize, vpapersize; /* horizontal and vertical paper size */
integer hoff, voff;			 /* horizontal and vertical offsets */
int maxsecsize;			 /* the maximum size of a section */
integer firstboploc;			/* where the first bop is */
Boolean sepfiles;				/* each section in its own file? */
int numcopies;					/* number of copies of each page to print */
char *iname;					  /* dvi file name */
char *oname;					  /* output file name */
char *strings;					/* strings for program */
char *nextstring, *maxstring; /* string pointers */
FILE *dvifile, *bitfile;	  /* dvi and output files */
quarterword *curpos;		  /* current position in virtual character packet */
quarterword *curlim;			/* final byte in virtual character packet */
fontmaptype *ffont;			 /* first font in current frame */
real conv;						 /* conversion ratio, pixels per DVI unit */
real vconv;						/* conversion ratio, pixels per DVI unit */
real alpha;						/* conversion ratio, DVI unit per TFM unit */
double mag;						/* the magnification of this document */
integer num, den;				/* the numerator and denominator */
int overridemag;				 /* substitute for mag value in DVI file? */
int actualdpi = DEFRES;		/* the actual resolution of the printer */
int vactualdpi = DEFRES;	  /* the actual resolution of the printer */
int maxdrift;					 /* max pixels away from true rounded position */
int vmaxdrift;					/* max pixels away from true rounded position */
char *paperfmt;				  /* command-line paper format */
int landscape = 0;			  /* landscape mode */
integer fontmem;				 /* memory remaining in printer */
long pagecount;			  /* page counter for the sections */
long pagenum;				 /* the page number we currently look at */
long bytesleft;				  /* number of bytes left in raster */
quarterword *raster;			/* area for raster manipulations */
integer hh, vv;				  /* horizontal and vertical pixel positions */

char *infont;					 /* is the file we are downloading a font? */
long swmem;					/* font memory in the PostScript printer */
int quiet;						 /* should we only print errors to stderr? */
Boolean filter = true;		  /* act as semi-filter default output to stdout */
int prettycolumn;				/* the column we are at when running pretty */
int argc;						 /* global argument count; shared */
char **argv;					 /* global argument vector; shared */
int totalpages = 0;			 /* total number of pages */
Boolean reverse;				 /* are we going reverse? */
Boolean usesPSfonts;			/* do we use local PostScript fonts? */
Boolean usesspecial;			/* do we use \special? */
Boolean headers_off;			/* do we send headers or not? */
Boolean usescolor;			  /* IBM: color - do we use colors? */
char *headerfile;				/* default header file */
char *warningmsg;				/* a message to write, if set in config file */
Boolean multiplesects;		 /* more than one section? */
Boolean disablecomments;	  /* should we suppress any EPSF comments? */
char *printer;					/* what printer to send this to? */
frametype frames[MAXFRAME];  /* stack for virtual fonts */
fontdesctype *baseFonts[256]; /* base fonts for dvi file */
long pagecost;					/* memory used on the page being prescanned */
int delchar;						  /* characters to delete from prescanned page */
integer fsizetol;					/* max dvi units error for psfile font sizes */
Boolean includesfonts;			 /* are fonts used in included psfiles? */
fontdesctype *fonthd[MAXFONTHD];/* list headers for included fonts of 1 name */
int nextfonthd;					  /* next unused fonthd[] index */
unsigned char xdig[256];					  /* table for reading hexadecimal digits */
unsigned char xchr[256];		/* web/TeX like. Identity for now.[TL] */
char banner[] = BANNER;		  /* our startup message */
Boolean dopprescan = 0;		  /* do we do a scan before the prescan? */
struct papsiz *papsizes;		 /* all available paper size */
int headersready;				  /* ready to check headers? */
char queryline[256];					 /* interactive query of options */
int qargc;
char *qargv[32];
char queryoptions;
Boolean HPS_FLAG = 0;

static char *helparr[] = {
"	 Usage: dvips [options] filename[.dvi]",
"a*  Conserve memory, not time		z	pass html (HyperTeX) hints",
"b # Page copies, for posters e.g.  A	Print only odd (TeX) pages",
"c # Uncollated copies				  B	Print only even (TeX) pages",
"d # Debugging							 C # Collated copies",
"e # Maxdrift value					  D # Resolution",
"											  E*  Try to create EPSF",
"h f Add header file					 F*  Send control-D at end",
"i*  Separate file per section		G*  Try to Generate missing fonts",
"j*  Download fonts partially		 K*  Pull comments from inclusions",
"k*  Print crop marks					N*  No structured comments",
"l # Last page							 O c Set/change paper offset",
"m*  Manual feed						  P s Load $s.cnf",
"n # Maximum number of pages		  ",
"o f Output file						  S # Max section size in pages",
"p # First page							T c Specify desired page size",
"q*  Run quietly						  U*  Disable string param trick",
"r*  Reverse order of pages			V*  Send downloadable PS fonts as PK",
"s*  Enclose output in save/restore X # Horizontal resolution",
"t s Paper format						 Y # Vertical resolution",
"x # Override dvi magnification	  Z*  Compress bitmap fonts",
"y # Multiply by dvi magnification",
/* "-	Interactive query of options", */
"	 # = number	f = file	s = string  * = suffix (`0' to turn off)",
"	 c = comma-separated dimension pair (e.g., 3.2in,-32.1cm)", 0
};

static void help(void);
static void morestrings(void);
static void initialize(void);
static void newoutname(void);
static void queryargs(void);

void
help(void)
{
	char **p;
	for (p=helparr; *p; p++)
		fprintf(stderr, " %s\n", *p);
}

/*
 *	This error routine prints an error message; if the first
 *	character is !, it aborts the job.
 */
void
error(char *s)
{
	if (prettycolumn > 0)
		  fprintf(stderr,"\n");
	prettycolumn = 0;
	(void)fprintf(stderr, "%s: %s\n", progname, s);
	if (*s=='!') {
		if (bitfile != NULL) {
			cleanprinter();
		}
		exit(EXIT_FAILURE); /* fatal */
	}
}

/*
 *	This is our malloc that checks the results.  We debug the
 *	allocations but not the frees, since memory fragmentation
 *	might be such that we can never use the free'd memory and
 *	it's wise to be conservative.  The only real place we free
 *	is when repacking *huge* characters anyway.
 */
#ifdef DEBUG
static size_t totalalloc = 0;
#endif
char *
mymalloc(size_t n)
{
	char *p;

	if (n == 0) /* catch strange 0 mallocs in flib.c without breaking code */
		n = 1;
#ifdef DEBUG
	totalalloc += n;
	if (dd(D_MEM)) {
		fprintf(stderr, "Alloc %zu\n", n);
	}
#endif
	p = malloc(n);
	if (p == NULL)
		error("! no memory");
	return p;
}

void
morestrings(void)
{
	strings = mymalloc(STRINGSIZE);
	nextstring = strings;
	*nextstring++ = '\0';
	maxstring = strings + STRINGSIZE - 200;
}

void
checkstrings(void)
{
	if (nextstring - strings > STRINGSIZE / 2)
		morestrings();
}

/*
 *	Initialize sets up all the globals and data structures.
 */
void
initialize(void)
{
	unsigned char *s;
	unsigned int i;

	/* xchr[] should be used in later version for latin<->ebcdic. [TL]
	 */
	for (i = 0; i < 256; i++)
		xchr[i] = (unsigned char) i;

	for (i = 0, s = (unsigned char *)"0123456789ABCDEF"; *s!='\0'; s++)
		xdig[*s] = (unsigned char) i++;
	for (i = 10, s= (unsigned char *)"abcdef"; *s!= '\0'; s++)
		xdig[*s] = (unsigned char) i++;
	nextfonthd = 0;
	morestrings(); iname = strings; /* iname[0] == '\0' */
	maxpages = 100000;
	numcopies = 1;
	bitfile = NULL;
	bytesleft = 0;
	swmem = SWMEM;
	oname = "";	/* stdout */
	sendcontrolD = 0;
	multiplesects = 0;
	disablecomments = 0;
	maxdrift = -1;
	vmaxdrift = -1;
	setpaths(DVIPSPATHSSET);	/* libweb/pascalh.c. progname is set. */
}

/*
 *	This routine copies a string into the string `pool', safely.
 */
char *
newstring(char *s)
{
	int l;

	if (s == NULL)
		return(NULL);
	l = strlen(s);
	if (nextstring + l >= maxstring)
		morestrings();
	if (nextstring + l >= maxstring)
		error("! out of string space");
	(void)strcpy(nextstring, s);
	s = nextstring;
	nextstring += l + 1;
	return(s);
}

void
newoutname(void)
{
	static int seq = 0;
	static char *seqptr = NULL;
	char *p;

	if (oname == NULL || *oname == '\0')
		error("! need an output file name to specify separate files");
	if (*oname == '!' || *oname == '|')
		error("! special directives `!' or `|' not supported");
	if (seqptr == NULL) {
		oname = newstring(oname);
		for (p = oname; *p; p++)
			if (*p == '.')
				seqptr = p + 1;
		if (seqptr == 0)
			seqptr = p;
		nextstring += 5; /* make room for the number, up to five digits */
	}
	sprintf(seqptr, "%03d", ++seq);
}

/*
 *	This routine reverses a list, where a list is defined to be any
 *	structure whose first element is a pointer to another such structure.
 */
void *
revlist(void *p)
{
	struct list {
		struct list *next;
	} *pp = (struct list *)p, *qq = 0, *tt;

	while (pp) {
		tt = pp->next;
		pp->next = qq;
		qq = pp;
		pp = tt;
	}
	return (void *)qq;
}

/* this asks for a new set of arguments from the command line */
void
queryargs(void)
{
	fputs("Options: ",stdout);
	fgets(queryline,256,stdin);
	qargc=1;
	if ( (qargv[1] = strtok(queryline," \n")) != (char *)NULL ) {
		qargc=2;
		while ( ((qargv[qargc] = strtok((char *)NULL," \n")) != (char *)NULL)
				&& (qargc < 31) )
			qargc++;
	}
	qargv[qargc] = (char *)NULL;
}
 
int
main(int argc_, char *argv_[])
{
	int i, lastext = -1;
	register sectiontype *sects;

	argv = argv_;
	argc = argc_;

/* we sneak a look at the first arg in case it's debugging */
#ifdef DEBUG
	if (argc > 1 && strncmp(argv[1], "-d", 2)==0) {
		if (argv[1][2]==0 && argc > 2) {
			if (sscanf(argv[2], "%ld", &debug_flag)==0)
				debug_flag = 0;
		} else {
			if (sscanf(argv[1]+2, "%ld", &debug_flag)==0)
				debug_flag = 0;
		}
	}
#endif
	initialize();	/* progname is set, error() can be used. */
	getdefaults(CONFIGFILE);
	getdefaults((char *)0);
/*
 *	This next whole big section of code is straightforward; we just scan
 *	the options.  An argument can either immediately follow its option letter
 *	or be separated by spaces.  Any argument not preceded by '-' and an
 *	option letter is considered a file name; the program complains if more
 *	than one file name is given, and uses stdin if none is given.
 */
	queryoptions = 0;
	do {
		for (i=1; i<argc; i++) {
			if (*argv[i]=='-') {
				char *p=argv[i]+2;
				char c=argv[i][1];
				switch (c) {
case '-':
					queryoptions = 1;
					break;
case 'a':
					dopprescan = (*p != '0');
					break;
case 'b':
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					if (sscanf(p, "%d", &pagecopies)==0)
						error("! Bad number of page copies option (-b).");
					if (pagecopies < 1 || pagecopies > 1000)
						error("! can only print one to a thousand page copies");
					break;
case 'c' :
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					if (sscanf(p, "%d", &numcopies)==0)
						error("! Bad number of copies option (-c).");
					break;
case 'd' :
#ifdef DEBUG
					{
						long old_debug = debug_flag;
						static int warned_already = 0;

						if (*p == '\0' && argv[i+1])
							p = argv[++i];
						if (sscanf(p, "%ld", &debug_flag)==0)
							error("! Bad debug option (-d).");
						if (debug_flag != old_debug && warned_already++ == 0) {
							fprintf(stderr,
  "I found a debug option that was not the first argument to the dvips\n");
							fprintf(stderr,
  "command.  Some debugging output may have been lost because of this.\n");
						}
						break;
					}
#else
					error("not compiled in debug mode");
					break;
#endif /* DEBUG */
case 'e' :
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					if (sscanf(p, "%d", &maxdrift)==0 || maxdrift<0)
						error("! Bad maxdrift option (-e).");
					vmaxdrift = maxdrift;
					break;
case 'h' : case 'H' :
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					if (strcmp(p, "-") == 0)
						headers_off = 1;
					else
						(void)add_header(p);
					break;
case 'i':
					sepfiles = (*p != '0');
					break;
case 'j':
					partialdownload = (*p != '0');
					break;
case 'k':
					cropmarks = (*p != '0');
					break;
case 'S':
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					if (sscanf(p, "%d", &maxsecsize)==0)
						error("! Bad section size arg (-S).");
					break;
case 'm' :
					manualfeed = (*p != '0');
					break;
case 'n' :
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					if (sscanf(p, "%d", &maxpages)==0)
						error("! Bad number of pages option (-n).");
					break;
case 'o' :
					if (*p == '\0' && argv[i+1] && *argv[i+1]!='-')
						p = argv[++i];
					oname = p;
				filter = false;
					sendcontrolD = 0;
					break;
case 'O' :
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					handlepapersize(p, &hoff, &voff);
					break;
case 'T' :
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					handlepapersize(p, &hpapersize, &vpapersize);
					if (landscape) {
						error(
				  "both landscape and papersize specified; ignoring landscape");
						landscape = 0;
					}
					break;
case 'p' :
					if (*p == 'p') {  /* a -pp specifier for a page list? */
						p++;
						if (*p == '\0' && argv[i+1])
							p = argv[++i];
						if (ParsePages(p))
							error("! Bad page list specifier (-pp).");
						pagelist = 1;
						break;
					}
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					if (*p == '=') {
						abspage = 1;
						p++;
					}
					switch(sscanf(p, "%d.%d", &firstpage, &firstseq)) {
case 1:			  firstseq = 0;
case 2:			  break;
default:
						error("! Bad first page option (-p).");
					}
					notfirst = 1;
					break;
case 'l':
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					if (*p == '=') {
						abspage = 1;
						p++;
					}
					switch(sscanf(p, "%d.%d", &lastpage, &lastseq)) {
case 1:			  lastseq = 0;
case 2:			  break;
default:
						error("! Bad last page option (-l).");
					}
					notlast = 1;
					break;
case 'A':
					oddpages = 1;
					break;
case 'B':
					evenpages = 1;
					break;
case 'q' : case 'Q' :
					quiet = (*p != '0');
					break;
case 'r' :
					reverse = (*p != '0');
					break;
case 't' :
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					if (strcmp(p, "landscape") == 0) {
						if (hpapersize || vpapersize)
							error(
				 "both landscape and papersize specified; ignoring landscape");
						else
							landscape = 1;
					} else
						paperfmt = p;
					break;
case 'x' : case 'y' :
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					if (sscanf(p, "%lg", &mag)==0 || mag < 1 ||
								  mag > 1000000)
						error("! Bad magnification parameter (-x or -y).");
					overridemag = (c == 'x' ? 1 : -1);
					break;
case 'C' :
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					if (sscanf(p, "%d", &collatedcopies)==0)
						error("! Bad number of collated copies option (-C).");
					break;
case 'D' :
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					if (sscanf(p, "%d", &actualdpi)==0 || actualdpi < 10 ||
								  actualdpi > 10000)
						error("! Bad dpi parameter (-D).");
					vactualdpi = actualdpi;
					break;
case 'E' :
					tryepsf = (*p != '0');
					if (tryepsf && maxsecsize == 0)
						maxsecsize = 1;
					break;
case 'K' :
					removecomments = (*p != '0');
					break;
case 'U' :
					nosmallchars = (*p != '0');
					break;
case 'X' :
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					if (sscanf(p, "%d", &actualdpi)==0 || actualdpi < 10 ||
								  actualdpi > 10000)
						error("! Bad dpi parameter (-D).");
					break;
case 'Y' :
					if (*p == '\0' && argv[i+1])
						p = argv[++i];
					if (sscanf(p, "%d", &vactualdpi)==0 || vactualdpi < 10 ||
								  vactualdpi > 10000)
						error("! Bad dpi parameter (-D).");
					vactualdpi = vactualdpi;
					break;
case 'F' :
					sendcontrolD = (*p != '0');
					break;
case 'G':
					do_makefont = (*p != '0') ? true : false;
					break;
case 'N' :
					disablecomments = (*p != '0');
					break;
case 'P' :
					{
						struct papsiz *opapsiz = papsizes;
						struct papsiz *npapsiz;
						papsizes = 0;
						if (*p == '\0' && argv[i+1])
							p = argv[++i];
						printer = p;
						getdefaults("");
		  npapsiz = opapsiz;
						while (npapsiz && npapsiz->next)
							npapsiz = npapsiz->next;
						if (npapsiz) {
							npapsiz->next = papsizes;
							papsizes = opapsiz;
						}
			 }
					break;
case 's':
					safetyenclose = (*p != '0');
					break;
case 'V':
					downloadpspk = (*p != '0');
					break;
case 'Z':
					compressed = (*p != '0');
					break;
case 'z':
					HPS_FLAG = (*p != '0');
					break;
case '?':
					(void)fprintf(stderr, banner);
					help();
					break;
default:
					error(
	  "! Bad option, not one of acdehijklmnopqrstxyzABCDEFKMNOPSTUXYZ?");
				}
			} else {
				if (*iname == '\0') {
					register char *p;
	
					lastext = 0;
					iname = nextstring;
					p = argv[i];
					while (*p) {
						*nextstring = *p++;
						if (*nextstring == '.')
							lastext = nextstring - iname;
						else if (*nextstring == '/' || *nextstring == ':')
							lastext = 0;
						nextstring++;
					}
					*nextstring++ = '.';
					*nextstring++ = 'd';
					*nextstring++ = 'v';
					*nextstring++ = 'i';
					*nextstring++ = '\0';
				} else
					error("! Two input file names specified.");
			}
		}
		papsizes = (struct papsiz *)revlist((void *)papsizes);
		if (queryoptions != 0) {				/* get new options */
			(void)fprintf(stderr, banner);
			help();
			queryargs();
			if (qargc == 1)
			  queryoptions = 0;
			else {
			  qargv[0] = argv[0];
			  argc=qargc;
			  argv=qargv;
			}
		}
	} while (queryoptions != 0);
/*
 *	The logic here is a bit convoluted.  Since all `additional'
 *	PostScript font information files are loaded *before* the master
 *	one, and yet they should be able to override the master one, we
 *	have to add the information in the master list to the *ends* of
 *	the hash chain.  We do this by reversing the lists, adding them
 *	to the front, and then reversing them again.
 */
	revpslists();
	getpsinfo((char *)NULL);
	revpslists();
	if (!quiet)
		(void)fprintf(stderr, banner);
	if (*iname) {
#ifdef DEBUG
	if (dd(D_FILES)) 
		fprintf(stderr, "Trying to open <%s(%s)> ", iname, READBIN);
#endif
		dvifile = fopen(iname, READBIN);
		if (dvifile == NULL) {	/* try without suffix */
			iname[strlen(iname)-4] = '\0'; /* remove the .dvi suffix */
#ifdef DEBUG
	if (dd(D_FILES)) 
		fprintf(stderr, "Trying to open (suffix cut) <%s(%s)> ", iname, READBIN);
#endif
			dvifile = fopen(iname, READBIN);
		}
	}
	if (dvifile == NULL) {	/* dvifile is global hence NULL if not set */
		(void)sprintf(errbuf,"! DVI file <%s> can't be opened.", iname);
		error("! DVI file can't be opened.");
	}
	if (oname[0] == '-' && oname[1] == '\0')
		oname[0] = '\0';
	if (*oname == '\0' && filter == false) {
		oname = nextstring;
		lastext = strlen(iname) - 1;
		while (iname[lastext] != '.' && lastext > 0)
			lastext--;
		if (iname[lastext] != '.')
			lastext = strlen(iname) - 1;
		for (i=0; i<=lastext; i++)
			*nextstring++ = iname[i];
		if (iname[lastext] != '.')
			*nextstring++ = '.';
		*nextstring++ = 'p';
		*nextstring++ = 's';
		*nextstring++ = 0;
/*
 *	Now we check the name, and `throw away' any prefix information.
 *	This means throwing away anything before (and including) a colon
 *	or slash.
 */
		{
			char *p;

			for (p=oname; *p && p[1]; p++)
				if (*p == DIR_SEP_CHAR)
					oname = p + 1;
		}
	}
#ifdef DEBUG
	if (dd(D_PATHS)) {
		  (void)fprintf(stderr,"input file %s output file %s swmem %ld\n",
			  iname, oname, swmem);
	/* Add paths debugging (printing) information. [TL] */
	} /* dd(D_PATHS) */
#endif /* DEBUG */
/*
 *	Prepare to scan.
 */
	if (warningmsg)
		error(warningmsg);
	headersready = 1;
	headerfile = (compressed? CHEADERFILE : HEADERFILE);
	(void)add_header(headerfile);
	initcolor();
	if (fseek(dvifile, 0L, 0) < 0)
		error("! DVI file is not seekable!");
/*
 *	Now we do our main work.
 */
	swmem += fontmem;
	if (maxdrift < 0) {
		if (actualdpi <= 599)
			maxdrift = actualdpi / 100;
		else if (actualdpi < 1199)
			maxdrift = actualdpi / 200 + 3;
		else
			maxdrift = actualdpi / 400 + 6;
	}
	if (vmaxdrift < 0) {
		if (vactualdpi <= 599)
			vmaxdrift = vactualdpi / 100;
		else if (vactualdpi < 1199)
			vmaxdrift = vactualdpi / 200 + 3;
		else
			vmaxdrift = vactualdpi / 400 + 6;
	}
	if (dopprescan)
		pprescanpages();
	prescanpages();
	if (includesfonts)
		(void)add_header(IFONTHEADER);
	if (usesPSfonts)
		(void)add_header(PSFONTHEADER);
	if (usesspecial)
		(void)add_header(SPECIALHEADER);
	if (usescolor)  /* IBM: color */
		(void)add_header(COLORHEADER);
	if (HPS_FLAG)
		(void)add_header(HPSHEADER);
	sects = sections;
	totalpages *= collatedcopies;
	if (sects == NULL || sects->next == NULL) {
		sectioncopies = collatedcopies;
		collatedcopies = 1;
	} else {
		if (! sepfiles)
			multiplesects = 1;
	}
	totalpages *= pagecopies;
	if (tryepsf) {
		if (paperfmt || landscape || manualfeed ||
			 collatedcopies > 1 || numcopies > 1 || cropmarks ||
			 *iname == 0 ||
			  (totalpages > 1 && !(sepfiles && maxsecsize == 1))) {
			error("Can't make it EPSF, sorry");
			tryepsf = 0;
		}
	}
	if (HPS_FLAG)
		set_bitfile("head.tmp", 0);
	if (! sepfiles) {
		initprinter(sections);
		outbangspecials();
	}
	for (i=0; i<collatedcopies; i++) {
		sects = sections;
		while (sects != NULL) {
			if (sepfiles) {
				newoutname();
				if (! quiet) {
					if (prettycolumn + strlen(oname) + 6 > LINELENGTH) {
						fprintf(stderr, "\n");
						prettycolumn = 0;
					}
					(void)fprintf(stderr, "(-> %s) ", oname);
					prettycolumn += strlen(oname) + 6;
				}
				if (HPS_FLAG)
					set_bitfile("head.tmp", 0);
				initprinter(sects);
				outbangspecials();
			} else if (! quiet) {
				if (prettycolumn > LINELENGTH) {
					fprintf(stderr, "\n");
					prettycolumn = 0;
				}
				(void)fprintf(stderr, ". ");
				prettycolumn += 2;
			}
			(void)fflush(stderr);
			dosection(sects, sectioncopies);
			sects = sects->next;
			if (sepfiles) {
				if (HPS_FLAG)
					finish_hps();
				cleanprinter();
	 }
		}
	}
	if (! sepfiles) {
		if (HPS_FLAG)
			finish_hps();
		cleanprinter();
	}
	if (! quiet)
		(void)fprintf(stderr, "\n");
#ifdef DEBUG
	if (dd(D_MEM)) {
		fprintf(stderr, "Total memory allocated:  %ld\n", totalalloc);
	}
#endif
	exit(EXIT_SUCCESS);
	/*NOTREACHED*/
}

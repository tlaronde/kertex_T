/*
 *	This is dvips, a freely redistributable PostScript driver
 *	for dvi files.  It is (C) Copyright 1986-94 by Tomas Rokicki.
 *	You may modify and use this program to your heart's content,
 *	so long as you send modifications to Tomas Rokicki.  It can
 *	be included in any distribution, commercial or otherwise, so
 *	long as the banner string defined below is not modified (except
 *	for the version number) and this banner is printed on program
 *	invocation, or can be printed on program invocation with the -? option.
 */

/* C89 and kerTeX modifications (mainly C89 cleaning and security) by
 * Thierry Laronde, 2010-04.
 * TL 2017-08-18: dospecial.c: PAGESIZE was a constant (HyperTeX);
 * TL 2017-08-22: resident.c: the psmap was not reading a not "p +name";
 * TL 2022-03: new WEBLIB API for file handling (name and opening);
 * TL 2022-04-23: reformatting to suppress spaces before ';' and to
 *   put tabs instead of spaces for better indentation.
 * TL 2022-05-01: suppress automatic landscape when dimensions are
 *   given by user but we find a matching papersize with dimensions
 *   rotated: do exactly what told.
 */
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "kertex.h"
#include "pascal.h"
#include "web.h"


#define BANNER \
"This is dvips (kerTeX) 6.10 from 5.76 Copyright 1997 Radical Eye Software (www.radicaleye.com)\n"

#define DEBUG

/* Configuration.
 */
#define DEFRES (400)
#define HEADERFILE "tex.ips"
#define CHEADERFILE "texc.ips"
#define PSFONTHEADER "texps.ips"
#define IFONTHEADER "finclude.ips"
#define SPECIALHEADER "special.ips"
#define COLORHEADER "color.ips"  /* IBM: color */
#define CROPHEADER "crop.ips"
#define HPSHEADER "hps.ips"
#define ADOBE_ENCODING "ps_standard.enc"
#define PSMAPFILE "psfonts.map"
#define CONFIGFILE "dvips.cnf"

/* Should be adjusted if default layout changed.[TL]
 */
#define MFEXEC "mf"
#define GFTOPKEXEC "gftopk"

/* arguments to fopen. "b" can be used for every system since it
	does nothing if it doesn't make sense on the system (Unix). [TL]
 */
#define READ	"r"
#define READBIN	"rb"

#ifdef DEBUG
extern long debug_flag;

#define dd(darg)	((darg)&debug_flag)

#define D_SPECIAL		(1<<0)
#define D_PATHS			(1<<1)
#define D_FONTS			(1<<2)
#define D_PAGE			(1<<3)
#define D_HEADER					 (1<<4)
#define D_COMPRESS				  (1<<5)
#define D_FILES			(1<<6)
#define D_MEM						 (1<<7)
#endif  /* DEBUG */

/* Namespace pollution */
	/* truncation on IBM MVS/XA or VMCMS
	 */
#	define pprescanpages pprscnpgs  /* confict with pprescan */
#	define flushDashedPath flshDshdPth  /* conflict with flushDash */
#	define PageList PgList  /* re-definition conflict with pagelist  */
#	define downloadpspk dnldpspk
	/* Remove namespace conflict with standard library on Macintosh
	 */
#	define newstring newpoolstring

/*
 *	Constants, used to increase or decrease the capacity of this program.
 *
 *	Strings are now more dynamically allocated, so STRINGSIZE is not the
 *	strict limit it once was.  However, it still sets the maximum size
 *	of a string that can be handled in specials, so it should not be
 *	set too small.
 */
#define STRINGSIZE (25000)  /* maximum total chars in strings in program */
#define RASTERCHUNK (8192)  /* size of chunk of raster */
#define MINCHUNK (240)		/* minimum size char to get own raster */
#define STACKSIZE (100)	  /* maximum stack size for dvi files */
#define MAXFRAME (10)		 /* maximum depth of virtual font recursion */
#define MAXFONTHD (100)	  /* number of unique names of included fonts */
/*
 *	Other constants, which define printer-dependent stuff.
 */
#define SWMEM (180000)		/* available virtual memory in PostScript printer */
#define DPI (actualdpi)	  /* dots per inch */
#define VDPI (vactualdpi)	/* dots per inch */
#define RES_TOLERANCE(dpi) ((int)(1+dpi/500))
									 /* error in file name resolution versus desired */
#define FONTCOST (298)		/* overhead cost of each sw font */
#define PSFONTCOST (1100)	/* overhead cost for PostScript fonts */
#define PSCHARCOST (20)	  /* overhead cost for PostScript font chars */
#define DNFONTCOST (35000)  /* overhead cost for downloaded PS font */
#define CHARCOST (15)		 /* overhead cost for each character */
#define OVERCOST (30000)	 /* cost of overhead */
#define DICTITEMCOST (20)	/* cost per key, value in dictionary */
#define NAMECOST (40)		 /* overhead cost of each new name */
/*
 *	LINELENGTH tells the maximum line length to send out.  It's been
 *	reduced to 72 because sometimes PostScript files are included in
 *	mail messages and many mailers mutilate longer lines.
 */
#define LINELENGTH (72)

/*
 *	Type declarations.  integer must be a 32-bit signed; shalfword must
 *	be a sixteen-bit signed; halfword must be a sixteen-bit unsigned;
 *	quarterword must be an eight-bit unsigned.
 *	 integer and real are defined in kertex.h.
 *	 These impact what is written in the DVI. But since long is
 *	guaranteed by C to be at least a tetra, for the program itself
 *	we use long and always "%ld". long is also the definition of
 *	integer on systems where RISK can not find what a tetra is.
 */
typedef short shalfword;
typedef unsigned short halfword;
typedef unsigned char quarterword;

/*
 *	This is the structure definition for resident fonts.  We use
 *	a small and simple hash table to handle these.  We don't need
 *	a big hash table.
 */
#define RESHASHPRIME (73)
struct resfont {
	struct resfont *next;
	char *Keyname, *PSname, *TeXname, *Fontfile, *Vectfile;
	char *specialinstructions;
	char *downloadheader; /* possibly multiple files */
	quarterword sent;
};

/*
 *	A chardesc describes an individual character.  Before the fonts are
 *	downloaded, the flags indicate that the character has already been used
 *	with the following meanings:
 */
typedef struct {
	integer TFMwidth;
	quarterword *packptr;
	shalfword pixelwidth;
	quarterword flags, dmy;
} chardesctype;
#define EXISTS (1)
#define PREVPAGE (2)
#define THISPAGE (4)
#define TOOBIG (8) /* not used at the moment */
#define REPACKED (16)
#define BIGCHAR (32)
#define STATUSFLAGS (EXISTS|REPACKED|BIGCHAR)

/*
 *	A fontdesc describes a font.  The name, area, and scalename are located in
 *	the string pool. The nextsize pointer is used to link fonts that are used
 *	in included psfiles and differ only in scaledsize.  Such fonts also have
 *	a non-NULL scalename that gives the scaledsize as found in the included
 *	file.  The psflag indicates that the font has been used in an included
 *	psfile.  It can be 0, PREVPAGE, THISPAGE, or EXISTS.
 */
typedef struct tfd {
	integer checksum, scaledsize, designsize, thinspace;
	halfword dpi, loadeddpi;
	halfword alreadyscaled;
	halfword psname;
	halfword loaded;
	halfword maxchars;
	char *name, *area;
	struct resfont *resfont;
	struct tft *localfonts;
	struct tfd *next;
	struct tfd *nextsize;
	char *scalename;
	quarterword psflag;
	chardesctype chardesc[256];
} fontdesctype;

/*  A fontmap associates a fontdesc with a font number.
 */
typedef struct tft {
	integer fontnum;
	fontdesctype *desc;
	struct tft *next;
} fontmaptype;

/*	Virtual fonts require a `macro' capability that is implemented by
 *	using a stack of `frames'.
 */
typedef struct {
	quarterword *curp, *curl;
	fontdesctype *curf;
	fontmaptype *ff;
} frametype;

/*
 *	The next type holds the font usage information in a 256-bit table;
 *	there's a 1 for each character that was used in a section.
 */
typedef struct {
	fontdesctype *fd;
	halfword psfused;
	halfword bitmap[16];
} charusetype;

/*	Next we want to record the relevant data for a section.  A section is
 *	a largest portion of the document whose font usage does not overflow
 *	the capacity of the printer.  (If a single page does overflow the
 *	capacity all by itself, it is made into its own section and a warning
 *	message is printed; the page is still printed.)
 *
 *	The sections are in a linked list, built during the prescan phase and
 *	processed in proper order (so that pages stack correctly on output) during
 *	the second phase.
 */
typedef struct t {
	integer bos;
	struct t *next;
	halfword numpages;
} sectiontype;

/*
 *	Sections are actually represented not by sectiontype but by a more
 *	complex data structure of variable size, having the following layout:
 *		sectiontype sect;
 *		charusetype charuse[numfonts];
 *		fontdesctype *sentinel = NULL;
 *	(Here numfonts is the number of bitmap fonts currently defined.)
 *	 Since we can't declare this or take a sizeof it, we build it and
 *	manipulate it ourselves (see the end of the prescan routine).
 */
/*
 *	This is how we build up headers and other lists.
 */
struct header_list {
	struct header_list *next;
	char *Hname;
	char name[1];
};
/*
 *	Some machines define putlong in their library.
 *	We get around this here.
 */
#define putlong was_putlong
/*
 *	Information on available paper sizes is stored here.
 */
struct papsiz {
	struct papsiz *next;
	integer xsize, ysize;
	char *name;
	char *specdat;
};

extern Boolean abspage;
extern Boolean compressed;
extern Boolean cropmarks;
extern Boolean disablecomments;
extern Boolean dopprescan;
extern Boolean downloadpspk;
extern Boolean evenpages;
extern Boolean includesfonts;
extern Boolean manualfeed;
extern Boolean multiplesects;
extern Boolean nosmallchars;
extern Boolean notfirst, notlast;
extern Boolean oddpages;
extern Boolean pagelist;
extern Boolean partialdownload;
extern Boolean pprescan;
extern Boolean removecomments;
extern Boolean reverse;
extern Boolean safetyenclose;
extern Boolean sendcontrolD;
extern Boolean sepfiles;
extern Boolean tryepsf;
extern Boolean usesPSfonts, headers_off;
extern Boolean usescolor;	/* IBM: color */
extern Boolean usesspecial;
extern FILE *bitfile;
extern FILE *dvifile;
extern FILE *pkfile;
extern FILE *tfmfile;
extern char *iname;
extern char *infont;
extern char *maxstring;
extern char *mfmode, *mflandmode;
extern char *nextstring;
extern char *oname;
extern char *paperfmt;
extern char *printer;
extern char *warningmsg;
extern char banner[];
extern char errbuf[200];
extern char preamblecomment[];
extern double mag;
extern fontdesctype *baseFonts[];
extern fontdesctype *curfnt;
extern fontdesctype *fonthd[MAXFONTHD];
extern fontdesctype *fonthead;
extern fontmaptype *ffont;
extern frametype frames[];
extern int actualdpi;
extern int collatedcopies;
extern Boolean do_makefont;
extern Boolean filter;
extern int headersready;
extern Boolean noprocset;
extern Boolean HPS_FLAG;
extern int landscape;
extern int lastfont;
extern int lastresortsizes[];
extern int maxdrift;
extern int nextfonthd;
extern int numcopies;
extern int overridemag;
extern int pagecopies;
extern int prettycolumn;
extern int quiet;
extern int to_close;
extern int totalpages;
extern int vactualdpi;
extern int vmaxdrift;
extern integer den;
extern integer firstboploc;
extern int firstpage;
extern int firstseq;
extern integer fontmem;
extern integer fsizetol;
extern integer hh;
extern integer hoff;
extern int hpapersize;
extern int lastpage;
extern int lastseq;
extern int maxpages;
extern int maxsecsize;
extern integer num;
extern integer num, den;
extern long pagecost;
extern long pagecount;
extern long pagenum;
extern long swmem;
extern integer voff;
extern int vpapersize;
extern integer vv;
extern long bytesleft;
extern long mbytesleft;
extern quarterword *curlim;
extern quarterword *curpos;
extern quarterword *mraster;
extern quarterword *raster;
extern real alpha;
extern real conv; /* horizontal converter */
extern real vconv;	/* vertical converter */
extern sectiontype *sections;
extern shalfword linepos;
extern struct header_list *ps_fonts_used;
extern struct papsiz *papsizes;
extern unsigned char xdig[256];
extern unsigned char ebcdic2ascii[256];
extern unsigned char ascii2ebcdic[256];

/* bbox.c */
extern void findbb(integer bop);
/* bbox.c */
/* color.c */
extern void initcolor(void);
extern void background(char *bkgrnd);
extern void pushcolor(char *p, Boolean outtops);
extern void popcolor(Boolean outtops);
extern void resetcolorstack(char *p, int outtops);
extern void bopcolor(int outtops);
/* color.c */
/* dopage.c */
extern void dopage(void);
/* dopage.c */
/* dosection.c */
extern void dosection(sectiontype *s, int c);
extern int InPageList(integer i);
extern int ParsePages(register char *s);
/* dosection.c */
/* dospecial.c */
extern void outbangspecials(void);
extern void predospecial(integer numbytes, Boolean scanning);
extern void dospecial(integer numbytes);
extern float * bbdospecial(int nbytes);
/* dospecial.c */
/* download.c */
extern void makepsname(register char *s, register int n);
extern void lfontout(int n);
extern void download(charusetype *p, int psfont);
extern void dopsfont(sectiontype *fs);
/* download.c */
/* dpicheck.c */
extern halfword dpicheck(halfword dpi);
/* dpicheck.c */
/* dviinput.c */
extern shalfword dvibyte(void);
extern halfword twobytes(void);
extern integer threebytes(void);
extern shalfword signedbyte(void);
extern shalfword signedpair(void);
extern integer signedtrio(void);
extern integer signedquad(void);
extern void skipover(int i);
/* dviinput.c */
/* finclude.c */
extern void scanfontcomments(char *filename);
extern void fonttableout(void);
/* finclude.c */
/* fontdef.c */
extern fontdesctype* newfontdesc(integer cksum, integer scsize, integer dssize,			char *name, char *area);
extern fontdesctype * matchfont(char *name, char *area, integer scsize, char *scname);
extern void fontdef(int siz);
extern int skipnop(void);
/* fontdef.c */
/* header.c */
extern int add_name(char *s, struct header_list **what);
extern int add_header(char *s);
extern char *get_name(struct header_list **what);
extern void send_headers(void);
/* header.c */
/* hps.c */
extern int pagecounter;
extern integer pushcount;
extern int current_pushcount;
extern integer hhmem, vvmem;
extern Boolean inHTMLregion;
extern Boolean NEED_NEW_BOX;
extern Boolean PAGEUS_INTERUPPTUS;
extern integer HREF_COUNT;
extern void do_html(char *s);
extern void finish_hps(void);
extern void set_bitfile(char *s, int mode);
extern void vertical_in_hps(void);
extern void end_current_box(void);
extern void start_new_box(void);
/* hps.c */
/* loadfont.c */
extern void loadfont(register fontdesctype *curfnt);
/* loadfont.c */
/* main.c */
extern void error(char *s);
extern char * mymalloc(size_t n);
extern void checkstrings(void);
extern char * newstring(char *s);
extern void * revlist(void *p);
/* main.c */
/* makefont.c */
extern void makefont(char *name, int dpi, int bdpi);
/* makefont.c */
/* output.c */
extern void copyfile(char *s, unsigned int pathspec);
extern void figcopyfile(char *s);
extern void specialout(char c);
extern void stringend(void);
extern void scout(char c);
extern void cmdout(char *s);
extern void doubleout(double n);
extern void floatout(float n); /* unused */
extern void nlcmdout(char *s); /* unused */
extern void numout(long n);
extern void mhexout(register unsigned char *p, register long len);
extern void hvpos(void);
extern void newline(void);
extern void initprinter(sectiontype *sect);
extern void setup(void);
extern void cleanprinter(void);
extern void open_output(void);
extern void psflush(void);
extern void pageinit(void);
extern void pageend(void);
extern void drawrule(integer rw, integer rh);
extern void drawchar(chardesctype *c, int cc);
/* output.c */
/* papersiz.c */
extern void handlepapersize(char *p, integer *x, integer *y);
/* papersiz.c */
/* pprescan.c */
extern void pprescanpages(void);
/* pprescan.c */
/* prescan.c */
extern void readpreamble(void);
extern void prescanpages(void);
/* prescan.c */
/* repack.c */
extern long getlong(register unsigned char *a);
extern void repack(register chardesctype *cp);
/* repack.c */
/* resident.c */
extern void revpslists(void);
extern void cleanres(void);
extern struct resfont * findPSname(char *name);
extern int residentfont(register fontdesctype *curfnt);
extern char *configstring(char *s, int nullok);
extern void getdefaults(char *s);
extern void getpsinfo(char *name);
/* resident.c */
/* scalewidth.c */
extern integer scalewidth(register integer a, register integer b);
/* scalewidth.c */
/* scanpage.c */
extern Boolean prescanchar(chardesctype *cd);
extern Boolean preselectfont(fontdesctype *f);
extern short scanpage(void);
/* scanpage.c */
/* subr.c */
extern unsigned int pathspecSet(const char *filename);
/* subr.c */
/* skippage.c */
extern void skippage(void);
/* skippage.c */
/* t1part.c */
/* specific: in t1part.h only included for t1part.c and download.c */
/* t1part.c */
/* tfmload.c */
extern void tfmopen(register fontdesctype *fd);
extern halfword tfm16(void);
extern integer tfm32(void);
extern int tfmload(register fontdesctype *curfnt);
/* tfmload.c */
/* unpack.c */
extern long unpack(quarterword *pack, halfword *raster, halfword cwidth,			halfword cheight, halfword cmd);
/* unpack.c */
/* virtualfont.c */
extern Boolean virtualfont(register fontdesctype *curfnt);
/* virtualfont.c */

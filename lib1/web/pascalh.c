/* Some extension of PASCAL-H.
   C) 2010-2012, 2017, 2020--2022 Thierry Laronde <tlaronde@polynum.com>
   kerTeX Public Licence v1.0.

   Some routines were extracted and sometimes adjusted from the 
   various web2c V5.0C files.
   The path searching is new.
 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "kertex.h"
#include "pascal.h"
#include "web.h"

/* See comment in date.c.
 */
#ifdef DEBUG
int debug_search_; /* set at launch time by date:get_sys_time() */
#ifdef DEBUGF
#undef DEBUGF
#endif
#define DEBUGF(f,s) if (debug_search_) (void)fprintf(stderr,f,s)
#else
#define DEBUGF(f,s)
#endif /* DEBUG */

/* Doing something will need 2D handling (curses is 2D: page oriented).
   And we aim here at strictly C89, so, for example, no curses.
   So here there are no-op. If someone wants to add an implementation
   for his OS...
 */
void 
hbreakin(FILE *stream, Boolean val)
{
/* The following code is derived from web2c 5.0C.
	if (val == true) {
	    int arg = FREAD;
	
	    (void) ioctl(fileno(stream), TIOCFLUSH, &arg);
	}

*/
}

/* This FILE * is used by extensions in Prote and is set by TeX/Prote
   code. */
FILE *datain;

/* This buffer is used by extensions in Prote and unused by other
   engines. But to share the maximum, it is always defined.
 */
unsigned char xchgbuffer[xchgbuffersize+1]; /* indices start at 1 in WEB */
int xchgbufferlength;	/* 0, i.e., no data at start */

/* kertex_bindir and kertex_libdir are set at running time, from
   environment if KERTEX_FIXED_PATH is not defined and KERTEX_BINDIR
   and KERTEX_LIBDIR, resp., are there defined, and from fixed compile
   time definition if not.
 */
char *kertex_bindir;
char *kertex_libdir;

/* progname is set by set_paths and shall not be used before.
   It can be adapted by e-TeX with removing leading 'e' in order to
   allow path searching shared between TeX and e-TeX.
 */
char *progname;	/* filename of argv[0] for searching */

/* name_of_file[] in WEB or nameoffile[] in C is set by the caller. 
   real_name_of_file[] is shared for the WEB source and will be set in
   return as the full pathname found in the searched directories by 
   these C routines. Generally, D.E.K. uses ``cur_name'', and we 
   replace it, via change files, to this. 
   The indices in Pascal code start at 1 (and not 0 like usually in C),
   so the arrays used with (originally) Pascal code are definite
   starting at 1. The length to read shall be set in namelength
   (Pascal).
   We add a final '\0' in order for C code accessing the arrays (for
   ex. when debugging) to have the stopping sentry. That is 2 more than
   filenamesize.
   After searching, realnameoffile and realnamelength are
   redefined with the path found.
   cee_realnameoffile is the C version of the pathname for C code. [TL]
 */
unsigned char nameoffile[filenamesize + 2];
int namelength;
unsigned char realnameoffile[filenamesize + 2];
int realnamelength;
	
/* The array cee_realnameoffile[] is used by C code in C convention:
   indices start at 0. We must be able to store filenamesize
   and the trailing nul */
unsigned char cee_realnameoffile[filenamesize + 1];

/* Set the nameoffile in C code for libweb routines */
static
void
nameErase(void)
{
	unsigned char *cp;

	for (cp = nameoffile+1;
		(cp - (nameoffile+1)) < filenamesize;)
		*cp++ = ' ';
	nameoffile[filenamesize+1] = '\0'; /* sentry */
	namelength = 0;
}

void
nameSet(const char *filename)
{
	int i;
	for (i = 0; i < filenamesize && filename[i] != '\0'; i++)
		nameoffile[i+1] = filename[i];
	nameoffile[i+1] = '\0';
	namelength = i; /* This, is the definition in the array from index 1 */
}

/* Set realnameoffile from C cee_realnameoffile for calling.
   Before having to return something, we erase i.e. we set all
   spaces.
 */
static
void
realnameErase(void)
{
	unsigned char *cp;

	for (cp = realnameoffile+1;
		(cp - (realnameoffile+1)) < filenamesize;)
		*cp++ = ' ';
	realnameoffile[filenamesize+1] = '\0'; /* sentry */
	realnamelength = 0;
}

static
void
realnameSet(void)
{
	unsigned char *cp, *up;

    for (cp = cee_realnameoffile, up = realnameoffile+1;
		(*up++ = *cp++) != '\0';)
		;
	realnamelength = strlen((char *)cee_realnameoffile);
	DEBUGF("#realname found: `%s'\n", cee_realnameoffile);
}

/* C89/fopen does not do a difference between regular file and 
   directory. To avoid opening a directory, we test first by appending
   a trailing DIR_SEP_CHAR. If this fails, this is not a directory and
   we try again without the trailing DIR_SEP_CHAR. [TL]
   The test is against cee_realnameoffile.
 */
   
static
Boolean
is_dir(void)
{
	FILE *fp;
	unsigned char *cp;

	for (cp = cee_realnameoffile; *cp != '\0'; cp++)
		;

	assert((cp - cee_realnameoffile) <= filenamesize);
	if ((cp - cee_realnameoffile) == filenamesize)
		return false; /* since there can't be any leaf */

	/* We have not passed the end */
	cp[0] = DIR_SEP_CHAR;
	cp[1] = '\0';

	fp = fopen((char *)cee_realnameoffile, "rb");

	*cp = '\0';	/* trunk trailing DIR_SEP_CHAR */

	if (fp != NULL) {
		(void) fclose(fp);
		return true;
	} else
		return false;
}

/* Files and PATHs handling.
   The procedures are shared by all programs.
   If a pathname is given absolutely, whether by a leading DIR_SEP_CHAR
   or by a leading CURDIR, the pathname is taken as is. If the pathname
   is relative, a search is done with the following principles:

   The alternative pathnames are searched following a defined precedence.
   The first found is the one used.

   Actually, the main procedure composes alternative strings separated
   by "DIR_SEP_CHAR". The root searching is done with predefined
   strings that can be overwritten via environment variables. Since
   these strings may be read-only, we can not overwrite the
   PATH_SEP_CHAR with a '\0' to have handy C strings. So we will
   manipulate a Pascal like structure, with a pointer to a C string,
   but a length. The String_ structure typedef'ed in web.h.
 */

/* Construct the pathname from a filename (C string) given and other
 * path chunks.
 */
static 
void
packrealnameoffile(String_ *prefix, char *prog_name, String_ *addpath,
	char *sub_dir1, char *sub_dir2, unsigned char *name)
{
    register unsigned char *cpb, *cpe, *q;
	int i;

	/* Define the start whatever arguments are there.
	 */
	q = cee_realnameoffile;

	/* Set non NULL prefix in full pathname that is C cee_realnameoffile.
	 */
	if (prefix != NULL && prefix->sp != NULL) {
	    for ( i = 0;
				i < prefix->len
				&& (q - cee_realnameoffile) < (filenamesize - 1); 
				*q++ = (unsigned char) prefix->sp[i++])
			;
		*q++ = DIR_SEP_CHAR;
	}

	/* If prog_name is set, add it as a subdir.
	 */
	if (prog_name != NULL && *prog_name) {
		for (; 
			*prog_name != '\0' && (q - cee_realnameoffile) < (filenamesize - 1); 
			*q++ = (unsigned char) *prog_name++)
			;
		*q++ = DIR_SEP_CHAR;
	}

	/* Add optional additional path alternative from PATH_SPEC_FILE.
	 */
	if (addpath != NULL && addpath->sp != NULL) {
	    for ( i = 0;
				i < addpath->len
				&& (q - cee_realnameoffile) < (filenamesize - 1); 
				*q++ = (unsigned char) addpath->sp[i++])
			;
		*q++ = DIR_SEP_CHAR;
	}
	/* Add optional subdir1 if defined.
	 */
	if (sub_dir1 && *sub_dir1) {
		for (; 
			*sub_dir1 && (q - cee_realnameoffile) < (filenamesize - 1); 
			*q++ = (unsigned char) *sub_dir1++)
			;
		*q++ = DIR_SEP_CHAR;
	}
	/* The name is a C string i.e. ends with the nul character. Caller
	   has to set this correctly.
	   Here, the dirname part.
	   The condition has to work for an absolute pathname: if strrchr(3)
	   returns the pointer name (for example with "/filename"), nothing
	   will be copied, but a DIR_SEP_CHAR will be added; this is
	   necessary because it will be skipped for the final filename.
	 */
	if ((cpe = (unsigned char *)strrchr((char *)name, DIR_SEP_CHAR)) != NULL ) {
    	for (cpb = name; 
			cpb != cpe && *cpb && (q - cee_realnameoffile) < filenamesize; )
			*q++ = *cpb++;
		*q++ = DIR_SEP_CHAR;
	}
	/* Add optional subdir2 if defined.
	 */
	if (sub_dir2 && *sub_dir2) {
		for (; 
			*sub_dir2 && (q - cee_realnameoffile) < (filenamesize - 1); 
			*q++ = (unsigned char) *sub_dir2++)
			;
		*q++ = DIR_SEP_CHAR;
	}

	/* Here, the filename part. We skip the potential
	   DIR_SEP_CHAR, that needs to be added when dealing with dirname
	   above.
	 */
	cpe = (unsigned char *)strrchr((char *)name, DIR_SEP_CHAR);
    for (cpb = (cpe == NULL) ? name : ++cpe; 
		*cpb && (q - cee_realnameoffile) < filenamesize; )
		*q++ = *cpb++;

	*q = '\0';
	DEBUGF("searched: `%s'.\n", cee_realnameoffile);
}

/*
   Given a path specification, alternatives separated by PATH_SEP_CHAR,
   this procedure returns an array of strings. The sentry is a string
   of zero length and NULL pointer.
   Calling with a NULL spec is allowed (for convenience with env
   setting). It then returns a NULL pointer. The same is true if the
   spec is empty. Null length strings are not registered, hence the
   sentry can be tested whether by length or by pointer.

   Beware that we take the string as is, including blanks!

   The spec SHALL NOT have whatever is the newline char or sequence of
   char. If fgets(3) is used, this must be discarded before.
 */
String_ *
pathSet(const char *spec)
{
	size_t npath;
	String_ *path;
	const char *spb, *spe;

	if (spec == NULL) return NULL; /* calling with NULL allowed */

	path = NULL, npath = 0;
	for (spb = spec; *spb == PATH_SEP_CHAR; ++spb)
		;
	for (spe = strchr(spb, (int) PATH_SEP_CHAR);
		*spb != '\0';
		spe = strchr(spb, (int) PATH_SEP_CHAR)) {
		if (spe == NULL)
			spe = strchr(spb, '\0');
		if ((spe - spb) != 0) {	/* add a string */
			if ( (path = (String_ *) realloc(path,
				(npath + 2) * sizeof(String_))) == NULL ) {
				perror("pathSet: ");
				return NULL;
			}
			path[npath+1].len = 0;
			path[npath+1].sp = NULL;
			path[npath].len = spe - spb;
			path[npath].sp = spb;
			++npath;
		}
		if (*spe != '\0')
			spb = ++spe;
		else
			spb = spe;
	}
	return path;
}

/*
   We use 4 strings arrays for the root path searching, in bijection
   with the 4 path specifications that can be given via the environment:
   KERTEXPOOL, KERTEXINPUTS, KERTEXDUMP and KERTEXFONTS.

   The correct way should be to qualify files
   by using the persistent identifier pathname subdir:

   /universe/solar_system/earth/europe/france/haute-savoie/laronde/thierry
   has a casual leading part (up to haute-savoie/) and a persistent
   part, what identifies me: laronde/thierry. So I can be anywhere,
   the identifier will be the concatenation of something variable:
   <this_place>, and something persistent: laronde/thierry.

   If the pathname begins by DIR_SEP_CHAR, it is an absolute
   specification, and the name is taken as is and no searching is done.
   If the id is relative, it is searched in the varying host
   environment.

   A file shall be given a non ambiguous name (see the example of
   /universe/.../laronde/thierry, where laronde/thierry is the id part,
   the leading being casual). The subdir specified by the searcher, if 
   set, is added, as an alternative, before the id and between the 
   dirname and the filename of the id:
	 (subdir|)/laronde/(subdir|)/thierry,
   this means that laronde/thierry is searched too, if every other
   combination fails.

   Path + subdirectory is searched first; subdirectory set to "" is 
   searched if the subdirectory was not already "" and the first 
   search didn't succeed.

   Some auxiliary programs search several inputs (ex. mft(1): tex and
   mf) so then one tricks by allocating an alternate (not the "right"
   named) buffer.

   Search is done _only_ in the directories specified, starting with
   the most qualified raw dir and then trying less qualified or
   alternative subdirectories.

   As a convenience, the string "KERTEXSYS" as the _last_ path
   alternative in an environment variable adds the default kertex 
   installation paths to the specification last.

   But as a convenience, if the file is not found directly in the subdir
   we are searching in, we look for a PATH_SPEC_FILE holding 
   subdirectories to explore. This is NOT recursive.
   [TL]
 */
static String_ *pool;
static String_ *inputs;
String_ *dump;	/* this one exported for dvips */
static String_ *fonts;

/* In the root alternatives, if a file named PATH_SPEC_FILE is found,
   these additional subdirs will be explored after trying without.
 */
static char pathbuf[MAXPATHSPEC];
static
String_ *
pathAddSet(String_ *root, char *prog_name)
{
	FILE *fp;

	packrealnameoffile(root, prog_name, NULL, NULL, NULL,
		(unsigned char *)PATH_SPEC_FILE);
	if (is_dir() == true)	/* searching a regular file */
		return NULL;

	pathbuf[0] = '\0';	/* used in every case */
	if ( (fp = fopen((char *)cee_realnameoffile, "r")) != NULL) {
		char *p;
		(void) fgets(pathbuf, MAXPATHSPEC, fp);
		p = strchr(pathbuf, '\r'); /* discard whatever newline */
		if (p == NULL) p = strchr(pathbuf, '\n');
		if (p != NULL) *p = '\0';
		(void) fclose(fp);
	}
	return pathSet(pathbuf);
}

static char *subdir[] = {
	NULL,
	"mf",
	"gf",
	"pk",
	"tfm",
	"afm",
	"pfa",
	"pfb",
	"enc",
	"vf",
	"bib",
	"bst"
};

/*
   pathOverwrite() takes a root string series (that may be NULL), and 
   another possible path spec. If this path spec is not NULL, it 
   initializes a string series from it. And if the last entry of this 
   is the reserved name "KERTEXSYS", it adds the series specified in 
   the first argument to the alternatives.
   It returns the result (a String_ *), that may be unchanged.
*/
static
String_ *
pathOverwrite(String_ *orig, char *override)
{
	String_ *p;

	p = pathSet(override);

	if (p == NULL)
		return orig;
	else if (orig == NULL)
		return p;
	else {
		int nold, nnew;

		for (nnew = 0; p[nnew].sp != NULL; ++nnew)
			;
		if ( strlen(PATH_ADD_DIRECTIVE) == p[nnew-1].len
			&& strncmp(p[nnew-1].sp, PATH_ADD_DIRECTIVE, p[nnew-1].len) == 0) {
			for (nold = 0; orig[nold].sp != NULL; ++nold)
				;
			/* The PATH_ADD_DIRECTIVE will be overwritten; so there is
			   room for NULL. */
			if ((p = (String_ *) realloc(p, 
				(size_t) (nnew + nold) * sizeof(String_))) == NULL)
				return orig;
			p[nnew+nold-1].len = 0;	/* sentry */
			p[nnew+nold-1].sp = NULL;	/* sentry */
			for (; nold > 0; --nold)
				p[nnew+nold-2] = orig[nold-1];
		}
		free(orig);
		return p;
	}
}

/* Initialize progname and path variables for searching */
/* As a convenience, KERTEX_LIBDIR and KERTEX_BINDIR can be set in
   the environment (moved installation). If not, we use the compiled
   in values.
   Should we add a "security" option to forbid this in environment?
   Since the 4 variables can be set by the user, I don't see at the
   moment what it will be usable for (but the code could be changed
   to force only specific directories). [TL 2020-08-27 ]
 */
static int initialized;
static char *poolstr;
static char *dumpstr;
static char *inputsstr;
static char *fontsstr;

void
setpaths(char paths_set)
{
	nameErase();	/* blank Pascal nameoffile */

	if ( (progname = strrchr(argv[0], DIR_SEP_CHAR)) == NULL )
		progname = argv[0];	/* argv[0] is already just filename */
	else
		++progname;	/* pass the DIR_SEP_CHAR */

	if (!initialized) {
#ifdef KERTEX_FIXED_PATH
		kertex_bindir = KERTEX_BINDIR;
		kertex_libdir = KERTEX_LIBDIR;
#else
		kertex_bindir = getenv("KERTEX_BINDIR");
		if (kertex_bindir == NULL) kertex_bindir = KERTEX_BINDIR;

		kertex_libdir = getenv("KERTEX_LIBDIR");
		if (kertex_libdir == NULL) kertex_libdir = KERTEX_LIBDIR;
#endif
		DEBUGF("#KERTEX_BINDIR: `%s'\n", kertex_bindir);
		DEBUGF("#KERTEX_LIBDIR: `%s'\n", kertex_libdir);

		/* Let it abort if allocations fail... */
		poolstr = malloc(MAXPATHSPEC);
		dumpstr = malloc(MAXPATHSPEC);
		inputsstr = malloc(MAXPATHSPEC);
		fontsstr = malloc(MAXPATHSPEC);

		if (poolstr == NULL || dumpstr == NULL || inputsstr == NULL
			|| fontsstr == NULL) {
			perror("setpaths");
			exit(EXIT_FAILURE);
		}

		poolstr[0] = dumpstr[0] = inputsstr[0] = fontsstr[0] = '\0';

		initialized = 1;
	}

	(void)snprintf(fontsstr, MAXPATHSPEC, ".%s%s%sfonts",
		PATH_SEP, kertex_libdir, DIR_SEP);

	fonts = pathSet(fontsstr);
    fonts = pathOverwrite(fonts, getenv("KERTEXFONTS"));

	switch (paths_set) {
		case WEBPATHSSET:
			(void)snprintf(inputsstr, MAXPATHSPEC, ".%s%s%stex",
				PATH_SEP, kertex_libdir, DIR_SEP);
			inputs = pathSet(inputsstr);
			break;
		case MFPATHSSET:
			(void)snprintf(poolstr, MAXPATHSPEC, ".%s%s%spool",
				PATH_SEP, kertex_libdir, DIR_SEP);
			pool = pathSet(poolstr);
			/* inimf and virmf have no subdirectory so add tex */
			(void)snprintf(inputsstr, MAXPATHSPEC, ".%s%s"
				"%s%s%smf"
				"%s%s%sfonts",
				PATH_SEP, kertex_libdir,
				PATH_SEP, kertex_libdir, DIR_SEP,
				PATH_SEP, kertex_libdir, DIR_SEP);
			inputs = pathSet(inputsstr);
			(void)snprintf(dumpstr, MAXPATHSPEC, ".%s%s%slib",
				PATH_SEP, kertex_bindir, DIR_SEP);
			dump = pathSet(dumpstr);

			pool = pathOverwrite(pool, getenv("KERTEXPOOL"));
			inputs = pathOverwrite(inputs, getenv("KERTEXINPUTS"));
			dump = pathOverwrite(dump, getenv("KERTEXDUMP"));
			break;
		case TEXPATHSSET:
			(void)snprintf(poolstr, MAXPATHSPEC, ".%s%s%spool",
				PATH_SEP, kertex_libdir, DIR_SEP);
			pool = pathSet(poolstr);
			/* initex and virtex have no subdirectory so add tex */
			(void)snprintf(inputsstr, MAXPATHSPEC, ".%s%s"
				"%s%s%stex",
				PATH_SEP, kertex_libdir,
				PATH_SEP, kertex_libdir, DIR_SEP);
			inputs = pathSet(inputsstr);
			(void)snprintf(dumpstr, MAXPATHSPEC, ".%s%s%slib",
				PATH_SEP, kertex_bindir, DIR_SEP);
			dump = pathSet(dumpstr);

    		pool = pathOverwrite(pool, getenv("KERTEXPOOL"));
    		inputs = pathOverwrite(inputs, getenv("KERTEXINPUTS"));
    		dump = pathOverwrite(dump, getenv("KERTEXDUMP"));
			break;
		case DVIPSPATHSSET:
			(void)snprintf(inputsstr, MAXPATHSPEC, ".%s%s"
				"%s%s%smf"
				"%s%s%sfonts%smf",
				PATH_SEP, kertex_libdir,
				PATH_SEP, kertex_libdir, DIR_SEP,
				PATH_SEP, kertex_libdir, DIR_SEP, DIR_SEP);
			inputs = pathSet(inputsstr);
    		inputs = pathOverwrite(inputs, getenv("KERTEXINPUTS"));
			/* XXX The maps were all in KERTEX_LIBDIR DIR_SEP "dvips";
			   leave the PS standard map there (there are no fonts:
			   they are embedded in the device) but allow to leave the
			   maps in the fonts hierarchy with the pfa or pfb.
			   [TL 2017-08-22]
			 */
			free(fonts);
			(void)snprintf(fontsstr, MAXPATHSPEC, ".%s%s%sfonts"
				"%s%s%sdvips",
				PATH_SEP, kertex_libdir, DIR_SEP,
				PATH_SEP, kertex_libdir, DIR_SEP);
			fonts = pathSet(fontsstr);
    		fonts = pathOverwrite(fonts, getenv("KERTEXFONTS"));
			break;
		case MFTPATHSSET:
			(void)snprintf(inputsstr, MAXPATHSPEC, ".%s%s%stex",
				PATH_SEP, kertex_libdir, DIR_SEP);
			inputs = pathSet(inputsstr);
			(void)snprintf(dumpstr, MAXPATHSPEC, ".%s%s%smf"
				"%s%s%sfonts%smf",
				PATH_SEP, kertex_libdir, DIR_SEP,
				PATH_SEP, kertex_libdir, DIR_SEP, DIR_SEP);
			dump = pathSet(dumpstr);
			break;
		case BIBTEXPATHSSET:
			(void)snprintf(inputsstr, MAXPATHSPEC, ".%s%s",
				PATH_SEP, kertex_libdir);
			inputs = pathSet(inputsstr);
    		inputs = pathOverwrite(inputs, getenv("KERTEXINPUTS"));
			break;
		case MPPATHSSET:	/* same as MF plus mp specifics */
			(void)snprintf(poolstr, MAXPATHSPEC, ".%s%s%spool",
				PATH_SEP, kertex_libdir, DIR_SEP);
			pool = pathSet(poolstr);
			/* ps_tab_name is still in dvips directory.
			   inimp and virmp have no subdirectory so add tex.
			 */
			(void)snprintf(inputsstr, MAXPATHSPEC, ".%s%s"
				"%s%s%smp"
				"%s%s%smf"
				"%s%s%sdvips"
				"%s%s%sfonts%smf",
				PATH_SEP, kertex_libdir,
				PATH_SEP, kertex_libdir, DIR_SEP,
				PATH_SEP, kertex_libdir, DIR_SEP,
				PATH_SEP, kertex_libdir, DIR_SEP,
				PATH_SEP, kertex_libdir, DIR_SEP, DIR_SEP);
			inputs = pathSet(inputsstr);
			(void)snprintf(dumpstr, MAXPATHSPEC, ".%s%s%slib",
				PATH_SEP, kertex_bindir, DIR_SEP);
			dump = pathSet(dumpstr);

			pool = pathOverwrite(pool, getenv("KERTEXPOOL"));
			inputs = pathOverwrite(inputs, getenv("KERTEXINPUTS"));
			dump = pathOverwrite(dump, getenv("KERTEXDUMP"));
			break;
		case ETEXPATHSSET:
			(void)snprintf(poolstr, MAXPATHSPEC, ".%s%s%spool",
				PATH_SEP, kertex_libdir, DIR_SEP);
			pool = pathSet(poolstr);
			/* einitex and evirtex have no subdirectory so add etex
			   and, after, tex for compatibility.
			 */
			(void)snprintf(inputsstr, MAXPATHSPEC, ".%s%s"
				"%s%s%setex"
				"%s%s%stex",
				PATH_SEP, kertex_libdir,
				PATH_SEP, kertex_libdir, DIR_SEP,
				PATH_SEP, kertex_libdir, DIR_SEP);
			inputs = pathSet(inputsstr);
			(void)snprintf(dumpstr, MAXPATHSPEC, ".%s%s%slib",
				PATH_SEP, kertex_bindir, DIR_SEP);
			dump = pathSet(dumpstr);

    		pool = pathOverwrite(pool, getenv("KERTEXPOOL"));
    		inputs = pathOverwrite(inputs, getenv("KERTEXINPUTS"));
    		dump = pathOverwrite(dump, getenv("KERTEXDUMP"));
			break;
		case CWEBPATHSSET:
			(void)snprintf(inputsstr, MAXPATHSPEC, ".%s%s"
				"%s%s%scweb",
				PATH_SEP, kertex_libdir,
				PATH_SEP, kertex_libdir, DIR_SEP);
			inputs = pathSet(inputsstr);
			inputs = pathOverwrite(inputs, getenv("CWEBINPUTS"));
			break;
		case PROTEPATHSSET:
			(void)snprintf(poolstr, MAXPATHSPEC, ".%s%s%spool",
				PATH_SEP, kertex_libdir, DIR_SEP);
			pool = pathSet(poolstr);
			/* einitex and evirtex have no subdirectory so add etex,
			   prote and, after, tex for compatibility.
			 */
			(void)snprintf(inputsstr, MAXPATHSPEC, ".%s%s"
				"%s%s%setex"
				"%s%s%sprote"
				"%s%s%stex",
				PATH_SEP, kertex_libdir,
				PATH_SEP, kertex_libdir, DIR_SEP,
				PATH_SEP, kertex_libdir, DIR_SEP,
				PATH_SEP, kertex_libdir, DIR_SEP);
			inputs = pathSet(inputsstr);
			(void)snprintf(dumpstr, MAXPATHSPEC, ".%s%s%slib",
				PATH_SEP, kertex_bindir, DIR_SEP);
			dump = pathSet(dumpstr);

    		pool = pathOverwrite(pool, getenv("KERTEXPOOL"));
    		inputs = pathOverwrite(inputs, getenv("KERTEXINPUTS"));
    		dump = pathOverwrite(dump, getenv("KERTEXDUMP"));
			break;
		case FONTSPATHSSET:
		default:
			break;
	}
}


/* Open an input file f */

Boolean
Openin(FILE **f, unsigned int pathspec, const char *mode)
{
    register String_ *prefix, *addpath;
	char *sub_dir;
    register unsigned char *tex_name;
	int i, j, k, l, m;

	*f = NULL;	/* spoil; caller should know */
	realnameErase();

	if ( namelength <= 0 || namelength > filenamesize )
		return false;

	nameoffile[1+namelength] = '\0';
	tex_name = nameoffile+1; /* Pascal code starts indices at 1 */

	/* Absolute or curdir pathname: don't do path searching */
    if ( *tex_name == DIR_SEP_CHAR
		|| (strncmp((const char *)tex_name, CURDIR, 2) == 0) ) {

		packrealnameoffile(NULL, NULL, NULL, NULL, NULL, tex_name);
		if (is_dir() == true)
			return false;

		if ( (*f = fopen((char *)cee_realnameoffile, mode)) != NULL) {
			realnameSet();
			DEBUGF("#opened for reading as FILE *: `%p'\n", *f);
			return true;
		} else
			return false;
    }

	/* else: searching */
	addpath = NULL;	/* to free */
	switch (pathspec & 0xf0) {
		case POOLPATHSPEC: prefix = pool; break;
		case INPUTSPATHSPEC: prefix = inputs; break;
		case DUMPPATHSPEC: prefix = dump; break;
		case FONTSPATHSPEC: prefix = fonts; break;
		case NOPATHSPEC:
		default: prefix = NULL; break;
	}
	sub_dir = subdir[pathspec & 0x0F];
	i = 0;
	do {	/* prefix may be NULL */
		for (j = 0; j < 2; j++) {
			/* explore first with progname subdir, if not without */
			free(addpath);
			addpath = pathAddSet((prefix == NULL) ? NULL : &prefix[i],
				(j == 0) ? progname : NULL);
		/* we always try without added paths first */
			for (k = -1; 
				k < 0 || (addpath != NULL && addpath[k].sp != NULL);
				++k) {
				for (l = 0; l < 2; l++) {
					for (m = 0; m < 2; m++) {
						packrealnameoffile(
							(prefix == NULL) ? NULL : &prefix[i], 
							(j == 0) ? progname : NULL,
							(k == -1) ? NULL : &addpath[k],
							(l == 0) ? sub_dir : NULL, 
							(m == 0) ? sub_dir : NULL,
							tex_name);
						if (is_dir() == false)
							*f = fopen((char *)cee_realnameoffile, mode);
						if (*f != NULL)
							goto found;
						if (sub_dir == NULL) 
							++m;	/* skip same next lookup */
					}
					if (sub_dir == NULL) 
						++l;	/* skip same next lookup */
				}
			}
		}
		++i;
	} while (prefix != NULL && prefix[i].sp != NULL);

	free(addpath);
    return false;

found:
	free(addpath);
	realnameSet();
	DEBUGF("#opened for reading as FILE *: `%p'\n", *f);
   	return true;
}

/* Open an output file f */
Boolean
Openout(FILE **f, const char *mode)
{
    register unsigned char *tex_name;

	DEBUGF("nameoffile: `%s'\n", nameoffile);

	*f = NULL;	/* spoil; caller should know; and we may return before setting */

	if ( namelength <= 0 || namelength > filenamesize )
		return false;

	nameoffile[1+namelength] = '\0';
	tex_name = nameoffile+1; /* Pascal code starts indices at 1 */

    packrealnameoffile(NULL, NULL, NULL, NULL, NULL, tex_name);
	if (is_dir() == false)
    	*f = fopen((char *)cee_realnameoffile, mode);

	if (*f != NULL) {
		realnameSet();
		DEBUGF("#opened for writing as FILE *: `%p'\n", *f);
		return true;
	} else
		return false;
}


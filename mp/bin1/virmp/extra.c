/* Special routines for C virmp.
 */
#include <stdlib.h>
#include <string.h>

#define	EXTERN			/* Actually instantiate globals here */
#include "mpd.h"

/* bufsize is a constant (custom) and cinputln() is in the library.
   Hence we define a variable to link to the library, holding the
   constant.
 */
unsigned int cbufsize = bufsize;

/* oldfilename must be accessible for both Pascal and C, hence ' ' and
   '\0' conventions and no overflow. Better put in C and "initialized"
   by the following topenin(). [TL]
 */
unsigned char oldnameoffile[filenamesize+2];

/*
 * "Open the terminal for input".  Actually, copy any METAFONT
 * command-line arguments for processing.
 * If nothing is available, we return with last==first.
 * If already processed, argc == 0 and we do nothing more.
 * The C entry point (main()) is defined by the parser and argc and
 * argv are available as global variables. [TL]
 */
void
topenin(void)
{
    if (argc > 0) {	/* first call after entry point (main) */
    	register int i;
		int skip;
		char *memname;

		oldfilename[0] = ' ';	/* [0] never written by Pascal; block C!  */

		buffer[first] = '\0';	/* So the first strcat will work */

		/* libweb:setpaths() has defined progname */

		if (strcmp(progname, "virmp") == 0)
		    memname = NULL;
		else if (strcmp(progname, "mpost") == 0)
			memname = "plain";	/* enforce MetaPost standard */
		else
			memname = progname;
	    
		skip = 1;
		/* The only switch handled is for troff mode */
		if (argc > 1 && strcmp(argv[1], "-T") == 0) {
			troffmode = true;
			skip = 2;
		}
	    /* If no format file specified, use progname as the default */
	    if ( ( argc < 2
			|| (skip < argc && argv[skip][0] != '&') )
			&& memname != NULL )
			(void) sprintf((char *) &buffer[first], "&%s ", memname);

		for (i = skip;
			i < argc && (strlen((char *)buffer) + strlen(argv[i]) + 2) <= bufsize;
			i++) {
	    	(void) strcat((char *) &buffer[first], argv[i]);
	    	(void) strcat((char *) &buffer[first], " ");
		}

    	/* Make last index 1 past the last non-blank character in buffer[] */
    	for (last=first; buffer[last]; ++last)
			;
    	for (--last; last >= first && buffer[last] == ' '; --last)
			;
    	++last;

		argc = 0;	/* Don't do this again */
	}
}

/* Raw writes. Originals from Tim Morgan, 4/8/88.
   Modified by TL.
   We use functions for more than one byte, since ',' separated 
   expressions are only for assignements, and a ';' following a closing 
   curly brace for compound statement is not officially supported, i
   hence macros would be syntactically dirty.
 */
#define aputc(x, f) \
	if (putc(((int)((x) & 255)), f) == EOF) {\
		(void)fprintf(stderr, "Fatal error writing FILE * %p.\n", f);\
		exit(EXIT_FAILURE);\
	}

void
zbwrite2bytes(FILE *f, integer b)
{
  aputc(b >> 8, f)
  aputc(b, f)
}

void
zbwrite4bytes(FILE *f, integer b)
{
  aputc(b >> 24, f)
  aputc(b >> 16, f)
  aputc(b >> 8, f)
  aputc(b, f)
}

void
zbwritebuf(FILE *f, unsigned char *buf, integer first, integer last)
{
  if (fwrite(&buf[first], sizeof(unsigned char),
               (size_t) (last - first + 1), f) == 0) {
      perror ("fwrite");
      exit(EXIT_FAILURE);
    }
}

/* We need to create a function, because the thing is passed by value:
   we can not take the address. Furthermore, it would be a compound 
   statement, with a trailing ';'.
 */
void
dumpint(integer x)
{
	integer val;

	val = x;

	(void)fwrite((char *) &(val), sizeof(val), 1, memfile);
}

/* Invoke makempx to make sure there is an up-to-date .mpx file
   for a given .mp file
   John Hobby 3/14/90
 */

boolean
callmakempx(unsigned char *mpname, unsigned char *mpxname)
{
	char *cmd, *p, *q, *qlimit;
	char buf[BUFSIZ];

	cmd = getenv("MPXCOMMAND");
	if (cmd==NULL) {
		if ( (cmd = malloc(strlen(kertex_bindir) + 1
			+ ( (strlen(TROFFMPX) > strlen(TEXMPX))?
				strlen(TROFFMPX) : strlen(TEXMPX) )
			+ 1)) == NULL )
			return 0;
		(void)sprintf(cmd, "%s" DIR_SEP "%s", kertex_bindir,
			(troffmode)? TROFFMPX : TEXMPX);
	}

	q = buf;
	qlimit = buf+BUFSIZ-1;
	for (p=cmd; *p!=0; p++)
		if (q==qlimit) return 0; else *q++ = *p;
	*q++ = ' ';
	for (p=(char *)mpname+1; *p!=0 && *p!=' '; p++)
		if (q==qlimit) return 0; else *q++ = *p;
	*q++ = ' ';
	for (p=(char *)mpxname+1; *p!=0 && *p!=' '; p++)
		if (q==qlimit) return 0; else *q++ = *p;
	*q = 0;
	return system(buf)==0;
}


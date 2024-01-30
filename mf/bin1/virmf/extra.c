/* Special routines for C virmf.
 */
#include <stdlib.h>
#include <string.h>

#define	EXTERN			/* Actually instantiate globals here */
#include "mfd.h"

/* bufsize is a constant (custom) and cinputln() is in the library.
   Hence we define a variable to link to the library, holding the
   constant.
 */
unsigned int cbufsize = bufsize;

#define USAGE() (void)fprintf(stderr,\
	"usage: %s [ [-w width] [-d depth] ] [mf_instructions]\n",\
	progname)	
#define OPTIONS "wd"

/*
 * "Open the terminal for input".  Actually, copy any METAFONT
 * command-line arguments for processing.
 * We treat first what is not METAFONT statements but has been added:
 * the setting of screen_width and screen_depth via environment
 * variables (problem not fatal) or command line arguments (problem
 * fatal).
 * If nothing is available, we return with last==first.
 * If already processed, argc == 0 and we do nothing more.
 * The C entry point (main()) is defined by the parser and argc and
 * argv are available as global variables. [TL]
 */
void
topenin(void)
{
	if (argc > 0) {	/* first call after entry point (main) */
    	register int i, first_mfarg;
		char *basename;
		char *s, *endptr; /* screen size definition */
		const char *mfenv[] = { "MF_SCREEN_WIDTH", "MF_SCREEN_DEPTH" };
		int *mfvar[] = { &screenwidth, &screendepth };
		unsigned long int screen_size; /* ditto */

    	buffer[first] = '\0';	/* So the first strcat will work */

		/* libweb:setpaths() has defined progname */
		if (strcmp(progname, "virmf") == 0)
		    basename = NULL;
		else if (strcmp(progname, "mf") == 0)
			basename = "plain";	/* enforce METAFONT standard */
		else
			basename = progname;
	    
		/* Proceed the peculiar parameters not in METAFONTbook: setting
	   	   screen_width and screen_depth on command line _before_
	   	   MF specific statements. 2016-01-06 TL
	 	*/
		/* First, environment variables if set. Don't exit on error. */
		for (i = 0; i < 2; i++) {
			if ( (s = getenv(mfenv[i])) != NULL ) {
				screen_size = strtoul(s, &endptr, 10);
				if (endptr != s && *endptr == '\0')
					*mfvar[i] = screen_size;
			}
		}
		/* If no options, first_mfarg == 1 */
		for (first_mfarg = 1; first_mfarg < argc
			&& argv[first_mfarg][0] == '-'
			&& strchr(OPTIONS, (int)argv[first_mfarg][1]) != NULL
			&& argv[first_mfarg][2] == '\0'; first_mfarg += 2) {
			if ( (first_mfarg + 1) == argc ) {
				(void)fprintf(stderr,
					"%s: missing parameter to '%s' option.\n",
					progname, argv[first_mfarg]);
				USAGE();
				exit(EXIT_FAILURE);
			}
			screen_size = strtoul(argv[first_mfarg + 1], &endptr, 10);
			if (endptr == argv[first_mfarg + 1] || *endptr != '\0') {
				(void)fprintf(stderr,
					"%s: argument to '%s': incorrect screen size value '%s'.\n",
					progname, argv[first_mfarg], argv[first_mfarg + 1]);
				USAGE();
				exit(EXIT_FAILURE);
			}

			switch (argv[first_mfarg][1]) {
				case 'd': screendepth = (int)screen_size; break;
				case 'w': screenwidth = (int)screen_size; break;
				default: (void)fprintf(stderr,
					"%s: topenin() programmer error! Should not be there!\n",
					progname);
					exit(EXIT_FAILURE);
					break;
			}
		}

	    /* If no format file specified, use progname as the default */
	    if ( (first_mfarg == argc || argv[first_mfarg][0] != '&')
			&& basename != NULL)
			(void) sprintf((char *) &buffer[first], "&%s ", basename);

		for (i = first_mfarg;
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
   expressions are only for assignments, and a ';' following a closing 
   curly brace for compound statement is not officially supported, 
   hence macros would be syntactically dirty.
   Setting errno on error for putc is a POSIX extension of standard C,
   so we don't use it.
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

	(void)fwrite((char *) &(val), sizeof(val), 1, basefile);
}

/* Special routines for C inimf.
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
    if (argc > 0) {	/* First call after entry point (main) */
    	register int i;

    	buffer[first] = '\0';	/* So the first strcat will work */

		for (i = 1;
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

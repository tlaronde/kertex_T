/* C) 2021--2022 Thierry Laronde <tlaronde@polynum.com>.
   Testing the Prote extensions routines.
   kerTeX Public Licence v1.0.

   KERTEXDEBUG has to be set in the environment (setenv(3) or putenv(3)
   are extensions of standard C.
 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "kertex.h"
#include "pascal.h"
#include "web.h"

/* Not advertised */
extern void set_creation_date(time_t);
extern char creation_date[];

int argc;
char **argv;

int
main(int argc_, char *argv_[])
{
	int i, count;
	unsigned int pathspec;

	if (argc_ != 2) {
		(void) fprintf(stderr, "Usage: %s filename.\n", argv_[0]);
		exit(1);
	}

	(void)fprintf(stderr, "# Reminder: KERTEXDEBUG has to be set!\n");

	/* WEBLIB API */
	argc = argc_;
	argv = argv_;
		
	/* Creation date */
	set_creation_date(time(NULL));
	(void)fprintf(stdout, "Creation date: %s\n", creation_date);

	/* The file is handled separately: name in nameoffile; FILE *
       in datain if it is retained.
     */
	pathspec = NOPATHSPEC;
	nameSet(argv[1]); /* setting nameoffile, simulating call from TeX */
	if (Openin(&datain, pathspec, "r") == true) {
		(void) fprintf(stderr, "`%s' found as `%s':\n", argv[1],
			cee_realnameoffile);

		/* MD5 hash subroutines */
		mdfiveinit();
		do {
			count = fread(xchgbuffer+1, 1, 64, datain);
			if ( (xchgbufferlength = count) != 0 )
				mdfiveupdate();
		} while (count == 64);
		mdfivefinal();
		assert(xchgbufferlength == 16); /* shall be set by mdfivefinal */
		(void)fprintf(stdout, "\tMD5: ");
		for (i = 0; i < 16; i++)
			(void)fprintf(stdout, "%.2hhX", *(xchgbuffer+i+1));
		(void)fprintf(stdout, "\n");
		
		/* Modification date */
		getfilemtime();
		(void)fprintf(stdout, "\tmod time: %.*s\n", xchgbufferlength,
			(char *)(xchgbuffer+1));

		/* File size */
		(void)fprintf(stdout, "\tfile size: %d\n", getfilesize());
	
		(void) fclose(datain);
	} else
		(void) fprintf(stderr, "`%s' not found.\n", argv[1]);

	exit(0);
}

/* C) 2012, 2022 Thierry Laronde <tlaronde@polynum.com>.
   Testing the search file routines.
   kerTeX Public Licence v1.0.

   KERTEXDEBUG has to be set in the environment (setenv(3) or putenv(3)
   are extensions of standard C.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "kertex.h"
#include "pascal.h"
#include "web.h"

static char buf[1024];
int argc;
char **argv;

int
main(int argc_, char *argv_[])
{
	FILE *fp;
	unsigned int pathspec;

	if (argc_ != 1) {
		(void) fprintf(stderr, "Usage: %s[<file].\n", argv_[0]);
		exit(1);
	}

	(void)fprintf(stderr, "# Reminder: KERTEXDEBUG has to be set!\n");

	/* WEBLIB API */
	argc = argc_;
	argv = argv_;

	setpaths(TEXPATHSSET);
		
	fp = NULL;
	do {
		(void) fprintf(stderr, "\nPathspec (hexa; see web.h): ");
		if (scanf(" %x", &pathspec) != 1)
			pathspec = INPUTSPATHSPEC;
		(void)fprintf(stderr, "Filename to search: ");
		if (scanf(" %1023s", buf) != 1)
			continue;
		nameSet(buf);
		(void)fprintf(stderr, "Searching for `%s' (%d)...\n",
			nameoffile+1, namelength);
		if (Openin(&fp, pathspec, "r") == true) {
			(void) fprintf(stderr, " (found)\n");
			(void) fclose(fp);
		} else
			(void) fprintf(stderr, " (not found)\n");

	} while (!feof(stdin));
	exit(0);
}

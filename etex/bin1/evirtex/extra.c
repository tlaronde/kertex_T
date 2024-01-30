/*
 * Hand-coded routines for C TeX.
 * This module should contain any system-dependent code.
 *
 * This code was written by Tim Morgan, drawing from other Unix
 * ports of TeX.
 *
 * The adaptation for e-TeX is just the removing of any leading 'e' if
 * name of the executable is not etex. Hence elatex will refer to 
 * latex subdirs, i.e. share the very same files as pure tex 
 * masquerading under a latex name. [TL]
 */
#include <stdlib.h>
#include <string.h>

#define	EXTERN			/* Actually instantiate globals here */
#include "texd.h"

/* bufsize is a constant (custom) and cinputln() is in the library.
   Hence we define a variable to link to the library, holding the
   constant.
 */
unsigned int cbufsize = bufsize;

/*
 * "Open the terminal for input".  Actually, copy any command-line
 * arguments for processing.
 * Once the command line arguments have been processed, argc == 0
 * the procedure does nothing.
 * The C entry point (main()) is defined by the parser and argc and
 * argv are available as global variables. [TL]
 */
void
topenin(void)
{
	if (argc > 0) {	/* argc can be 0 since we redefine it */
    	register int i;
		char *dgstname;

    	buffer[first] = '\0';	/* So the first strcat will work */

		/* libweb:setpaths() has defined progname */

		if (progname[0] == 'e')	/* skip for sharing hier */
			++progname;

		if (strcmp(progname, "virtex") == 0)
		    dgstname = NULL;
		else if (strcmp(progname, "tex") == 0)
			dgstname = "plain";	/* enforce e-TeX standard */
		else
			dgstname = progname;
	    
	    /* If no format file specified, use progname as the default
		   removing any leading 'e' since it's etex.
		 */
	    if ( (argc < 2 || argv[1][0] != '&') && dgstname != NULL )
			(void) sprintf((char *) &buffer[first], "&%s ", dgstname);

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

/* We need to create a function, because the thing is passed by value:
   we can not take the address. Furthermore, it would be a compound 
   statement, with a trailing ';'.
 */
void
putfmtint(integer x)
{
	integer val;

	val = x; 
	(void) fwrite((char *)&val, sizeof(integer), 1, fmtfile);
}

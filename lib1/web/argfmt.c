/* Some routines shared between WEB programs.
   C) 2010; 2022 Thierry Laronde <tlaronde@polynum.com>
   kerTeX Public Licence v1.0.

   These routines were extracted and sometimes adjusted from the 
   various web2c V5.0C files.
 */

/* This library implements various routines used by the WEB programs
   and that are not specified by Pascal ISO 7185:1990. But it is one
   level above the libpascal holding the C version of the standard
   Pascal routines.
 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "kertex.h"
#include "pascal.h"
#include "web.h"

/* Return the nth argument in argv[] (global variable put by pp2rc
   in entry module) into the string nameoffile, index starting at 1
   (index 0 being set to a space) since it is with Pascal translated
   code where indices start at 1 and not 0).libpascal::reset() takes
   name as the C string starting at s+1, so no trailing spaces, and a
   trailing '\0'.
 */
void 
argfmt(integer n)
{
	int i;

	assert(n < argc);
	for (i=0; i < filenamesize && argv[n][i] != '\0'; i++)
		nameoffile[i+1] = argv[n][i];
	nameoffile[i+1] = '\0';
	namelength = i;
}


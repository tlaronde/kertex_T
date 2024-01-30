/* Some print routines shared between auxiliary WEB programs.
   C) 2010, 2022 Thierry Laronde <tlaronde@polynum.com>
   kerTeX Public Licence v1.0.

   The originals were extracted and adjusted from web2c V5.0C.
 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "kertex.h"
#include "pascal.h"
#include "web.h"

/* Print real number r in format n:m
   Original by Tim Morgan, 3/22/88.
 */
void
printreal(FILE *fp, double r, int n, int m)
{
    char fmt[50];

    (void) sprintf(fmt, "%%%d.%df", n, m);
    (void) fprintf(fp, fmt, r);
}

/* Print the significant part of a Pascal string, from index 1 and for
   the specified amount of bytes (length).
 */
void
printstring(FILE *fp, unsigned char *s, int length)
{
	assert(s != NULL);
	(void)fwrite((char *)s, 1, (size_t)length, fp);
}

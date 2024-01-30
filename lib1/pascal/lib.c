/* C implementation of some required routines for Pascal as of 
   annexe C of ISO/IEC 7185:1990(E).
   C) 2010, 2020, 2022 Thierry Laronde <tlaronde@polynum.com>
   All right reserved and no guarantees.

   These routines were extracted and sometimes adjusted from the 
   various web2c V5.0C files.
 */
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include "kertex.h"
#include "pascal.h"

#ifdef DEBUG
#define DEBUGF(f,a1,a2) (void)fprintf(stderr,f,a1,a2)
#else
#define DEBUGF(f,a1,a2)
#endif

Boolean
eof(FILE *fp)
{
	register int c;

	if (feof(fp))
		return true;
	else { /* check to see if next is EOF */
		c = getc(fp);
		if (c == EOF)
			return true;
		else {
			(void) ungetc(c,fp);
			return false;
		}
	}
}

Boolean
eoln(FILE *f)
{
    register int c;

    if (feof(f)) return(true);
    c = getc(f);
    if (c != EOF) (void) ungetc(c, f);
    if (c == '\n' || c == EOF) 
		return true;
	else
		return false;
}

/* Open a file; exit on error. Since name could be read-only and not
 * C nul terminated, we allocate, copy and terminate.
 */
FILE *
openf(char *name, int length, char *mode)
{
	int i;
    FILE *result;
	char *s;

	assert(length > 0);

	if ( (s = malloc((size_t)length+1)) == NULL ) {
    	perror(name);
    	exit(EXIT_FAILURE);
	}
	for (i = 0; i < length; ++i)
		s[i] = name[i];	
	s[length] = '\0';
    if ( (result = fopen(s, mode)) == NULL ) {
    	perror(name);
    	exit(EXIT_FAILURE);
	}
	DEBUGF("#openf: '%s' opened as FILE * %p\n", s, result);
	free(s);

	return result;
}

/* Mea maxima culpa! I had implemented round as a macro, but the
   argument was evaluated twice! A function will do. [TL]
 */
integer
pround(double d)	
{
return (d >= 0.0) ? trunc(d+0.5) : trunc(d-0.5);
}

/* Reading input lines for bibtex.
   It shall be noted that there is a lineread too for mft, but
   different... [TL]
*/
#include <stdio.h>
#include "bibtex.h"

extern long last; /* defined in WEB source */
extern signed char buffer[], xord[];

/* This is not a string with Pascal convention, but a buffer to be
   scanned by the Pascal code. We start at 0.
 */
void
lineread(FILE *f, unsigned int size)
{
    register int in;

    last = 0;
	in = EOF;
    while (last < size && (in = getc(f)) != EOF && in != '\n') {
		buffer[last++] = xord[in];
    }
    while (in != EOF && in != '\n')	/* Skip past eoln if buffer full */
		(void) getc(f);
}

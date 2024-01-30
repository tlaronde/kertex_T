/* These are the dumb version of routines needed by WEBLIB, but that
   require more than ISO C. These are the ISO C version, translation
   from the Pascal/web version, doing nothing useful, but allowing
   the programs to be compiled even in this restricted environment.

   C) 2021 Thierry Laronde <tlaronde@polynum.com>
   kerTeX Public Licence v1.0.
 */
#include <assert.h>
#include <stdio.h> /* needed by declarations in web.h */
#include <stdlib.h> /* idem */
#include <string.h> /* idem */
#include <time.h> /* de dicto */
#include "kertex.h"
#include "pascal.h"
#include "web.h"

/* There is no reliable way to obtain the elapsed time in ISO C if
   we want a precision over the second (clock(3) doesn't measure real
   time but time spent executing the program and for a very small
   activity, the clock() will return 0...).
   So we do our best: we return the time elapsed with an accuracy of one
   second (the result returned is in 1/65536 of a second.
 */
static time_t ref_time;
void
resettimer(void)
{
	ref_time = time(NULL);
}

integer
getelapsedtime(void)
{
	time_t nunc;

	nunc = time(NULL);
	assert(nunc >= ref_time);
	if ( ref_time == (time_t)-1 || nunc == (time_t)-1
		|| (nunc - ref_time) >= 32767 )
		return infinity;
	else
		return ((nunc - ref_time) << 16);
}

/* Getting the mtime for a file can not be done in ISO C. We then set
   xchgbufferlength to 0 to indicate: no data.
 */
void
getfilemtime(void)
{
	xchgbufferlength=0;
}

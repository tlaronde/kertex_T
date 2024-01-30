/* This is for Plan9 but is indeed the same as the "unix" that is
   a POSIX version of routines needed by WEBLIB, but that
   require more than ISO C.

   C) 2021--2022 Thierry Laronde <tlaronde@polynum.com>
   kerTeX Public Licence v1.0.
 */
#define _SUSV2_SOURCE
#include <fcntl.h>
#include <sys/stat.h>
#include <stdio.h> /* needed by declarations in web.h */
#include <stdlib.h> /* idem */
#include <string.h> /* idem */
#include <sys/time.h> /* gettimeofday(2) */
#include "kertex.h"
#include "pascal.h"
#include "web.h"

/* There is no reliable way to obtain the elapsed time in ISO C if
   we want a precision over the second (clock(3) doesn't measure real
   time but time spent executing the program and for a very small
   activity, the clock() will return 0...).
   Plan9 has nsec(2) that answers the question but, for now, I have
   problems linking against libc under APE since nsec() is not visible.
   So we use gettimeofday(2)---obsolescent in newer POSIX---to get
   microseconds that are enough for our 1/65536 unit based time.
 */
static long long ref_time;
void
resettimer(void)
{
	struct timeval tm;
 
	(void)gettimeofday(&tm, NULL);
	ref_time = tm.tv_sec * 1000000 + tm.tv_usec;
}

integer
getelapsedtime(void)
{
	struct timeval nunc;
	static long long timeint;

	(void)gettimeofday(&nunc, NULL);
	if ( (timeint = (nunc.tv_sec * 1000000 + nunc.tv_usec) - ref_time)
		 >= 32767000000 )
		return infinity;
	else
		return ( (timeint * 65536) / 1000000 );
}

/* Getting the mtime for a file can not be done in ISO C. The file
   handling is one of the main difference between Unix/POSIX and
   Plan9 due to the server/9P aspect.
   It is still stat(2), but with Plan9 flavor.
 */
extern void time2date(time_t gm_time);

void
getfilemtime(void)
{
	struct stat stat_buf;

	/* realnameoffile has been set by Prote Openin previous call */
	if (stat((const char *)cee_realnameoffile, &stat_buf) == -1)  {
		xchgbufferlength = 0;
		return;
	}
	time2date(stat_buf.st_mtime);
}

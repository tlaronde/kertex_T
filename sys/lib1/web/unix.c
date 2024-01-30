/* These are the POSIX version of routines needed by WEBLIB, but that
   require more than ISO C.

   C) 2021 Thierry Laronde <tlaronde@polynum.com>
   kerTeX Public Licence v1.0.
 */
#include <assert.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <stdio.h> /* needed by declarations in web.h */
#include <stdlib.h> /* idem */
#include <string.h> /* idem */
#include <time.h> /* de dicto */
#include "kertex.h"
#include "pascal.h"
#include "web.h"

#if defined(CLOCK_MONOTONIC) || defined(CLOCK_REALTIME)
#ifdef CLOCK_MONOTONIC
#define CLOCK_ID_ CLOCK_MONOTONIC
#else
#define CLOCK_ID_ CLOCK_REALTIME
#endif
/* Reference moment for timer */
static struct timespec ref_clk;

/* ISO C clock() only returns ticks relative to processor cycles
   consumed by process, not wall clock ticks. So we must use a more
   accurate source of information.
 */
void
resettimer(void)
{
	(void)clock_gettime(CLOCK_ID_, &ref_clk);
}

integer
getelapsedtime(void)
{
	struct timespec nunc;

	if ( clock_gettime(CLOCK_ID_, &nunc) != 0
		|| (nunc.tv_sec - ref_clk.tv_sec) >= 32767 )
		 return infinity;

	return (integer) ( (nunc.tv_sec - ref_clk.tv_sec) * 65536
		+ ((nunc.tv_nsec - ref_clk.tv_nsec) * 65536) / 1000000000 );
}
#elif (_POSIX_C_SOURCE - 0) >= 200112L || defined(_XOPEN_SOURCE)
#include <sys/time.h> /* gettimeofday(2) */

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
#else
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
#endif

/* Getting the mtime for a file can not be done in ISO C. We then set
   the date as invalid date and there is a routine in Prote code to
   do so.
   The filename is in nameoffile. By calling Openin, realnameoffile is
   set with the path. This is this pathname that we use for stat'ing
   the file. In case of error, we set invalid date.
   If UTC is requested, we must translate in UTC. If not we translate
   in local time.
   We don't use more than second resolution.	
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
#if (_POSIX_C_SOURCE - 0) >= 200809L || (_XOPEN_SOURCE - 0) >= 700
	time2date(stat_buf.st_mtim.tv_sec);
#else
	time2date(stat_buf.st_mtime);
#endif
}

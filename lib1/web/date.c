/* Some routines shared between WEB programs.
   C) 2010, 2021--2022 Thierry Laronde <tlaronde@polynum.com>
   kerTeX Public Licence v1.0.
 */
#include <assert.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "kertex.h"
#include "pascal.h"
#include "web.h"

/* If DEBUG is set at compilation time; the env var KERTEXDEBUG is
   read and debug_*_ variables are set to as many level as a matching
   single letter is encountered in the string.
   's': debug searching (only one level used for now).
 */
#ifdef DEBUG
extern int debug_search_; /* internally shared; not published */
extern int debug_buf_; /* idem */
#endif

void time2date(time_t gm_time); /* uses xchgbuffer; sets xchgbufferlength */
void set_creation_date(time_t gm_time); /* sets date_is_utc */

/* The dates in format "D:YYYYMMDDHHMMSSO'HH'MM"
 */
int date_is_utc; /* Set at creation_date definition */
#define TMZONE_OFFSET 16
char creation_date[24];
size_t creation_date_length; /* de dicto */

/* The formating of the date is used for creation date or for
   getfilemtime(). In order to share the maximum of code and to
   implement what is possible in ISO C (at least C89), the acrobatics
   for the definition of the string and the computation of the UTC
   offset are done here.
   We use xchgbuffer and set xchgbufferlength. date_is_utc has been
   set previously, before the first call to this, by set_creation_date().
 */
void
time2date(time_t gm_time)
{
	long gmsec, lsec, sec_offset;
    struct tm *tp;
	struct tm gmt;

	tp = gmtime(&gm_time);

	if (date_is_utc) {
		(void)snprintf((char *)(xchgbuffer+1), 24,
			"D:%4d%02d%02d%02d%02d%02dZ",
			tp->tm_year + 1900, tp->tm_mon + 1, tp->tm_mday,
			tp->tm_hour, tp->tm_min, tp->tm_sec);
		xchgbufferlength = TMZONE_OFFSET+1;
		return;
	}

	/* Not in UTC, so we need to set localtime and to compute
	   the offset between localtime and UTC. */

	/* The structure is statically allocated and
	   overwritten. So we recopy before calling localtime(3). */
	gmt = *tp;
	tp = localtime(&gm_time);

	(void)snprintf((char *)(xchgbuffer+1), 24,
		"D:%4d%02d%02d%02d%02d%02d",
		tp->tm_year + 1900, tp->tm_mon + 1, tp->tm_mday,
		tp->tm_hour, tp->tm_min, tp->tm_sec);

	/* The maximum of difference is 24 hours (and probably in the
	   range +/- 12 hours). So we need to know which day comes first,
	   and use this "first" day to add a day number of seconds to the
	   other day. This involves taking into account starting from the
	   year to take into account the rolling of month and day with
	   switching to the brand new year (first day of first month, so
	   "inferior" indices but in the future nonetheless).
	*/ 	
	gmsec = gmt.tm_hour * 3600 + gmt.tm_min * 60 + gmt.tm_sec;
	lsec = tp->tm_hour * 3600 + tp->tm_min * 60 + tp->tm_sec;
	if (gmt.tm_year < tp->tm_year || gmt.tm_mon < tp->tm_mon
		|| gmt.tm_mday < tp->tm_mday)
		lsec += 24 * 3600;
	else if (gmt.tm_year > tp->tm_year || gmt.tm_mon > tp->tm_mon
		|| gmt.tm_mday > tp->tm_mday)
		gmsec += 24 * 3600;

	sec_offset = lsec - gmsec;
	if (sec_offset == 0.) {
		xchgbuffer[1+TMZONE_OFFSET] = 'Z';
		xchgbufferlength = TMZONE_OFFSET+1;
	} else {
		(void)snprintf((char *)(xchgbuffer+1+TMZONE_OFFSET), 8,
			"%c'%02d'%02d",
			(sec_offset > 0.)? '+' : '-',
			abs( ((int)sec_offset) / 3600 ),
			abs( ( ((int)sec_offset) % 3600 ) / 60 ) );
		xchgbufferlength = TMZONE_OFFSET+7;
	}
}

/* If FORCE_SOURCE_DATE is 1 and SOURCE_DATE_EPOCH is correctly set,
   use SOURCE_DATE_EPOCH. We verify---using scanf(3) and rewriting
   successively the terminating nul (if this guaranteed to always
   work?)---the syntax not the semantic: the date could be
   nonsense...
   This routine is not declared static in order to be available for
   testing purposes, but it is not advertised.
 */
void
set_creation_date(time_t gm_time)
{
	char *p;

	if ( (p = getenv("FORCE_SOURCE_DATE")) != NULL
		&& (strcmp(p, "1") == 0)
		&& (p = getenv("SOURCE_DATE_EPOCH")) != NULL
		&& sscanf(p, "%1[D]%1[:]%4[0-9]%1[01]%1[0-9]%1[0-3]%1[0-9]%1[0-2]%1[0-9]%1[0-5]%1[0-9]%1[0-5]%1[0-9]%1[Z]%*s",
		creation_date, creation_date+1,
		creation_date+2, creation_date+6, creation_date+7,
		creation_date+8, creation_date+9,
		creation_date+10, creation_date+11,
		creation_date+12, creation_date+13,
		creation_date+14, creation_date+15,
		creation_date+TMZONE_OFFSET) >= 14 ) {
			/* Check _some_ consistency... */
			char buf[5];
			int y, m, d, h;
			int nerr;

			(void)sprintf(buf, "%.4s", creation_date+2);
			y = atoi(buf);
			(void)sprintf(buf, "%.2s", creation_date+6);
			m = atoi(buf);
			(void)sprintf(buf, "%.2s", creation_date+8);
			d = atoi(buf);
			(void)sprintf(buf, "%.2s", creation_date+10);
			h = atoi(buf);
	
			nerr = 0;
			if (m == 0 || m > 12 || d == 0 || d > 31 || h > 23)
				++nerr;
			if ( (m < 8 && (m % 2) == 0 && d == 31)
				|| (m > 8 && (m % 2) && d == 31) )
				++nerr;
			if (m == 2 && (
				( ( (y % 4) || ((y % 100) == 0 && (y % 400) != 0) ) && d > 28 )
					|| ( (y % 4) == 0 && d > 29 ) 
				)
			 ) ++nerr;
			if (nerr == 0) {	
				creation_date_length = TMZONE_OFFSET+1;
				date_is_utc = 1;
				return;
			}
	}

	/* No such (correct) EPOCH set, use nunc */
	assert(date_is_utc == 0);
	time2date(gm_time);
	(void)strncpy(creation_date, (char *)(xchgbuffer+1),
		xchgbufferlength);
	creation_date[xchgbufferlength] = '\0';
	creation_date_length = xchgbufferlength;
}

/* We define first the reference clock (moment) since it's fine grained,
   using the macro in order to avoid the function call overhead, and
   as soon as possible we fix `nunc', this very moment. Having done that
   we set the creation_date, that depends on environment variables being
   set or not. If they are not set or are incorrectly set, we call the
   time2date(nunc).
 */
void
get_sys_time(integer *sys_minutes, integer *sys_day, integer *sys_month,
	integer *sys_year)
{
	char buf[6];
#ifdef DEBUG
	char *debug_;
#endif

	resettimer();

	set_creation_date(time(NULL));
	(void)strncpy(buf, creation_date+2, 4);
	buf[4] = '\0';
	*sys_year = atoi(buf);
	(void)strncpy(buf, creation_date+6, 2);
	buf[2] = '\0';
	*sys_month = atoi(buf);
	(void)strncpy(buf, creation_date+8, 2); /* final nul already set */
	*sys_day = atoi(buf);
	(void)strncpy(buf, creation_date+10, 2); /* final nul already set */
	(void)strncpy(buf+3, creation_date+12, 2);
	buf[5] = '\0';
	*sys_minutes = atoi(buf) * 60 + atoi(buf+3);

	/* last, in order to get ``the'' time as close as possible from
	   calling time.
	 */
#ifdef DEBUG
	debug_ = getenv("KERTEXDEBUG");
	for (; debug_ != NULL && *debug_ != '\0'; ++debug_) {
		/* 's': debug searching; only one level used for now */
		if (*debug_ == 's') ++debug_search_;
		/* 's': debug buf; only one level used for now */
		if (*debug_ == 'b') ++debug_buf_;
	}
#endif
}

void
getcreationdate(void)
{
	(void)strncpy((char *)(xchgbuffer+1), creation_date, creation_date_length);
	xchgbufferlength = creation_date_length;
}

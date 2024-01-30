/* Header for mf incarnations.
   Original: Tim Morgan   December 2, 1988.
   Reworked significantly for kerTeX by Thierry Laronde March 2010.
   2022-03-12 New WEBLIB Open{in,out} API. TL
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "kertex.h"
#include "pascal.h"
#include "web.h"
#ifdef WITH_OGO
#include "ogo.h"
#endif

/* Some things must _not_ be optimized away: be_careful.
 */
#define volatileinteger volatile integer

/* METAFONT relies on a floor half. The shift is suggested by 
   D.E. Knuth himself in the METAFONTbook.
 */
#define half(x)	((x) >> 1)

/* For powers of two, substitute binary operations to div and mod.
 */
#define bdiv(x,k)	((x) >> (k))
#define bmod(x,k)	((x) & (twotothe[k] - 1))

/* libweb::Openin() takes as a second parameter a pathspec and a third
   for the mode. So these are defined as macros.
 */
#define	aopenin(f, p)	Openin(&(f), p, "r")
#define	wopenin(f)	Openin(&(f), MFDUMPPATHSPEC, "rb")

/* This one is defined in extra.c but declared here for 
   libweb::inputln().
 */
EXTERN unsigned int cbufsize;

extern void topenin(void);

/* There is no verification for one byte for efficiency: we use the
   macro putc() and there will be a trailing ';'. Others (several 
   writes hence compound statements) are implemented as functions 
   (one call, but several writes and fatal error on failure).
 */
extern void zbwrite2bytes(FILE *f, integer b);
extern void zbwrite4bytes(FILE *f, integer b);
extern void zbwritebuf(FILE *f, unsigned char *buf, integer first, 
	integer last);

#define	bwritebyte(f,b)		(void) putc((int)((b)&255), f)
#define	bwrite2bytes(f,b)	zbwrite2bytes(f,(integer)(b))
#define	bwrite4bytes(f,b)	zbwrite4bytes(f,(integer)(b))
#define	bwritebuf(fp,buf,first,last)\
	zbwritebuf(fp,(unsigned char *)buf,(integer)(first),(integer)(last))

extern void dumpint(integer x);
#define	undumpint(x)	(void) fread((char *) &(x), sizeof(x), 1, basefile)
#define	dumpqqqq(x)	(void) fwrite((char *) &(x), sizeof(x), 1, basefile)
#define	dumpwd(x)	(void) fwrite((char *) &(x), sizeof(x), 1, basefile)
#define	dumphh(x)	(void) fwrite((char *) &(x), sizeof(x), 1, basefile)
#define	undumpqqqq(x)	(void) fread((char *) &(x), sizeof(x), 1, basefile)
#define	undumpwd(x)	(void) fread((char *) &(x), sizeof(x), 1, basefile)
#define	undumphh(x)	(void) fread((char *) &(x), sizeof(x), 1, basefile)


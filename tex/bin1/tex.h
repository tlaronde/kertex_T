/* Main include file for TeX in C.
   Original: Tim Morgan   December 23, 1987.
   Rework for kerTeX by Thierry Laronde March 2010.
   2022-03-12 New WEBLIB Open{in,out} API. TL
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "kertex.h"
#include "pascal.h"
#include "web.h"

/* libweb::Openin() takes as a second parameter a pathspec and a third
   for the mode. So these are defined as macros.
 */
#define	aopenin(f, p)	Openin(&(f), p, "r")
#define	bopenin(f)	Openin(&(f), INPUTSPATHSPEC, "rb")
#define tfmopenin(f) Openin(&(f), TFMPATHSPEC, "rb")
#define	wopenin(f)	Openin(&(f), DUMPPATHSPEC, "rb")  /* Only used for FMTs */

/* This one is defined in main.c but declared here for 
   libweb::inputln().
 */
EXTERN unsigned int cbufsize;

/* Some types we'll need.
 */
typedef FILE	*alphafile, *bytefile, *wordfile;

/* Global routines implemented as macros, plus some type coercion stuff.
 */
#define	writedvi(a,b)	(void) fwrite((char *) &dvibuf[a], sizeof(dvibuf[a]), (int)(b-a+1), dvifile)
#define	dumpcore	abort
#define	dumpthings(base,len)	(void) fwrite((char *) &(base), sizeof(base), (int)(len), fmtfile)
#define	undumpthings(base,len)	(void) fread((char *) &(base), sizeof(base), (int)(len), fmtfile)

#define	genericputfmt(x)(void) fwrite((char *) &(x), sizeof(x), 1, fmtfile)
#define	genericgetfmt(x)(void) fread((char *) &(x), sizeof(x), 1, fmtfile)
#define putfmtword	genericputfmt
#define getfmtword	genericgetfmt
#define putfmthh	genericputfmt
#define getfmthh	genericgetfmt
#define putfmtqqqq 	genericputfmt
#define	getfmtqqqq	genericgetfmt
extern void putfmtint(integer x);
#define	getfmtint(x)	fread((char *) &x, sizeof(x), 1, fmtfile)


extern void topenin(void);

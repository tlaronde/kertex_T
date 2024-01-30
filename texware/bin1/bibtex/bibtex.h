/* Thierry Laronde 2010-11-24.
   2022-03-12 new WEBLIB API for file opening [TL].
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "kertex.h"
#include "pascal.h"
#include "web.h"

#define	aopenin(f, p)	Openin(&(f), p, "r")
extern void lineread(FILE *f, unsigned int size);

/* Coercing the parameter to (char *)---it's (unsigned char *). */
#define cstrlen(s) strlen((char *)s)

/* In C, we need to take the address of the variable to fill. This is
   not handled by pp2rc.
 */
#define buildin(a,b,c,d) pbuildin(a,b,&c,d)
#define poplitstk(a,b) ppoplitstk(&a,&b)
#define inttoASCII(a,b,c,d) pinttoASCII(a,b,c,&d)
#define adddatabasecite(a) padddatabasecite(&a)

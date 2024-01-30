/* Header for gftype conversion.mf incarnations.
   Thierry Laronde 2010-04-07.
   2022-03-12 new WEBLIB API for file opening [TL].
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "kertex.h"
#include "pascal.h"
#include "web.h"

/* Kind of misnommer: long is guaranteed to be at least 32 bits,
   but we use 32 bits word not long---that may be 64 bits with
   some compilation tool chains. [TL] */
#define LONGMAX  0x7fffffff

/* libweb::Openin() takes as a second parameter a pathspec and a third
   for the mode. So these are defined as macros.
 */
#define	bopenin(f)	Openin(&(f), GFPATHSPEC, "rb")

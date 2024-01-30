/* Thierry Laronde 2010-04-07.
   2022-03-12 New WEBLIB API for opening files [TL].
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "kertex.h"
#include "pascal.h"
#include "web.h"

#define	bopenin(f,p)	Openin(&(f),p, "rb")

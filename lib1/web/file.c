/* File related routines linked to supplementary primitives in Prote.
   C) 2021 Thierry Laronde <tlaronde@polynum.com>
   kerTeX Public Licence v1.0.
 */
#include <stdio.h>
#include "kertex.h"
#include "pascal.h"
#include "web.h"

integer
getfilesize(void)
{
	long fsize;

	if ( fseek(datain, 0L, SEEK_END) != 0
		|| (fsize = ftell(datain)) == -1L
		|| fsize > infinity )
		return -1;
		
	return (integer)fsize;
}

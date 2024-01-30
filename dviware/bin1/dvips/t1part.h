/* t1part.h from t1part.c version 1.59 beta (c)1994, 1996
	by Sergey Lesenko <lesenko@desert.ihep.su>
	Only declarations shared between t1part.c and download.c are here.
	[TL 2010-08-22].
*/
#include <assert.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

/* DEBUG is defined or not in dvips.h included before [TL].
 */
#ifdef DEBUG
#define D_VIEW_VECTOR	 (1<<8)
#define D_CALL_SUBR		(1<<9)
#endif

/* CHAR is typedef'd by <windows.h> -- popineau@esemetz.ese-metz.fr.  */
#define CHAR CHARACTER

typedef struct Char
{
	 unsigned char *name;
	 int length;
	 int num;
	 int choose;
	 struct Char *NextChar;
}
CHAR;

#define NUM_LABEL	  2048
#define BASE_MEM	  16384
#define ADD_MEM		16384

#define FLG_LOAD_BASE	(1)

extern unsigned char grid[];
extern unsigned char *line, *tmpline;
extern int loadbase;
extern struct Char *FirstCharB;

extern void * getmem(unsigned size);
extern CHAR * UnDefineChars(CHAR *TmpChar);
extern int FontPart(FILE *fout, unsigned char *fontfile, unsigned char *vectfile);

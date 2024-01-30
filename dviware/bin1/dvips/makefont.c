#include <math.h>
#include "dvips.h"	/* copyright is here */

char *mfmode;
char *mflandmode;	/* unused at the moment */

/* We try to generate a mf font not found (in pk format) only if
 * explicitely requested.
 * If we do not create the font (or fail to), we send to stderr the
 * command needed to generate the files. 
 * The command is forged here and passed to the system (we do not use
 * anymore the mktexpk(1)). [TL]
 */

/* Forge the command. Pass it to system if requested to do so, or send
 * it to stderr for user help. [TL]
 */
void
makefont(char *name, int dpi, int bdpi)
{
	char *buf;
	int nwritten;
	size_t bsiz;

	bsiz = 512;
	buf = NULL;
	do {
		free(buf);
		bsiz *= 2;
		if ( (buf = malloc(bsiz)) == NULL )
			error("!Unable to allocate memory for makefont cmd buffer!");
		nwritten = snprintf(buf, bsiz,
		". which_kertex;"
		"%s" DIR_SEP MFEXEC " '\\relax;mode_def adhoc = mode_param(pixels_per_inch,%d);enddef;"
		"mode=adhoc; scrollmode; input %s;' >/dev/null 2>&1;"
		"%s" DIR_SEP GFTOPKEXEC " %s.%dgf >/dev/null 2>&1;\n",
		kertex_bindir, dpi, name, kertex_bindir, name, dpi);
	} while (nwritten >= bsiz);

	if ( (do_makefont == true && system(buf) != 0)
		|| do_makefont == false )
		(void) fprintf(stderr, 
			"\n# Command to generate missing font:\n#%s\n", buf);
	free(buf);
}

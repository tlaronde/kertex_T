/*
 *	This routine handles the PostScript prologs that might
 *	be included through:
 *
 *		- Default
 *		- Use of PostScript fonts
 *		- Specific inclusion through specials, etc.
 *		- Use of graphic specials that require them.
 *
 *	Things are real simple.  We build a linked list of headers to
 *	include.  Then, when the time comes, we simply copy those
 *	headers down.
 */
#include "dvips.h" /* The copyright notice in that file is included too! */
struct header_list *header_head;

static void checkhmem(char *s);

/*
 *	This more general routine adds a name to a list of unique
 *	names.
 */
int
add_name(char *s, struct header_list **what)
{
	struct header_list *p, *q;

	for (p = *what; p != NULL; p = p->next)
		if (strcmp(p->name, s)==0)
			return 0;
	q = (struct header_list *)mymalloc(sizeof(struct header_list)
														+ strlen(s));
	q->Hname = infont;
	q->next = NULL;
	strcpy(q->name, s);
	if (*what == NULL)
		*what = q;
	else {
		for (p = *what; p->next != NULL; p = p->next);
		p->next = q;
	}
	return 1;
}

/*
 *	This function checks the virtual memory usage of a header file.
 *	If we can find a VMusage comment, we use that; otherwise, we use
 *	length of the file.
 */
void
checkhmem(char *s)
{
	unsigned int pathspec;
	char *p;
	FILE *fp;

	nameSet(s);
	p = strrchr(s, '.');
	if (strcmp(p , ".pfa") == 0)
		pathspec = FONTSPATHSPEC | PFASUBDIR;
	else if (strcmp(p, ".pfb") == 0) 
		pathspec = FONTSPATHSPEC | PFBSUBDIR;
	else if (strcmp(p, ".enc") == 0) 
		pathspec = FONTSPATHSPEC | ENCSUBDIR;
	else
		pathspec = INPUTSPATHSPEC;
	(void)Openin(&fp, pathspec, "rb");

	if (fp == NULL) {
		(void)sprintf(errbuf, "! Couldn't find header file %s", s);
		error(errbuf);
	} else {
		int len, i, j;
		long mem = -1;
		char buf[1024];

		len = fread(buf, sizeof(char), 1024, fp);
		for (i=0; i<len-20; i++)
			if (buf[i]=='%' && strncmp(buf+i, "%%VMusage:", 10)==0) {
				if (sscanf(buf+i+10, "%d %ld", &j, &mem) != 2)
					mem = -1;
				break;
			}
		if (mem == -1) {
			mem = 0;
			while (len > 0) {
				mem += len;
				len = fread(buf, sizeof(char), 1024, fp);
			}
		}
		if (mem < 0)
			mem = DNFONTCOST;
		(void) fclose(fp);
#ifdef DEBUG
		if (dd(D_HEADER))
			(void)fprintf(stderr, "Adding header file \"%s\" %ld\n",
										  s, mem);
#endif
		fontmem -= mem;
		if (fontmem > 0) /* so we don't count it twice. */
			swmem -= mem;
	}
}

/*
 *	This routine is responsible for adding a header file.  We also
 *	calculate the VM usage.  If we can find a VMusage comment, we
 *	use that; otherwise, we use the length of the file.
 */
int
add_header(char *s)
{
	int r;

	r = add_name(s, &header_head);
	if (r) {
		if (headersready == 1) {
			struct header_list *p = header_head;

			while (p) {
				checkhmem(p->name);
				p = p->next;
			}
			headersready = 2;
		} else if (headersready == 2) {
			checkhmem(s);
		}
	}
	return r;
}

/*
 *	This routine runs down a list, returning each in order.
 */
char *
get_name(struct header_list **what)
{
	if (what && *what) {
		char *p = (*what)->name;
		infont = (*what)->Hname;
		*what =  (*what)->next;
		return p;
	} else
		return 0;
}

/*
 *	This routine actually sends the headers.
 */
void
send_headers(void)
{
	struct header_list *p = header_head;
	char *q;

	while (0 != (q=get_name(&p))) {
#ifdef DEBUG
		if (dd(D_HEADER))
			(void)fprintf(stderr, "Sending header file \"%s\"\n", q);
#endif
	  if (HPS_FLAG) {
 		  if (strcmp(q,"target.dct")==0) noprocset = 1;
		 }
		copyfile(q, pathspecSet(q));
	}
	infont = 0;
}

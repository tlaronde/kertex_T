/* Header for libweb.
 * C) 2010-2012, 2021--2022 Thierry Laronde <tlaronde@polynum.com>
 * All rights reserved and no guarantees.
 */
/* Lib depends on declarations in libc/stdio.h, libc/stdlib.h, 
   libc/string.h and pascal.h.
 */
#ifndef PASCAL_H
  #error "libpascal header not included!"
#endif

#ifndef WEB_H
#define WEB_H

/* The maximum length of a pathname including a directory specifier.
   Use C FILENAME_MAX (frequently 1024) and normalize the Pascal
   code to use file_name_size leading to filenamesize, '_' removed.
   in identifiers (declared as constant in ppdef).
*/
#define	filenamesize	FILENAME_MAX

/* glueratio is only for TeX. To blend with the other memory structure
   members, it should have the same size (32 bits). Hence a float.
 */
#define glueratio float

/* PASCAL-H routines.
 */
#define hbreak(f) (void) fflush(f)
extern void hbreakin(FILE *stream, Boolean val);
/* PATH spec as second parameter to Openin().
 */

/* Only a defined set of paths is initialized for programs.
 */
#define WEBPATHSSET 1
#define MFPATHSSET 2
#define TEXPATHSSET 3
#define DVIPSPATHSSET 4
#define FONTSPATHSSET 5
#define MFTPATHSSET 6
#define BIBTEXPATHSSET 7
#define MPPATHSSET 8
#define ETEXPATHSSET 9
#define CWEBPATHSSET 10
#define PROTEPATHSSET 11

/* We combine as 2^4 units the buffer, and as 2^0 the prefix. [TL]
 */
#define NOPATHSPEC 0U
#define POOLPATHSPEC 0x10U
#define INPUTSPATHSPEC 0x20U
#define DUMPPATHSPEC	0x30U 
#define FONTSPATHSPEC 0x40U
#define NOSUBDIR 0U
#define MFSUBDIR 0x01U
#define GFSUBDIR 0x02U
#define PKSUBDIR 0x03U
#define TFMSUBDIR 0x04U
#define AFMSUBDIR 0x05U
#define PFASUBDIR 0x06U
#define PFBSUBDIR 0x07U
#define ENCSUBDIR 0x08U
#define VFSUBDIR 0x09U
#define BIBSUBDIR 0x0aU
#define BSTSUBDIR 0x0bU

/* We keep here the macro definitions since setpaths() depends on these
 * too.
 */
#define MFPOOLPATHSPEC POOLPATHSPEC
#define MFINPUTSPATHSPEC (INPUTSPATHSPEC|MFSUBDIR)
#define MFDUMPPATHSPEC DUMPPATHSPEC
#define TEXPOOLPATHSPEC POOLPATHSPEC
#define TEXINPUTSPATHSPEC INPUTSPATHSPEC
#define TEXDUMPPATHSPEC DUMPPATHSPEC
#define MFTTEXINPUTSPATHSPEC INPUTSPATHSPEC
#define MFTMFINPUTSPATHSPEC DUMPPATHSPEC /* use alternate buffer */
#define MFPATHSPEC (FONTSPATHSPEC|MFSUBDIR)
#define GFPATHSPEC (FONTSPATHSPEC|GFSUBDIR)
#define PKPATHSPEC (FONTSPATHSPEC|PKSUBDIR)
#define TFMPATHSPEC (FONTSPATHSPEC|TFMSUBDIR)
#define BIBPATHSPEC (INPUTSPATHSPEC|BIBSUBDIR)
#define BSTPATHSPEC (INPUTSPATHSPEC|BSTSUBDIR)

extern char *kertex_bindir;
extern char *kertex_libdir;

extern char *progname;
extern unsigned char cee_realnameoffile[];	/* for Cee access */
extern unsigned char nameoffile[];	/* shared with WEB */
extern int namelength; /* this length is definite in nameoffile[] 
	starting from index 1 */
extern void nameSet(const char *name);	/* convenience for setting above */
extern unsigned char realnameoffile[];	/* shared with WEB */
extern int realnamelength; /* this length is definite in
	realnameoffile[] starting from index 1 */

#define	aopenout(f)	Openout(&(f), "w") /* Always open outputs in cwd */
#define	bopenout(f)	Openout(&(f), "wb")
#define	wopenout(f)	Openout(&(f), "wb")
#define	aclose(f)	if (f != NULL) (void) fclose(f)
#define	bclose(f)	if (f != NULL) (void) fclose(f)
#define	wclose(f)	if (f != NULL) (void) fclose(f)

#define	amakenamestring(f)	makenamestring()
#define	bmakenamestring(f)	makenamestring()
#define	wmakenamestring(f)	makenamestring()

/* A Pascal like string structure... but not used in Pascal code. This
   allows pointing to chunk of strings on a read-only buffer (a constant
   string or an environment variable) where we can not overwrite with
   a '\0' to end the chunks.
 */
typedef struct {
	size_t len;
	const char *sp;
} String_;

extern String_ *dump;	/* this one exported for dvips(1) */
extern String_ *pathSet(const char *spec);
extern void setpaths(char paths_set);
extern Boolean Openin(FILE **f, unsigned int pathspec, const char *mode);
extern Boolean Openout(FILE **f, const char *mode);

/* tangle and weave.
 */
extern void argfmt(integer n);

/* Auxiliary programs use these formatting routines.
 */
extern void printreal(FILE *fp, double r, int n, int m);
extern void printstring(FILE *fp, unsigned char *s, int length);

/* Non Pascal or PASCAL-H, but WEB common.
 */
#define cexit(d) exit(d)
#define decr(x) --(x)
#define	fabs(x)		((x>=0.0)?(x):(-(x)))
#define incr(x) ++(x)
#define putbyte(b,f)	(void) putc((int)((b)&255), f)
#define	toint(x)	((integer) (x))
#define	getsystime(i,j,k,l)	get_sys_time(&(i), &(j), &(k), &(l))
/* This one if for dest array set in C with trailing '\0' taking into
   account.
 */
#define	vstrcpy(a,b)		(void) strcpy((char *)(a), (char *)(b))
/* This one if for dest array set in Pascal with indices and not nul
   terminated. For implementing in C the assignation of a constant
   string to an array.
 */
#define	vstrncpy(a,b,l)		(void) strncpy((char *)(a), (char *)(b), (size_t)(l))
#define zfseek(f,n,w)	(void) fseek(f, (long) n, (int) w)

extern void get_sys_time(integer *sys_minutes, integer *sys_day,
	integer *sys_month, integer *sys_year);
extern void setinvaliddate(void); /* redefined in C from web */
extern void getfilemtime(void); /* sys dependent; see sys/lib1/web */
extern Boolean cinputln(FILE *fp, Boolean bypass_eoln);

extern Boolean aritherror; 
extern integer ftakefraction(integer p, integer q);
extern integer ftakescaled(integer p, integer q);
extern integer fmakefraction(integer p, integer q);
extern integer fmakescaled(integer p, integer q);

/* These are extensions in Prote. But in order to share the maximum
   between the diverse engines, the system dependent part is put in
   the library and is always available, even if it is only used when
   Prote extensions are activated.
 */

#define vreverse(a,b,c,d) reverse(a,b,&(c),&(d)) /* value vs ref */

#define infinity 017777777777 /* max positive scaled integer */

#define xchgbuffersize 64 /* minimum required in Prote */
extern integer xchgbufferlength;
extern unsigned char xchgbuffer[xchgbuffersize+1]; /* indices start at 1 */
extern FILE *datain; /* Defined in WEBLIB in order to test subr */
extern integer getfilesize(void);
extern integer getelapsedtime(void);
extern void resettimer(void);
extern void getfilemtime(void); /* not ISO C; system dependent */
extern void getcreationdate(void);
extern void mdfiveinit(void);
extern void mdfiveupdate(void);
extern void mdfivefinal(void);

#endif /* WEB_H */

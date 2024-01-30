/* Header for the C implementation of some required routines for Pascal
   as of annexe C of ISO/IEC 7185:1990(E).
   C) 2010, 2020--2021 Thierry Laronde <tlaronde@polynum.com>
   All right reserved and no guarantees.
 */
#ifndef PASCAL_H
#define PASCAL_H

#include <stdio.h>
#include <stdlib.h>

/* Machine dependant configuration.
 */

/* The sizes are set at configure time.
   The type `integer' must be a signed integer capable of holding at
   least the range of numbers (-2^31+1)..(2^31-1).  The ANSI C
   standard says that `long' meets this requirement. On 64 bits
   arch, depending on ILP64, LP64, LLP64 the size of a long varies...
   It is 32 bits with Windows compilers, 64 bits generally on Unices,
   it was 32 bits with kencc on Plan9. It depends and it is a waste
   of space since TeX and al. only use (and need) 32 bits.
   But int32_t is optional in C99... 
   RISK uses limits.h to set definitions of BYTE, WYDE and TETRA and
   we use them if they are set.
   We use defines, since these identifiers may be used for typedef
   afterwards, and "typedef unsigned <typedef'ed> <newtype>" doesn't
   work.
*/
#ifdef T_TETRA
#define integer T_TETRA
#else
#define integer long
#endif

/* glue_ratio should be a floating point type but in the integer
   (32 bits) range. Hence we can use IEEE754 float.
   Indeed, since the word is 64 bits because we promote halfword to 32
   bits (because of the LaTeX needs), we could use double that will
   fit (see the remark in  \P 110 of "TeX: The Program").
   But double computations are slower than single precisions. So we
   stick to float i.e. 32 bits floating numbers. [TL]
 */
#define real float

/* The types as macros. Some have default values that shall not be
   changed. Others can be adjusted for optimization depending on the
   target machine.
   For integer, real and glueration, the values are set (typedef) after
   configuration in "kertex.h".

   As K&R A8.2 specifies that "char" does not mean "signed char",
   if a char is unsigned, the parser writes "unsigned char". If
   the char is signed, the parser writes explicitely "signed char".
   There is hence no more macro for this. 
 */

/* Pascal ISO 74185:1990 specifies Boolean with a leading capital,
   while all the others have a leading minuscule. In the programs,
   there is the minuscule version. Hence the define to make Boolean
   an alias of boolean specified.
 */
#ifdef boolean
#undef boolean
#endif
#define boolean char
#define Boolean boolean

#ifdef true
#undef true
#endif
#define true '\1'

#ifdef false
#undef false
#endif
#define false '\0'

/* These ones are direct mapping.
 */
typedef FILE	*text, *file_ptr;
typedef unsigned char	*ccharpointer;

/* pp2rc(1) translates Pascal entry point "program" into main(). argc
 * and argv are defined as global variables, accessible for scanning
 * arguments.
 */
extern int argc;
extern char **argv;

/* macros. */
#define	chr(x)		(x)
#define get(f)		(void) getc(f)
#define	odd(x)		((x) % 2)
#define	ord(x)		(x)
#define pred(x)		((x) - 1)	/* !!! no checking */
#define	readln(f)	{register int c; while ((c=getc(f)) != '\n' && c != EOF);}
/* read() implementation is limited and ad hoc.
 */
#define	read(f, c)	c = getc(f)
#define read2(f,c1,c2)	c1 = getc(f); c2 = getc(f)
#define	rewrite(f,n,l)	f = openf((char *)n+1, l, "wb")
#define	reset(f,n,l)	if (f != NULL) {\
	fclose(f);\
	f = openf((char *)n+1, l, "rb");\
} else\
	f = openf((char *)n+1, l, "rb")

#define succ(x)		((x) + 1)	/* !!! no checking */
#define	trunc(x)	( (integer) (x) )	/* K&R A6.3 alinea 1 */
#define round(x) pround(x)
extern integer pround(double);

extern Boolean eof(FILE *);
extern Boolean eoln(FILE *);
extern FILE *openf(char *name, int length, char *mode);	/* exit() on error */

#endif /* PASCAL_H */

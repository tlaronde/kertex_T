% This is the change file for kerTeX.
% 2012-08-29 Thierry Laronde <tlaronde@polynum.com>
% 2019-08-18 Thierry Laronde: adjust for new release
% 2022-03-12 New WEBLIB API for file opening [TL]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1] C89:string.h (see common.ch). We request standard C. And we use
% weblib path searching.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
#include <ctype.h> /* definition of |isalpha|, |isdigit| and so on */
@y
#include <ctype.h> /* definition of |isalpha|, |isdigit| and so on */
#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include "kertex.h"
#include "pascal.h"
#include "web.h"
#undef boolean
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1] Initializing the path searching.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
main (ac,av)
int ac; char **av;
{
  argc=ac; argv=av;
@y
unsigned char xchr[256];	/* for weblib compatibility */
int
main (int ac, char **av)
{
  argc=ac; argv=av;
  { int i; for (i = 0; i < 256; i++) xchr[i] = (unsigned char) i; }
  setpaths(CWEBPATHSSET);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [3] We use standard C so string.h.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
including their system header files, because the names of the header files
are not as standard as the names of the functions. (There's confusion
between \.{<string.h>} and \.{<strings.h>}.)

@<Predecl...@>=
extern size_t strlen(); /* length of string */
extern char* strcpy(); /* copy one string to another */
extern int strncmp(); /* compare up to $n$ string characters */
extern char* strncpy(); /* copy up to $n$ string characters */
@y
including their system header files, because the names of the header files
are not as standard as the names of the functions. (There's confusion
between \.{<string.h>} and \.{<strings.h>}.)

But here kerTeX request standard C. So \.{<string.h>} is used and we
predeclare nothing related.

@<Predecl...@>=

@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [4] Predeclarations of functions.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ @<Predec...@>=

@y
@ @<Predec...@>=
int input_ln(FILE *fp);
int get_line(void);
void prime_the_change_buffer(void);
void check_change(void);
void reset_input(void);
int wrap_up(void);
void check_complete(void);
void put_line(void);

@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [6] Fix declarations of routines.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
input_ln(fp) /* copies a line into |buffer| or returns 0 */
FILE *fp; /* what file to read from */
@y
int
input_ln(FILE *fp) /* copies a line into |buffer| or returns 0 */
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [7] Changing size of max filename according to stdio.h:FILENAME_MAX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d max_file_name_length 60
@y
@d max_file_name_length FILENAME_MAX + 1
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [9] Fix declarations of routines.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
void
prime_the_change_buffer()
@y
void
prime_the_change_buffer(void)
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [13] Fix declarations of routines.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
void
check_change() /* switches to |change_file| if the buffers match */
@y
void
check_change(void) /* switches to |change_file| if the buffers match */
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [14] Fix declarations of routines.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
void
reset_input()
@y
void
reset_input(void)
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [] Fix declarations of routines.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
int get_line() /* inputs the next line */
@y
int get_line(void) /* inputs the next line */
@z

@x
void put_line()
@y
void put_line(void)
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [22] Let kerTeX routines do the path searching.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ @<Try to open...@>= {
  char temp_file_name[max_file_name_length];
  char *cur_file_name_end=cur_file_name+max_file_name_length-1;
  char *k=cur_file_name, *kk;
  int l; /* length of file name */

  if (*loc=='"') {
    loc++;
    while (*loc!='"' && k<=cur_file_name_end) *k++=*loc++;
    if (loc==limit) k=cur_file_name_end+1; /* unmatched quote is `too long' */
  } else
    while (*loc!=' '&&*loc!='\t'&&*loc!='"'&&k<=cur_file_name_end) *k++=*loc++;
  if (k>cur_file_name_end) too_long();
@.Include file name ...@>
  *k='\0';
  if ((cur_file=fopen(cur_file_name,"r"))!=NULL) {
    cur_line=0;
    goto restart; /* success */
  }
  kk=getenv("CWEBINPUTS");
  if (kk!=NULL) {
    if ((l=strlen(kk))>max_file_name_length-2) too_long();
    strcpy(temp_file_name,kk);
  }
  else {
#ifdef CWEBINPUTS
    if ((l=strlen(CWEBINPUTS))>max_file_name_length-2) too_long();
    strcpy(temp_file_name,CWEBINPUTS);
#else
    l=0;
#endif /* |CWEBINPUTS| */
  }
  if (l>0) {
    if (k+l+2>=cur_file_name_end)  too_long();
@.Include file name ...@>
    for (; k>= cur_file_name; k--) *(k+l+1)=*k;
    strcpy(cur_file_name,temp_file_name);
    cur_file_name[l]='/'; /* \UNIX/ pathname separator */
    if ((cur_file=fopen(cur_file_name,"r"))!=NULL) {
      cur_line=0;
      goto restart; /* success */
    }
  }
  include_depth--; err_print("! Cannot open include file"); goto restart;
}
@y
@ @<Try to open...@>= {
  char *cur_file_name_end=cur_file_name+max_file_name_length-1;
  char *k=cur_file_name;

  if (*loc=='"') {
    loc++;
    while (*loc!='"' && k<=cur_file_name_end) *k++=*loc++;
    if (loc==limit) k=cur_file_name_end+1; /* unmatched quote is `too long' */
  } else
    while (*loc!=' '&&*loc!='\t'&&*loc!='"'&&k<=cur_file_name_end) *k++=*loc++;
  if (k>cur_file_name_end) too_long();
@.Include file name ...@>
  *k='\0';
  nameSet(cur_file_name);	/* dialog with weblib */
  if (Openin(&cur_file, INPUTSPATHSPEC, "r")==true) {
    cur_line=0;
    goto restart; /* success */
  }
  include_depth--; err_print("! Cannot open include file"); goto restart;
}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [] Fix declarations of routines.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
void
check_complete(){
@y
void
check_complete(void){
@z

@x
@<Predecl...@>=
void  err_print();
@y
@<Predecl...@>=
void  err_print(char *s);
@z

@x
@<Functions...@>=
void
err_print(s) /* prints `\..' and location of error message */
char *s;
@y
@<Functions...@>=
void
err_print(char *s) /* prints `\..' and location of error message */
@z

@x
@<Func...@>=
wrap_up() {
@y
@<Func...@>=
int wrap_up(void) {
@z

@x
@<Pred...@>=
void scan_args();
@y
@<Pred...@>=
void scan_args(void);
@z

@x
@<Function...@>=
void
scan_args()
@y
@<Function...@>=
void
scan_args(void)
@z


% This is the change file for kerTeX.
% 2011-12-25 Thierry Laronde <tlaronde@polynum.com>
% 2022-03-12 new WEBLIB API for file opening [TL]
% 2023-07-24 update for 4.9 [TL]
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1] kerTeX installation dir for non machine dependent stuff, in order
% to set CWEBINPUTS. We use kerTeX search routines.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@<Include files@>@/
@h
@y
@<Include files@>@/
#include "kertex.h"
#include "pascal.h"
#include "web.h"
#undef boolean
@h
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [2] Changing size of max filename according to stdio.h:FILENAME_MAX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d max_file_name_length 60
@y
@d max_file_name_length (FILENAME_MAX+1)
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [19] Initializing the path searching.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@c
void
common_init(void)
{
  @<Initialize pointers@>@;
@y
@c
unsigned char xchr[256];	/* for weblib compatibility */

void
common_init(void)
{
  { int i; for (i = 0; i < 256; i++) xchr[i] = (unsigned char) i; }
  setpaths(CWEBPATHSSET);
  @<Initialize pointers@>@;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [38] Use weblib searching facilities.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@<Try to open...@>= {
  char temp_file_name[max_file_name_length];
  char *cur_file_name_end=cur_file_name+max_file_name_length-1;
  char *kk, *k=cur_file_name;
  size_t l; /* length of file name */

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
    cur_line=0; print_where=true;
    goto restart; /* success */
  }
  if ((kk=getenv("CWEBINPUTS"))!=NULL) {
@.CWEBINPUTS@>
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
    if (k+l+2>=cur_file_name_end) too_long();
@.Include file name ...@>
    for (; k>=cur_file_name; k--) *(k+l+1)=*k;
    strcpy(cur_file_name,temp_file_name);
    cur_file_name[l]='/'; /* \UNIX/ pathname separator */
    if ((cur_file=fopen(cur_file_name,"r"))!=NULL) {
      cur_line=0; print_where=true;
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
    cur_line=0; print_where=1;
    goto restart; /* success */
  }
  include_depth--; err_print("! Cannot open include file"); goto restart;
}
@z


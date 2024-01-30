% Change file for adjust tex/bin1/kertex.ch for Prote by
% Thierry Laronde.
% 
% Modification history:
%
% 2021-09-11 TL
%    Prote adjustements.
%
% NOTE: the module numbers in this change file refer to the published
%  text in TeX: The Program, Volume B of Computers&Typesetting, 1986.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d Prote_version_string=='3.141592653-2.6-1.1.0' {current \Prote\ version}
@y
@d Prote_version_string=='kerTeX C 3.141592653-2.6-1.1.0' {current \Prote\ version}
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1.11] compile-time constants; mem_max enlarged. We transform mem_top
% in a variable due to its (changed) sizes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!pool_name='tex.pool';
@!pool_name_length=8;
  {required: |name_of_file| and |name_length| have to be both defined}
@y
@!pool_name='prote.pool';
@!pool_name_length=10;
  {required: |name_of_file| and |name_length| have to be both defined}
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [29.520] default format. See module below too.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
a C string.

@d format_default_length=9 {length of the |TEX_format_default| string}
@d format_area_length=0 {length of its area part}
@d format_ext_length=4 {length of its `\.{.fmt}' part}
@d format_extension=".fmt" {the extension, as a \.{WEB} constant}
  {not empty and distinct from ".tex", ".log", "tfm" and ".dvi"}
@y
a C string.

Distinct objects shall have distinct names. \TeX\ has formats.
/Prote has digests.

@d format_default_length=10 {length of the |TEX_format_default| string}
@d format_area_length=0 {length of its area part}
@d format_ext_length=5 {length of its `\.{.dgst}' part}
@d format_extension=".dgst" {the extension, as a \.{WEB} constant}
  {not empty and distinct from ".fmt", ".base", ".mem"}
  {and  ".tex", ".log", "tfm" and ".dvi"}
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [29.521] plain format location
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
vstrncpy(TEX_format_default + 1, 'plain.fmt', format_default_length);
@y
vstrncpy(TEX_format_default + 1, 'plain.dgst', format_default_length);
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [51.1332] call to set_paths for Prote ones
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
set_paths(TEX_PATHS_SET); {get default file paths from the Unix environment}
@y
set_paths(PROTE_PATHS_SET); {get default file paths from the Unix environment}
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [53a] \eTeX: fixing call to pointer to variables instead of variable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
cur_h:=0; link(p):=reverse(this_box,null,cur_g,cur_glue); width(p):=-cur_h;
@y
cur_h:=0; link(p):=v_reverse(this_box,null,cur_g,cur_glue); width(p):=-cur_h;
@z
@x
link(p):=reverse(this_box,new_edge(reflected,0),cur_g,cur_glue);
@y
link(p):=v_reverse(this_box,new_edge(reflected,0),cur_g,cur_glue);
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [53b] \Prote: xchg_buffer and xchg_buffer_length externally defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
\.{\\filemoddate} that is $23$ \.{text\_char}. So at least $64$ for now.

@<Global...@>=
@!xchg_buffer:array[1..xchg_buffer_size] of eight_bits;
  {exchange buffer for interaction with system routines}
@!xchg_buffer_length:integer; {last valid index in this buf; 0 means no data}
@y
\.{\\filemoddate} that is $23$ \.{text\_char}. So at least $64$ for now.

@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [53b] \Prote: data_in externally defined for debugging purposes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
variable external routine may refer to for processing.

@<Global...@>=
@!data_in:byte_file; {opening here, but letting external routines handle}
@y
variable external routine may refer to for processing.

|data_in| is externally defined in order to be able to test the external
code independantly.
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [53b] \Prote: system dependencies: get_creation_date
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x get_creation_date() provided by WEBLIB
It is here only an alias to |set_invalid_date|.

@d get_creation_date==set_invalid_date 
@y
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [53b] \Prote: system dependencies: get_elapsed_time()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
the permanent answer.
@^system dependencies@>

@d get_elapsed_time==infinity {a function should be implemented}
@y
the permanent answer.
@^system dependencies@>
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [53b] \Prote: system dependencies: reset_timer()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
Standard \PASCAL\ doesn't provide related routines so our
syntactically correct but semantically useless routines are implemented
here: the |reset_timer| does nothing, while the |get_elapsed_time|
simply returns, even when |reset_timer| has been called, the invalid
value |infinity|. 

@d reset_timer==do_nothing
@y
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [53b] \Prote: system dependencies: get_file_size()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
The code below is a basic working implementation; but the result
can obviously be obtained more efficiently by the system, without
reading the contents of the file. The file is opened externally
and is closed externally.
@^system dependencies@>

@<Declare \Prote\ procedures for scanning@>=
function get_file_size:integer;
var k:integer; {length to be returned}
@!i:integer; {byte returned; unused}
begin k:=0; repeat read(data_in,i);incr(k); until eof(data_in);
get_file_size:=k;
end;
@y
This routine is externally implemented.
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [53b] \Prote: system dependencies: get_file_mtime()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
In this basic implementation, we set the string to the empty one by
simply setting |xchg_buffer_length| to $0$.

@d get_file_mtime==xchg_buffer_length:=0
@y
This routine is externally provided.
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [53b] \Prote: system dependencies: mdfive*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
unchanged.

@d mdfive_init==do_nothing
@y
unchanged.

This routine is externally provided.
@z
@x

@d mdfive_update==xchg_buffer_length:=0
@y

This routine is externally provided.
@z
@x
Here, by default, we do nothing except carefully set
|xchg_buffer_length| to $0$ in order to state that we have consumed
the data.

@d mdfive_final==xchg_buffer_length:=0
@y
This routine is externally provided.
@z

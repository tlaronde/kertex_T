% tangle.ch for C compilation under kerTeX.
% The original version of this file was created by Howard Trickey and
% Pavel Curtis.
%
% History:
%  10/9/82 (HT) Original version
%  11/29   (HT) New version, with conversion to lowercase handled properly
%               Also, new control sequence:
%                       @=...text...@>   Put ...text... verbatim on a line
%                                        by itself in the Pascal output.
%                                        (argument must fit on one line)
%               This control sequence facilitates putting #include "gcons.h"
%               (for example) in files meant for the pc compiler.
%               Also, changed command line usage, so that the absence of a
%               change file implies no change file, rather than one with the
%               same name as the web file, with .ch at the end.
%  1/15/83 (HT) Changed to work with version 1.2, which incorporates the
%               above change (though unbundling the output line breaking),
%               so mainly had to remove stuff.
%  2/17    (HT) Fixed bug that caused 0-9 in identifiers to be converted to
%               Q-Y on output.
%  3/18    (HT) Brought up to work with Version 1.5.  Added -r command line
%               flag to cause a .rpl file to be written with all the lines
%               of the .web file that were replaced because of the .ch file
%               (useful for comparing with previous .rpl files, to see if a
%               change file will still work with a new version of a .web file)
%               Also, made it write a newline just before exit.
%  4/12    (PC) Merged with Pavel's version, including adding a call to exit()
%               at the end depending upon the value of history.
%  4/16    (PC) Brought up to date with version 1.5 released April, 1983.
%  6/28   (HWT) Brought up to date with version 1.7 released June, 1983.
%               With new change file format, the -r option is now unnecessary.
%  7/17   (HWT) Brought up to date with version 2.0 released July, 1983.
% 12/18/83 (ETM) Brought up to date with version 2.5 released November, 1983.
% 11/07/84 (ETM) Brought up to date with version 2.6.
% 12/15/85 (ETM) Brought up to date with version 2.8.
% 03/07/88 (ETM) Converted for use with WEB2C
% 01/02/89 (PAM) Cosmetic upgrade to version 2.9
% 11/30/89 (KB)  Version 4.
% 2009-12-16 (TL) Version 4.4:
%	- the banner;
%	- the .p and .pool files are created in the current directory and
%		_not_ in the source directory (may be read only or with
%		``precious'' files.
% 2009-12-19 (TL) Version 4.5: the banner.
% 2017-04-10 (TL): allow signed tetra constant values (for big added
% packages---pgfplot) by redifining equiv.
%
% 2021-04-21 (TL) Version 4.6: the banner.
% 2022-03-05 (TL) argfmt, rewrite, reset and file opening modifications
%   for space handling in file names. print_string() takes supplementary
%   parameter: string length.
%
% NOTE: The module numbers refer to the red-covered listing (Version 2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [0] WEAVE: print only changes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=\contentspagenumber \advance\pageno by 1
\let\maybe=\iffalse
\def\title{TANGLE changes C}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1] Change banner message
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d banner=='This is TANGLE, Version 4.6'
@y
@d banner=='This is TANGLE, C Version 4.6'
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [2] remove arguments and add ref to scan_args.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d end_of_TANGLE = 9999 {go here to wrap it up}

@p @t\4@>@<Compiler directives@>@/
program TANGLE(@!web_file,@!change_file,@!Pascal_file,@!pool);
label end_of_TANGLE; {go here to finish}
const @<Constants in the outer block@>@/
type @<Types in the outer block@>@/
var @<Globals in the outer block@>@/
@<Error handling procedures@>@/
@y
@d end_of_TANGLE = 9999 {go here to wrap it up}

@p program TANGLE;
label end_of_TANGLE; {go here to finish}
const @<Constants in the outer block@>@/
type @<Types in the outer block@>@/
var @<Globals in the outer block@>@/
@<Error handling procedures@>@/
@<Declaration of |scan_args|@>@/
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [4] compiler options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@{@&$C-,A+,D-@} {no range check, catch arithmetic overflow, no debug overhead}
@!debug @{@&$C+,D+@}@+ gubed {but turn everything on when debugging}
@y
@=(*$C-*)@> {no range check}
@!debug @=(*$C+*)@>@+ gubed {but turn everything on when debugging}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [6] Let the macros for incr() and decr() stay as is.
% [6] We can not use succ() and pred() since these are functions (we
% [6] want to have a side effect to change the variable without
% [6] assignment).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ Here are some macros for common programming idioms.

@d incr(#) == #:=#+1 {increase a variable by unity}
@d decr(#) == #:=#-1 {decrease a variable by unity}
@y
@ Here are some macros for common programming idioms.

@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [8] Constants: increase some of them in order to allow processing
% big files. (e-TeX needs some of these increases.)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!buf_size=100; {maximum length of input line}
@!max_bytes=45000; {|1/ww| times the number of bytes in identifiers,
  strings, and module names; must be less than 65536}
@!max_toks=65000; {|1/zz| times the number of bytes in compressed \PASCAL\ code;
  must be less than 65536}
@!max_names=4000; {number of identifiers, strings, module names;
  must be less than 10240}
@!max_texts=2000; {number of replacement texts, must be less than 10240}
@!hash_size=353; {should be prime}
@!longest_name=400; {module names shouldn't be longer than this}
@!line_length=72; {lines of \PASCAL\ output have at most this many characters}
@!out_buf_size=144; {length of output buffer, should be twice |line_length|}
@!stack_size=50; {number of simultaneous levels of macro expansion}
@!max_id_length=12; {long identifiers are chopped to this length, which must
  not exceed |line_length|}
@!unambig_length=7; {identifiers must be unique if chopped to this length}
  {note that 7 is more strict than \PASCAL's 8, but this can be varied}
@y
@!buf_size=100; {maximum length of input line}
@!max_bytes=65535; {|1/ww| times the number of bytes in identifiers,
  strings, and module names; must be less than 65536}
@!max_toks=65535; {|1/zz| times the number of bytes in compressed \PASCAL\ code;
  must be less than 65536}
@!max_names=5000; {number of identifiers, strings, module names;
  must be less than 10240}
@!max_texts=2500; {number of replacement texts, must be less than 10240}
@!hash_size=353; {should be prime}
@!longest_name=400; {module names shouldn't be longer than this}
@!line_length=72; {lines of \PASCAL\ output have at most this many characters}
@!out_buf_size=144; {length of output buffer, should be twice |line_length|}
@!stack_size=100; {number of simultaneous levels of macro expansion}
@!max_id_length=50; {long identifiers are chopped to this length, which must
  not exceed |line_length|}
@!unambig_length=20; {identifiers must be unique if chopped to this length}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [12] The text_char type is used as an array index into xord. Since 
% C doesn't deal with subrange, and since we need unsigned char,
% ASCII_code range is a perfect match.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
@d text_char == char {the data type of characters in text files}
@y
@d text_char == ASCII_code {the data type of characters in text files}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [17] enable maximum character set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
for i:=1 to @'37 do xchr[i]:=' ';
for i:=@'200 to @'377 do xchr[i]:=' ';
@y
for i:=1 to @'37 do xchr[i]:=chr(i);
for i:=@'200 to @'377 do xchr[i]:=chr(i);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [20] terminal output: use standard i/o
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d print(#)==write(term_out,#) {`|print|' means write on the terminal}
@y
@d term_out==stdout
@d print(#)==write(term_out,#) {`|print|' means write on the terminal}
@z

@x
@<Globals...@>=
@!term_out:text_file; {the terminal as an output file}
@y
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [21] init terminal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ Different systems have different ways of specifying that the output on a
certain file will appear on the user's terminal. Here is one way to do this
on the \PASCAL\ system that was used in \.{TANGLE}'s initial development:
@^system dependencies@>

@<Set init...@>=
rewrite(term_out,'TTY:'); {send |term_out| output to the terminal}
@y
@ Different systems have different ways of specifying that the output on a
certain file will appear on the user's terminal.
@^system dependencies@>

@<Set init...@>=
 {Nothing need be done for C.}
@z

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [22] break is a C reserved name => hbreak defined in web.h
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d update_terminal == break(term_out) {empty the terminal output buffer}
@y
@d update_terminal == hbreak(term_out) {empty the terminal output buffer}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [24] open input files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ The following code opens the input files.  Since these files were listed
in the program header, we assume that the \PASCAL\ runtime system has
already checked that suitable file names have been given; therefore no
additional error checking needs to be done.
@^system dependencies@>

@p procedure open_input; {prepare to read |web_file| and |change_file|}
begin reset(web_file); reset(change_file);
end;
@y
@ In this implementation, the opening of files is done while we scan the
arguments provided on the command line, that is directly in |scan_args|.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [26] open output files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ The following code opens |Pascal_file| and |pool|.
Since these files were listed in the program header, we assume that the
\PASCAL\ runtime system has checked that suitable external file names have
been given.
@^system dependencies@>

@<Set init...@>=
rewrite(Pascal_file); rewrite(pool);
@y
@ The following code opens |Pascal_file| and |pool|.
The file are opened while the |scan_args| procedure scan the command
line.

@<Set init...@>=
set_paths(WEB_PATHS_SET); {retrieve environment for paths if set by user}
scan_args;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [28] Fix f^
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
if eof(f) then input_ln:=false
else  begin while not eoln(f) do
    begin buffer[limit]:=xord[f^]; get(f);
    incr(limit);
    if buffer[limit-1]<>" " then final_limit:=limit;
    if limit=buf_size then
      begin while not eoln(f) do get(f);
@y
if eof(f) then input_ln:=false
else  begin while not eoln(f) do
    begin buffer[limit]:=xord[getc(f)];
    incr(limit);
    if buffer[limit-1]<>" " then final_limit:=limit;
    if limit=buf_size then
      begin while not eoln(f) do get(f);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [34] Fix jump_out: in C we should be doing a longjmp() since the
% label is outside the scope of jump_out.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d fatal_error(#)==begin new_line; print(#); error; mark_fatal; jump_out;
  end

@<Error handling...@>=
procedure jump_out;
begin goto end_of_TANGLE;
end;
@y
@d jump_out==cexit(1)
@d fatal_error(#)==begin new_line; print(#); error; mark_fatal; cexit(1);
  end
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [38] Data Structures: provide for larger |byte_mem| and |tok_mem|
% and tetra constants.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x Extra capacity:
@d ww=2 {we multiply the byte capacity by approximately this amount}
@d zz=3 {we multiply the token capacity by approximately this amount}
@y
@d ww=3 {we multiply the byte capacity by approximately this amount}
@d zz=4 {we multiply the token capacity by approximately this amount}
@z

@x
@!equiv: array [0..max_names] of sixteen_bits; {info corresponding to names}
@y
@!equiv: array [0..max_names] of integer; {info corresponding to names;
enough for a sixteen_bits positive index or a signed tetra const}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [48] Extending constant arithmetic done by TANGLE to tetra.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
\yskip\hang |numeric| identifiers have been defined to be numeric macros;
their |equiv| value contains the corresponding numeric value plus $2^{15}$.
Strings are treated as numeric macros.
@y
\yskip\hang |numeric| identifiers have been defined to be numeric macros;
their |equiv| value contains the corresponding numeric value.
Strings are treated as numeric macros.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [63] Remove conversion to uppercase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
    begin if c>="a" then c:=c-@'40; {merge lowercase with uppercase}
@y
    begin 
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [64] Equiv can handle positive wydes and signed tetras as immediate
% constant. No need to add a constant to a signed value to ensure the
% result is >= 0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
if l-double_chars=2 then {this string is for a single character}
  equiv[p]:=buffer[id_first+1]+@'100000
else  begin equiv[p]:=string_ptr+@'100000;
@y
if l-double_chars=2 then {this string is for a single character}
  equiv[p]:=buffer[id_first+1]
else  begin equiv[p]:=string_ptr;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [89] Equiv can handle positive wydes and signed tetras as immediate
% constant. No need to add a constant to a signed value to ensure the
% result is >= 0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
numeric: begin cur_val:=equiv[a]-@'100000; a:=number;
  end;
@y
numeric: begin cur_val:=equiv[a]; a:=number;
  end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [105] Accept DIV, div, MOD, and mod
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
 (((out_contrib[1]="D")and(out_contrib[2]="I")and(out_contrib[3]="V")) or@|
 ((out_contrib[1]="M")and(out_contrib[2]="O")and(out_contrib[3]="D")) ))or@|
@^uppercase@>
@y
  (((out_contrib[1]="D")and(out_contrib[2]="I")and(out_contrib[3]="V")) or@|
  ((out_contrib[1]="d")and(out_contrib[2]="i")and(out_contrib[3]="v")) or@|
  ((out_contrib[1]="M")and(out_contrib[2]="O")and(out_contrib[3]="D")) or@|
  ((out_contrib[1]="m")and(out_contrib[2]="o")and(out_contrib[3]="d")) ))or@|
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [110] lowercase ids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@^uppercase@>
  if ((out_buf[out_ptr-3]="D")and(out_buf[out_ptr-2]="I")and
    (out_buf[out_ptr-1]="V"))or @/
     ((out_buf[out_ptr-3]="M")and(out_buf[out_ptr-2]="O")and
    (out_buf[out_ptr-1]="D")) then@/ goto bad_case
@y
  if ((out_buf[out_ptr-3]="D")and(out_buf[out_ptr-2]="I")and
    (out_buf[out_ptr-1]="V"))or @/
     ((out_buf[out_ptr-3]="d")and(out_buf[out_ptr-2]="i")and
    (out_buf[out_ptr-1]="v"))or @/
     ((out_buf[out_ptr-3]="M")and(out_buf[out_ptr-2]="O")and
    (out_buf[out_ptr-1]="D"))or @/
     ((out_buf[out_ptr-3]="m")and(out_buf[out_ptr-2]="o")and
    (out_buf[out_ptr-1]="d")) then@/ goto bad_case
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [114] lowercase operators (`and', `or', etc.)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
and_sign: begin out_contrib[1]:="A"; out_contrib[2]:="N"; out_contrib[3]:="D";
@^uppercase@>
  send_out(ident,3);
  end;
not_sign: begin out_contrib[1]:="N"; out_contrib[2]:="O"; out_contrib[3]:="T";
  send_out(ident,3);
  end;
set_element_sign: begin out_contrib[1]:="I"; out_contrib[2]:="N";
  send_out(ident,2);
  end;
or_sign: begin out_contrib[1]:="O"; out_contrib[2]:="R"; send_out(ident,2);
@y
and_sign: begin out_contrib[1]:="a"; out_contrib[2]:="n"; out_contrib[3]:="d";
  send_out(ident,3);
  end;
not_sign: begin out_contrib[1]:="n"; out_contrib[2]:="o"; out_contrib[3]:="t";
  send_out(ident,3);
  end;
set_element_sign: begin out_contrib[1]:="i"; out_contrib[2]:="n";
  send_out(ident,2);
  end;
or_sign: begin out_contrib[1]:="o"; out_contrib[2]:="r"; send_out(ident,2);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [116] Remove conversion to uppercase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ Single-character identifiers represent themselves, while longer ones
appear in |byte_mem|. All must be converted to uppercase,
with underlines removed. Extremely long identifiers must be chopped.

(Some \PASCAL\ compilers work with lowercase letters instead of
uppercase. If this module of \.{TANGLE} is changed, it's also necessary
to change from uppercase to lowercase in the modules that are
listed in the index under ``uppercase''.)
@^system dependencies@>
@^uppercase@>

@d up_to(#)==#-24,#-23,#-22,#-21,#-20,#-19,#-18,#-17,#-16,#-15,#-14,
  #-13,#-12,#-11,#-10,#-9,#-8,#-7,#-6,#-5,#-4,#-3,#-2,#-1,#

@<Cases related to identifiers@>=
"A",up_to("Z"): begin out_contrib[1]:=cur_char; send_out(ident,1);
  end;
"a",up_to("z"): begin out_contrib[1]:=cur_char-@'40; send_out(ident,1);
  end;
identifier: begin k:=0; j:=byte_start[cur_val]; w:=cur_val mod ww;
  while (k<max_id_length)and(j<byte_start[cur_val+ww]) do
    begin incr(k); out_contrib[k]:=byte_mem[w,j]; incr(j);
    if out_contrib[k]>="a" then out_contrib[k]:=out_contrib[k]-@'40
    else if out_contrib[k]="_" then decr(k);
    end;
  send_out(ident,k);
  end;
@y
@ Single-character identifiers represent themselves, while longer ones
appear in |byte_mem|. All must be converted to lowercase,
with underlines removed. Extremely long identifiers must be chopped.
@^system dependencies@>

@d up_to(#)==#-24,#-23,#-22,#-21,#-20,#-19,#-18,#-17,#-16,#-15,#-14,
  #-13,#-12,#-11,#-10,#-9,#-8,#-7,#-6,#-5,#-4,#-3,#-2,#-1,#

@<Cases related to identifiers@>=
"A",up_to("Z"),
"a",up_to("z"): begin out_contrib[1]:=cur_char; send_out(ident,1);
  end;
identifier: begin k:=0; j:=byte_start[cur_val]; w:=cur_val mod ww;
  while (k<max_id_length)and(j<byte_start[cur_val+ww]) do
    begin incr(k); out_contrib[k]:=byte_mem[w,j]; incr(j);
    if out_contrib[k]="_" then decr(k);
    end;
  send_out(ident,k);
  end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [134] Remove open_input call.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ @<Initialize the input system@>=
open_input; line:=0; other_line:=0;@/
@y
@ @<Initialize the input system@>=
line:=0; other_line:=0;@/
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [157] Fix casting bug
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d add_in(#)==begin accumulator:=accumulator+next_sign*(#); next_sign:=+1;
  end
@y
@d add_in(#)==begin accumulator:=accumulator+next_sign*toint(#); next_sign:=+1;
  end
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [157] Equiv can handle positive wydes and signed tetras as immediate
% constant. No need to add a constant to a signed value to ensure the
% result is >= 0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
if abs(accumulator)>=@'100000 then
  begin err_print('! Value too big: ',accumulator:1); accumulator:=0;
@.Value too big@>
  end;
equiv[p]:=accumulator+@'100000; {name |p| now is defined to equal |accumulator|}
@y
equiv[p]:=accumulator; {name |p| now is defined to equal |accumulator|}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [158] Equiv can handle positive wydes and signed tetras as immediate
% constant. No need to add a constant to a signed value to ensure the
% result is >= 0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
  identifier: begin q:=id_lookup(normal);
    if ilk[q]<>numeric then
      begin next_control:="*"; goto reswitch; {leads to error}
      end;
    add_in(equiv[q]-@'100000);
    end;
@y
  identifier: begin q:=id_lookup(normal);
    if ilk[q]<>numeric then
      begin next_control:="*"; goto reswitch; {leads to error}
      end;
    add_in(equiv[q]);
    end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [179] make term_in = input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
any error stop will set |debug_cycle| to zero.
@y
any error stop will set |debug_cycle| to zero.

@d term_in==stdin
@z

@x
@!term_in:text_file; {the user's terminal as an input file}
@y

@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [180] remove term_in reset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
reset(term_in,'TTY:','/I'); {open |term_in| as the terminal, don't do a |get|}
@y

@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [182] write newline just before exit; use value of |history|
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@<Print the job |history|@>;
@y
@<Print the job |history|@>;
new_line;
if (history <> spotless) and (history <> harmless_message) then
    cexit(1)
else
    cexit(0);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [188] system dependent changes--the |scan_args| procedure.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
This module should be replaced, if necessary, by changes to the program
that are necessary to make \.{TANGLE} work at a particular installation.
It is usually best to design your change file so that all changes to
previous modules preserve the module numbering; then everybody's version
will be consistent with the printed program. More extensive changes,
which introduce new modules, can be inserted here; then only the index
itself will get a new module number.
@^system dependencies@>
@y
@ Here is a special handling on the C |main| entry: scanning the
arguments provided on the command line.

The handling is done using the facilities provided by the C libweb. All
the file names are taken ``as is'', i.e. there is no path searching. One
exception though: if no change file is provided, we open ``null.tex'',
an empty (only comments) file installed by kerTeX. This is in order to
avoid giving ``/dev/null'', which is not a C thing.

There are no flags that affect \.{TANGLE} at the moment.

@ The |scan_args| procedure looks at the command line arguments, and the
C externally defined |name_of_file| is used for convenience.

At least one file name must be present: the \.{WEB} file.  It may have
an extension, or it may omit it to get |'.web'| added.
The \PASCAL\ output file name is formed by replacing the \.{WEB} file
name extension by |'.p'|.
Similarly, the pool file name is formed using a |'.pool'| extension.

If there is another file name present among the arguments, it is the
change file, again either with an extension or without one to get |'.ch'|
An omitted change file argument means that |'null.tex'| should be used,
when no changes are desired.

@<Declaration of |scan_args|@>=
procedure scan_args;
var dot_pos, sep_pos, i, a: integer; {indices}
max_suffix_length: integer; {we need this more at most}
c: char;
@!found_web,@!found_change: boolean; {|true| when those file names have
                                        been seen}
begin
found_web:=false;
found_change:=false;
for a:=1 to argc-1 do begin
        argfmt(a); {put argument number |a| into |name_of_file|}
        if name_of_file[1]<>'-' then begin
                if not found_web then
                        @<Get |web_file_name|, |pascal_file_name|, and
                                | pool_file_name| variables from |name_of_file|@>
                else if not found_change then
                        @<Get |change_file_name| from |name_of_file|@>
                else  @<Print usage error message and quit@>;
                end
        else @<Handle flag argument in |name_of_file|@>;
        end;
if not found_web then @<Print usage error message and quit@>;
if not found_change then @<Set up null change file@>;
end;

@ In every case, the tentative file name is in |name_of_file|. We
will define |sep_pos| and |dot_pos| in |name_of_file| in order to be
able to add a suffix if it is not there (assuming that if we found a
dot, the suffix is correct; we take it as is if it is there).

We need to verify, first, that |dot_pos| is after the directory
separator |sep_pos| if defined and, second, that if we want to add a
suffix, there is enough room for it.

Since this chunk is shared and the suffix varies, the variable
|max_suffix_length|---including the dot---has to be set before calling
the section, since it's a parameter.

@<Set |dot_pos| and |sep_pos| from |name_of_file|; |abort| is not enough
room for the lengthest suffix according to |max_suffix_length|@>=
dot_pos:=-1;
sep_pos:=-1;
i:=name_length;
while ((dot_pos=-1) or (sep_pos=-1)) and (i>0) do begin
        if (name_of_file[i]='.') and (dot_pos=-1) then dot_pos:=i;
        if (name_of_file[i]='/') and (sep_pos=-1) then sep_pos:=i;
        decr(i);
        end;
if sep_pos>dot_pos then dot_pos:=-1;
if ( (dot_pos=-1) and (name_length > (file_name_size-max_suffix_length)) )
  or ( (dot_pos<>-1) and (dot_pos > (file_name_size-max_suffix_length+1)) ) then
        begin {not enough room for the suffixes}
	    print_string(stdout, name_of_file, name_length);
	    print_ln(': filename too long.');
	    cexit(1);
        end;

@ Use all of |name_of_file| as the |web_file_name|, appending |'.web'|
if not there.

The other file names come from removing dirname---the created files are
created in the current directory and not in the source one that may be
read only or already have ``precious'' files with the same name---adding
things after the dot.

The |reset| and |rewrite| procedures take a pointer to a string, whose
definite portion giving the name starting at $1$ and having the passed
length.

@<Get |web_file_name|...@>=
begin
max_suffix_length:=5;
@<Set |dot_pos| and |sep_pos| from |name_of_file|...@>@;
if dot_pos=-1 then begin
        dot_pos:=name_length+1;
        name_of_file[dot_pos]:='.';
        name_of_file[dot_pos+1]:='w';
        name_of_file[dot_pos+2]:='e';
        name_of_file[dot_pos+3]:='b';
		name_length:=dot_pos+3;
        end;
reset(web_file, name_of_file, name_length);
if sep_pos=-1 then sep_pos:=0; {will be use as translation delta}
name_of_file[dot_pos+1]:='p';
name_length:=dot_pos+1-sep_pos; {truncate to file name}
rewrite(Pascal_file, name_of_file+sep_pos, name_length);
name_of_file[dot_pos+1]:='p';
name_of_file[dot_pos+2]:='o';
name_of_file[dot_pos+3]:='o';
name_of_file[dot_pos+4]:='l';
name_length:=dot_pos+4-sep_pos;
rewrite(pool, name_of_file+sep_pos, name_length);
found_web:=true;
end

@ @<Get |change_file_name|...@>=
begin
max_suffix_length:=3;
@<Set |dot_pos| and |sep_pos| from |name_of_file|...@>@;
if dot_pos=-1 then begin
        dot_pos:=name_length+1;
        name_of_file[dot_pos]:='.';
        name_of_file[dot_pos+1]:='c';
        name_of_file[dot_pos+2]:='h';
		name_length:=dot_pos+2;
        end;
reset(change_file, name_of_file, name_length);
found_change:=true;
end

@ If there is no change file, we provide not \.{/dev/null}---since it is
system dependant---but an empty change file: |null.tex| will do.

@<Set up null change file@>=
begin
	name_of_file[1]:='n';
	name_of_file[2]:='u';
	name_of_file[3]:='l';
	name_of_file[4]:='l';
	name_of_file[5]:='.';
	name_of_file[6]:='t';
	name_of_file[7]:='e';
	name_of_file[8]:='x';
	name_length:=8;
	if not b_open_in(change_file, INPUTS_PATH_SPEC) then begin
		print_string(stdout, real_name_of_file, name_length);
		print_ln(': unable to find an empty change file!');
		cexit(1);
	end;
end

@ There are no flags currently used by \.{TANGLE}, but this module can be
used as a hook to introduce flags.

@<Handle flag...@>=
begin
  @<Print usage error message and quit@>;
end

@ @<Print usage error message and quit@>=
begin
print_ln('Usage: tangle webfile[.web] [changefile[.ch]].');
cexit(1);
end
@z

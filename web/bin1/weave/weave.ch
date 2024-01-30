% weave.ch, for C compilation under kerTeX.
%
% The original version of this file, for Pascal compilation using pc,
% was created by Howard Trickey and Pavel Curtis.
%
% History:
%  11/29/82 HWT Original version. This modifies weave to allow a new
%               control sequence:
%                       @=...text...@>   Put ...text... verbatim on a line
%                                        by itself in the Pascal output.
%                                        (argument must fit on one line)
%               This control sequence facilitates putting #include "gcons.h"
%               (for example) in files meant for the pc compiler.
%               Also, there is a command line option, -c, which means that
%               only the modules affected by the change file are to generate
%               TeX output.  (All the limbo stuff still goes to the output
%               file, as does the index and table of contents.)
%
%  2/12/83 HWT  Brought up for use with version 1.3.  Uses Knuth's new
%               control sequences for verbatim Pascal (as above, without
%               the "on one line" part), and the force_line (@\) primitive.
%               Also, he added stuff to keep track of changed modules, and
%               output enough information that macros can choose only to
%               print changed modules.  This isn't as efficient as my
%               implementation because I avoided outputting the text for
%               non-changed modules altogether, but this feature won't be
%               used too often (just for TeX and TeXware), so Knuth's
%               solution is accepted.
%               The change file changes that used
%               to implement these features have been removed.
%               There is a -x flag to cause WEAVE to omit cross referencing
%               of identifiers, and index and T.of.C. processing.
%               This, too, is unnecessary, for one could simply redefine some
%               WEB macros to avoid the printing, but there are only a couple
%               of easy changes, so they have been made.
%
%  2/18     HWT Increased stack size to 400 (not for TeX-related programs).
%
%  3/18     HWT Brought up for Version 1.5.  Made it print newline at end of
%               run.
%
%  4/13     PC  Merged with Pavel's version, including adding a call to
%               exit() at the end of the program, based upon the value of
%               `history'.
%  4/16     PC  Brought up to version 1.5 released with TeX 0.97 in April 1983
%  6/29     HWT Brought up to version 1.7 released with TeX 0.99 in June 1983,
%		introducing a new change file format
%  7/17	    HWT Brought up to version 2.0 released with TeX 0.999 in July 1983
%  7/29     HWT Brought up to version 2.1
% 11/17     HWT Brought up to version 2.4 released with TeX 1.0.  Made
%		changes to use C routines for I/O, for speedup.
%  1/31     HWT Brought up to version 2.6
%  12/15/85 ETM Brought up to version 2.8
%  03/15/88 ETM Converted for use with WEB to C, and for version 2.9 of Weave.
%  11/30/89 KB  Version 4.
% 2009-12-16 (TL) Version 4.4: 
%	- the banner;
%	- removing unneeded "optimizations" to have the smallest set of
%	changes.
% 2021-04-21 (TL) Version 4.5.
% 2022-03-05 (TL) argfmt, rewrite, reset and file opening modifications
%   for spaces handling. print_string() takes supplementary parameter
%   string length.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [0] WEAVE: print changes only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=\contentspagenumber \advance\pageno by 1
\let\maybe=\iffalse
\def\title{WEAVE changes for C}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1] Change banner message
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d banner=='This is WEAVE, Version 4.5'
@y
@d banner=='This is WEAVE, C Version 4.5'
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [2] remove arguments and add ref to scan_args
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
program WEAVE(@!web_file,@!change_file,@!tex_file);
label end_of_WEAVE; {go here to finish}
const @<Constants in the outer block@>@/
type @<Types in the outer block@>@/
var @<Globals in the outer block@>@/
@<Error handling procedures@>@/
@y
program WEAVE;
const @<Constants in the outer block@>@/
type @<Types in the outer block@>@/
var @<Globals in the outer block@>@/
@<Error handling procedures@>@/
@<|scan_args| procedure@>@/
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [4] compiler options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@{@&$C-,A+,D-@} {no range check, catch arithmetic overflow, no debug overhead}
@!debug @{@&$C+,D+@}@+ gubed {but turn everything on when debugging}
@y
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [5] Let the macros for incr() and decr() stay as is.
% [5] We can not use succ() and pred() since these are functions (we
% [5] want to have a side effect to change the variable without
% [5] assignment).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ Here are some macros for common programming idioms.

@d incr(#) == #:=#+1 {increase a variable by unity}
@d decr(#) == #:=#-1 {decrease a variable by unity}
@y
@ Here are some macros for common programming idioms.

@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [8] Constants: increase some values to allow processing big files.
% (e-TeX needs some of these.)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!max_bytes=45000; {|1/ww| times the number of bytes in identifiers,
  index entries, and module names; must be less than 65536}
@!max_names=5000; {number of identifiers, index entries, and module names;
  must be less than 10240}
@!max_modules=2000;{greater than the total number of modules}
@!hash_size=353; {should be prime}
@!buf_size=100; {maximum length of input line}
@!longest_name=400; {module names shouldn't be longer than this}
@!long_buf_size=500; {|buf_size+longest_name|}
@!line_length=80; {lines of \TeX\ output have at most this many characters,
  should be less than 256}
@!max_refs=30000; {number of cross references; must be less than 65536}
@!max_toks=30000; {number of symbols in \PASCAL\ texts being parsed;
  must be less than 65536}
@!max_texts=2000; {number of phrases in \PASCAL\ texts being parsed;
  must be less than 10240}
@!max_scraps=1000; {number of tokens in \PASCAL\ texts being parsed}
@!stack_size=200; {number of simultaneous output levels}
@y
@!max_bytes=65535; {|1/ww| times the number of bytes in identifiers,
  index entries, and module names; must be less than 65536}
@!max_names=5000; {number of identifiers, index entries, and module names;
  must be less than 10240}
@!max_modules=2000;{greater than the total number of modules}
@!hash_size=353; {should be prime}
@!buf_size=100; {maximum length of input line}
@!longest_name=400; {module names shouldn't be longer than this}
@!long_buf_size=500; {|buf_size+longest_name|}
@!line_length=80; {lines of \TeX\ output have at most this many characters,
  should be less than 256}
@!max_refs=30000; {number of cross references; must be less than 65536}
@!max_toks=30000; {number of symbols in \PASCAL\ texts being parsed;
  must be less than 65536}
@!max_texts=2500; {number of phrases in \PASCAL\ texts being parsed;
  must be less than 10240}
@!max_scraps=3000; {number of tokens in \PASCAL\ texts being parsed}
@!stack_size=400; {number of simultaneous output levels}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [??] The text_char type is used as an array index into xord. Since 
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
{nothing need be done}
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
additional error checking needs to be done. We will see below that
\.{WEAVE} reads through the entire input twice.
@^system dependencies@>

@p procedure open_input; {prepare to read |web_file| and |change_file|}
begin reset(web_file); reset(change_file);
end;
@y
@ The files are opened while scanning the command line, i.e. by the
|scan_args| procedure.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [26] Opening the .tex file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ The following code opens |tex_file|.
Since this file was listed in the program header, we assume that the
\PASCAL\ runtime system has checked that a suitable external file name has
been given.
@^system dependencies@>

@<Set init...@>=
rewrite(tex_file);
@y
@ The |tex_file| is opened by the |scan_args| procedure.

@<Set init...@>=
set_paths(WEB_PATHS_SET); {retrieve the environment variables if set by user}
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [??] Fix jump_out
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ The |jump_out| procedure just cuts across all active procedure levels
and jumps out of the program. This is the only non-local \&{goto} statement
in \.{WEAVE}. It is used when no recovery from a particular error has
been provided.

Some \PASCAL\ compilers do not implement non-local |goto| statements.
@^system dependencies@>
In such cases the code that appears at label |end_of_WEAVE| should be
copied into the |jump_out| procedure, followed by a call to a system procedure
that terminates the program.

@d fatal_error(#)==begin new_line; print(#); error; mark_fatal; jump_out;
  end

@<Error handling...@>=
procedure jump_out;
begin goto end_of_WEAVE;
end;
@y
@ The |jump_out| procedure cleans up, prints appropriate messages,
and exits back to the operating system.

@d fatal_error(#)==begin new_line; print(#); error; mark_fatal; jump_out;
	end

@<Error handling...@>=
procedure jump_out;
begin
stat @<Print statistics about memory usage@>;@+tats@;@/
@t\4\4@>{here files should be closed if the operating system requires it}
  @<Print the job |history|@>;
  new_line;
  if (history <> spotless) and (history <> harmless_message) then
    cexit(1)
  else
    cexit(0);
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [50] don't enter xrefs if no_xref set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d append_xref(#)==if xref_ptr=max_refs then overflow('cross reference')
  else  begin incr(xref_ptr); num(xref_ptr):=#;
    end

@p procedure new_xref(@!p:name_pointer);
label exit;
var q:xref_number; {pointer to previous cross reference}
@!m,@!n: sixteen_bits; {new and previous cross-reference value}
begin if (reserved(p)or(byte_start[p]+1=byte_start[p+ww]))and
@y
If the user has sent the |no_xref| flag (the -x option of the command line),
then it is unnecessary to keep track of cross references for identifers.
If one were careful, one could probably make more changes around module
100 to avoid a lot of identifier looking up.

@d append_xref(#)==if xref_ptr=max_refs then overflow('cross reference')
  else  begin incr(xref_ptr); num(xref_ptr):=#;
    end

@p procedure new_xref(@!p:name_pointer);
label exit;
var q:xref_number; {pointer to previous cross-reference}
@!m,@!n: sixteen_bits; {new and previous cross-reference value}
begin if no_xref then return;
if (reserved(p)or(byte_start[p]+1=byte_start[p+ww]))and
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [79] Reset_input shall rewind to the very beginning for second pass.
% Since we have perhaps manipulated the name, and in order not to create
% an array just for this, we simply rewind in C the FILE *.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p procedure reset_input;
begin open_input; line:=0; other_line:=0;@/
@y
@p procedure reset_input;
begin rewind(web_file); rewind(change_file); line:=0; other_line:=0;@/
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [239] omit index and module names if no_xref set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@<Phase III: Output the cross-reference index@>=
@y
If the user has set the |no_xref| flag (the -x option on the command line),
just finish off the page, omitting the index, module name list, and table of
contents.

@<Phase III: Output the cross-reference index@>=
if no_xref then begin
        finish_line;
        out("\"); out5("v")("f")("i")("l")("l");
        out4("\")("e")("n")("d");
        finish_line;
        end
else begin
@z

@x
print('Done.');
@y
end;
print('Done.');
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [258] term_in == stdin, when debugging.
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
% [259] Take out reset(term_in)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
reset(term_in,'TTY:','/I'); {open |term_in| as the terminal, don't do a |get|}
@y
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [261] print newline at end of run and exit based upon value of history
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p procedure Phase_I;
@y
@p procedure Phase_I;
@z

@x
end_of_WEAVE:
stat @<Print statistics about memory usage@>;@+tats@;@/
@t\4\4@>{here files should be closed if the operating system requires it}
@<Print the job |history|@>;
end.
@y
jump_out;
end.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [264] system dependent changes--the scan_args procedure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@* System-dependent changes.
This module should be replaced, if necessary, by changes to the program
that are necessary to make \.{WEAVE} work at a particular installation.
It is usually best to design your change file so that all changes to
previous modules preserve the module numbering; then everybody's version
will be consistent with the printed program. More extensive changes,
which introduce new modules, can be inserted here; then only the index
itself will get a new module number.
@^system dependencies@>
@y
@* System-dependent changes.
The user calls \.{WEAVE} with arguments on the command line.
These are either file names or flags (beginning with '-').
The following globals are for communicating the user's desires to the rest
of the program.  The various |file_name| variables contain strings with
the full names of those files, as UNIX knows them.

The only flag that affects weave is |'-x'| whose status is kept in |no_xref|.

@<Globals...@>=
@!no_xref:boolean;

@ The |scan_args| procedure looks at the command line arguments and sets
the |file_name| variables accordingly.
At least one file name must be present: the \.{WEB} file.  It may have
an extension, or it may omit it to get |'.web'| added.
The \TeX\ output file name is formed by replacing the \.{WEB} file
name extension by |'.tex'|.

If there is another file name present among the arguments, it is the
change file, again either with an extension or without one to get |'.ch'|
An omitted change file argument means that |'null.tex'| should be used,
when no changes are desired.

An argument beginning with a minus sign is a flag.
Any letters following the minus sign may cause global flag variables to be
set.
Currently, an |x| means that the cross referencing information---the index,
the module name list, and the table of contents---is to be suppressed.

@<|scan_args|...@>=
procedure scan_args;
var dot_pos, sep_pos, i, a: integer; {indices}
max_suffix_length: integer; {we need this more at most}
@!found_web,@!found_change: boolean; {|true| when those file names have
                                        been seen}
begin
found_web:=false;
found_change:=false;
no_xref:=false;
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

@ Use all of |name_of_file| for the |web_file_name|, appending |'.web'|
if there is no suffix.

The other file names come from adding things after the dot.

The length of the name to take into account is set in |name_length|
for |name_of_file|. The |reset| and |rewrite| procedures take a pointer
to a bytes string defining a name beginning at index $1$ and whose
length is passed as an argument.

@<Get |web_file_name|...@>=
begin
max_suffix_length:=4;
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
name_of_file[dot_pos+1]:='t';
name_of_file[dot_pos+2]:='e';
name_of_file[dot_pos+3]:='x';
name_length:=dot_pos+3-sep_pos; {truncate to file name}
rewrite(tex_file, name_of_file+sep_pos, name_length);
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
		print_ln('Unable to find an empty change file!');
		cexit(1);
	end;
end

@

@<Handle flag...@>=
begin
i:=2;
while i<=name_length do begin
        if name_of_file[i]='x' then no_xref:=true;
        incr(i);
        end;
end

@

@<Print usage error message and quit@>=
begin
print_ln('Usage: weave webfile[.web] [changefile[.ch]] [-x].');
cexit(1);
end
@z

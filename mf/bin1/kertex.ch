% Change file for Metafont in C, derived from various other change
% files.  Originally derived from INITEX.CH for Berkeley Unix TeX 1.1 (by
% Howard Trickey and Pavel Curtis), by Paul Richards.
% web2c modifications by Tim Morgan, et al.
%
% Modification history:
%
% Revision 3.2 2017/03/26 Thierry Laronde.
%    char arrays and strings; Pascal vs C; vstrcpy() vs vstrncpy().
% Revision 3.1 2016/01/06 Thierry Laronde
%    change banner for 2.7182818.
%    OGO var and routines put in a dedicated changefile.
% Revision 3.0 2010/03/29 Thierry Laronde
%    cleaning for kerTeX and to version 2.718281.
% Revision 2.0  90/3/27   20:20:00  ken
%       To version 2.0.
% Revision 1.9  90/1/20   09:05:32  karl
%       To version 1.9.
% Revision 1.8  89/11/30  09:08:16  karl
%   To version 1.8 (8-bit).
% Revision 1.7  88/12/27  15:02:24  mackay
%  Cosmetic upgrade for version 1.7
% Revision 1.6  88/12/11  15:59:15  morgan
%  Brought up to MF version 1.6
% Revision 1.5  88/03/02  13:25:44  morgan
%  More C changes
% Revision 1.4  87/12/09  12:50:00  hesse
%  Changes for C version
% Revision 1.3  87/03/07  21:15:21  mackay
%  Minor changes found on archive version on SCORE
% Revision 1.2  86/09/29  21:46:43  mackay
%  Made no-debug the default, and changed version number
%  to correspond with improved mf.web file
%  (Got rid of debug code to avoid bug in range check
%  code of VAX4.3 BSD and SUN3 version 3.1 Os pc interpreter)
% Revision 1.0  86/01/31  15:46:08  richards
% Released for MF 1.0;
%   Incorporates: New binary I/O library, separate optimized
%   arithmetic for takefraction/makefraction, new graphics interface.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [0] WEAVE: only print changes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
\def\botofcontents{\vskip 0pt plus 1fil minus 1.5in}
@y
\def\botofcontents{\vskip 0pt plus 1fil minus 1.5in}
\let\maybe=\iffalse
\def\title{{\logo opqrstuq} changes for C}
\def\glob{13}\def\gglob{20, 25} % these are defined in module 1
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1.2] banner line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d banner=='This is METAFONT, Version 2.71828182' {printed when \MF\ starts}
@y
@d banner=='This is METAFONT, kerTeX C Version 2.71828182' {printed when \MF\ starts}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1.7] debug..gubed, stat..tats
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d debug==@{ {change this to `$\\{debug}\equiv\null$' when debugging}
@d gubed==@t@>@} {change this to `$\\{gubed}\equiv\null$' when debugging}
@f debug==begin
@f gubed==end
@#
@d stat==@{ {change this to `$\\{stat}\equiv\null$' when gathering
  usage statistics}
@d tats==@t@>@} {change this to `$\\{tats}\equiv\null$' when gathering
  usage statistics}
@y
@d stat==ifdef('STAT')
@d tats==endif('STAT')
@d debug==ifdef('DEBUG')
@d gubed==endif('DEBUG')
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1.8] init..tini
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d init== {change this to `$\\{init}\equiv\.{@@\{}$' in the production version}
@d tini== {change this to `$\\{tini}\equiv\.{@@\}}$' in the production version}
@y
@d init==ifdef('INIMF')
@d tini==endif('INIMF')
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1.9] Get rid of compiler directives
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@<Compiler directives@>=
@{@&$C-,A+,D-@} {no range check, catch arithmetic overflow, no debug overhead}
@!debug @{@&$C+,D+@}@+ gubed {but turn everything on when debugging}
@y
@<Compiler directives@>=
@{No compiler directives for C.@}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1.11] Compile-time constants.  Although we only change a few of
% these, it is in the same chunk.
% We change a define in a variable due to its size (too big for a
% define).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@<Constants...@>=
@!mem_max=30000; {greatest index in \MF's internal |mem| array;
  must be strictly less than |max_halfword|;
  must be equal to |mem_top| in \.{INIMF}, otherwise |>=mem_top|}
@!max_internal=100; {maximum number of internal quantities}
@!buf_size=500; {maximum number of characters simultaneously present in
  current lines of open files; must not exceed |max_halfword|}
@!error_line=72; {width of context lines on terminal error messages}
@!half_error_line=42; {width of first lines of contexts in terminal
  error messages; should be between 30 and |error_line-15|}
@!max_print_line=79; {width of longest text lines output; should be at least 60}
@!screen_width=768; {number of pixels in each row of screen display}
@!screen_depth=1024; {number of pixels in each column of screen display}
@!stack_size=30; {maximum number of simultaneous input sources}
@!max_strings=2000; {maximum number of strings; must not exceed |max_halfword|}
@!string_vacancies=8000; {the minimum number of characters that should be
  available for the user's identifier names and strings,
  after \MF's own error messages are stored}
@!pool_size=32000; {maximum number of characters in strings, including all
  error messages and help texts, and the names of all identifiers;
  must exceed |string_vacancies| by the total
  length of \MF's own strings, which is currently about 22000}
@!move_size=5000; {space for storing moves in a single octant}
@!max_wiggle=300; {number of autorounded points per cycle}
@!gf_buf_size=800; {size of the output buffer, must be a multiple of 8}
@!file_name_size=40; {file names shouldn't be longer than this}
@!pool_name='MFbases:MF.POOL                         ';
  {string of length |file_name_size|; tells where the string pool appears}
@.MFbases@>
@!path_size=300; {maximum number of knots between breakpoints of a path}
@!bistack_size=785; {size of stack for bisection algorithms;
  should probably be left at this value}
@!header_size=100; {maximum number of \.{TFM} header words, times~4}
@!lig_table_size=5000; {maximum number of ligature/kern steps, must be
  at least 255 and at most 32510}
@!max_kerns=500; {maximum number of distinct kern amounts}
@!max_font_dimen=50; {maximum number of \&{fontdimen} parameters}
@y

@<Constants...@>=
@!mem_max=60000; {greatest index in \MF's internal |mem| array;
  must be strictly less than |max_halfword|;
  must be equal to |mem_top| in \.{INIMF}, otherwise |>=mem_top|}
@!max_internal=100; {maximum number of internal quantities}
@!buf_size=500; {maximum number of characters simultaneously present in
  current lines of open files; must not exceed |max_halfword|}
@!error_line=79; {width of context lines on terminal error messages}
@!half_error_line=50; {width of first lines of contexts in terminal
  error messages; should be between 30 and |error_line-15|}
@!max_print_line=79; {width of longest text lines output; should be at least 60}
@!screen_width=1664; {number of pixels in each row of screen display}
@!screen_depth=1200; {number of pixels in each column of screen display}
@!stack_size=30; {maximum number of simultaneous input sources}
@!max_strings=2000; {maximum number of strings; must not exceed |max_halfword|}
@!string_vacancies=8000; {the minimum number of characters that should be
  available for the user's identifier names and strings,
  after \MF's own error messages are stored}
@!pool_size=32000; {maximum number of characters in strings, including all
  error messages and help texts, and the names of all identifiers;
  must exceed |string_vacancies| by the total
  length of \MF's own strings, which is currently about 22000}
@!move_size=5000; {space for storing moves in a single octant}
@!max_wiggle=300; {number of autorounded points per cycle}
@!gf_buf_size=16384; {size of the output buffer, must be a multiple of 8}
@!pool_name='mf.pool';
@!pool_name_length=7;
  {required: |name_of_file| and |name_length| have to be both defined}
@!path_size=300; {maximum number of knots between breakpoints of a path}
@!bistack_size=785; {size of stack for bisection algorithms;
  should probably be left at this value}
@!header_size=100; {maximum number of \.{TFM} header words, times~4}
@!lig_table_size=5000; {maximum number of ligature/kern steps, must be
  at least 255 and at most 32510}
@!max_kerns=500; {maximum number of distinct kern amounts}
@!max_font_dimen=50; {maximum number of \&{fontdimen} parameters}
@!mem_top=60000; {largest index in the |mem| array dumped by \.{INIMF};
  must be substantially larger than |mem_min|
  and not greater than |mem_max|}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1.12] Sensitive compile-time constants. mem_top is a variable now
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d mem_min=0 {smallest index in the |mem| array, must not be less
  than |min_halfword|}
@d mem_top==30000 {largest index in the |mem| array dumped by \.{INIMF};
  must be substantially larger than |mem_min|
  and not greater than |mem_max|}
@d hash_size=2100 {maximum number of symbolic tokens,
  must be less than |max_halfword-3*param_size|}
@d hash_prime=1777 {a prime number equal to about 85\pct! of |hash_size|}
@d max_in_open=6 {maximum number of input files and error insertions that
  can be going on simultaneously}
@d param_size=150 {maximum number of simultaneous macro parameters}
@y
@d mem_min=0 {smallest index in the |mem| array, must not be less
  than |min_halfword|}
@d hash_size=2100 {maximum number of symbolic tokens,
  must be less than |max_halfword-3*param_size|}
@d hash_prime=1777 {a prime number equal to about 85\pct! of |hash_size|}
@d max_in_open=15 {maximum number of input files and error insertions that
  can be going on simultaneously}
@d param_size=150 {maximum number of simultaneous macro parameters}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1.16] Use C macros for incr()/decr()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% By not defining these, they slip through into the C code, where we
% use macros, which we hope generate more efficient code.
@x
@d incr(#) == #:=#+1 {increase a variable by unity}
@d decr(#) == #:=#-1 {decrease a variable by unity}
@y
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1.19] The text_char type is used as an array index into xord. Since 
% C doesn't deal with subrange, and since we need unsigned char,
% ASCII_code range is a perfect match.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
In order to accommodate this difference, we shall use the name |text_char|
to stand for the data type of the characters that are converted to and
from |ASCII_code| when they are input and output. We shall also assume
that |text_char| consists of the elements |chr(first_text_char)| through
|chr(last_text_char)|, inclusive. The following definitions should be
adjusted if necessary.
@^system dependencies@>

@d text_char == char {the data type of characters in text files}
@y
In order to accommodate this difference, we shall use the name |text_char|
to stand for the data type of the characters that are converted to and
from |ASCII_code| when they are input and output. We shall also assume
that |text_char| consists of the elements |chr(first_text_char)| through
|chr(last_text_char)|, inclusive. The following definitions should be
adjusted if necessary.
@^system dependencies@>

@d text_char == ASCII_code {the data type of characters in text files}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1.22] permissive input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@^character set dependencies@>
@^system dependencies@>

@<Set init...@>=
for i:=0 to @'37 do xchr[i]:=' ';
for i:=@'177 to @'377 do xchr[i]:=' ';
@y
@^character set dependencies@>
@^system dependencies@>

@d tab = @'11 { ASCII horizontal tab }
@d form_feed = @'14 { ASCII form feed }

@<Set init...@>=
for i:=0 to @'37 do xchr[i]:=chr(i);
for i:=@'177 to @'377 do xchr[i]:=chr(i);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [3.25] Suppress definition of name_of_file which is defined in C
% libweb.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
is crucial for our purposes. We shall assume that |name_of_file| is a variable
of an appropriate type such that the \PASCAL\ run-time system being used to
implement \MF\ can open a file whose external name is specified by
|name_of_file|.
@^system dependencies@>

@<Glob...@>=
@!name_of_file:packed array[1..file_name_size] of char;@;@/
  {on some systems this may be a \&{record} variable}
@!name_length:0..file_name_size;@/{this many characters are actually
  relevant in |name_of_file| (the rest are blank)}
@y
is crucial for our purposes.  |name_of_file| is an |ASCII_code| array,
defined in the C libweb and |name_length| tells how many bytes, starting
from index $1$ define the name. The external glue code will do the
searching and will define back |name_of_file| and |name_length| with
the pathname found.
@^system dependencies@>

@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [3.26] file opening
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ The \ph\ compiler with which the present version of \MF\ was prepared has
extended the rules of \PASCAL\ in a very convenient way. To open file~|f|,
we can write
$$\vbox{\halign{#\hfil\qquad&#\hfil\cr
|reset(f,@t\\{name}@>,'/O')|&for input;\cr
|rewrite(f,@t\\{name}@>,'/O')|&for output.\cr}}$$
The `\\{name}' parameter, which is of type `\ignorespaces|packed
array[@t\<\\{any}>@>] of text_char|', stands for the name of
the external file that is being opened for input or output.
Blank spaces that might appear in \\{name} are ignored.

The `\.{/O}' parameter tells the operating system not to issue its own
error messages if something goes wrong. If a file of the specified name
cannot be found, or if such a file cannot be opened for some other reason
(e.g., someone may already be trying to write the same file), we will have
|@!erstat(f)<>0| after an unsuccessful |reset| or |rewrite|.  This allows
\MF\ to undertake appropriate corrective action.
@:PASCAL H}{\ph@>
@^system dependencies@>

\MF's file-opening procedures return |false| if no file identified by
|name_of_file| could be opened.

@d reset_OK(#)==erstat(#)=0
@d rewrite_OK(#)==erstat(#)=0

@p function a_open_in(var @!f:alpha_file):boolean;
  {open a text file for input}
begin reset(f,name_of_file,'/O'); a_open_in:=reset_OK(f);
end;
@#
function a_open_out(var @!f:alpha_file):boolean;
  {open a text file for output}
begin rewrite(f,name_of_file,'/O'); a_open_out:=rewrite_OK(f);
end;
@#
function b_open_out(var @!f:byte_file):boolean;
  {open a binary file for output}
begin rewrite(f,name_of_file,'/O'); b_open_out:=rewrite_OK(f);
end;
@#
function w_open_in(var @!f:word_file):boolean;
  {open a word file for input}
begin reset(f,name_of_file,'/O'); w_open_in:=reset_OK(f);
end;
@#
function w_open_out(var @!f:word_file):boolean;
  {open a word file for output}
begin rewrite(f,name_of_file,'/O'); w_open_out:=rewrite_OK(f);
end;
@y
@ All of the file opening functions will be defined as macros in C.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [3.27] reserve file closure for C routines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ Files can be closed with the \ph\ routine `|close(f)|', which
@:PASCAL H}{\ph@>
@^system dependencies@>
should be used when all input or output with respect to |f| has been completed.
This makes |f| available to be opened again, if desired; and if |f| was used for
output, the |close| operation makes the corresponding external file appear
on the user's area, ready to be read.

@p procedure a_close(var @!f:alpha_file); {close a text file}
begin close(f);
end;
@#
procedure b_close(var @!f:byte_file); {close a binary file}
begin close(f);
end;
@#
procedure w_close(var @!f:word_file); {close a word file}
begin close(f);
end;
@y
@ And all file closing as well.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [3.30] f^ fix. But since D.E. Knuth allows/suggests to replace the
% input_ln() routine with a more efficient implementation, we implement
% it as an external in library.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
Standard \PASCAL\ says that a file should have |eoln| immediately
before |eof|, but \MF\ needs only a weaker restriction: If |eof|
occurs in the middle of a line, the system function |eoln| should return
a |true| result (even though |f^| will be undefined).

@p function input_ln(var @!f:alpha_file;@!bypass_eoln:boolean):boolean;
  {inputs the next line or returns |false|}
var @!last_nonblank:0..buf_size; {|last| with trailing blanks removed}
begin if bypass_eoln then if not eof(f) then get(f);
  {input the first character of the line into |f^|}
last:=first; {cf.\ Matthew 19\thinspace:\thinspace30}
if eof(f) then input_ln:=false
else  begin last_nonblank:=first;
  while not eoln(f) do
    begin if last>=max_buf_stack then
      begin max_buf_stack:=last+1;
      if max_buf_stack=buf_size then
        @<Report overflow of the input buffer, and abort@>;
      end;
    buffer[last]:=xord[f^]; get(f); incr(last);
    if buffer[last-1]<>" " then last_nonblank:=last;
    end;
  last:=last_nonblank; input_ln:=true;
  end;
end;
@y
@ The |input_ln| function is defined in an external C routine.

@d input_ln==cinput_ln {implemented in C libweb, so prefixed to avoid conflict}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [3.31] term_in/term_out are stdin/stdout.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
@<Glob...@>=
@!term_in:alpha_file; {the terminal as an input file}
@!term_out:alpha_file; {the terminal as an output file}
@y
@d term_in==stdin {the terminal as an input file}
@d term_out==stdout {the terminal as an output file}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [3.32] We don't need to open the terminal files.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ Here is how to open the terminal files
in \ph. The `\.{/I}' switch suppresses the first |get|.
@:PASCAL H}{\ph@>
@^system dependencies@>

@d t_open_in==reset(term_in,'TTY:','/O/I') {open the terminal for text input}
@d t_open_out==rewrite(term_out,'TTY:','/O')
 {open the terminal for text output}
@y
@ Here is how to open the terminal files.  |t_open_out| does nothing.
|t_open_in|, on the other hand, does the work of ``rescanning,'' or getting
any command line arguments the user has provided.  It's coded in C
externally.
  
@d t_open_out == {output already open for text output}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [3.33] Flushing output.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
these operations can be specified in \ph:
@:PASCAL H}{\ph@>
@^system dependencies@>

@d update_terminal == break(term_out) {empty the terminal output buffer}
@d clear_terminal == break_in(term_in,true) {clear the terminal input buffer}
@d wake_up_terminal == do_nothing {cancel the user's cancellation of output}
@y
these operations are provided by the \.{libweb} library, including an
implementation of the \ph
@:PASCAL H}{\ph@>
extensions. But \.{break} is a C reserved word, so we put a prefix.
|hbreak()| can be implemented in standard \CEE ; |hbreak_in()| would
need for example curses, so we will implement a no-op.
@^system dependencies@>

@d update_terminal == hbreak(term_out) {empty the terminal output buffer}
@d clear_terminal == hbreak_in(term_in,true) {clear the terminal input buffer}
@d wake_up_terminal == do_nothing {cancel the user's cancellation of output}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [3.36] rescanning the command line 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ The following program does the required initialization
without retrieving a possible command line.
It should be clear how to modify this routine to deal with command lines,
if the system permits them.
@^system dependencies@>

@p function init_terminal:boolean; {gets the terminal input started}
label exit;
begin t_open_in;
loop@+begin wake_up_terminal; write(term_out,'**'); update_terminal;
@.**@>
  if not input_ln(term_in,true) then {this shouldn't happen}
    begin write_ln(term_out);
    write(term_out,'! End of file on the terminal... why?');
@.End of file on the terminal@>
    init_terminal:=false; return;
    end;
  loc:=first;
  while (loc<last)and(buffer[loc]=" ") do incr(loc);
  if loc<last then
    begin init_terminal:=true;
    return; {return unless the line was all blank}
    end;
  write_ln(term_out,'Please type the name of your input file.');
  end;
exit:end;
@y
@ The following program does the required initialization.
Iff anything has been specified on the command line, then |t_open_in|
will return with |last > first|.
@^system dependencies@>

@p
function init_terminal:boolean; {gets the terminal input started}
label exit;
begin
  t_open_in;
  if last > first then begin
    loc := first;
    while (loc < last) and (buffer[loc]=' ') do
      incr(loc);
      if loc < last then begin
        init_terminal := true;
        goto exit;
      end;
    end;
    loop@+begin
      wake_up_terminal; write(term_out, '**'); update_terminal;
@.**@>
      if not input_ln(term_in,true) then begin {this shouldn't happen}
        write_ln(term_out);
        write(term_out, '! End of file on the terminal... why?');
@.End of file on the terminal@>
        init_terminal:=false;
        return;
      end;

      loc:=first;
      while (loc<last)and(buffer[loc]=" ") do
        incr(loc);

      if loc<last then begin
        init_terminal:=true;
        return; {return unless the line was all blank}
      end;
      write_ln(term_out, 'Please type the name of your input file.');
    end;
exit:
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [4.51] a_open_in of pool file needs path specifier. name_of_file is
% used by C external routines so needs to be correct both for Pascal
% (' ' sentry) and C ('\0' terminated and no '\0' before). [TL]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
name_of_file:=pool_name; {we needn't set |name_length|}
if a_open_in(pool_file) then
@y
vstrncpy(name_of_file + 1, pool_name, pool_name_length);
name_length:=pool_name_length;
if a_open_in(pool_file,MF_POOL_PATH_SPEC) then
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [4.51,52,53] Make MF.POOL lowercase in messages.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
else  bad_pool('! I can''t read MF.POOL.')
@y
else  bad_pool('! I can''t read mf.pool.')
@z

% Our implementation of read() is not variadic since there is immediate
% assignement to the variable. read2() is a C macro.
@x
begin if eof(pool_file) then bad_pool('! MF.POOL has no check sum.');
@.MF.POOL has no check sum@>
read(pool_file,m,n); {read two digits of string length}
@y
begin if eof(pool_file) then bad_pool('! mf.pool has no check sum.');
@.MF.POOL has no check sum@>
read2(pool_file,m,n); {read two digits of string length}
@z

@x
    bad_pool('! MF.POOL line doesn''t begin with two digits.');
@y
    bad_pool('! mf.pool line doesn''t begin with two digits.');
@z

@x
  bad_pool('! MF.POOL check sum doesn''t have nine digits.');
@y
  bad_pool('! mf.pool check sum doesn''t have nine digits.');
@z

@x
done: if a<>@$ then bad_pool('! MF.POOL doesn''t match; TANGLE me again.');
@y
done: if a<>@$ then bad_pool('! mf.pool doesn''t match; tangle me again.');
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [5.61] Eliminate the misleading initial message 
% ``(no format preloaded)''---this is true, but looks like an error 
% while it is not, at least then.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
if base_ident=0 then wterm_ln(' (no base preloaded)')
else  begin slow_print(base_ident); print_ln;
  end;
@y
if base_ident>0 then slow_print(base_ident);
print_ln;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [6.76] Eliminate non-local goto.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
Some \PASCAL\ compilers do not implement non-local |goto| statements.
@^system dependencies@>
In such cases the body of |jump_out| should simply be
`|close_files_and_terminate|;\thinspace' followed by a call on some system
procedure that quietly terminates the program.

@<Error hand...@>=
procedure jump_out;
begin goto end_of_MF;
end;
@y
Some \PASCAL\ compilers do not implement non-local |goto| statements.
@^system dependencies@>
In such cases the body of |jump_out| should simply be
`|close_files_and_terminate|;\thinspace' followed by a call on some system
procedure that quietly terminates the program.

Use the value of |history| to determine what exit code to use.

@<Error hand...@>=
procedure jump_out;
begin
close_files_and_terminate;
ready_already:=0;
if (history <> spotless) and (history <> warning_issued) then
    cexit(1)
else
    cexit(0);
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [7.96] Efficiency and consistency in C: there is no guarantee, with
% two signed integers, that (x + y) / 2 will lead to the floor---it is
% common that this is the opposite of the half of the positive value.
% Hence, the formula given by Donald E. Knuth will ensure correctness,
% even if D. E. Knuth's algorithms are sufficiently robust to deal with
% whatever version.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ One of \MF's most common operations is the calculation of
$\lfloor{a+b\over2}\rfloor$,
the midpoint of two given integers |a| and~|b|. The only decent way to do
this in \PASCAL\ is to write `|(a+b) div 2|'; but on most machines it is
far more efficient to calculate `|(a+b)| right shifted one bit'.

Therefore the midpoint operation will always be denoted by `|half(a+b)|'
in this program. If \MF\ is being implemented with languages that permit
binary shifting, the |half| macro should be changed to make this operation
as efficient as possible.

@d half(#)==(#) div 2
@y
@ One of \MF's most common operations is the calculation of
$\lfloor{a+b\over2}\rfloor$,
the midpoint of two given integers |a| and~|b|. The only decent way to do
this in \PASCAL\ is to write `|(a+b) div 2|'; but on most machines it is
far more efficient to calculate `|(a+b)| right shifted one bit'.

That's what we do in C, both for efficiency and for consistency: the
expression `|(a+b)/2|', when a or b is negative, will not lead to the
floor. The binary shift: yes. This a macro in C.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [7.107,109,112,114,119] We need to instruct the compiler not to 
% optimize away some code. For example, if ken-cc ignores register, it 
% takes volatile to disable optimizations. That's what we do.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p function make_fraction(@!p,@!q:integer):fraction;
var @!f:integer; {the fraction bits, with a leading 1 bit}
@!n:integer; {the integer part of $\vert p/q\vert$}
@!negative:boolean; {should the result be negated?}
@!be_careful:integer; {disables certain compiler optimizations}
@y
@p function make_fraction(@!p,@!q:integer):fraction;
var @!f:integer; {the fraction bits, with a leading 1 bit}
@!n:integer; {the integer part of $\vert p/q\vert$}
@!negative:boolean; {should the result be negated?}
@!be_careful:volatile_integer; {disables certain compiler optimizations}
@z

@x
@p function take_fraction(@!q:integer;@!f:fraction):integer;
var @!p:integer; {the fraction so far}
@!negative:boolean; {should the result be negated?}
@!n:integer; {additional multiple of $q$}
@!be_careful:integer; {disables certain compiler optimizations}
@y
@p function take_fraction(@!q:integer;@!f:fraction):integer;
var @!p:integer; {the fraction so far}
@!negative:boolean; {should the result be negated?}
@!n:integer; {additional multiple of $q$}
@!be_careful:volatile_integer; {disables certain compiler optimizations}
@z

@x
@p function take_scaled(@!q:integer;@!f:scaled):integer;
var @!p:integer; {the fraction so far}
@!negative:boolean; {should the result be negated?}
@!n:integer; {additional multiple of $q$}
@!be_careful:integer; {disables certain compiler optimizations}
@y
@p function take_scaled(@!q:integer;@!f:scaled):integer;
var @!p:integer; {the fraction so far}
@!negative:boolean; {should the result be negated?}
@!n:integer; {additional multiple of $q$}
@!be_careful:volatile_integer; {disables certain compiler optimizations}
@z

@x
@p function make_scaled(@!p,@!q:integer):scaled;
var @!f:integer; {the fraction bits, with a leading 1 bit}
@!n:integer; {the integer part of $\vert p/q\vert$}
@!negative:boolean; {should the result be negated?}
@!be_careful:integer; {disables certain compiler optimizations}
@y
@p function make_scaled(@!p,@!q:integer):scaled;
var @!f:integer; {the fraction bits, with a leading 1 bit}
@!n:integer; {the integer part of $\vert p/q\vert$}
@!negative:boolean; {should the result be negated?}
@!be_careful:volatile_integer; {disables certain compiler optimizations}
@z

@x
@p function floor_scaled(@!x:scaled):scaled;
  {$2^{16}\lfloor x/2^{16}\rfloor$}
var @!be_careful:integer; {temporary register}
@y
@p function floor_scaled(@!x:scaled):scaled;
  {$2^{16}\lfloor x/2^{16}\rfloor$}
var @!be_careful:volatile_integer; {temporary register}
@z

@x
function floor_unscaled(@!x:scaled):integer;
  {$\lfloor x/2^{16}\rfloor$}
var @!be_careful:integer; {temporary register}
@y
function floor_unscaled(@!x:scaled):integer;
  {$\lfloor x/2^{16}\rfloor$}
var @!be_careful:volatile_integer; {temporary register}
@z

@x
function round_unscaled(@!x:scaled):integer;
  {$\lfloor x/2^{16}+.5\rfloor$}
var @!be_careful:integer; {temporary register}
@y
function round_unscaled(@!x:scaled):integer;
  {$\lfloor x/2^{16}+.5\rfloor$}
var @!be_careful:volatile_integer; {temporary register}
@z

@x
function round_fraction(@!x:fraction):scaled;
  {$\lfloor x/2^{12}+.5\rfloor$}
var @!be_careful:integer; {temporary register}
@y
function round_fraction(@!x:fraction):scaled;
  {$\lfloor x/2^{12}+.5\rfloor$}
var @!be_careful:volatile_integer; {temporary register}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [9.155] Efficiency in C.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ The operation of subtracting |min_halfword| occurs rather frequently in
\MF, so it is convenient to abbreviate this operation by using the macro
|ho| defined here.  \MF\ will run faster with respect to compilers that
don't optimize the expression `|x-0|', if this macro is simplified in the
obvious way when |min_halfword=0|. Similarly, |qi| and |qo| are used for
input to and output from quarterwords.
@^system dependencies@>

@d ho(#)==#-min_halfword
  {to take a sixteen-bit item from a halfword}
@d qo(#)==#-min_quarterword {to read eight bits from a quarterword}
@d qi(#)==#+min_quarterword {to store eight bits in a quarterword}

@y
@ The operation of subtracting |min_halfword| occurs rather frequently in
\MF, so it is convenient to abbreviate this operation by using the macro
|ho| defined here.  \MF\ will run faster with respect to compilers that
don't optimize the expression `|x-0|', if this macro is simplified in the
obvious way when |min_halfword=0|. Similarly, |qi| and |qo| are used for
input to and output from quarterwords.

We need not do this in C, since the min_xxx values are all zero, and
we can't depend on most C compilers to optimize this.
@^system dependencies@>

@d ho(#)==#
@d qo(#)==#
@d qi(#)==#
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [9.156] Put the memory structure into an include file; it's too hard
% to translate automatically.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!two_halves = packed record@;@/
  @!rh:halfword;
  case two_choices of
  1: (@!lh:halfword);
  2: (@!b0:quarterword; @!b1:quarterword);
  end;
@!four_quarters = packed record@;@/
  @!b0:quarterword;
  @!b1:quarterword;
  @!b2:quarterword;
  @!b3:quarterword;
  end;
@!memory_word = record@;@/
  case three_choices of
  1: (@!int:integer);
  2: (@!hh:two_halves);
  3: (@!qqqq:four_quarters);
  end;
@y
@=#include "memory.h";@>
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [10.169] Fix an unsigned/signed problem in getnode.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
if r>p+1 then @<Allocate from the top of node |p| and |goto found|@>;
@y
if r>toint(p+1) then @<Allocate from the top of node |p| and |goto found|@>;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [11.178] Change the word `free' so that it doesn't conflict with the
% standard C library routine of the same name.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
been included. (You may want to decrease the size of |mem| while you
@^debugging@>
are debugging.)
@y
been included. (You may want to decrease the size of |mem| while you
@^debugging@>
are debugging.)

@d free==free_arr
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [11.182] Eliminate two unsigned comparisons to zero.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
repeat if (p>=lo_mem_max)or(p<mem_min) then clobbered:=true
  else if (rlink(p)>=lo_mem_max)or(rlink(p)<mem_min) then clobbered:=true
@y
repeat if (p>=lo_mem_max) then clobbered:=true
  else if (rlink(p)>=lo_mem_max) then clobbered:=true
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [12.194] fix_date_and_time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ The following procedure, which is called just before \MF\ initializes its
input and output, establishes the initial values of the date and time.
@^system dependencies@>
Since standard \PASCAL\ cannot provide such information, something special
is needed. The program here simply assumes that suitable values appear in
the global variables \\{sys\_time}, \\{sys\_day}, \\{sys\_month}, and
\\{sys\_year} (which are initialized to noon on 4 July 1776,
in case the implementor is careless).

Note that the values are |scaled| integers. Hence \MF\ can no longer
be used after the year 32767.

@p procedure fix_date_and_time;
begin sys_time:=12*60;
sys_day:=4; sys_month:=7; sys_year:=1776;  {self-evident truths}
internal[time]:=sys_time*unity; {minutes since midnight}
internal[day]:=sys_day*unity; {day of the month}
internal[month]:=sys_month*unity; {month of the year}
internal[year]:=sys_year*unity; {Anno Domini}
end;
@y
@ The following procedure, which is called just before \MF\ initializes its
input and output, establishes the initial values of the date and time.
It calls an externally defined |get_sys_time|---indeed, using the
underscores removal of tangle, via a macro definition to use pointers
in \CEE.
@^system dependencies@>

Note that the values are |scaled| integers. Hence \MF\ can no longer
be used after the year 32767.

@p procedure fix_date_and_time;
begin
get_sys_time(sys_time,sys_day,sys_month,sys_year);
internal[time]:=sys_time*unity; {minutes since midnight}
internal[day]:=sys_day*unity; {day of the month}
internal[month]:=sys_month*unity; {month of the year}
internal[year]:=sys_year*unity; {Anno Domini}
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [12.199] Allow <tab> and <form feed> as input.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
for k:=0 to " "-1 do char_class[k]:=invalid_class;
for k:=127 to 255 do char_class[k]:=invalid_class;
@y
for k:=0 to " "-1 do char_class[k]:=invalid_class;
for k:=127 to 255 do char_class[k]:=invalid_class;
char_class[tab]:=space_class;
char_class[form_feed]:=space_class;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [38.768] Area and extension rules.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ The file names we shall deal with for illustrative purposes have the
following structure:  If the name contains `\.>' or `\.:', the file area
consists of all characters up to and including the final such character;
otherwise the file area is null.  If the remaining file name contains
`\..', the file extension consists of all such characters from the first
remaining `\..' to the end, otherwise the file extension is null.
@^system dependencies@>

We can scan such file names easily by using two global variables that keep track
of the occurrences of area and extension delimiters:

@<Glob...@>=
@!area_delimiter:pool_pointer; {the most recent `\.>' or `\.:', if any}
@!ext_delimiter:pool_pointer; {the relevant `\..', if any}
@y
@ The file names we shall deal with for illustrative purposes have the
following structure:  If the name contains `\./', the file area
consists of all characters up to and including the final such character;
otherwise the file area is null.  If the remaining file name contains
`\..', the file extension consists of all such characters from the first
remaining `\..' to the end, otherwise the file extension is null.
@^system dependencies@>

We can scan such file names easily by using two global variables that keep
track of the occurrences of area and extension delimiters:

@<Glob...@>=
@!area_delimiter:pool_pointer; {the most recent `\./', if any}
@!ext_delimiter:pool_pointer; {the most recent `\..', if any}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [38.769] MF area directories don't exist.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d MF_area=="MFinputs:"
@.MFinputs@>
@y
In C, the default paths are specified in a separate
file, \.{site.h}.  The file opening procedures do path searching
based either on those default paths, or on paths given by the user
in environment variables.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [38.771] more_name
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
begin if c=" " then more_name:=false
else  begin if (c=">")or(c=":") then
@y
begin if (c=" ")or(c=tab) then more_name:=false
else  begin if (c="/") then
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [38.775] The default base.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d base_default_length=18 {length of the |MF_base_default| string}
@d base_area_length=8 {length of its area part}
@d base_ext_length=5 {length of its `\.{.base}' part}
@d base_extension=".base" {the extension, as a \.{WEB} constant}
  {not empty and distinct from ".log", ".gf" and "tfm"}

@<Glob...@>=
@!MF_base_default:packed array[1..base_default_length] of char;

@ @<Set init...@>=
MF_base_default:='MFbases:plain.base';
@y
Under {\mc UNIX} we don't give the area part, instead depending
on the path searching that will happen during file opening. \.{pp2rc}i
adds one to the array sizes so that the indices do point inside the
array. When the array is declared in the Pascal code and used by Pascal
routines, we do not need the C trailing nul character since this is not
a C string.

@d base_default_length=10 {length of the |MF_base_default| string}
@d base_area_length=0 {length of its area part}
@d base_ext_length=5 {length of its `\.{.base}' part}
@d base_extension=".base" {the extension, as a \.{WEB} constant}
  {not empty and distinct from ".log", ".gf" and "tfm"}

@<Glob...@>=
@!MF_base_default:packed array[1..base_default_length] of 0..255;

@ @<Set init...@>=
vstrncpy(MF_base_default + 1, 'plain.base', base_default_length);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [38.779] w_open_in of base file needs to be called only once
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
  pack_buffered_name(0,loc,j-1); {try first without the system file area}
  if w_open_in(base_file) then goto found;
  pack_buffered_name(base_area_length,loc,j-1);
    {now try the system base file area}
  if w_open_in(base_file) then goto found;
@y
  pack_buffered_name(0,loc,j-1);
  if w_open_in(base_file) then goto found;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (still [38.779]) Replace `PLAIN' in error messages with `default'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
  wterm_ln('Sorry, I can''t find that base;',' will try PLAIN.');
@y
  wterm_ln('Sorry, I can''t find that base;',' will try the default.');
@z
@x
  wterm_ln('I can''t find the PLAIN base file!');
@.I can't find PLAIN...@>
@y
  wterm_ln('I can''t find the default base file!');
@.I can't find default base...@>
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [38.780] make_name_string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
which simply makes a \MF\ string from the value of |name_of_file|, should
ideally be changed to deduce the full name of file~|f|, which is the file
most recently opened, if it is possible to do this in a \PASCAL\ program.
@^system dependencies@>

This routine might be called after string memory has overflowed, hence
we dare not use `|str_room|'.

@p function make_name_string:str_number;
var @!k:1..file_name_size; {index into |name_of_file|}
begin if (pool_ptr+name_length>pool_size)or(str_ptr=max_strings) then
  make_name_string:="?"
else  begin for k:=1 to name_length do append_char(xord[name_of_file[k]]);
  make_name_string:=make_string;
  end;
end;
@y
which simply makes a \MF\ string from the value of |name_of_file|, should
ideally be changed to deduce the full name of file~|f|, which is the file
most recently opened, if it is possible to do this in a \PASCAL\ program.
With the C version, we know that |real_name_of_file|
contains |name_of_file| prepended with the directory name that was found
by path searching.
@^system dependencies@>

This routine might be called after string memory has overflowed, hence
we dare not use `|str_room|'.

@p function make_name_string:str_number;
var @!k:1..file_name_size; {index into |name_of_file|}
begin
if (pool_ptr+real_name_length>pool_size)or(str_ptr=max_strings) then
  make_name_string:="?"
else  begin
  for k:=1 to real_name_length do append_char(xord[real_name_of_file[k]]);
  make_name_string:=make_string;
  end;
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [38.780] Change the make_name_strings to be C macros.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
function a_make_name_string(var @!f:alpha_file):str_number;
begin a_make_name_string:=make_name_string;
end;
function b_make_name_string(var @!f:byte_file):str_number;
begin b_make_name_string:=make_name_string;
end;
function w_make_name_string(var @!f:word_file):str_number;
begin w_make_name_string:=make_name_string;
end;
@y
{The a, b and w variants are all replaced by macros in C which call
|makenamestring|.}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [38.781] Make scan_file_name ignore leading tabs as well as spaces.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p procedure scan_file_name;
label done;
begin begin_name;
while buffer[loc]=" " do incr(loc);
@y
@p procedure scan_file_name;
label done;
begin begin_name;
while (buffer[loc]=" ")or(buffer[loc]=tab) do incr(loc);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [38.787] <Scan file name...> needs similar leading tab treatment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ @<Scan file name in the buffer@>=
begin begin_name; k:=first;
while (buffer[k]=" ")and(k<last) do incr(k);
@y
@ @<Scan file name in the buffer@>=
begin begin_name; k:=first;
while ((buffer[k]=" ")or(buffer[k]=tab))and(k<last) do incr(k);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [38.788, 790] Indices start at 1 in Pascal, and at 0 in Cee. 
% Furthermore, we can't assign so we copy, and increase the size of the
% buffer for the leading ' ' for CEE translation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
months:='JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC';
@y
vstrncpy(months + 1, 'JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC', 36);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [38.793] a_open_in of input file needs path selector.
% Search is done from the first call. So no need to stutter.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
  if a_open_in(cur_file) then goto done;
  if cur_area="" then
    begin pack_file_name(cur_name,MF_area,cur_ext);
    if a_open_in(cur_file) then goto done;
    end;
@y
  if a_open_in(cur_file,MF_INPUTS_PATH_SPEC) then goto done;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [38.793] Get rid of return of name to string pool.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
if name=str_ptr-1 then {conserve string pool space (but see note above)}
  begin flush_string(name); name:=cur_name;
  end;
@y
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [45.1120] `threshold' is both a function and a variable, and broken C
% compilers (i.e., many versions of pcc), get confused by that.  Since
% the function is used much less often than the variable, we'll change
% the function name.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
@p function threshold(@!m:integer):scaled;
var @!d:scaled; {lower bound on the smallest interval size}
begin excess:=min_cover(0)-m;
if excess<=0 then threshold:=0
else  begin repeat d:=perturbation;
  until min_cover(d+d)<=m;
  while min_cover(d)>m do d:=perturbation;
  threshold:=d;
@y
@p function threshold_fn(@!m:integer):scaled;
var @!d:scaled; {lower bound on the smallest interval size}
begin excess:=min_cover(0)-m;
if excess<=0 then threshold_fn:=0
else  begin repeat d:=perturbation;
  until min_cover(d+d)<=m;
  while min_cover(d)>m do d:=perturbation;
  threshold_fn:=d;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [45.1121] Change the call to the threshold function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
begin d:=threshold(m); perturbation:=0;
@y
begin d:=threshold_fn(m); perturbation:=0;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [45.1133] Writing the tfm file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d tfm_out(#)==write(tfm_file,#) {output one byte to |tfm_file|}

@p procedure tfm_two(@!x:integer); {output two bytes to |tfm_file|}
begin tfm_out(x div 256); tfm_out(x mod 256);
end;
@#
procedure tfm_four(@!x:integer); {output four bytes to |tfm_file|}
begin if x>=0 then tfm_out(x div three_bytes)
else  begin x:=x+@'10000000000; {use two's complement for negative values}
  x:=x+@'10000000000;
  tfm_out((x div three_bytes) + 128);
  end;
x:=x mod three_bytes; tfm_out(x div unity);
x:=x mod unity; tfm_out(x div @'400);
tfm_out(x mod @'400);
end;
@#
procedure tfm_qqqq(@!x:four_quarters); {output four quarterwords to |tfm_file|}
begin tfm_out(qo(x.b0)); tfm_out(qo(x.b1)); tfm_out(qo(x.b2));
tfm_out(qo(x.b3));
end;
@y
Under {\mc UNIX}, we are using the binary input and output routines.
Hence, we redefine all the {\mc TFM} input and output in terms of those
routines.

@d tfm_out(#) == b_write_byte(tfm_file, #)
@d tfm_two(#) == b_write_2_bytes(tfm_file, #)
@d tfm_four(#) == b_write_4_bytes(tfm_file, #)

@p procedure tfm_qqqq(@!x:four_quarters); {output four quarterwords to |tfm_file|}
begin tfm_out(qo(x.b0)); tfm_out(qo(x.b1)); tfm_out(qo(x.b2));
tfm_out(qo(x.b3));
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [47.1154] write_gf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@<Declare generic font output procedures@>=
procedure write_gf(@!a,@!b:gf_index);
var k:gf_index;
begin for k:=a to b do write(gf_file,gf_buf[k]);
end;
@y
For C, this is going to be handled by a macro
|b_write_buf|, which will do the output using |fwrite| or |write|.

@d write_gf(#) == b_write_buf(gf_file, gf_buf, #)
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [47.1163] init_gf:  C needs k to be 0..256 instead of 0..255.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
procedure init_gf;
var @!k:eight_bits; {runs through all possible character codes}
@y
procedure init_gf;
var @!k:0..256; {runs through all possible character codes}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [47.1169] Fix signed/unsigned comparison problem in C.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
if prev_m-m_offset(cur_edges)+x_off>gf_max_m then
  gf_max_m:=prev_m-m_offset(cur_edges)+x_off
@y
if prev_m-toint(m_offset(cur_edges))+x_off>gf_max_m then
  gf_max_m:=prev_m-m_offset(cur_edges)+x_off
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [48.1188,1189,1191] Leave the dump and undump macros for the 
% preprocessor.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d dump_wd(#)==begin base_file^:=#; put(base_file);@+end
@d dump_int(#)==begin base_file^.int:=#; put(base_file);@+end
@d dump_hh(#)==begin base_file^.hh:=#; put(base_file);@+end
@d dump_qqqq(#)==begin base_file^.qqqq:=#; put(base_file);@+end
@y
@z

@x
@d undump_wd(#)==begin get(base_file); #:=base_file^;@+end
@d undump_int(#)==begin get(base_file); #:=base_file^.int;@+end
@d undump_hh(#)==begin get(base_file); #:=base_file^.hh;@+end
@d undump_qqqq(#)==begin get(base_file); #:=base_file^.qqqq;@+end
@y
@z

@x
x:=base_file^.int;
@y
undump_int(x);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [48.1199] In C, when we have read, the cursor is after the value
% read, hence at the end (if we fail to read, there is a fatal error).
% So we can revert the condition.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
undump_int(x);@+if (x<>69069)or eof(base_file) then goto off_base
@y
undump_int(x);@+if (x<>69069)or not eof(base_file) then goto off_base
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [49.1204] Add call to exit() depending upon value of `history'.
%           Also, add call to set_paths.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
t_open_out; {open the terminal for output}
@y
t_open_out; {open the terminal for output}
set_paths(MF_PATHS_SET);
@z

@x
end_of_MF: close_files_and_terminate;
final_end: ready_already:=0;
@y
close_files_and_terminate;
final_end: ready_already:=0;
if (history <> spotless) and (history <> warning_issued) then
    cexit(1)
else
    cexit(0);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [49.1205] print new line before termination.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
    slow_print(log_name); print_char(".");
    end;
  end;
@y
    slow_print(log_name); print_char(".");
    end;
  end;
print_ln;
@z

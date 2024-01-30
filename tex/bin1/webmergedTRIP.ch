% This is webmergedTRIP.ch, a WEB change file produced by webmerge.tex
% to be applied to /data/src/knuth/tex/tex.web
% combining the changes (one after the other) from
% 1. filename.ch
% 2. kertex_common.ch
% 3. kertex.ch
% 4. TRIP.ch

@x l.88
  \def\?##1]{\hbox to 1in{\hfil##1.\ }}
  }
@y
  \def\?##1]{\hbox{Changes to \hbox to 1em{\hfil##1}.\ }}
  }
\let\maybe=\iffalse
@z

@x l.193
@d banner=='This is TeX, Version 3.141592653' {printed when \TeX\ starts}
@y
@d banner=='This is TeX, kerTeX C Version 3.141592653' {printed when \TeX\ starts}
@z

@x l.244
Actually the heading shown here is not quite normal: The |program| line
does not mention any |output| file, because \ph\ would ask the \TeX\ user
to specify a file name if |output| were specified here.
@:PASCAL H}{\ph@>
@^system dependencies@>

@d mtype==t@&y@&p@&e {this is a \.{WEB} coding trick:}
@f mtype==type {`\&{mtype}' will be equivalent to `\&{type}'}
@f type==true {but `|type|' will not be treated as a reserved word}

@p @t\4@>@<Compiler directives@>@/
program TEX; {all file names are defined dynamically}
label @<Labels in the outer block@>@/
@y

@d mtype==t@&y@&p@&e {this is a \.{WEB} coding trick:}
@f mtype==type {`\&{mtype}' will be equivalent to `\&{type}'}
@f type==true {but `|type|' will not be treated as a reserved word}

@p @t\4@>@<Compiler directives@>@/
program TEX; {all file names are defined dynamically}
@z

@x l.286
@<Labels in the out...@>=
start_of_TEX@t\hskip-2pt@>, end_of_TEX@t\hskip-2pt@>,@,final_end;
  {key control points}
@y
@<Labels in the outer block@>=
start_of_TEX@t\hskip-2pt@>, end_of_TEX@t\hskip-2pt@>,@,final_end;
  {key control points}
@z

@x l.304
@d debug==@{ {change this to `$\\{debug}\equiv\null$' when debugging}
@d gubed==@t@>@} {change this to `$\\{gubed}\equiv\null$' when debugging}
@y
@d debug==ifdef('DEBUG')
@d gubed==endif('DEBUG')
@z

@x l.309
@d stat==@{ {change this to `$\\{stat}\equiv\null$' when gathering
  usage statistics}
@d tats==@t@>@} {change this to `$\\{tats}\equiv\null$' when gathering
  usage statistics}
@y
@d stat==ifdef('STAT')
@d tats==endif('STAT')
@z

@x l.324
@d init== {change this to `$\\{init}\equiv\.{@@\{}$' in the production version}
@d tini== {change this to `$\\{tini}\equiv\.{@@\}}$' in the production version}
@y
@d init==ifdef('INITEX')
@d tini==endif('INITEX')
@z

@x l.345
@{@&$C-,A+,D-@} {no range check, catch arithmetic overflow, no debug overhead}
@!debug @{@&$C+,D+@}@+ gubed {but turn everything on when debugging}
@y
@z

@x l.389
@<Constants...@>=
@!mem_max=30000; {greatest index in \TeX's internal |mem| array;
  must be strictly less than |max_halfword|;
  must be equal to |mem_top| in \.{INITEX}, otherwise |>=mem_top|}
@!mem_min=0; {smallest index in \TeX's internal |mem| array;
  must be |min_halfword| or more;
  must be equal to |mem_bot| in \.{INITEX}, otherwise |<=mem_bot|}
@!buf_size=500; {maximum number of characters simultaneously present in
  current lines of open files and in control sequences between
  \.{\\csname} and \.{\\endcsname}; must not exceed |max_halfword|}
@!error_line=72; {width of context lines on terminal error messages}
@!half_error_line=42; {width of first lines of contexts in terminal
  error messages; should be between 30 and |error_line-15|}
@!max_print_line=79; {width of longest text lines output; should be at least 60}
@!stack_size=200; {maximum number of simultaneous input sources}
@!max_in_open=6; {maximum number of input files and error insertions that
  can be going on simultaneously}
@!font_max=75; {maximum internal font number; must not exceed |max_quarterword|
  and must be at most |font_base+256|}
@!font_mem_size=20000; {number of words of |font_info| for all fonts}
@!param_size=60; {maximum number of simultaneous macro parameters}
@!nest_size=40; {maximum number of semantic levels simultaneously active}
@!max_strings=3000; {maximum number of strings; must not exceed |max_halfword|}
@!string_vacancies=8000; {the minimum number of characters that should be
  available for the user's control sequences and font names,
  after \TeX's own error messages are stored}
@!pool_size=32000; {maximum number of characters in strings, including all
  error messages and help texts, and the names of all fonts and
  control sequences; must exceed |string_vacancies| by the total
  length of \TeX's own strings, which is currently about 23000}
@!save_size=600; {space for saving values outside of current group; must be
  at most |max_halfword|}
@!trie_size=8000; {space for hyphenation patterns; should be larger for
  \.{INITEX} than it is in production versions of \TeX}
@!trie_op_size=500; {space for ``opcodes'' in the hyphenation patterns}
@!dvi_buf_size=800; {size of the output buffer; must be a multiple of 8}
@!file_name_size=40; {file names shouldn't be longer than this}
@y

@<Constants...@>=
@!mem_max=3000; {greatest index in \TeX's internal |mem| array;
  must be strictly less than |max_halfword|;
  must be equal to |mem_top| in \.{INITEX}, otherwise |>=mem_top|}
@!mem_min=1; {smallest index in \TeX's internal |mem| array;
  must be |min_halfword| or more;
  must be equal to |mem_bot| in \.{INITEX}, otherwise |<=mem_bot|}
@!buf_size=500; {maximum number of characters simultaneously present in
  current lines of open files and in control sequences between
  \.{\\csname} and \.{\\endcsname}; must not exceed |max_halfword|}
@!error_line=64; {width of context lines on terminal error messages}
@!half_error_line=32; {width of first lines of contexts in terminal
  error messages; should be between 30 and |error_line-15|}
@!max_print_line=72; {width of longest text lines output; should be at least 60}
@!stack_size=200; {maximum number of simultaneous input sources}
@!max_in_open=15; {maximum number of input files and error insertions that
  can be going on simultaneously}
@!font_max=75; {maximum internal font number; must not exceed |max_quarterword|
  and must be at most |font_base+256|}
@!font_mem_size=20000; {number of words of |font_info| for all fonts}
@!param_size=60; {maximum number of simultaneous macro parameters}
@!nest_size=40; {maximum number of semantic levels simultaneously active}
@!max_strings=3000; {maximum number of strings; must not exceed |max_halfword|}
@!string_vacancies=8000; {the minimum number of characters that should be
  available for the user's control sequences and font names,
  after \TeX's own error messages are stored}
@!pool_size=32000; {maximum number of characters in strings, including all
  error messages and help texts, and the names of all fonts and
  control sequences; must exceed |string_vacancies| by the total
  length of \TeX's own strings, which is currently about 23000}
@!save_size=600; {space for saving values outside of current group; must be
  at most |max_halfword|}
@!trie_size=8000; {space for hyphenation patterns; should be larger for
  \.{INITEX} than it is in production versions of \TeX}
@!trie_op_size=500; {space for ``opcodes'' in the hyphenation patterns}
@!neg_trie_op_size=-500; {for lower trie_op_hash array bound}
@!dvi_buf_size=800; {size of the output buffer; must be a multiple of 8}
@z

@x l.426
@!pool_name='TeXformats:TEX.POOL                     ';
  {string of length |file_name_size|; tells where the string pool appears}
@y
@!pool_name='tex.pool';
@!pool_name_length=8;
  {required: |name_of_file| and |name_length| have to be both defined}
@!mem_top=3000; {largest index in the |mem| array dumped by \.{INITEX};
  must be substantially larger than |mem_bot|
  and not greater than |mem_max|}
@z

@x l.441
@d mem_bot=0 {smallest index in the |mem| array dumped by \.{INITEX};
  must not be less than |mem_min|}
@d mem_top==30000 {largest index in the |mem| array dumped by \.{INITEX};
  must be substantially larger than |mem_bot|
  and not greater than |mem_max|}
@d font_base=0 {smallest internal font number; must not be less
  than |min_quarterword|}
@d hash_size=2100 {maximum number of control sequences; it should be at most
  about |(mem_max-mem_min)/10|}
@d hash_prime=1777 {a prime number equal to about 85\pct! of |hash_size|}
@d hyph_size=307 {another prime; the number of \.{\\hyphenation} exceptions}
@y
@d mem_bot=1 {smallest index in the |mem| array dumped by \.{INITEX};
  must not be less than |mem_min|}
@d font_base=0 {smallest internal font number; must not be less
  than |min_quarterword|}
@d hash_size=2100 {maximum number of control sequences; it should be at most
  about |(mem_max-mem_min)/10|}
@d hash_prime=1777 {a prime number equal to about 85\pct! of |hash_size|}
@d hyph_size=307 {another prime; the number of \.{\\hyphenation} exceptions}
@z

@x l.512
@d incr(#) == #:=#+1 {increase a variable by unity}
@d decr(#) == #:=#-1 {decrease a variable by unity}
@y
@z

@x l.571
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

@x l.737
for i:=0 to @'37 do xchr[i]:=' ';
for i:=@'177 to @'377 do xchr[i]:=' ';
@y
for i:=0 to @'37 do xchr[i]:=chr(i);
for i:=@'177 to @'377 do xchr[i]:=chr(i);
@z

@x l.780
The program actually makes use also of a third kind of file, called a
|word_file|, when dumping and reloading base information for its own
initialization.  We shall define a word file later; but it will be possible
for us to specify simple operations on word files before they are defined.

@y
I/O in C is done using standard I/O.  We will define the path numbers
in an include file for C which are used in searching for files to be
read.  We'll define all the file types in C also.
@z

@x l.787
@!alpha_file=packed file of text_char; {files that contain textual data}
@!byte_file=packed file of eight_bits; {files that contain binary data}
@y
@z

@x l.796
is crucial for our purposes. We shall assume that |name_of_file| is a variable
of an appropriate type such that the \PASCAL\ run-time system being used to
implement \TeX\ can open a file whose external name is specified by
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
searching and will define back |name_of_file| and |name_length|
according to the pathname found.
@^system dependencies@>

@z

@x l.808
@ The \ph\ compiler with which the present version of \TeX\ was prepared has
extended the rules of \PASCAL\ in a very convenient way. To open file~|f|,
we can write
$$\vbox{\halign{#\hfil\qquad&#\hfil\cr
|reset(f,@t\\{name}@>,'/O')|&for input;\cr
|rewrite(f,@t\\{name}@>,'/O')|&for output.\cr}}$$
The `\\{name}' parameter, which is of type `{\bf packed array
$[\langle\\{any}\rangle]$ of \\{char}}', stands for the name of
the external file that is being opened for input or output.
Blank spaces that might appear in \\{name} are ignored.

The `\.{/O}' parameter tells the operating system not to issue its own
error messages if something goes wrong. If a file of the specified name
cannot be found, or if such a file cannot be opened for some other reason
(e.g., someone may already be trying to write the same file), we will have
|@!erstat(f)<>0| after an unsuccessful |reset| or |rewrite|.  This allows
\TeX\ to undertake appropriate corrective action.
@:PASCAL H}{\ph@>
@^system dependencies@>

\TeX's file-opening procedures return |false| if no file identified by
|name_of_file| could be opened.

@d reset_OK(#)==erstat(#)=0
@d rewrite_OK(#)==erstat(#)=0

@p function a_open_in(var f:alpha_file):boolean;
  {open a text file for input}
begin reset(f,name_of_file,'/O'); a_open_in:=reset_OK(f);
end;
@#
function a_open_out(var f:alpha_file):boolean;
  {open a text file for output}
begin rewrite(f,name_of_file,'/O'); a_open_out:=rewrite_OK(f);
end;
@#
function b_open_in(var f:byte_file):boolean;
  {open a binary file for input}
begin reset(f,name_of_file,'/O'); b_open_in:=reset_OK(f);
end;
@#
function b_open_out(var f:byte_file):boolean;
  {open a binary file for output}
begin rewrite(f,name_of_file,'/O'); b_open_out:=rewrite_OK(f);
end;
@#
function w_open_in(var f:word_file):boolean;
  {open a word file for input}
begin reset(f,name_of_file,'/O'); w_open_in:=reset_OK(f);
end;
@#
function w_open_out(var f:word_file):boolean;
  {open a word file for output}
begin rewrite(f,name_of_file,'/O'); w_open_out:=rewrite_OK(f);
end;
@y
@ All of the file opening functions will be defined as macros in C.
@z

@x l.864
@ Files can be closed with the \ph\ routine `|close(f)|', which
@:PASCAL H}{\ph@>
@^system dependencies@>
should be used when all input or output with respect to |f| has been completed.
This makes |f| available to be opened again, if desired; and if |f| was used for
output, the |close| operation makes the corresponding external file appear
on the user's area, ready to be read.

These procedures should not generate error messages if a file is
being closed before it has been successfully opened.

@p procedure a_close(var f:alpha_file); {close a text file}
begin close(f);
end;
@#
procedure b_close(var f:byte_file); {close a binary file}
begin close(f);
end;
@#
procedure w_close(var f:word_file); {close a word file}
begin close(f);
end;
@y
@ And all file closing as well.
@z

@x l.940
Since the inner loop of |input_ln| is part of \TeX's ``inner loop''---each
character of input comes in at this place---it is wise to reduce system
overhead by making use of special routines that read in an entire array
of characters at once, if such routines are available. The following
code uses standard \PASCAL\ to illustrate what needs to be done, but
finer tuning is often possible at well-developed \PASCAL\ sites.
@^inner loop@>

@p function input_ln(var f:alpha_file;@!bypass_eoln:boolean):boolean;
  {inputs the next line or returns |false|}
var last_nonblank:0..buf_size; {|last| with trailing blanks removed}
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
Since the inner loop of |input_ln| is part of \TeX's ``inner loop''---each
character of input comes in at this place---it is wise to reduce system
overhead by making use of special routines that read in an entire array
of characters at once, if such routines are available. This is the case
in this \CEE flavor: the routine is provided as an external in the
library.
@^inner loop@>

@d input_ln==cinput_ln {implemented in C libweb, so prefixed to avoid conflict}
@z

@x l.969
@ The user's terminal acts essentially like other files of text, except
that it is used both for input and for output. When the terminal is
considered an input file, the file variable is called |term_in|, and when it
is considered an output file the file variable is |term_out|.
@^system dependencies@>

@<Glob...@>=
@!term_in:alpha_file; {the terminal as an input file}
@!term_out:alpha_file; {the terminal as an output file}
@y
@ The user's terminal acts essentially like other files of text, except
that it is used both for input and for output. When the terminal is
considered an input file, the file is called |term_in|, and when it
is considered an output file the file is |term_out|.  In C, these
files will be defined as ``stdin'' and ``stdout,'' respectively.

@d term_in==stdin {the terminal as an input file}
@d term_out==stdout {the terminal as an output file}
@z

@x l.979
@ Here is how to open the terminal files
in \ph. The `\.{/I}' switch suppresses the first |get|.
@:PASCAL H}{\ph@>
@^system dependencies@>

@d t_open_in==reset(term_in,'TTY:','/O/I') {open the terminal for text input}
@d t_open_out==rewrite(term_out,'TTY:','/O') {open the terminal for text output}
@y
@ Here is how to open the terminal files.  |t_open_out| does nothing.
|t_open_in|, on the other hand, does the work of "rescanning", or getting
any command line arguments the user has provided.  It's coded in C
externally.

@d t_open_out == {output already open for text output}
@z

@x l.998
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

@x l.1026
The first line is special also because it may be read before \TeX\ has
input a format file. In such cases, normal error messages cannot yet
be given. The following code uses concepts that will be explained later.
(If the \PASCAL\ compiler does not support non-local |@!goto|\unskip, the
@^system dependencies@>
statement `|goto final_end|' should be replaced by something that
quietly terminates the program.)

@<Report overflow of the input buffer, and abort@>=
if format_ident=0 then
  begin write_ln(term_out,'Buffer size exceeded!'); goto final_end;
@.Buffer size exceeded@>
  end
@y
The first line is special also because it may be read before \TeX\ has
input a format file. In such cases, normal error messages cannot yet
be given. The following code uses concepts that will be explained later.
(Since C does not support non-local |@!goto|\unskip, the
@^system dependencies@>
statement `|goto final_end|' has been replaced by something that
quietly terminates the program.)

@<Report overflow of the input buffer, and abort@>=
if format_ident=0 then
  begin write_ln(term_out,'Buffer size exceeded!'); do_final_end;
@.Buffer size exceeded@>
  end
@z

@x l.1072
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

@x l.1332
name_of_file:=pool_name; {we needn't set |name_length|}
if a_open_in(pool_file) then
@y
vstrncpy(name_of_file + 1, pool_name, pool_name_length);
name_length:=pool_name_length;
  {API requirement: |name_length| has to be set}
if a_open_in(pool_file,TEX_POOL_PATH_SPEC) then
@z

@x l.1340
else  bad_pool('! I can''t read TEX.POOL.')
@y
else begin
  {Like |bad_pool|, but must not close file if we never opened it}
  wake_up_terminal; write_ln(term_out, '! I can''t read tex.pool.');
  get_strings_started:= false; return;
end
@z

@x l.1344
begin if eof(pool_file) then bad_pool('! TEX.POOL has no check sum.');
@.TEX.POOL has no check sum@>
read(pool_file,m,n); {read two digits of string length}
@y
begin if eof(pool_file) then bad_pool('! tex.pool has no check sum.');
@.TEX.POOL has no check sum@>
read(pool_file,m); read(pool_file,n); {read two digits of string length}
@z

@x l.1350
    bad_pool('! TEX.POOL line doesn''t begin with two digits.');
@y
    bad_pool('! tex.pool line doesn''t begin with two digits.');
@z

@x l.1372
  bad_pool('! TEX.POOL check sum doesn''t have nine digits.');
@y
  bad_pool('! tex.pool check sum doesn''t have nine digits.');
@z

@x l.1378
done: if a<>@$ then bad_pool('! TEX.POOL doesn''t match; TANGLE me again.');
@y
done: if a<>@$ then bad_pool('! tex.pool doesn''t match; tangle me again.');
@z

@x l.1575
if format_ident=0 then wterm_ln(' (no format preloaded)')
else  begin slow_print(format_ident); print_ln;
  end;
@y
if format_ident>0 then slow_print(format_ident);
print_ln;
@z

@x l.1870
@<Error hand...@>=
procedure jump_out;
begin goto end_of_TEX;
end;
@y
@d do_final_end==begin
   update_terminal;
   ready_already:=0;
   if (history <> spotless) and (history <> warning_issued) then
     cexit(1)
   else
     cexit(0);
   end
@<Error hand...@>=
procedure jump_out;
begin
close_files_and_terminate;
do_final_end;
end;
@z

@x l.2373
@!glue_ratio=real; {one-word representation of a glue expansion factor}
@y
@z

@x l.2426
@d min_quarterword=0 {smallest allowable value in a |quarterword|}
@d max_quarterword=255 {largest allowable value in a |quarterword|}
@d min_halfword==0 {smallest allowable value in a |halfword|}
@d max_halfword==65535 {largest allowable value in a |halfword|}
@y
@d min_quarterword=0 {smallest allowable value in a |quarterword|}
@d max_quarterword=255 {largest allowable value in a |quarterword|}
@d min_halfword==0 {smallest allowable value in a |halfword|}
@d max_halfword==65535 {largest allowable value in a |halfword|}
@z

@x l.2454
The inner loop of \TeX\ will run faster with respect to compilers
that don't optimize expressions like `|x+0|' and `|x-0|', if these
macros are simplified in the obvious way when |min_quarterword=0|.
@^inner loop@>@^system dependencies@>

@d qi(#)==#+min_quarterword
  {to put an |eight_bits| item into a quarterword}
@d qo(#)==#-min_quarterword
  {to take an |eight_bits| item out of a quarterword}
@d hi(#)==#+min_halfword
  {to put a sixteen-bit item into a halfword}
@d ho(#)==#-min_halfword
  {to take a sixteen-bit item from a halfword}
@y
The inner loop of \TeX\ will run faster with respect to compilers
that don't optimize expressions like `|x+0|' and `|x-0|', if these
macros are simplified in the obvious way when |min_quarterword=0|.
So they have been simplified here in the obvious way.
@^inner loop@>@^system dependencies@>

@d qi(#)==# {to put an |eight_bits| item into a quarterword}
@d qo(#)==# {to take an |eight_bits| item from a quarterword}
@d hi(#)==# {to put a sixteen-bit item into a halfword}
@d ho(#)==# {to take a sixteen-bit item from a halfword}
@z

@x l.2474
@!quarterword = min_quarterword..max_quarterword; {1/4 of a word}
@!halfword=min_halfword..max_halfword; {1/2 of a word}
@!two_choices = 1..2; {used when there are two variants in a record}
@!four_choices = 1..4; {used when there are four variants in a record}
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
  case four_choices of
  1: (@!int:integer);
  2: (@!gr:glue_ratio);
  3: (@!hh:two_halves);
  4: (@!qqqq:four_quarters);
  end;
@!word_file = file of memory_word;
@y
@!quarterword=min_quarterword..max_quarterword;
@!halfword=min_halfword..max_halfword;
@!two_choices = 1..2; {used when there are two variants in a record}
@!four_choices = 1..4; {used when there are four variants in a record}
@=#include "memory.h";@>
@z

@x l.2566
@!mem : array[mem_min..mem_max] of memory_word; {the big dynamic storage area}
@y
@!zmem : array[mem_min..mem_max] of memory_word; {the big dynamic storage area}
@z

@x l.2760
if r>p+1 then @<Allocate from the top of node |p| and |goto found|@>;
@y
if r>toint(p+1) then @<Allocate from the top of node |p| and |goto found|@>;
@z

@x l.3383
been included. (You may want to decrease the size of |mem| while you
@^debugging@>
are debugging.)
@y
been included. (You may want to decrease the size of |mem| while you
@^debugging@>
are debugging.)

@d free==free_arr
@z

@x l.3547
        begin if (font(p)<font_base)or(font(p)>font_max) then
          print_char("*")
@y
        begin if (font(p)>font_max) then
          print_char("*")
@z

@x l.3584
@p procedure print_font_and_char(@!p:integer); {prints |char_node| data}
begin if p>mem_end then print_esc("CLOBBERED.")
else  begin if (font(p)<font_base)or(font(p)>font_max) then print_char("*")
@y
@p procedure print_font_and_char(@!p:integer); {prints |char_node| data}
begin if p>mem_end then print_esc("CLOBBERED.")
else  begin if (font(p)>font_max) then print_char("*")
@z

@x l.3759
floating point underflow on the author's computer.
@^system dependencies@>
@^dirty \PASCAL@>

@<Display the value of |glue_set(p)|@>=
g:=float(glue_set(p));
if (g<>float_constant(0))and(glue_sign(p)<>normal) then
  begin print(", glue set ");
  if glue_sign(p)=shrinking then print("- ");
  if abs(mem[p+glue_offset].int)<@'4000000 then print("?.?")
  else if abs(g)>float_constant(20000) then
    begin if g>float_constant(0) then print_char(">")
    else print("< -");
    print_glue(20000*unity,glue_order(p),0);
    end
  else print_glue(round(unity*g),glue_order(p),0);
@^real multiplication@>
  end
@y
floating point underflow on the author's computer.
@^system dependencies@>
@^dirty \PASCAL@>

@<Display the value of |glue_set(p)|@>=
g:=float(glue_set(p));
if (g<>float_constant(0))and(glue_sign(p)<>normal) then
  begin print(", glue set ");
  if glue_sign(p)=shrinking then print("- ");
  { The Unix "pc" folks removed this restriction with a remark that
    invalid bit patterns were vanishingly improbable, so we follow
    their example without really understanding it.
  |if abs(mem[p+glue_offset].int)<@'4000000 then print('?.?')|
  |else| }
  if fabs(g)>float_constant(20000) then
    begin if g>float_constant(0) then print_char(">")
    else print("< -");
    print_glue(20000*unity,glue_order(p),0);
    end
  else print_glue(round(unity*g),glue_order(p),0);
@^real multiplication@>
  end
@z

@x l.5243
Since standard \PASCAL\ cannot provide such information, something special
is needed. The program here simply assumes that suitable values appear in
the global variables \\{sys\_time}, \\{sys\_day}, \\{sys\_month}, and
\\{sys\_year} (which are initialized to noon on 4 July 1776,
in case the implementor is careless).
@y
It calls---in fact via a C macro using the fact that underscores are
removed from identifiers in the Pascal code----a C procedure that sets
the system values. The C macro expands in order to call pointers to
the variables instead of their values.
@z

@x l.5249
@p procedure fix_date_and_time;
begin sys_time:=12*60;
sys_day:=4; sys_month:=7; sys_year:=1776;  {self-evident truths}
time:=sys_time; {minutes since midnight}
day:=sys_day; {day of the month}
month:=sys_month; {month of the year}
year:=sys_year; {Anno Domini}
end;
@y
@p procedure fix_date_and_time;
begin
get_sys_time(sys_time, sys_day, sys_month, sys_year);
time:=sys_time; {minutes since midnight}
day:=sys_day; {day of the month}
month:=sys_month; {month of the year}
year:=sys_year; {Anno Domini}
end;
@z

@x l.5462
@!eqtb:array[active_base..eqtb_size] of memory_word;
@y
@!zeqtb:array[active_base..eqtb_size] of memory_word;
@z

@x l.5611
else if (text(p)<0)or(text(p)>=str_ptr) then print_esc("NONEXISTENT.")
@y
else if (text(p)>=str_ptr) then print_esc("NONEXISTENT.")
@z

@x l.6283
else  begin m:=info(p) div @'400; c:=info(p) mod @'400;
  if info(p)<0 then print_esc("BAD.")
@.BAD@>
  else @<Display the token $(|m|,|c|)$@>;
  end
@y
else  begin m:=info(p) div @'400; c:=info(p) mod @'400;
  @<Display the token $(|m|,|c|)$@>;
  end
@z

@x l.7095
first:=buf_size; repeat buffer[first]:=0; decr(first); until first=0;
@y
bufindx:=buf_size; repeat buffer[bufindx]:=0; decr(bufindx); until bufindx=0;
@z

@x l.9983
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
`\..', the file extension consists of all such characters from the last
`\..' to the end, otherwise the file extension is null.
@^system dependencies@>

We can scan such file names easily by using two global variables that keep
track of the occurrences of area and extension delimiters:

@<Glob...@>=
@!area_delimiter:pool_pointer; {the most recent `\./', if any}
@!ext_delimiter:pool_pointer; {the most recent `\..', if any}
@z

@x l.10005
@d TEX_area=="TeXinputs:"
@.TeXinputs@>
@d TEX_font_area=="TeXfonts:"
@.TeXfonts@>
@y
We'll handle the path stuff in an external C module.
@z

@x l.10025
else  begin str_room(1); append_char(c); {contribute |c| to the current string}
  if (c=">")or(c=":") then
    begin area_delimiter:=cur_length; ext_delimiter:=0;
    end
  else if (c=".")and(ext_delimiter=0) then ext_delimiter:=cur_length;
@y
else  begin str_room(1); append_char(c); {contribute |c| to the current string}
  if (c="/") then
    begin area_delimiter:=cur_length; ext_delimiter:=0;
    end
  else if c="." then ext_delimiter:=cur_length;
@z

@x l.10067
allows both lowercase and uppercase letters in the file name.
@^system dependencies@>

@d append_to_name(#)==begin c:=#; incr(k);
  if k<=file_name_size then name_of_file[k]:=xchr[c];
  end
@y
allows both lowercase and uppercase letters in the file name.
@^system dependencies@>

But |name_of_file| is of limited length and we must ensure both to not
overflow it but still to produce file names that are distinct, while the
prefix may be---for example for the job name---common. So we truncate
the prefix but never the extension that shall not be the empty string.

@d append_to_prefix(#)==begin c:=#; incr(k);
  if k<=(file_name_size-length(e)) then
    name_of_file[k]:=xchr[c];
  end
@d append_to_name(#)==begin c:=#; incr(k);
  if k<=file_name_size then name_of_file[k]:=xchr[c];
  end
@z

@x l.10079
for j:=str_start[a] to str_start[a+1]-1 do append_to_name(so(str_pool[j]));
for j:=str_start[n] to str_start[n+1]-1 do append_to_name(so(str_pool[j]));
@y
@!debug if e=0 then begin print_err("This can't happen!");
@.This can't happen@>
  help1("I'm broken. There shall always be an extension to filenames!");
  end;
gubed
for j:=str_start[a] to str_start[a+1]-1 do append_to_prefix(so(str_pool[j]));
for j:=str_start[n] to str_start[n+1]-1 do append_to_prefix(so(str_pool[j]));
@z

@x l.10092
@d format_default_length=20 {length of the |TEX_format_default| string}
@d format_area_length=11 {length of its area part}
@d format_ext_length=4 {length of its `\.{.fmt}' part}
@y
Under {\mc UNIX} we don't give the area part, instead depending
on the path searching that will happen during file opening. \.{pp2rc}
adds one to the array sizes so that the indices do point inside the
array. When the array is declared in the Pascal code and used by Pascal
routines, we do not need the C trailing nul character since this is not
a C string.

@d format_default_length=9 {length of the |TEX_format_default| string}
@d format_area_length=0 {length of its area part}
@d format_ext_length=4 {length of its `\.{.fmt}' part}
@z

@x l.10095
@d format_extension=".fmt" {the extension, as a \.{WEB} constant}
@y
@d format_extension=".fmt" {the extension, as a \.{WEB} constant}
  {not empty and distinct from ".tex", ".log", "tfm" and ".dvi"}
@z

@x l.10098
@!TEX_format_default:packed array[1..format_default_length] of char;

@ @<Set init...@>=
TEX_format_default:='TeXformats:plain.fmt';
@y
@!TEX_format_default:packed array[1..format_default_length] of 0..255;

@ @<Set init...@>=
vstrncpy(TEX_format_default + 1, 'plain.fmt', format_default_length);
@z

@x l.10106
@ @<Check the ``constant'' values for consistency@>=
if format_default_length>file_name_size then bad:=31;
@y
@ The buffer |name_of_file| shall be able to accommodate for
|TeX_format_default|---that shall have a specific extension---but shall
too be able to hold the default job filenames mentionned in
{\sl the \TeX book}.

@d default_job_filenames_len=10 {"texput.log", "texput.dvi"}

@<Check the ``constant'' values for consistency@>=
if (format_default_length>file_name_size)
  or(format_ext_length<1)or(file_name_size<default_job_filenames_len)
  then bad:=31;
@z

@x l.10150
  pack_buffered_name(0,loc,j-1); {try first without the system file area}
  if w_open_in(fmt_file) then goto found;
  pack_buffered_name(format_area_length,loc,j-1);
    {now try the system format file area}
  if w_open_in(fmt_file) then goto found;
@y
  pack_buffered_name(0,loc,j-1);
  if w_open_in(fmt_file) then goto found;
@z

@x l.10156
  wterm_ln('Sorry, I can''t find that format;',' will try PLAIN.');
@y
  wterm_ln('Sorry, I can''t find that format;',' will try the default.');
@z

@x l.10164
  wterm_ln('I can''t find the PLAIN format file!');
@.I can't find PLAIN...@>
@y
  wterm_ln('I can''t find the default format file!');
@.I can't find default format...@>
@z

@x l.10174
which simply makes a \TeX\ string from the value of |name_of_file|, should
ideally be changed to deduce the full name of file~|f|, which is the file
most recently opened, if it is possible to do this in a \PASCAL\ program.
@^system dependencies@>

This routine might be called after string memory has overflowed, hence
we dare not use `|str_room|'.

@p function make_name_string:str_number;
var k:1..file_name_size; {index into |name_of_file|}
begin if (pool_ptr+name_length>pool_size)or(str_ptr=max_strings)or
 (cur_length>0) then
  make_name_string:="?"
else  begin for k:=1 to name_length do append_char(xord[name_of_file[k]]);
  make_name_string:=make_string;
  end;
end;
function a_make_name_string(var f:alpha_file):str_number;
begin a_make_name_string:=make_name_string;
end;
function b_make_name_string(var f:byte_file):str_number;
begin b_make_name_string:=make_name_string;
end;
function w_make_name_string(var f:word_file):str_number;
begin w_make_name_string:=make_name_string;
end;
@y
which simply makes a \TeX\ string from the value of |name_of_file|, should
ideally be changed to deduce the full name of file~|f|, if it is
possible to do this in a \PASCAL\ program.

This routine might be called after string memory has overflowed, hence
we dare not use `|str_room|'.

With the C version, we know that |real_name_of_file|
contains |name_of_file| prepended with the directory name that was found
by path searching.
@^system dependencies@>

@p function make_name_string:str_number;
var k:1..file_name_size; {index into |name_of_file|}
begin
  if (pool_ptr+real_name_length>pool_size)or(str_ptr=max_strings)or
   (cur_length>0) then
    make_name_string:="?"
  else begin
    for k:=1 to real_name_length do append_char(xord[real_name_of_file[k]]);
    make_name_string:=make_string;
  end;
end;

{The X_make_name_string functions are changed to macros in C.}
@z

@x l.10359
months:='JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC';
@y
vstrncpy(months + 1, 'JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC', 36);
@z

@x l.10377
  if a_open_in(cur_file) then goto done;
  if cur_area="" then
    begin pack_file_name(cur_name,TEX_area,cur_ext);
    if a_open_in(cur_file) then goto done;
    end;
@y
  if a_open_in(cur_file,TEX_INPUTS_PATH_SPEC) then goto done;
@z

@x l.10390
if term_offset+length(name)>max_print_line-2 then print_ln
@y
if term_offset+length(name)>max_print_line-3 then print_ln
@z

@x l.10394
if name=str_ptr-1 then {conserve string pool space (but see note above)}
  begin flush_string; name:=cur_name;
  end;
@y
@z

@x l.10977
file_opened:=false;
if aire="" then pack_file_name(nom,TEX_font_area,".tfm")
else pack_file_name(nom,aire,".tfm");
if not b_open_in(tfm_file) then abort;
file_opened:=true
@y
file_opened:=false;
pack_file_name(nom,aire,".tfm");
if not tfm_open_in(tfm_file) then abort;
tfm_temp:=getc(tfm_file); {read ahead; see m.564 fget}
file_opened:=true
@z

@x l.10991
@d fget==get(tfm_file)
@d fbyte==tfm_file^
@y
@d fget==tfm_temp:=getc(tfm_file)
@d fbyte==tfm_temp
@z

@x l.11185
@ We check to see that the \.{TFM} file doesn't end prematurely; but
no error message is given for files having more than |lf| words.

@<Read font parameters@>=
begin for k:=1 to np do
  if k=1 then {the |slant| parameter is a pure number}
    begin fget; sw:=fbyte; if sw>127 then sw:=sw-256;
    fget; sw:=sw*@'400+fbyte; fget; sw:=sw*@'400+fbyte;
    fget; font_info[param_base[f]].sc:=
      (sw*@'20)+(fbyte div@'20);
    end
  else store_scaled(font_info[param_base[f]+k-1].sc);
if eof(tfm_file) then abort;
for k:=np+1 to 7 do font_info[param_base[f]+k-1].sc:=0;
end
@y
@ In the C implementation, if we are short of reading |get()| we
abort. But the final byte once read, we may be at EOF, and it's OK.
Hence, we test for the first bytes, not the last.

@<Read font parameters@>=
begin for k:=1 to np do
  if k=1 then {the |slant| parameter is a pure number}
    begin fget; if eof(tfm_file) then abort;
      sw:=fbyte; if sw>127 then sw:=sw-256;
      fget; if eof(tfm_file) then abort;
      sw:=sw*@'400+fbyte; fget; sw:=sw*@'400+fbyte;
      fget; font_info[param_base[f]].sc:=
        (sw*@'20)+(fbyte div@'20);
    end
  else store_scaled(font_info[param_base[f]+k-1].sc);
for k:=np+1 to 7 do font_info[param_base[f]+k-1].sc:=0;
end
@z

@x l.11911
@ The actual output of |dvi_buf[a..b]| to |dvi_file| is performed by calling
|write_dvi(a,b)|. For best results, this procedure should be optimized to
run as fast as possible on each particular system, since it is part of
\TeX's inner loop. It is safe to assume that |a| and |b+1| will both be
multiples of 4 when |write_dvi(a,b)| is called; therefore it is possible on
many machines to use efficient methods to pack four bytes per word and to
output an array of words with one system call.
@^system dependencies@>
@^inner loop@>
@^defecation@>

@p procedure write_dvi(@!a,@!b:dvi_index);
var k:dvi_index;
begin for k:=a to b do write(dvi_file,dvi_buf[k]);
end;
@y
@ In C, we use a macro to call fwrite() or write() directly, writing all
the bytes to be written in one shot.  Much better even than writing four
bytes at a time.
@^system dependencies@>
@^inner loop@>
@^defecation@>
@z

@x l.16909
if abs(fit_class-fitness(r))>1 then d:=d+adj_demerits;
@y
if abs(toint(fit_class)-toint(fitness(r)))>1 then d:=d+adj_demerits;
@z

@x l.17223
repeat if type(r)<>delta_node then
  begin line_diff:=line_number(r)-best_line;
@y
repeat if type(r)<>delta_node then
  begin line_diff:=toint(line_number(r))-toint(best_line);
@z

@x l.18397
The hash table is called |trie_op_hash|, and the number of entries it contains
is |trie_op_ptr|.

@<Glob...@>=
@!init @!trie_op_hash:array[-trie_op_size..trie_op_size] of 0..trie_op_size;
@y
The hash table is called |trie_op_hash|, and the number of entries it contains
is |trie_op_ptr|.

@<Glob...@>=
@!init @! trie_op_hash:array[neg_trie_op_size..trie_op_size] of 0..trie_op_size;
@z

@x l.18422
var h:-trie_op_size..trie_op_size; {trial hash location}
@y
var h:neg_trie_op_size..trie_op_size; {trial hash location}
@z

@x l.18425
begin h:=abs(n+313*d+361*v+1009*cur_lang) mod (trie_op_size+trie_op_size)
@y
begin h:=abs(toint(n)+313*toint(d)+361*toint(v)+1009*toint(cur_lang))
  mod (trie_op_size+trie_op_size)
@z

@x l.18526
begin h:=abs(trie_c[p]+1009*trie_o[p]+@|
    2718*trie_l[p]+3142*trie_r[p]) mod trie_size;
@y
begin h:=abs(toint(trie_c[p])+1009*toint(trie_o[p])+@|
    2718*toint(trie_l[p])+3142*toint(trie_r[p])) mod trie_size;
@z

@x l.23521
  if a_open_in(read_file[n]) then read_open[n]:=just_open;
@y
  if a_open_in(read_file[n],TEX_INPUTS_PATH_SPEC) then read_open[n]:=just_open;
@z

@x l.23767
@!x: integer; {something to dump}
@!w: four_quarters; {four ASCII codes}
@y
@!x: integer; {something to dump}
@z

@x l.23799
@!x: integer; {something undumped}
@!w: four_quarters; {four ASCII codes}
@y
@!x: integer; {something undumped}
@z

@x l.23829
@d dump_wd(#)==begin fmt_file^:=#; put(fmt_file);@+end
@d dump_int(#)==begin fmt_file^.int:=#; put(fmt_file);@+end
@d dump_hh(#)==begin fmt_file^.hh:=#; put(fmt_file);@+end
@d dump_qqqq(#)==begin fmt_file^.qqqq:=#; put(fmt_file);@+end
@y
@d dump_wd(#)==put_fmt_word(#)
@d dump_int(#)==put_fmt_int(#)
@d dump_hh(#)==put_fmt_hh(#)
@d dump_qqqq(#)==put_fmt_qqqq(#)
@z

@x l.23843
@d undump_wd(#)==begin get(fmt_file); #:=fmt_file^;@+end
@d undump_int(#)==begin get(fmt_file); #:=fmt_file^.int;@+end
@d undump_hh(#)==begin get(fmt_file); #:=fmt_file^.hh;@+end
@d undump_qqqq(#)==begin get(fmt_file); #:=fmt_file^.qqqq;@+end
@y
@d undump_wd(#)==get_fmt_word(#)
@d undump_int(#)==get_fmt_int(#)
@d undump_hh(#)==get_fmt_hh(#)
@d undump_qqqq(#)==get_fmt_qqqq(#)
@z

@x l.23873
x:=fmt_file^.int;
@y
get_fmt_int(x);    {This is reading the first word of the fmt file}
@z

@x l.23894
for k:=0 to str_ptr do dump_int(str_start[k]);
k:=0;
while k+4<pool_ptr do
  begin dump_four_ASCII; k:=k+4;
  end;
k:=pool_ptr-4; dump_four_ASCII;
@y
dump_things(str_start[0], str_ptr+1);
dump_things(str_pool[0], pool_ptr);
@z

@x l.23911
for k:=0 to str_ptr do undump(0)(pool_ptr)(str_start[k]);
k:=0;
while k+4<pool_ptr do
  begin undump_four_ASCII; k:=k+4;
  end;
k:=pool_ptr-4; undump_four_ASCII;
@y
undump_things(str_start[0], str_ptr+1);
undump_things(str_pool[0], pool_ptr);
@z

@x l.23930
repeat for k:=p to q+1 do dump_wd(mem[k]);
x:=x+q+2-p; var_used:=var_used+q-p;
p:=q+node_size(q); q:=rlink(q);
until q=rover;
var_used:=var_used+lo_mem_max-p; dyn_used:=mem_end+1-hi_mem_min;@/
for k:=p to lo_mem_max do dump_wd(mem[k]);
x:=x+lo_mem_max+1-p;
dump_int(hi_mem_min); dump_int(avail);
for k:=hi_mem_min to mem_end do dump_wd(mem[k]);
@y
repeat
 dump_things(mem[p], q+2-p);
x:=x+q+2-p; var_used:=var_used+q-p;
p:=q+node_size(q); q:=rlink(q);
until q=rover;
var_used:=var_used+lo_mem_max-p; dyn_used:=mem_end+1-hi_mem_min;@/
dump_things(mem[p], lo_mem_max+1-p);
x:=x+lo_mem_max+1-p;
dump_int(hi_mem_min); dump_int(avail);
dump_things(mem[hi_mem_min], mem_end+1-hi_mem_min);
@z

@x l.23953
repeat for k:=p to q+1 do undump_wd(mem[k]);
p:=q+node_size(q);
if (p>lo_mem_max)or((q>=rlink(q))and(rlink(q)<>rover)) then goto bad_fmt;
q:=rlink(q);
until q=rover;
for k:=p to lo_mem_max do undump_wd(mem[k]);
@y
repeat
  undump_things(mem[p], q+2-p);
p:=q+node_size(q);
if (p>lo_mem_max)or((q>=rlink(q))and(rlink(q)<>rover)) then goto bad_fmt;
q:=rlink(q);
until q=rover;
undump_things(mem[p], lo_mem_max+1-p);
@z

@x l.23968
for k:=hi_mem_min to mem_end do undump_wd(mem[k]);
@y
undump_things(mem[hi_mem_min], mem_end+1-hi_mem_min);
@z

@x l.24005
while k<l do
  begin dump_wd(eqtb[k]); incr(k);
  end;
@y
dump_things(eqtb[k], l-k);
@z

@x l.24024
while k<l do
  begin dump_wd(eqtb[k]); incr(k);
  end;
@y
dump_things(eqtb[k], l-k);
@z

@x l.24034
for j:=k to k+x-1 do undump_wd(eqtb[j]);
@y
undump_things(eqtb[k], x);
@z

@x l.24052
for p:=hash_used+1 to undefined_control_sequence-1 do dump_hh(hash[p]);
@y
dump_things(hash[hash_used+1], undefined_control_sequence-1-hash_used);
@z

@x l.24060
for p:=hash_used+1 to undefined_control_sequence-1 do undump_hh(hash[p]);
@y
undump_things(hash[hash_used+1], undefined_control_sequence-1-hash_used);
@z

@x l.24065
for k:=0 to fmem_ptr-1 do dump_wd(font_info[k]);
dump_int(font_ptr);
for k:=null_font to font_ptr do
  @<Dump the array info for internal font number |k|@>;
@y
@<Dump the array info for internal font number |k|@>;
@z

@x l.24075
for k:=0 to fmem_ptr-1 do undump_wd(font_info[k]);
undump_size(font_base)(font_max)('font max')(font_ptr);
for k:=null_font to font_ptr do
  @<Undump the array info for internal font number |k|@>
@y
@<Undump the array info for internal font number |k|@>;
@z

@x l.24080
@ @<Dump the array info for internal font number |k|@>=
begin dump_qqqq(font_check[k]);
dump_int(font_size[k]);
dump_int(font_dsize[k]);
dump_int(font_params[k]);@/
dump_int(hyphen_char[k]);
dump_int(skew_char[k]);@/
dump_int(font_name[k]);
dump_int(font_area[k]);@/
dump_int(font_bc[k]);
dump_int(font_ec[k]);@/
dump_int(char_base[k]);
dump_int(width_base[k]);
dump_int(height_base[k]);@/
dump_int(depth_base[k]);
dump_int(italic_base[k]);
dump_int(lig_kern_base[k]);@/
dump_int(kern_base[k]);
dump_int(exten_base[k]);
dump_int(param_base[k]);@/
dump_int(font_glue[k]);@/
dump_int(bchar_label[k]);
dump_int(font_bchar[k]);
dump_int(font_false_bchar[k]);@/
print_nl("\font"); print_esc(font_id_text(k)); print_char("=");
print_file_name(font_name[k],font_area[k],"");
if font_size[k]<>font_dsize[k] then
  begin print(" at "); print_scaled(font_size[k]); print("pt");
  end;
end
@y
@ @<Dump the array info for internal font number |k|@>=
begin dump_things(font_info[0], fmem_ptr);
dump_int(font_ptr);
dump_things(font_check[null_font], font_ptr+1-null_font);
dump_things(font_size[null_font], font_ptr+1-null_font);
dump_things(font_dsize[null_font], font_ptr+1-null_font);
dump_things(font_params[null_font], font_ptr+1-null_font);
dump_things(hyphen_char[null_font], font_ptr+1-null_font);
dump_things(skew_char[null_font], font_ptr+1-null_font);
dump_things(font_name[null_font], font_ptr+1-null_font);
dump_things(font_area[null_font], font_ptr+1-null_font);
dump_things(font_bc[null_font], font_ptr+1-null_font);
dump_things(font_ec[null_font], font_ptr+1-null_font);
dump_things(char_base[null_font], font_ptr+1-null_font);
dump_things(width_base[null_font], font_ptr+1-null_font);
dump_things(height_base[null_font], font_ptr+1-null_font);
dump_things(depth_base[null_font], font_ptr+1-null_font);
dump_things(italic_base[null_font], font_ptr+1-null_font);
dump_things(lig_kern_base[null_font], font_ptr+1-null_font);
dump_things(kern_base[null_font], font_ptr+1-null_font);
dump_things(exten_base[null_font], font_ptr+1-null_font);
dump_things(param_base[null_font], font_ptr+1-null_font);
dump_things(font_glue[null_font], font_ptr+1-null_font);
dump_things(bchar_label[null_font], font_ptr+1-null_font);
dump_things(font_bchar[null_font], font_ptr+1-null_font);
dump_things(font_false_bchar[null_font], font_ptr+1-null_font);
for k:=null_font to font_ptr do begin
  print_nl("\font"); print_esc(font_id_text(k)); print_char("=");
  print_file_name(font_name[k],font_area[k],"");
  if font_size[k]<>font_dsize[k] then begin
    print(" at "); print_scaled(font_size[k]); print("pt");
  end;
end;
end
@z

@x l.24111
@ @<Undump the array info for internal font number |k|@>=
begin undump_qqqq(font_check[k]);@/
undump_int(font_size[k]);
undump_int(font_dsize[k]);
undump(min_halfword)(max_halfword)(font_params[k]);@/
undump_int(hyphen_char[k]);
undump_int(skew_char[k]);@/
undump(0)(str_ptr)(font_name[k]);
undump(0)(str_ptr)(font_area[k]);@/
undump(0)(255)(font_bc[k]);
undump(0)(255)(font_ec[k]);@/
undump_int(char_base[k]);
undump_int(width_base[k]);
undump_int(height_base[k]);@/
undump_int(depth_base[k]);
undump_int(italic_base[k]);
undump_int(lig_kern_base[k]);@/
undump_int(kern_base[k]);
undump_int(exten_base[k]);
undump_int(param_base[k]);@/
undump(min_halfword)(lo_mem_max)(font_glue[k]);@/
undump(0)(fmem_ptr-1)(bchar_label[k]);
undump(min_quarterword)(non_char)(font_bchar[k]);
undump(min_quarterword)(non_char)(font_false_bchar[k]);
end
@y
@  The way this is done in C makes the reference to
the internal font number meaningless, but putting the code
here preserves the association with the WEB modules.

@<Undump the array info for internal font number |k|@>=
begin undump_things(font_info[0], fmem_ptr);
undump_size(font_base)(font_max)('font max')(font_ptr);
undump_things(font_check[null_font], font_ptr+1-null_font);
undump_things(font_size[null_font], font_ptr+1-null_font);
undump_things(font_dsize[null_font], font_ptr+1-null_font);
undump_things(font_params[null_font], font_ptr+1-null_font);
undump_things(hyphen_char[null_font], font_ptr+1-null_font);
undump_things(skew_char[null_font], font_ptr+1-null_font);
undump_things(font_name[null_font], font_ptr+1-null_font);
undump_things(font_area[null_font], font_ptr+1-null_font);
undump_things(font_bc[null_font], font_ptr+1-null_font);
undump_things(font_ec[null_font], font_ptr+1-null_font);
undump_things(char_base[null_font], font_ptr+1-null_font);
undump_things(width_base[null_font], font_ptr+1-null_font);
undump_things(height_base[null_font], font_ptr+1-null_font);
undump_things(depth_base[null_font], font_ptr+1-null_font);
undump_things(italic_base[null_font], font_ptr+1-null_font);
undump_things(lig_kern_base[null_font], font_ptr+1-null_font);
undump_things(kern_base[null_font], font_ptr+1-null_font);
undump_things(exten_base[null_font], font_ptr+1-null_font);
undump_things(param_base[null_font], font_ptr+1-null_font);
undump_things(font_glue[null_font], font_ptr+1-null_font);
undump_things(bchar_label[null_font], font_ptr+1-null_font);
undump_things(font_bchar[null_font], font_ptr+1-null_font);
undump_things(font_false_bchar[null_font], font_ptr+1-null_font);
end
@z

@x l.24146
for k:=0 to trie_max do dump_hh(trie[k]);
dump_int(trie_op_ptr);
for k:=1 to trie_op_ptr do
  begin dump_int(hyf_distance[k]);
  dump_int(hyf_num[k]);
  dump_int(hyf_next[k]);
  end;
@y
dump_things(trie[0], trie_max+1);
dump_int(trie_op_ptr);
dump_things(hyf_distance[1], trie_op_ptr);
dump_things(hyf_num[1], trie_op_ptr);
dump_things(hyf_next[1], trie_op_ptr);
@z

@x l.24174
for k:=0 to j do undump_hh(trie[k]);
undump_size(0)(trie_op_size)('trie op size')(j); @+init trie_op_ptr:=j;@+tini
for k:=1 to j do
  begin undump(0)(63)(hyf_distance[k]); {a |small_number|}
  undump(0)(63)(hyf_num[k]);
  undump(min_quarterword)(max_quarterword)(hyf_next[k]);
  end;
@y
undump_things(trie[0], j+1);
undump_size(0)(trie_op_size)('trie op size')(j); @+init trie_op_ptr:=j;@+tini
undump_things(hyf_distance[1], j);
undump_things(hyf_num[1], j);
undump_things(hyf_next[1], j);
@z

@x l.24196
@ @<Undump a couple more things and the closing check word@>=
undump(batch_mode)(error_stop_mode)(interaction);
undump(0)(str_ptr)(format_ident);
undump_int(x);
if (x<>69069)or eof(fmt_file) then goto bad_fmt
@y
@ @<Undump a couple more things and the closing check word@>=
undump(batch_mode)(error_stop_mode)(interaction);
undump(0)(str_ptr)(format_ident);
undump_int(x);
if (x<>69069)or not eof(fmt_file) then goto bad_fmt
@z

@x l.24277
@ Now this is really it: \TeX\ starts and ends here.

The initial test involving |ready_already| should be deleted if the
\PASCAL\ runtime system is smart enough to detect such a ``mistake.''
@y
@ Now this is really it: \TeX\ starts and ends here.

Use the value of |history| to determine what exit code to use.
@z

@x l.24283
@p begin @!{|start_here|}
history:=fatal_error_stop; {in case we quit during initialization}
t_open_out; {open the terminal for output}
if ready_already=314159 then goto start_of_TEX;
@y
@p procedure tex_body;
label @<Labels in the outer block@>@/
var bufindx:0..buf_size; {an index used in a for loop below}
begin @!{|start_here|}
history:=fatal_error_stop; {in case we quit during initialization}
t_open_out; {open the terminal for output}
set_paths(TEX_PATHS_SET); {get default file paths from the Unix environment}
if ready_already=314159 then goto start_of_TEX;
@z

@x l.24306
final_end: ready_already:=0;
end.
@y
final_end: do_final_end;
end {|tex_body|};
begin tex_body; end.
@z

@x l.24328
wake_up_terminal; @<Finish the \.{DVI} file@>;
@y
@<Finish the \.{DVI} file@>;
@z

@x l.24334
    slow_print(log_name); print_char(".");
    end;
  end;
@y
    slow_print(log_name); print_char(".");
    end;
  end;
print_ln;
@z

@x l.24493
    begin goto breakpoint;@/ {go to every declared label at least once}
    breakpoint: m:=0; @{'BREAKPOINT'@}@/
    end
@y
    dump_core {Do something to cause a core dump}
@z

@x l.24986
This section should be replaced, if necessary, by any special
modifications of the program
that are necessary to make \TeX\ work at a particular installation.
It is usually best to design your change file so that all changes to
previous sections preserve the section numbering; then everybody's version
will be consistent with the published program. More extensive changes,
which introduce new sections, can be inserted here; then only the index
itself will get a new section number.
@^system dependencies@>
@y
Here is a temporary integer, used as a holder during reading and writing of
TFM files, and a temporary memory_word, used in reading/writing format
files.
Also, the variables used to hold ``switch-to-editor'' information.
@^<system dependencies@>

@<Glob...@>=
@!edit_name_start: pool_pointer;
@!edit_name_length,@!edit_line,@!tfm_temp: integer;

@ The |edit_name_start| will be set to point into |str_pool| somewhere after
its beginning if \TeX\ is supposed to switch to an editor on exit.

@<Set init...@>=
edit_name_start:=0;

@ More implementation modifications can come after this.
@z


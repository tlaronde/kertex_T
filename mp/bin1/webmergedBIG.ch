% This is webmergedBIG.ch, a WEB change file produced by webmerge.tex
% to be applied to mp.web
% combining the changes (one after the other) from
% 1. filename.ch
% 2. kertex.ch
% 3. BIG.ch

@x l.65
\def\botofcontents{\vskip 0pt plus 1fil minus 1.5in}
@y
\def\botofcontents{\vskip 0pt plus 1fil minus 1.5in}
\let\maybe=\iffalse
\def\title{{\logo opqrstuq} changes for C}
\def\glob{13}\def\gglob{20, 25} % these are defined in module 1
@z

@x l.119
@d banner=='This is MetaPost, Version 0.65' {printed when \MP\ starts}
@y
@d banner=='This is MetaPost, kerTeX C Version 0.65' {printed when \MP\ starts}
@z

@x l.224
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

@x l.244
@d init== {change this to `$\\{init}\equiv\.{@@\{}$' in the production version}
@d tini== {change this to `$\\{tini}\equiv\.{@@\}}$' in the production version}
@y
@d init==ifdef('INIMP')
@d tini==endif('INIMP')
@z

@x l.259
@<Compiler directives@>=
@{@&$C-,A+,D-@} {no range check, catch arithmetic overflow, no debug overhead}
@!debug @{@&$C+,D+@}@+ gubed {but turn everything on when debugging}
@y
@<Compiler directives@>=
@{No compiler directives for C@}
@z

@x l.304
@!mem_max=30000; {greatest index in \MP's internal |mem| array;
  must be strictly less than |max_halfword|;
  must be equal to |mem_top| in \.{INIMP}, otherwise |>=mem_top|}
@!max_internal=100; {maximum number of internal quantities}
@!buf_size=500; {maximum number of characters simultaneously present in
  current lines of open files; must not exceed |max_halfword|}
@y
@!mem_max=262140; {greatest index in \MP's internal |mem| array;
  must be strictly less than |max_halfword|;
  must be equal to |mem_top| in \.{INIMP}, otherwise |>=mem_top|}
@!max_internal=300; {maximum number of internal quantities}
@!buf_size=3000; {maximum number of characters simultaneously present in
  current lines of open files; must not exceed |max_halfword|}
@z

@x l.310
@!error_line=72; {width of context lines on terminal error messages}
@!half_error_line=42; {width of first lines of contexts in terminal
  error messages; should be between 30 and |error_line-15|}
@!max_print_line=79; {width of longest text lines output; should be at least 60}
@y
@!error_line=79; {width of context lines on terminal error messages}
@!half_error_line=50; {width of first lines of contexts in terminal
  error messages; should be between 30 and |error_line-15|}
@!max_print_line=79; {width of longest text lines output; should be at least 60}
@z

@x l.316
@!stack_size=30; {maximum number of simultaneous input sources}
@!max_read_files=4; {maximum number of simultaneously open \&{readfrom} files}
@!max_strings=2500; {maximum number of strings; must not exceed |max_halfword|}
@!string_vacancies=9000; {the minimum number of characters that should be
  available for the user's identifier names and strings,
  after \MP's own error messages are stored}
@!strings_vacant=1000; {the minimum number of strings that should be available}
@!pool_size=32000; {maximum number of characters in strings, including all
  error messages and help texts, and the names of all identifiers;
  must exceed |string_vacancies| by the total
  length of \MP's own strings, which is currently about 22000}
@y
@!stack_size=300; {maximum number of simultaneous input sources}
@!max_read_files=10; {maximum number of simultaneously open \&{readfrom} files}
@!max_strings=7500; {maximum number of strings; must not exceed |max_halfword|}
@!string_vacancies=74000; {the minimum number of characters that should be
  available for the user's identifier names and strings,
  after \MP's own error messages are stored}
@!strings_vacant=1000; {the minimum number of strings that should be available}
@!pool_size=100000; {maximum number of characters in strings, including all
  error messages and help texts, and the names of all identifiers;
  must exceed |string_vacancies| by the total
  length of \MP's own strings, which is currently about 22000}
@z

@x l.329
@!file_name_size=40; {file names shouldn't be longer than this}
@!pool_name='MPlib:MP.POOL                         ';
  {string of length |file_name_size|; tells where the string pool appears}
@.MPlib@>
@!ps_tab_name='MPlib:PSFONTS.MAP                     ';
  {string of length |file_name_size|; locates font name translation table}
@y
@!pool_name='mp.pool';
@!pool_name_length=7;
  {required: |name_of_file| and |name_length| have to be both defined}
@!mem_top=262140; {largest index in the |mem| array dumped by \.{INIMF};
  must be substantially larger than |mem_min|
  and not greater than |mem_max|}
@z

@x l.335
@!path_size=300; {maximum number of knots between breakpoints of a path}
@y
@!path_size=600; {maximum number of knots between breakpoints of a path}
@z

@x l.355
@d mem_min=0 {smallest index in the |mem| array, must not be less
  than |min_halfword|}
@d mem_top==30000 {largest index in the |mem| array dumped by \.{INIMP};
  must be substantially larger than |mem_min|
  and not greater than |mem_max|}
@d hash_size=2100 {maximum number of symbolic tokens,
  must be less than |max_halfword-3*param_size|}
@d hash_prime=1777 {a prime number equal to about 85\pct! of |hash_size|}
@d max_in_open=6 {maximum number of input files and error insertions that
  can be going on simultaneously}
@y
@d mem_min=0 {smallest index in the |mem| array, must not be less
  than |min_halfword|}
@d hash_size=9500 {maximum number of symbolic tokens,
  must be less than |max_halfword-3*param_size|}
@d hash_prime=7919 {a prime number equal to about 85\pct! of |hash_size|}
@d max_in_open=15 {maximum number of input files and error insertions that
  can be going on simultaneously}
@z

@x l.427
@d incr(#) == #:=#+1 {increase a variable by unity}
@d decr(#) == #:=#-1 {decrease a variable by unity}
@y
@z

@x l.475
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

@x l.624
@^character set dependencies@>
@^system dependencies@>

@<Set init...@>=
for i:=0 to @'37 do xchr[i]:=' ';
for i:=@'177 to @'377 do xchr[i]:=' ';

@y
@^character set dependencies@>
@^system dependencies@>

@d tab = @'11 { ASCII horizontal tab }
@d form_feed = @'14 { ASCII form-feed }

@<Set init...@>=
for i:=0 to @'37 do xchr[i]:=chr(i);
for i:=@'177 to @'377 do xchr[i]:=chr(i);

@z

@x l.689
is crucial for our purposes. We shall assume that |name_of_file| is a variable
of an appropriate type such that the \PASCAL\ run-time system being used to
implement \MP\ can open a file whose external name is specified by
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

@x l.701
@ The \ph\ compiler with which the original version of \MF\ was prepared
extends the rules of \PASCAL\ in a very convenient way. To open file~|f|,
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
\MP\ to undertake appropriate corrective action.
@:PASCAL H}{\ph@>
@^system dependencies@>

\MP's file-opening procedures return |false| if no file identified by
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
function b_open_in(var @!f:byte_file):boolean;
  {open a binary file for input}
begin reset(f,name_of_file,'/O'); b_open_in:=reset_OK(f);
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

@x l.757
@ Files can be closed with the \ph\ routine `|close(f)|', which
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

@x l.825
Standard \PASCAL\ says that a file should have |eoln| immediately
before |eof|, but \MP\ needs only a weaker restriction: If |eof|
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
The |input_ln| function will be defined in an external C routine.

@d input_ln==cinput_ln {implemented in C libweb, so prefixed to avoid conflict}
@z

@x l.857
@<Glob...@>=
@!term_in:alpha_file; {the terminal as an input file}
@!term_out:alpha_file; {the terminal as an output file}
@y
@d term_in==stdin {the terminal as an input file}
@d term_out==stdout {the terminal as an output file}
@z

@x l.861
@ Here is how to open the terminal files
in \ph. The `\.{/I}' switch suppresses the first |get|.
@^system dependencies@>

@d t_open_in==reset(term_in,'TTY:','/O/I') {open the terminal for text input}
@d t_open_out==rewrite(term_out,'TTY:','/O') {open the terminal for text output}
@y
@ Here is how to open the terminal files
in C: simply use stdin and stdout.
@^system dependencies@>

@d t_open_out == {output already open for text output}
@z

@x l.879
these operations can be specified in \ph:
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

@x l.946
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

@x l.1448
name_of_file:=pool_name; {we needn't set |name_length|}
if a_open_in(pool_file) then
@y
vstrncpy(name_of_file + 1, pool_name, pool_name_length);
name_length:=pool_name_length;
if a_open_in(pool_file,POOL_PATH_SPEC) then
@z

@x l.1456
else  bad_pool('! I can''t read MP.POOL.')
@y
else  bad_pool('! I can''t read mp.pool.')
@z

@x l.1460
begin if eof(pool_file) then bad_pool('! MP.POOL has no check sum.');
@.MP.POOL has no check sum@>
read(pool_file,m,n); {read two digits of string length}
@y
begin if eof(pool_file) then bad_pool('! mp.pool has no check sum.');
@.MP.POOL has no check sum@>
read2(pool_file,m,n); {read two digits of string length}
@z

@x l.1466
    bad_pool('! MP.POOL line doesn''t begin with two digits.');
@y
    bad_pool('! mp.pool line doesn''t begin with two digits.');
@z

@x l.1491
  bad_pool('! MP.POOL check sum doesn''t have nine digits.');
@y
  bad_pool('! mp.pool check sum doesn''t have nine digits.');
@z

@x l.1497
done: if a<>@$ then bad_pool('! MP.POOL doesn''t match; TANGLE me again.');
@y
done: if a<>@$ then bad_pool('! mp.pool doesn''t match; tangle me again.');
@z

@x l.1709
@ By popular demand, \MP\ prints the banner line only on the transcript file.
Thus there is nothing special to be printed here.

@<Initialize the output...@>=
update_terminal;
@y
@ Here is the very first thing that \MP\ prints: a headline that identifies
the version number. The |term_offset| variable is temporarily
incorrect, but the discrepancy is not serious since we assume that this
part of the program is system dependent.
@^system dependencies@>

@<Initialize the output...@>=
wterm(banner);
update_terminal;
@z

@x l.1940
procedure that quietly terminates the program.

@<Error hand...@>=
procedure jump_out;
begin goto end_of_MP;
end;
@y
procedure that quietly terminates the program.

Use the value of |history| to determine what exit-code to use.  We use
1 if |history <> spotless| and 0 otherwise.

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

@x l.2263
@d halfp(#)==(#) div 2
@y
@z

@x l.2440
@p function make_fraction(@!p,@!q:integer):fraction;
var @!f:integer; {the fraction bits, with a leading 1 bit}
@!n:integer; {the integer part of $\vert p/q\vert$}
@!negative:boolean; {should the result be negated?}
@!be_careful:integer; {disables certain compiler optimizations}
@y
In the C version, there are external routines that use double precision
floating point to simulate functions such as |make_fraction|.  This is carefully
done to be virtually machine-independent and it gives up to 12 times speed-up
on machines with hardware floating point.  Since some machines do not have fast
double-precision floating point, we provide a C preprocessor switch that allows
selecting the standard versions given below.

@p ifdef('FIXPT')@/
function make_fraction(@!p,@!q:integer):fraction;
var @!f:integer; {the fraction bits, with a leading 1 bit}
@!n:integer; {the integer part of $\vert p/q\vert$}
@!negative:boolean; {should the result be negated?}
@!be_careful:volatile_integer; {disables certain compiler optimizations}
@z

@x l.2460
  if negative then make_fraction:=-(f+n)@+else make_fraction:=f+n;
  end;
end;
@y
  if negative then make_fraction:=-(f+n)@+else make_fraction:=f+n;
  end;
end;@/
endif('FIXPT')
@z

@x l.2497
@p function take_fraction(@!q:integer;@!f:fraction):integer;
var @!p:integer; {the fraction so far}
@!negative:boolean; {should the result be negated?}
@!n:integer; {additional multiple of $q$}
@!be_careful:integer; {disables certain compiler optimizations}
@y
@p ifdef('FIXPT')@/
function take_fraction(@!q:integer;@!f:fraction):integer;
var @!p:integer; {the fraction so far}
@!negative:boolean; {should the result be negated?}
@!n:integer; {additional multiple of $q$}
@!be_careful:volatile_integer; {disables certain compiler optimizations}
@z

@x l.2516
else take_fraction:=n+p;
end;
@y
else take_fraction:=n+p;
end;@/
endif('FIXPT')
@z

@x l.2553
@p function take_scaled(@!q:integer;@!f:scaled):integer;
var @!p:integer; {the fraction so far}
@!negative:boolean; {should the result be negated?}
@!n:integer; {additional multiple of $q$}
@!be_careful:integer; {disables certain compiler optimizations}
@y
@p ifdef('FIXPT')@/
function take_scaled(@!q:integer;@!f:scaled):integer;
var @!p:integer; {the fraction so far}
@!negative:boolean; {should the result be negated?}
@!n:integer; {additional multiple of $q$}
@!be_careful:volatile_integer; {disables certain compiler optimizations}
@z

@x l.2572
else take_scaled:=n+p;
end;
@y
else take_scaled:=n+p;
end;@/
endif('FIXPT')
@z

@x l.2589
operands are positive. \ (This procedure is not used especially often,
so it is not part of \MP's inner loop.)

@p function make_scaled(@!p,@!q:integer):scaled;
var @!f:integer; {the fraction bits, with a leading 1 bit}
@!n:integer; {the integer part of $\vert p/q\vert$}
@!negative:boolean; {should the result be negated?}
@!be_careful:integer; {disables certain compiler optimizations}
@y
operands are positive. \ (This procedure is not used especially often,
so it is not part of \MP's inner loop, but we might as well allow for
an external C routine.)

@p ifdef('FIXPT')@/
function make_scaled(@!p,@!q:integer):scaled;
var @!f:integer; {the fraction bits, with a leading 1 bit}
@!n:integer; {the integer part of $\vert p/q\vert$}
@!negative:boolean; {should the result be negated?}
@!be_careful:volatile_integer; {disables certain compiler optimizations}
@z

@x l.2612
  if negative then make_scaled:=-(f+n)@+else make_scaled:=f+n;
  end;
end;
@y
  if negative then make_scaled:=-(f+n)@+else make_scaled:=f+n;
  end;
end;@/
endif('FIXPT')
@z

@x l.2712
@p function floor_scaled(@!x:scaled):scaled;
  {$2^{16}\lfloor x/2^{16}\rfloor$}
var @!be_careful:integer; {temporary register}
@y
@p function floor_scaled(@!x:scaled):scaled;
  {$2^{16}\lfloor x/2^{16}\rfloor$}
var @!be_careful:volatile_integer; {temporary register}
@z

@x l.2721
function round_unscaled(@!x:scaled):integer;
  {$\lfloor x/2^{16}+.5\rfloor$}
var @!be_careful:integer; {temporary register}
@y
function round_unscaled(@!x:scaled):integer;
  {$\lfloor x/2^{16}+.5\rfloor$}
var @!be_careful:volatile_integer; {temporary register}
@z

@x l.2731
function round_fraction(@!x:fraction):scaled;
  {$\lfloor x/2^{12}+.5\rfloor$}
var @!be_careful:integer; {temporary register}
@y
function round_fraction(@!x:fraction):scaled;
  {$\lfloor x/2^{12}+.5\rfloor$}
var @!be_careful:volatile_integer; {temporary register}
@z

@x l.3346
@d min_quarterword=0 {smallest allowable value in a |quarterword|}
@d max_quarterword=255 {largest allowable value in a |quarterword|}
@d min_halfword==0 {smallest allowable value in a |halfword|}
@d max_halfword==65535 {largest allowable value in a |halfword|}
@y
@d min_quarterword=0 {smallest allowable value in a |quarterword|}
@d max_quarterword=511 {largest allowable value in a |quarterword|}
@d min_halfword==0 {smallest allowable value in a |halfword|}
@d max_halfword==262143 {largest allowable value in a |halfword|}
@z

@x l.3368
@ The operation of subtracting |min_halfword| occurs rather frequently in
\MP, so it is convenient to abbreviate this operation by using the macro
|ho| defined here.  \MP\ will run faster with respect to compilers that
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
\MP, so it is convenient to abbreviate this operation by using the macro
|ho| defined here.  \MP\ will run faster with respect to compilers that
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

@x l.3391
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

@x l.3634
if r>p+1 then @<Allocate from the top of node |p| and |goto found|@>;
@y
if r>toint(p+1) then @<Allocate from the top of node |p| and |goto found|@>;
@z

@x l.3783
been included. (You may want to decrease the size of |mem| while you
@^debugging@>
are debugging.)
@y
been included. (You may want to decrease the size of |mem| while you
@^debugging@>
are debugging.)

@d free==free_arr
@z

@x l.3841
repeat if (p>=lo_mem_max)or(p<mem_min) then clobbered:=true
  else if (rlink(p)>=lo_mem_max)or(rlink(p)<mem_min) then clobbered:=true
@y
repeat if (p>=lo_mem_max) then clobbered:=true
  else if (rlink(p)>=lo_mem_max) then clobbered:=true
@z

@x l.4531
@ The following procedure, which is called just before \MP\ initializes its
input and output, establishes the initial values of the date and time.
@^system dependencies@>
Since standard \PASCAL\ cannot provide such information, something special
is needed. The program here simply assumes that suitable values appear in
the global variables \\{sys\_time}, \\{sys\_day}, \\{sys\_month}, and
\\{sys\_year} (which are initialized to noon on 4 July 1776,
in case the implementor is careless).

Note that the values are |scaled| integers. Hence \MP\ can no longer
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

@x l.4662
for k:=0 to " "-1 do char_class[k]:=invalid_class;
@y
for k:=0 to " "-1 do char_class[k]:=invalid_class;
char_class[tab]:=space_class;
char_class[form_feed]:=space_class;
@z

@x l.13962
@ The file names we shall deal with for illustrative purposes have the
following structure:  If the name contains `\.>' or `\.:', the file area
consists of all characters up to and including the final such character;
otherwise the file area is null.  If the remaining file name contains
`\..', the file extension consists of all such characters from the first
remaining `\..' to the end, otherwise the file extension is null.
@^system dependencies@>

We can scan such file names easily by using two global variables that keep track
of the occurrences of area and extension delimiters.  Note that these variables
cannot be of type |pool_pointer| because a string pool compaction could occur
while scanning a file name.

@<Glob...@>=
@!area_delimiter:integer;
  {most recent `\.>' or `\.:' relative to |str_start[str_ptr]|}
@!ext_delimiter:integer; {the relevant `\..', if any}
@y
@ The file names we shall deal with have the
following structure:  If the name contains `\./', the file area
consists of all characters up to and including the final such character;
otherwise the file area is null.  If the remaining file name contains
`\..', the file extension consists of all such characters from the first
remaining `\..' to the end, otherwise the file extension is null. For
input files, the area is used; for products, it is not used since the
files shall be created in the current directory.
@^system dependencies@>

We can scan such file names easily by using two global variables that keep
track of the occurrences of area and extension delimiters:

@<Glob...@>=
@!area_delimiter:pool_pointer; {the most recent `\./', if any}
@!ext_delimiter:pool_pointer; {the most recent `\..', if any}
@z

@x l.13987
@d MP_area=="MPinputs:"
@.MPinputs@>
@d MF_area=="MFinputs:"
@.MFinputs@>
@d MP_font_area=="TeXfonts:"
@.TeXfonts@>
@y
In C, the default paths are specified at compilation time, settable
via environment by user at run time, and the search routines are shared
by all programs and implemented in the kerTeX web library.
@z

@x l.14009
begin if c=" " then more_name:=false
else  begin if (c=">")or(c=":") then
@y
begin if (c=" ")or(c=tab) then more_name:=false
else  begin if (c="/") then
@z

@x l.14053
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

@x l.14066
for j:=str_start[a] to str_stop(a)-1 do append_to_name(so(str_pool[j]));
for j:=str_start[n] to str_stop(n)-1 do append_to_name(so(str_pool[j]));
@y
@!debug if e=0 then begin print_err("This can't happen!");
@.This can't happen@>
  help1("I'm broken. There shall always be an extension to filenames!");
  end;
gubed
for j:=str_start[a] to str_stop(a)-1 do append_to_prefix(so(str_pool[j]));
for j:=str_start[n] to str_stop(n)-1 do append_to_prefix(so(str_pool[j]));
@z

@x l.14079
@d mem_default_length=15 {length of the |MP_mem_default| string}
@d mem_area_length=6 {length of its area part}
@d mem_ext_length=4 {length of its `\.{.mem}' part}
@d mem_extension=".mem" {the extension, as a \.{WEB} constant}

@<Glob...@>=
@!MP_mem_default:packed array[1..mem_default_length] of char;

@ @<Set init...@>=
MP_mem_default:='MPlib:plain.mem';
@y
Under {\mc UNIX} we don't give the area part, instead depending
on the path searching that will happen during file opening. \.{pp2rc}
adds one to the array sizes so that the indices do point inside the
array. When the array is declared in the Pascal code and used by Pascal
routines, we do not need the C trailing nul character since this is not
a C string.

We also need a variable that keeps track of whether the \.{-T} flag
has been used to request \.{troff} mode

@d mem_default_length=9 {length of the |MP_mem_default| string}
@d mem_area_length=0 {length of its area part}
@d mem_ext_length=4 {length of its `\.{.mem}' part}
@d mem_extension=".mem" {the extension, as a \.{WEB} constant}
  {not empty and distinct from ".log" and "ps"}

@<Glob...@>=
@!MP_mem_default:packed array[1..mem_default_length] of text_char;
@!troff_mode:boolean; {has the user requested \.{troff} mode?}

@ @<Set init...@>=
vstrncpy(MP_mem_default + 1, 'plain.mem', mem_default_length);
troff_mode:=false; {this is the default}
@z

@x l.14093
@ @<Check the ``constant'' values for consistency@>=
if mem_default_length>file_name_size then bad:=20;
@y
@ The buffer |name_of_file| shall be able to accommodate for
|MP_mem_default|---that shall have a specific extension---but shall
too be able to hold the default job filename (\.{mpout.log}).

@d default_job_filenames_len=9 {"mpout.log"}

@<Check the ``constant'' values for consistency@>=
if (mem_default_length>file_name_size)
  or(mem_ext_length<1)or(file_name_size<default_job_filenames_len)
  then bad:=20;
@z

@x l.14137
  pack_buffered_name(0,loc,j-1); {try first without the system file area}
  if w_open_in(mem_file) then goto found;
  pack_buffered_name(mem_area_length,loc,j-1);
    {now try the system mem file area}
  if w_open_in(mem_file) then goto found;
@y
  pack_buffered_name(0,loc,j-1);
  if w_open_in(mem_file) then goto found;
@z

@x l.14143
  wterm_ln('Sorry, I can''t find that mem file;',' will try PLAIN.');
@y
  wterm_ln('Sorry, I can''t find that mem file;',' will try the default.');
@z

@x l.14151
  wterm_ln('I can''t find the PLAIN mem file!');
@.I can't find PLAIN...@>
@y
  wterm_ln('I can''t find the default mem file!');
@.I can't find default mem...@>
@z

@x l.14161
which simply makes a \MP\ string from the value of |name_of_file|, should
ideally be changed to deduce the full name of file~|f|, which is the file
most recently opened, if it is possible to do this in a \PASCAL\ program.
@^system dependencies@>

This routine might be called after string memory has overflowed, hence
we check for this before calling `|str_room|'.

@p function make_name_string:str_number;
var @!k:1..file_name_size; {index into |name_of_file|}
begin if str_overflowed then
  make_name_string:="?"
else  begin str_room(name_length);
  for k:=1 to name_length do append_char(xord[name_of_file[k]]);
  make_name_string:=make_string;
  end;
end;
@y
which simply makes a \MP\ string from the value of |name_of_file|, should
ideally be changed to deduce the full name of file~|f|, which is the file
most recently opened, if it is possible to do this in a \PASCAL\ program.
With the C version, we know that |real_name_of_file|
contains |name_of_file| prepended with the directory name that was found
by path searching.
@^system dependencies@>

This routine might be called after string memory has overflowed, hence
we check for this before calling `|str_room|'.

@p function make_name_string:str_number;
var @!k:1..file_name_size; {index into |name_of_file|}
begin
if str_overflowed then
  make_name_string:="?"
else  begin str_room(real_name_length);
  for k:=1 to real_name_length do append_char(xord[real_name_of_file[k]]);
  make_name_string:=make_string;
  end;
end;
@z

@x l.14178
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
{The a, b and w variants are replaced by macros in C calling makenamestring}
@z

@x l.14205
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

@x l.14288
@ @<Scan file name in the buffer@>=
begin begin_name; k:=first;
while (buffer[k]=" ")and(k<last) do incr(k);
@y
@ @<Scan file name in the buffer@>=
begin begin_name; k:=first;
while ((buffer[k]=" ")or(buffer[k]=tab))and(k<last) do incr(k);
@z

@x l.14347
months:='JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC';
@y
vstrncpy(months + 1, 'JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC', 36);
@z

@x l.14360
if a_open_in(cur_file) then try_extension:=true
else begin if str_vs_str(ext,".mf")=0 then in_area:=MF_area
  else in_area:=MP_area;
  pack_file_name(cur_name,in_area,ext);
  try_extension:=a_open_in(cur_file);
  end;
@y
try_extension:=a_open_in(cur_file, INPUTS_PATH_SPEC);
@z

@x l.14413
@<Flush |name| and replace it with |cur_name| if it won't be needed@>=
flush_string(name); name:=cur_name; cur_name:=0
@y
@<Flush |name| and replace it with |cur_name| if it won't be needed@>=
do_nothing
@z

@x l.14458
@ @<Glob...@>=
@!old_file_name : packed array[1..file_name_size] of char;
  {analogous to |name_of_file|}
@y
@ @<Glob...@>=
@!old_file_name : packed array[1..file_name_size] of text_char;
  {analogous to |name_of_file|}

@z

@x l.14470
begin pack_file_name(in_name,in_area,".mpx");
@<Try to make sure |name_of_file| refers to a valid \.{MPX} file and
  |goto not_found| if there is a problem@>;
begin_file_reading;
if not a_open_in(cur_file) then
  begin end_file_reading;
@y
begin pack_file_name(in_name,"",".mpx");
@<Try to make sure |name_of_file| refers to a valid \.{MPX} file and
  |goto not_found| if there is a problem@>;
begin_file_reading;
if not a_open_in(cur_file,NO_PATH_SPEC) then
  begin end_file_reading;
@z

@x l.14493
@<Try to make sure |name_of_file| refers to a valid \.{MPX} file and
  |goto not_found| if there is a problem@>=
copy_old_name(name)
{System-dependent code should be added here}
@y
@<Try to make sure |name_of_file| refers to a valid \.{MPX} file and
  |goto not_found| if there is a problem@>=
copy_old_name(name);
if not call_make_mpx(old_file_name,name_of_file) then goto not_found
@z

@x l.14543
if not a_open_in(rd_file[n]) then goto not_found;
@y
if not a_open_in(rd_file[n],NO_PATH_SPEC) then goto not_found;
@z

@x l.20495
@p function threshold(@!m:integer):scaled;
var @!d:scaled; {lower bound on the smallest interval size}
begin excess:=min_cover(0)-m;
if excess<=0 then threshold:=0
else  begin repeat d:=perturbation;
  until min_cover(d+d)<=m;
  while min_cover(d)>m do d:=perturbation;
  threshold:=d;
  end;
end;
@y
@p function compute_threshold(@!m:integer):scaled;
var @!d:scaled; {lower bound on the smallest interval size}
begin excess:=min_cover(0)-m;
if excess<=0 then compute_threshold:=0
else  begin repeat d:=perturbation;
  until min_cover(d+d)<=m;
  while min_cover(d)>m do d:=perturbation;
  compute_threshold:=d;
  end;
end;
@z

@x l.20518
begin d:=threshold(m); perturbation:=0;
@y
begin d:=compute_threshold(m); perturbation:=0;
@z

@x l.20681
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

@x l.21005
@d tfget==get(tfm_infile)
@d tfbyte==tfm_infile^
@y
@d tfget==tfm_temp:=getc(tfm_infile)
@d tfbyte==tfm_temp
@z

@x l.21104
if cur_area="" then cur_area:=MP_font_area;
if cur_ext="" then cur_ext:=".tfm";
pack_cur_name;
if not b_open_in(tfm_infile) then goto bad_tfm;
@y
if cur_ext="" then cur_ext:=".tfm";
pack_cur_name;
if not b_open_in(tfm_infile) then goto bad_tfm;
tfget; {load the first byte into |tfm_temp|}
@z

@x l.21209
begin name_of_file:=ps_tab_name;
if a_open_in(ps_tab_file) then
@y
begin vstrcpy(name_of_file, PS_TAB_NAME); {C string copy, including guards |_|}
if a_open_in(ps_tab_file,INPUTS_PATH_SPEC) then
@z

@x l.21239
loop @+begin if eoln(ps_tab_file) then
    fatal_error("The psfont map file is bad!");
  read(ps_tab_file,c);
  if c=' ' then goto done;
@y
read(ps_tab_file,c);
if (c=' ') or (c='*') or (c='#') or c=(';') or (c='%') or
  eoln(ps_tab_file) then goto common_ending
else begin
  decr(j);
  append_char(xord[c]); {j expected to be at least 1...}
  end;
loop @+begin if eoln(ps_tab_file) then
    fatal_error("The psfont map file is bad!");
  read(ps_tab_file,c);
  if c=' ' then goto done;
@z

@x l.21933
procedure ps_name_out(@!s:str_number;@!lit:boolean);
begin ps_room(length(s)+2);
print_char(" ");
if is_ps_name(s) then
        begin if lit then print_char("/");
        print(s);
        end
      else begin ps_string_out(s);
        if not lit then ps_print("cvx ");
        ps_print("cvn");
        end;
end;
@y
@ Indeed, since the code generated by MetaPost may be inserted in some
foreign code, except if we always create a true and self-contained EPS,
we can not use a font number, but we use a string identifying the font
by a name. In PostScript, the name used must match the name object
associated in the PostScript code. The font name given as the first
word in a line specification in the mapping table, is the name used. But
a PostScript name object must follow the PostScript syntactic rules, and
there is a limit in the length ($127$), and a range of characters valid.

Since converting an arbitrary string will not do, we translate a not
normal font name {\sl the same way a driver---dvips(1) for
example---translates the same font identifier}, since the goal is to
refer accordingly to the same object. We hence always create a
valid name in a defined (according to ker\TeX\ rules) way.

@<Declare the \ps\ output procedures@>=
procedure ps_name_out(@!s:str_number;@!lit:boolean);
var @!i:pool_pointer; {current character code position}
@!k:ASCII_code; {the character being checked}
begin ps_room(129); {the maximum length of a name object + " " + "/"}
print_char(" ");
if lit then print_char("/");
if (length(s) > 127) then i:=str_stop(s) - 127
  else i:=str_start[s];
while i<str_stop(s) do
  begin k:=so(str_pool[i]);
  if (k<=" ") then print_char("_")
  else if (k>"~") then print_char("?")
  else if (k="(")or(k=")")or(k="<")or(k=">")or@|
      (k="{")or(k="}")or(k="/")or(k="%") then print_char("@@")
  else print_char(k);
  incr(i);
  end;
end;
@z

@x l.22529
@d dump_wd(#)==begin mem_file^:=#; put(mem_file);@+end
@d dump_int(#)==begin mem_file^.int:=#; put(mem_file);@+end
@d dump_hh(#)==begin mem_file^.hh:=#; put(mem_file);@+end
@d dump_qqqq(#)==begin mem_file^.qqqq:=#; put(mem_file);@+end
@y
@z

@x l.22543
@d undump_wd(#)==begin get(mem_file); #:=mem_file^;@+end
@d undump_int(#)==begin get(mem_file); #:=mem_file^.int;@+end
@d undump_hh(#)==begin get(mem_file); #:=mem_file^.hh;@+end
@d undump_qqqq(#)==begin get(mem_file); #:=mem_file^.qqqq;@+end
@y
@z

@x l.22573
x:=mem_file^.int;
@y
undump_int(x);
@z

@x l.22744
undump_int(x);@+if (x<>69073)or eof(mem_file) then goto off_base
@y
undump_int(x);@+if (x<>69073)or not eof(mem_file) then goto off_base
@z

@x l.22825
t_open_out; {open the terminal for output}
@y
t_open_out; {open the terminal for output}
set_paths(MP_PATHS_SET);
@z

@x l.22845
history:=spotless; {ready to go!}
@y
if troff_mode then @+internal[prologues]:=unity;
history:=spotless; {ready to go!}
@z

@x l.22851
end_of_MP: close_files_and_terminate;
final_end: ready_already:=0;
@y
close_files_and_terminate;
final_end: ready_already:=0;
if (history <> spotless) and (history <> warning_issued) then
    cexit(1)
else
    cexit(0);
@z

@x l.22883
    print(log_name); print_char(".");
    end;
  end;
@y
    print(log_name); print_char(".");
    end;
  end;
print_ln;
@z

@x l.23043
program below. (If |m=13|, there is an additional argument, |l|.)
@.debug \#@>

@d breakpoint=888 {place where a breakpoint is desirable}

@<Last-minute...@>=
@!debug procedure debug_help; {routine to display various things}
@y
program below. (If |m=13|, there is an additional argument, |l|.)
@.debug \#@>

Since the C version of |read| only works for |text_char| variables,
we need another routine to read integers from the terminal.

@d breakpoint=888 {place where a breakpoint is desirable}

@<Last-minute...@>=
@!debug function read_int:integer;
var @!c:text_char;
@!k:ASCII_code;
@!n:integer;
@!neg:boolean;
begin read(term_in,c);
n:=0; neg:=c=xchr['-'];
if neg then read(term_in,c);
k:=xord[c];
while (k>="0")and(k<="9") do
  begin n:=10*n+k-"0";
  read(term_in,c);
  k:=xord[c];
  end;
if neg then read_int:=-n else read_int:=n;
end;
@#
procedure debug_help; {routine to display various things}
@z

@x l.23056
  read(term_in,m);
  if m<0 then return
  else if m=0 then
    begin goto breakpoint;@/ {go to every declared label at least once}
    breakpoint: m:=0; @{'BREAKPOINT'@}@/
    end
  else  begin read(term_in,n);
@y
  m:=read_int;
  if m<0 then return
  else if m=0 then
    begin goto breakpoint;@\ {go to every label at least once}
    breakpoint: m:=0; @{'BREAKPOINT'@}@\
    end
  else  begin n:=read_int;
@z

@x l.23085
13: begin read(term_in,l); print_cmd_mod(n,l);
  end;
@y
13: begin l:=read_int; print_cmd_mod(n,l);
  end;
@z

@x l.23090
@* \[48] System-dependent changes.
This section should be replaced, if necessary, by any special
modification of the program
that are necessary to make \MP\ work at a particular installation.
It is usually best to design your change file so that all changes to
previous sections preserve the section numbering; then everybody's version
will be consistent with the published program. More extensive changes,
which introduce new sections, can be inserted here; then only the index
itself will get a new section number.
@^system dependencies@>
@y
@* \[48] System-dependent changes.
Here are the variables used to hold ``switch-to-editor'' information.
@^system dependencies@>

@<Global...@>=
@!edit_name_start: pool_pointer;
@!edit_name_length,@!edit_line,@!tfm_temp: integer;

@ The |edit_name_start| will be set to point into |str_pool| somewhere after
its beginning if \MP\ is supposed to switch to an editor on exit.

@<Set init...@>=
edit_name_start:=0;
@z


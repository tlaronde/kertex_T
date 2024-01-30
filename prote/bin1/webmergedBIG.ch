% This is webmergedBIG.ch, a WEB change file produced by webmerge.tex
% to be applied to /data/src/knuth/tex/tex.web
% combining the changes (one after the other) from
% 1. ../../tex/bin1/filename.ch
% 2. ../../tex/bin1/batchmode.ch
% 3. /data/src/etex/etex.ch
% 4. prote.ch
% 5. ../../tex/bin1/kertex_common.ch
% 6. kertex.ch
% 7. input.ch
% 8. ../../tex/bin1/BIG.ch

@x l.1
% This program is copyright (C) 1982 by D. E. Knuth; all rights are reserved.
% Unlimited copying and redistribution of this file are permitted as long
% as this file is not modified. Modifications are permitted, but only if
% the resulting file is not named tex.web. (The WEB system provides
% for alterations via an auxiliary file; the master file should stay intact.)
% See Appendix H of the WEB manual for hints on how to install this program.
% And see Appendix A of the TRIP manual for details about how to validate it.

% TeX is a trademark of the American Mathematical Society.
% METAFONT is a trademark of Addison-Wesley Publishing Company.
@y
% Prote is copyright (C) 2021 by Thierry Laronde and put under
% the MIT/X11 license.
%
% As TeX and e-TeX are reserved names for the unchanged (except for the
% necessary implementation of system dependencies) instances of, resp.,
% Donald E. Knuth's program and the NTS team's e-TeX implementation, the
% name Prote is reserved for this kerTeX implementation.
%
% Hence, this is neither TeX (even if it is compatible at start) nor
% e-TeX (even if is compatible when entering the first set of
% extensions).
@z

@x l.54
% Although considerable effort has been expended to make the TeX program
% correct and reliable, no warranty is implied; the author disclaims any
% obligation or liability for damages, including but not limited to
% special, indirect, or consequential damages arising out of or in
% connection with the use or performance of this software. This work has
% been a ``labor of love'' and the author hopes that users enjoy it.
@y
% This is the 1.1 version of Prote, developed during August 2021,
% and corrected during september/october 2021 and amended in august 2023
% for file primitives behavior matching input behavior.
%
% 1.0: adds primitives needed by LaTeX as listed in ltnews31.
%    - 2022-07-21: tiddying formal fix: a spurious line was a left over
%      of a removed paragraph (pointed by Martin Ruckert). Suppressed.
%
% 1.1: 2023-08-01: the new file primitives are used in LaTeX expecting
%    the input behavior that ".tex" be appended if no extension. So
%    modified to provide this.
%
%  History towards 1.0 release:
%    0.99.4:
%      - typos and style corrections provided by Martin Ruckert for
%      clean translation in Pascal (forward declarations and underscores
%      omitted);
%      - adjustements against e-TeX 2.6 instead of 2.1 (T. Laronde).
%    0.99.7:
%      - \expanded was using an e-TeX procedure not doing def handling
%        => using scan_toks() now. Reported by Martin Ruckert and
%        test code narrowed down by Phelype Oleinik.
%    0.99.8:
%      - \expanded again: scan_toks() sets def_ref. But back_list()
%        has to take not the refernce count, but the first token.
%        Passing def_ref, a next invocation of scan_toks() was inserting
%        a missing left brace and then reading pass the end of the token
%        list to find a matching right one. def_ref => link(def_ref).
%        Test code narrowed down by Phelype Oleinik (a great help!).
%      - The API for file related primitives has been changed: no error
%        is reported on failure to find/open and nothing is returned
%        (matches current other implementations).
%    0.99.9:
%      - Fix typos in Pascal replacement text; xchg_buffer_length=0 =>
%        xchg_buffer_length:=0 (caught by Martin Ruckert).
%    0.99.10:
%      - KerTeX Public License -> X11/MIT license.
%    1.0:
%      - Just naming the official release. No change.
%
% This work was done by Thierry Laronde and is under the MIT/X11
% license.
%
%
@z

@x l.66
\let\mc=\ninerm % medium caps for names like SAIL
@y
\let\mc=\ninerm % medium caps for names like SAIL
\def\Prote{{\tenrm P\kern-0.1em R\kern-0.15em\raise.11ex\hbox{o}%
  \kern-0.22em T\kern-0.05em E}}
\def\MP{{\tenlogo META}\-{\tenlogo POST}}
\def\eTeX{$\varepsilon$-\TeX}
\font\revrm=xbmc10 % for right-to-left text
% to generate xbmc10 (i.e., reflected cmbx10) use a file
% xbmc10.mf containing:
%+++++++++++++++++++++++++++++++++++++++++++++++++
%     if unknown cmbase: input cmbase fi
%     extra_endchar := extra_endchar &
%       "currentpicture:=currentpicture " &
%       "reflectedabout((.5[l,r],0),(.5[l,r],1));";
%     input cmbx10
%+++++++++++++++++++++++++++++++++++++++++++++++++
\ifx\beginL\undefined % this is TeX
  \def\XeT{X\kern-.125em\lower.5ex\hbox{E}\kern-.1667emT}
  \def\TeXeT{\TeX-\hbox{\revrm \XeT}}   % for TeX-XeT
  \def\TeXXeT{\TeX-\hbox{\revrm -\XeT}} % for TeX--XeT
\else
  \ifx\eTeXversion\undefined % this is \TeXeT
    \def\TeXeT{\TeX-{\revrm\beginR\TeX\endR}}   % for TeX-XeT
    \def\TeXXeT{\TeX-{\revrm\beginR\TeX-\endR}} % for TeX--XeT
  \else % this is \eTeX
    \def\TeXeT{\TeX-{\TeXXeTstate=1\revrm\beginR\TeX\endR}}   % for TeX-XeT
    \def\TeXXeT{\TeX-{\TeXXeTstate=1\revrm\beginR\TeX-\endR}} % for TeX--XeT
  \fi
\fi
@z

@x l.69
\def\pct!{{\char`\%}} % percent sign in ordinary text
@y
\def\pct!{{\char`\%}} % percent sign in ordinary text
\def\grp{\.{\char'173...\char'175}}
@z

@x l.85
\def\title{\TeX82}
@y
\def\title{\eTeX}
% system dependent redefinitions of \title should come later
% and should use:
%    \toks0=\expandafter{\title}
%    \edef\title{...\the\toks0...}
\let\maybe=\iffalse % print only changed modules
@z

@x l.88
  \def\?##1]{\hbox to 1in{\hfil##1.\ }}
  }
@y
  \def\?##1]{\hbox{Changes to \hbox to 1em{\hfil##1}.\ }}
  }
\let\maybe=\iffalse
@z

@x l.96
This is \TeX, a document compiler intended to produce typesetting of high
@y
This is \Prote, a program derived from and extending the capabilities
of \TeX plus \eTeX,
a document compiler intended to produce typesetting of high
@z

@x l.137
based on some specifications that the author had made in May of that year.
@y
based on some specifications that the author (in the following, unless
specified, ``the author'' refers to D.E.~Knuth) had made in May of that year.
@z

@x l.185
If this program is changed, the resulting system should not be called
@y
This program contains code for various features extending \TeX,
therefore this program is called `\Prote' and not
@z

@x l.191
November 1984].
@y
November 1984].

A similar test suite called the ``\.{SELLETTE} test'' is available for
helping to determine whether a particular implementation deserves to be
known as `\Prote'.
@z

@x l.193
@d banner=='This is TeX, Version 3.141592653' {printed when \TeX\ starts}
@y
@d eTeX_version=2 { \.{\\eTeXversion} }
@d eTeX_revision==".6" { \.{\\eTeXrevision} }
@d eTeX_version_string=='-2.6' {current \eTeX\ version}
@#
@d eTeX_banner=='This is e-TeX, Version 3.141592653',eTeX_version_string
  {printed when \eTeX\ starts}
@#
@d TeX_banner=='This is TeX, Version 3.141592653' {printed when \TeX\ starts}
@#
@#
@d TEX==ETEX {change program name into |ETEX|}
@#
@d TeXXeT_code=0 {the \TeXXeT\ feature is optional}
@#
@d eTeX_states=1 {number of \eTeX\ state variables in |eqtb|}
@#
@d Prote_version_string=='kerTeX C 3.141592653-2.6-1.1.0' {current \Prote\ version}
@d Prote_version=1 { \.{\\Proteversion} }
@d Prote_revision==".1.0" { \.{\\Proterevision} }
@#
@d Prote_banner=='This is Prote, Version ',Prote_version_string
  {printed when \Prote\ starts}
@#
@d banner==Prote_banner
@z

@x l.212
scalar types; there are no `\&{var}' parameters, except in the case of files;
@y
scalar types; there are no `\&{var}' parameters, except in the case of files
--- \eTeX, however, does use `\&{var}' parameters for the |reverse| function;
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
@!mem_max=4194302; {greatest index in \TeX's internal |mem| array;
  must be strictly less than |max_halfword|;
  must be equal to |mem_top| in \.{INITEX}, otherwise |>=mem_top|}
@!mem_min=0; {smallest index in \TeX's internal |mem| array;
  must be |min_halfword| or more;
  must be equal to |mem_bot| in \.{INITEX}, otherwise |<=mem_bot|}
@!buf_size=30000; {maximum number of characters simultaneously present in
  current lines of open files and in control sequences between
  \.{\\csname} and \.{\\endcsname}; must not exceed |max_halfword|}
@!error_line=79; {width of context lines on terminal error messages}
@!half_error_line=50; {width of first lines of contexts in terminal
  error messages; should be between 30 and |error_line-15|}
@!max_print_line=79; {width of longest text lines output; should be at least 60}
@!stack_size=3000; {maximum number of simultaneous input sources}
@!max_in_open=15; {maximum number of input files and error insertions that
  can be going on simultaneously}
@!font_max=255; {maximum internal font number; must not exceed |max_quarterword|
  and must be at most |font_base+256|}
@!font_mem_size=1000000; {number of words of |font_info| for all fonts}
@!param_size=120; {maximum number of simultaneous macro parameters}
@!nest_size=80; {maximum number of semantic levels simultaneously active}
@!max_strings=100000; {maximum number of strings; must not exceed |max_halfword|}
@!string_vacancies=74000; {the minimum number of characters that should be
  available for the user's control sequences and font names,
  after \TeX's own error messages are stored}
@!pool_size=1000000; {maximum number of characters in strings, including all
  error messages and help texts, and the names of all fonts and
  control sequences; must exceed |string_vacancies| by the total
  length of \TeX's own strings, which is currently about 23000}
@!save_size=8000; {space for saving values outside of current group; must be
  at most |max_halfword|}
@!trie_size=65536; {space for hyphenation patterns; should be larger for
  \.{INITEX} than it is in production versions of \TeX}
@!trie_op_size=5000; {space for ``opcodes'' in the hyphenation patterns}
@!neg_trie_op_size=-5000; {for lower trie_op_hash array bound}
@!dvi_buf_size=16384; {size of the output buffer; must be a multiple of 8}
@z

@x l.426
@!pool_name='TeXformats:TEX.POOL                     ';
  {string of length |file_name_size|; tells where the string pool appears}
@.TeXformats@>
@y
@!xchg_buffer_size=64; {must be at least 64}
  {size of |eight_bits| buffer for exchange with system routines}
@!pool_name='prote.pool';
@!pool_name_length=10;
  {required: |name_of_file| and |name_length| have to be both defined}
@!mem_top=4194302; {largest index in the |mem| array dumped by \.{INITEX};
  must be substantially larger than |mem_bot|
  and not greater than |mem_max|}
@.TeXformats@>
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
@d mem_bot=0 {smallest index in the |mem| array dumped by \.{INITEX};
  must not be less than |mem_min|}
@d font_base=0 {smallest internal font number; must not be less
  than |min_quarterword|}
@d hash_size=40000 {maximum number of control sequences; it should be at most
  about |(mem_max-mem_min)/10|}
@d hash_prime=33997 {Run the primes
  program in LiterateProgramming to find out.  It is reasonably close to
  85\pct! of a |hash_size|}
@d hyph_size=5003 {another prime; the number of \.{\\hyphenation} exceptions}
@z

@x l.507
@d not_found=45 {go here when you've found nothing}
@y
@d not_found=45 {go here when you've found nothing}
@d not_found1=46 {like |not_found|, when there's more than one}
@d not_found2=47 {like |not_found|, when there's more than two}
@d not_found3=48 {like |not_found|, when there's more than three}
@d not_found4=49 {like |not_found|, when there's more than four}
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

@x l.1246
not_found: str_eq_str:=result;
end;
@y
not_found: str_eq_str:=result;
end;
@t\4@>@<Declare \Prote\ procedures for strings@>
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

@x l.1958
print("OK, entering ");
case c of
"Q":begin print_esc("batchmode"); decr(selector);
  end;
"R":print_esc("nonstopmode");
"S":print_esc("scrollmode");
end; {there are no other cases}
print("..."); print_ln; update_terminal; return;
@y
print("OK, entering ");
case c of
"Q":print_esc("batchmode");
"R":print_esc("nonstopmode");
"S":print_esc("scrollmode");
end; {there are no other cases}
print("..."); print_ln;
if c="Q" then decr(selector);
update_terminal; return;
@z

@x l.2337
@p function badness(@!t,@!s:scaled):halfword; {compute badness, given |t>=0|}
@y
@p @<Declare \Prote\ arithmetic routines@>@/
function badness(@!t,@!s:scaled):halfword; {compute badness, given |t>=0|}
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
@d max_quarterword=2047 {largest allowable value in a |quarterword|}
@d min_halfword==0 {smallest allowable value in a |halfword|}
@d max_halfword==4194303 {largest allowable value in a |halfword|}
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

@x l.2901
|fil|, |fill|, or |filll|). The |subtype| field is not used.
@y
|fil|, |fill|, or |filll|). The |subtype| field is not used in \TeX.
In \eTeX\ the |subtype| field records the box direction mode |box_lr|.
@z

@x l.2986
This field occupies a full word instead of a halfword, because
there's nothing to put in the other halfword; it is easier in \PASCAL\ to
use the full word than to risk leaving garbage in the unused half.
@y
In addition there is a |mark_class| field that contains the mark class.
@z

@x l.2992
@d mark_ptr(#)==mem[#+1].int {head of the token list for a mark}
@y
@d mark_ptr(#)==link(#+1) {head of the token list for a mark}
@d mark_class(#)==info(#+1) {the mark class}
@z

@x l.3001
@d adjust_ptr==mark_ptr {vertical list to be moved out of horizontal list}
@y
@d adjust_ptr(#)==mem[#+1].int
  {vertical list to be moved out of horizontal list}
@z

@x l.3090
the amount of surrounding space inserted by \.{\\mathsurround}.
@y
the amount of surrounding space inserted by \.{\\mathsurround}.

In addition a |math_node| with |subtype>after| and |width=0| will be
(ab)used to record a regular |math_node| reinserted after being
discarded at a line break or one of the text direction primitives (
\.{\\beginL}, \.{\\endL}, \.{\\beginR}, and \.{\\endR} ).
@z

@x l.3094
@d after=1 {|subtype| for math node that winds up a formula}
@y
@d after=1 {|subtype| for math node that winds up a formula}
@#
@d M_code=2
@d begin_M_code=M_code+before {|subtype| for \.{\\beginM} node}
@d end_M_code=M_code+after {|subtype| for \.{\\endM} node}
@d L_code=4
@d begin_L_code=L_code+begin_M_code {|subtype| for \.{\\beginL} node}
@d end_L_code=L_code+end_M_code {|subtype| for \.{\\endL} node}
@d R_code=L_code+L_code
@d begin_R_code=R_code+begin_M_code {|subtype| for \.{\\beginR} node}
@d end_R_code=R_code+end_M_code {|subtype| for \.{\\endR} node}
@#
@d end_LR(#)==odd(subtype(#))
@d end_LR_type(#)==(L_code*(subtype(#) div L_code)+end_M_code)
@d begin_LR_type(#)==(#-after+before)
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

@x l.3567
math_node: print_char("$");
@y
math_node: if subtype(p)>=L_code then print("[]")
  else print_char("$");
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

@x l.3734
    begin print(", shifted "); print_scaled(shift_amount(p));
    end;
@y
    begin print(", shifted "); print_scaled(shift_amount(p));
    end;
  if eTeX_ex then @<Display if this box is never to be reversed@>;
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

@x l.3832
begin print_esc("math");
@y
if subtype(p)>after then
  begin if end_LR(p) then print_esc("end")
  else print_esc("begin");
  if subtype(p)>R_code then print_char("R")
  else if subtype(p)>L_code then print_char("L")
  else print_char("M");
  end else
begin print_esc("math");
@z

@x l.3865
begin print_esc("mark"); print_mark(mark_ptr(p));
@y
begin print_esc("mark");
if mark_class(p)<>0 then
  begin print_char("s"); print_int(mark_class(p));
  end;
print_mark(mark_ptr(p));
@z

@x l.4102
@d un_vbox=24 {unglue a box ( \.{\\unvbox}, \.{\\unvcopy} )}
@y
@d un_vbox=24 {unglue a box ( \.{\\unvbox}, \.{\\unvcopy} )}
  {( or \.{\\pagediscards}, \.{\\splitdiscards} )}
@z

@x l.4112
@d valign=33 {vertical table alignment ( \.{\\valign} )}
@y
@d valign=33 {vertical table alignment ( \.{\\valign} )}
  {or text direction directives ( \.{\\beginL}, etc.~)}
@z

@x l.4128
@d left_right=49 {variable delimiter ( \.{\\left}, \.{\\right} )}
@y
@d left_right=49 {variable delimiter ( \.{\\left}, \.{\\right} )}
  {( or \.{\\middle} )}
@z

@x l.4172
  \.{\\insertpenalties} )}
@y
  \.{\\insertpenalties} )}
  {( or \.{\\interactionmode} )}
@z

@x l.4174
@d set_shape=84 {specify fancy paragraph shape ( \.{\\parshape} )}
@y
@d set_shape=84 {specify fancy paragraph shape ( \.{\\parshape} )}
  {(or \.{\\interlinepenalties}, etc.~)}
@z

@x l.4184
@d prefix=93 {qualify a definition ( \.{\\global}, \.{\\long}, \.{\\outer} )}
@y
@d prefix=93 {qualify a definition ( \.{\\global}, \.{\\long}, \.{\\outer} )}
  {( or \.{\\protected} )}
@z

@x l.4187
@d read_to_cs=96 {read into a control sequence ( \.{\\read} )}
@y
@d read_to_cs=96 {read into a control sequence ( \.{\\read} )}
  {( or \.{\\readline} )}
@z

@x l.4202
@d input=max_command+4 {input a source file ( \.{\\input}, \.{\\endinput} )}
@y
@d input=max_command+4 {input a source file ( \.{\\input}, \.{\\endinput} )}
  {( or \.{\\scantokens} )}
@z

@x l.4207
@d the=max_command+9 {expand an internal quantity ( \.{\\the} )}
@y
@d the=max_command+9 {expand an internal quantity ( \.{\\the} )}
  {( or \.{\\unexpanded}, \.{\\detokenize} )}
@z

@x l.4310
user's output routine.
@y
user's output routine.

A seventh quantity, |eTeX_aux|, is used by the extended features \eTeX.
In vertical modes it is known as |LR_save| and holds the LR stack when a
paragraph is interrupted by a displayed formula.  In display math mode
it is known as |LR_box| and holds a pointer to a prototype box for the
display.  In math mode it is known as |delim_ptr| and points to the most
recent |left_noad| or |middle_noad| of a |math_left_group|.
@z

@x l.4325
  @!head_field,@!tail_field: pointer;
@y
  @!head_field,@!tail_field: pointer;
  @!eTeX_aux_field: pointer;
@z

@x l.4332
@d tail==cur_list.tail_field {final node on current list}
@y
@d tail==cur_list.tail_field {final node on current list}
@d eTeX_aux==cur_list.eTeX_aux_field {auxiliary data for \eTeX}
@d LR_save==eTeX_aux {LR stack when a paragraph is interrupted}
@d LR_box==eTeX_aux {prototype box for display}
@d delim_ptr==eTeX_aux {most recent left or right noad of a math left group}
@z

@x l.4363
mode:=vmode; head:=contrib_head; tail:=contrib_head;
@y
mode:=vmode; head:=contrib_head; tail:=contrib_head;
eTeX_aux:=null;
@z

@x l.4379
incr(nest_ptr); head:=get_avail; tail:=head; prev_graf:=0; mode_line:=line;
@y
incr(nest_ptr); head:=get_avail; tail:=head; prev_graf:=0; mode_line:=line;
eTeX_aux:=null;
@z

@x l.4543
@d frozen_null_font=frozen_control_sequence+10
  {permanent `\.{\\nullfont}'}
@y
@d frozen_primitive=frozen_control_sequence+10
  {permanent `\.{\\primitive:}'}
@d frozen_null_font=frozen_control_sequence+11
  {permanent `\.{\\nullfont}'}
@z

@x l.4742
@d toks_base=local_base+10 {table of 256 token list registers}
@y
@d tex_toks=local_base+10 {end of \TeX's token list parameters}
@#
@d etex_toks_base=tex_toks {base for \eTeX's token list parameters}
@d every_eof_loc=etex_toks_base {points to token list for \.{\\everyeof}}
@d etex_toks=etex_toks_base+1 {end of \eTeX's token list parameters}
@#
@d toks_base=etex_toks {table of 256 token list registers}
@z

@x l.4743
@d box_base=toks_base+256 {table of 256 box registers}
@y
@#
@d etex_pen_base=toks_base+256 {start of table of \eTeX's penalties}
@d inter_line_penalties_loc=etex_pen_base {additional penalties between lines}
@d club_penalties_loc=etex_pen_base+1 {penalties for creating club lines}
@d widow_penalties_loc=etex_pen_base+2 {penalties for creating widow lines}
@d display_widow_penalties_loc=etex_pen_base+3 {ditto, just before a display}
@d etex_pens=etex_pen_base+4 {end of table of \eTeX's penalties}
@#
@d box_base=etex_pens {table of 256 box registers}
@z

@x l.4808
  othercases print_esc("errhelp")
@y
  @/@<Cases of |assign_toks| for |print_cmd_chr|@>@/
  othercases print_esc("errhelp")
@z

@x l.4826
eq_level(par_shape_loc):=level_one;@/
@y
eq_level(par_shape_loc):=level_one;@/
for k:=etex_pen_base to etex_pens-1 do
  eqtb[k]:=eqtb[par_shape_loc];
@z

@x l.4854
if n=par_shape_loc then
  begin print_esc("parshape"); print_char("=");
  if par_shape_ptr=null then print_char("0")
@y
if (n=par_shape_loc) or ((n>=etex_pen_base) and (n<etex_pens)) then
  begin print_cmd_chr(set_shape,n); print_char("=");
  if equiv(n)=null then print_char("0")
  else if n>par_shape_loc then
    begin print_int(penalty(equiv(n))); print_char(" ");
    print_int(penalty(equiv(n)+1));
    if penalty(equiv(n))>1 then print_esc("ETC.");
    end
@z

@x l.4975
@d int_pars=55 {total number of integer parameters}
@y
@d tex_int_pars=55 {total number of \TeX's integer parameters}
@#
@d etex_int_base=tex_int_pars {base for \eTeX's integer parameters}
@d tracing_assigns_code=etex_int_base {show assignments}
@d tracing_groups_code=etex_int_base+1 {show save/restore groups}
@d tracing_ifs_code=etex_int_base+2 {show conditionals}
@d tracing_scan_tokens_code=etex_int_base+3 {show pseudo file open and close}
@d tracing_nesting_code=etex_int_base+4 {show incomplete groups and ifs within files}
@d pre_display_direction_code=etex_int_base+5 {text direction preceding a display}
@d last_line_fit_code=etex_int_base+6 {adjustment for last line of paragraph}
@d saving_vdiscards_code=etex_int_base+7 {save items discarded from vlists}
@d saving_hyph_codes_code=etex_int_base+8 {save hyphenation codes for languages}
@d expand_depth_code=etex_int_base+9 {maximum depth for expansion---\eTeX}
@d eTeX_state_code=etex_int_base+10 {\eTeX\ state variables}
@d etex_int_pars=eTeX_state_code+eTeX_states {total number of \eTeX's integer parameters}
@#
@d int_pars=etex_int_pars {total number of integer parameters}
@z

@x l.5037
@d error_context_lines==int_par(error_context_lines_code)
@y
@d error_context_lines==int_par(error_context_lines_code)
@#
@d tracing_assigns==int_par(tracing_assigns_code)
@d tracing_groups==int_par(tracing_groups_code)
@d tracing_ifs==int_par(tracing_ifs_code)
@d tracing_scan_tokens==int_par(tracing_scan_tokens_code)
@d tracing_nesting==int_par(tracing_nesting_code)
@d pre_display_direction==int_par(pre_display_direction_code)
@d last_line_fit==int_par(last_line_fit_code)
@d saving_vdiscards==int_par(saving_vdiscards_code)
@d saving_hyph_codes==int_par(saving_hyph_codes_code)
@d expand_depth==int_par(expand_depth_code)
@z

@x l.5102
othercases print("[unknown integer parameter!]")
@y
@/@<Cases for |print_param|@>@/
othercases print("[unknown integer parameter!]")
@z

@x l.5241
input and output, establishes the initial values of the date and time.
@y
input and output, establishes the initial values of the date and time.
This does include too, for system integrators, the creation date and
the reference moment for the timer---\Prote\ extensions. If the system
supports environment variables, if |FORCE_SOURCE_DATE| is set to $1$ and
|SOURCE_DATE_EPOCH| is set, the date related values: year, month, day
and time, including creation date, will be taken relative from the value
defined by |SOURCE_DATE_EPOCH|.
@^creation date@>
@^reference time@>
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

@x l.5322
@d emergency_stretch_code=20 {reduces badnesses on final pass of line-breaking}
@d dimen_pars=21 {total number of dimension parameters}
@y
@d emergency_stretch_code=20 {reduces badnesses on final pass of line-breaking}
@d page_width_code=21 {current paper page width}
@d page_height_code=22 {current paper page height}
@d dimen_pars=23 {total number of dimension parameters}
@z

@x l.5350
@d emergency_stretch==dimen_par(emergency_stretch_code)
@y
@d emergency_stretch==dimen_par(emergency_stretch_code)
@d page_width==dimen_par(page_width_code)
@d page_height==dimen_par(page_height_code)
@z

@x l.5374
emergency_stretch_code:print_esc("emergencystretch");
@y
emergency_stretch_code:print_esc("emergencystretch");
page_width_code:print_esc("pagewidth");
page_height_code:print_esc("pageheight");
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

@x l.5613
else  begin print_esc(text(p));
  print_char(" ");
  end;
@y
else  begin if p=frozen_primitive then print_esc("primitive");
  print_esc(text(p)); print_char(" ");
  end;
@z

@x l.5639
@!j:small_number; {index into |buffer|}
@y
@!j:0..buf_size; {index into |buffer|}
@z

@x l.5640
@!l:small_number; {length of the string}
@y
@!l:small_number; {length of the string}
@!p:pointer; {pointer in |ROM|}
@z

@x l.5643
    {we will move |s| into the (empty) |buffer|}
  for j:=0 to l-1 do buffer[j]:=so(str_pool[k+j]);
  cur_val:=id_lookup(0,l); {|no_new_control_sequence| is |false|}
@y
    {we will move |s| into the (possibly non-empty) |buffer|}
  if first+l>buf_size+1 then
      overflow("buffer size",buf_size);
@:TeX capacity exceeded buffer size}{\quad buffer size@>
  for j:=0 to l-1 do buffer[first+j]:=so(str_pool[k+j]);
  cur_val:=id_lookup(first,l); {|no_new_control_sequence| is |false|}
@z

@x l.5648
eq_level(cur_val):=level_one; eq_type(cur_val):=c; equiv(cur_val):=o;
end;
@y
eq_level(cur_val):=level_one; eq_type(cur_val):=c; equiv(cur_val):=o;
@<Add primitive definition to the |ROM| array@>@;
end;
@z

@x l.5718
primitive("parshape",set_shape,0);@/
@y
primitive("parshape",set_shape,par_shape_loc);@/
@z

@x l.5735
primitive("toks",toks_register,0);@/
@y
primitive("toks",toks_register,mem_bot);@/
@z

@x l.5768
expand_after: print_esc("expandafter");
@y
expand_after: case chr_code of
0: print_esc("expandafter");
@/@<Cases of |expandafter| for |print_cmd_chr|@>@/
end; {there are no other cases}
@z

@x l.5774
mark: print_esc("mark");
@y
mark: begin print_esc("mark");
  if chr_code>0 then print_char("s");
  end;
@z

@x l.5785
read_to_cs: print_esc("read");
@y
read_to_cs: if chr_code=0 then print_esc("read")
  @<Cases of |read| for |print_cmd_chr|@>;
@z

@x l.5789
set_shape: print_esc("parshape");
@y
set_shape: case chr_code of
  par_shape_loc: print_esc("parshape");
  @<Cases of |set_shape| for |print_cmd_chr|@>@;@/
  end; {there are no other cases}
@z

@x l.5790
the: print_esc("the");
@y
the: if chr_code=0 then print_esc("the")
  @<Cases of |the| for |print_cmd_chr|@>;
@z

@x l.5791
toks_register: print_esc("toks");
@y
toks_register: @<Cases of |toks_register| for |print_cmd_chr|@>;
@z

@x l.5793
valign: print_esc("valign");
@y
valign: if chr_code=0 then print_esc("valign")@/
  @<Cases of |valign| for |print_cmd_chr|@>;
@z

@x l.5827
interpreted in one of four ways:
@y
interpreted in one of five ways:
@z

@x l.5847
the entries for that group.
@y
the entries for that group.
Furthermore, in extended \eTeX\ mode, |save_stack[p-1]| contains the
source line number at which the current level of grouping was entered.

\yskip\hang 5) If |save_type(p)=restore_sa|, then |sa_chain| points to a
chain of sparse array entries to be restored at the end of the current
group. Furthermore |save_index(p)| and |save_level(p)| should replace
the values of |sa_chain| and |sa_level| respectively.
@z

@x l.5857
@d level_boundary=3 {|save_type| corresponding to beginning of group}
@y
@d level_boundary=3 {|save_type| corresponding to beginning of group}
@d restore_sa=4 {|save_type| when sparse array entries should be restored}

@p@t\4@>@<Declare \eTeX\ procedures for tracing and input@>
@z

@x l.5915
@ The following macro is used to test if there is room for up to six more
@y
@ The following macro is used to test if there is room for up to seven more
@z

@x l.5921
  if max_save_stack>save_size-6 then overflow("save size",save_size);
@y
  if max_save_stack>save_size-7 then overflow("save size",save_size);
@z

@x l.5943
begin check_full_save_stack;
@y
begin check_full_save_stack;
if eTeX_ex then
  begin saved(0):=line; incr(save_ptr);
  end;
@z

@x l.5950
cur_boundary:=save_ptr; incr(cur_level); incr(save_ptr); cur_group:=c;
@y
cur_boundary:=save_ptr; cur_group:=c;
@!stat if tracing_groups>0 then group_trace(false);@+tats@;@/
incr(cur_level); incr(save_ptr);
@z

@x l.5968
othercases do_nothing
@y
@/@<Cases for |eq_destroy|@>@/
othercases do_nothing
@z

@x l.5990
the call, since |eq_save| makes the necessary test.
@y
the call, since |eq_save| makes the necessary test.

@d assign_trace(#)==@!stat if tracing_assigns>0 then restore_trace(#);
  tats
@z

@x l.5994
begin if eq_level(p)=cur_level then eq_destroy(eqtb[p])
@y
label exit;
begin if eTeX_ex and(eq_type(p)=t)and(equiv(p)=e) then
  begin assign_trace(p,"reassigning")@;@/
  eq_destroy(eqtb[p]); return;
  end;
assign_trace(p,"changing")@;@/
if eq_level(p)=cur_level then eq_destroy(eqtb[p])
@z

@x l.5997
end;
@y
assign_trace(p,"into")@;@/
exit:end;
@z

@x l.6004
begin if xeq_level[p]<>cur_level then
@y
label exit;
begin if eTeX_ex and(eqtb[p].int=w) then
  begin assign_trace(p,"reassigning")@;@/
  return;
  end;
assign_trace(p,"changing")@;@/
if xeq_level[p]<>cur_level then
@z

@x l.6008
end;
@y
assign_trace(p,"into")@;@/
exit:end;
@z

@x l.6017
begin eq_destroy(eqtb[p]);
eq_level(p):=level_one; eq_type(p):=t; equiv(p):=e;
@y
begin assign_trace(p,"globally changing")@;@/
begin eq_destroy(eqtb[p]);
eq_level(p):=level_one; eq_type(p):=t; equiv(p):=e;
end;
assign_trace(p,"into")@;@/
@z

@x l.6022
begin eqtb[p].int:=w; xeq_level[p]:=level_one;
@y
begin assign_trace(p,"globally changing")@;@/
begin eqtb[p].int:=w; xeq_level[p]:=level_one;
end;
assign_trace(p,"into")@;@/
@z

@x l.6039
@p@t\4@>@<Declare the procedure called |restore_trace|@>@;@/
@y
@p
@z

@x l.6046
begin if cur_level>level_one then
@y
@!a:boolean; {have we already processed an \.{\\aftergroup} ?}
begin a:=false;
if cur_level>level_one then
@z

@x l.6060
  else  begin if save_type(save_ptr)=restore_old_value then
@y
  else if save_type(save_ptr)=restore_sa then
    begin sa_restore; sa_chain:=p; sa_level:=save_level(save_ptr);
    end
  else  begin if save_type(save_ptr)=restore_old_value then
@z

@x l.6068
done: cur_group:=save_level(save_ptr); cur_boundary:=save_index(save_ptr)
@y
done: @!stat if tracing_groups>0 then group_trace(true);@+tats@;@/
if grp_stack[in_open]=cur_boundary then group_warning;
  {groups possibly not properly nested with files}
cur_group:=save_level(save_ptr); cur_boundary:=save_index(save_ptr);
if eTeX_ex then decr(save_ptr)
@z

@x l.6094
@ @<Declare the procedure called |restore_trace|@>=
@y
@ @<Declare \eTeX\ procedures for tr...@>=
@z

@x l.6182
@d end_match_token=@'7000 {$2^8\cdot|end_match|$}
@y
@d end_match_token=@'7000 {$2^8\cdot|end_match|$}
@d protected_token=@'7001 {$2^8\cdot|end_match|+1$}
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

@x l.6307
end_match: print("->");
@y
end_match: if c=0 then print("->");
@z

@x l.6328
else if cur_cmd=top_bot_mark then
@y
else if (cur_cmd=top_bot_mark)and(cur_chr<marks_code) then
@z

@x l.6402
procedure print_cmd_chr(@!cmd:quarterword;@!chr_code:halfword);
@y
procedure print_cmd_chr(@!cmd:quarterword;@!chr_code:halfword);
var n:integer; {temp variable}
@z

@x l.6421
@p procedure show_cur_cmd_chr;
@y
@p procedure show_cur_cmd_chr;
var n:integer; {level of \.{\\if...\\fi} nesting}
@!l:integer; {line where \.{\\if} started}
@!p:pointer;
@z

@x l.6426
print_cmd_chr(cur_cmd,cur_chr); print_char("}");
@y
print_cmd_chr(cur_cmd,cur_chr);
if tracing_ifs>0 then
  if cur_cmd>=if_test then if cur_cmd<=fi_or_else then
    begin print(": ");
    if cur_cmd=fi_or_else then
      begin print_cmd_chr(if_test,cur_if); print_char(" ");
      n:=0; l:=if_line;
      end
    else  begin n:=1; l:=line;
      end;
    p:=cond_ptr;
    while p<>null do
      begin incr(n); p:=link(p);
      end;
    print("(level "); print_int(n); print_char(")"); print_if_line(l);
    end;
print_char("}");
@z

@x l.6502
the terminal, under control of the procedure |read_toks|.)
@y
the terminal, under control of the procedure |read_toks|.)
Finally |18<=name<=19| indicates that we are reading a pseudo file
created by the \.{\\scantokens} command.
@z

@x l.6699
only if |token_type>=macro|.
@^reference counts@>
@y
only if |token_type>=macro|.
@^reference counts@>

Since \eTeX's additional token list parameters precede |toks_base|, the
corresponding token types must precede |write_text|.
@z

@x l.6720
@d write_text=15 {|token_type| code for \.{\\write}}
@y
@#
@d eTeX_text_offset=output_routine_loc-output_text
@d every_eof_text=every_eof_loc-eTeX_text_offset
  {|token_type| code for \.{\\everyeof}}
@#
@d write_text=toks_base-eTeX_text_offset {|token_type| code for \.{\\write}}
@z

@x l.6742
|align_state=0|.

@<Glob...@>=
@!align_state:integer; {group level with respect to current alignment}
@y
|align_state=0|.

The same principle applies when entering the definition of a
control sequence between \.{\\csname} and \.{\\endcsname}.

@<Glob...@>=
@!align_state:integer; {group level with respect to current alignment}
@!incsname_state:integer; {group level with respect to in csname state}
@z

@x l.6776
    if (name>17) or (base_ptr=0) then bottom_line:=true;
@y
    if (name>19) or (base_ptr=0) then bottom_line:=true;
@z

@x l.6821
else  begin print_nl("l."); print_int(line);
@y
else  begin print_nl("l.");
  if index=in_open then print_int(line)
  else print_int(line_stack[index+1]); {input from a pseudo file}
@z

@x l.6843
write_text: print_nl("<write> ");
@y
every_eof_text: print_nl("<everyeof> ");
write_text: print_nl("<write> ");
@z

@x l.7036
begin t:=cur_tok; cur_tok:=p; back_input; cur_tok:=t;
@y
begin t:=cur_tok; cur_tok:=p;
if a then
  begin p:=get_avail; info(p):=cur_tok; link(p):=loc; loc:=p; start:=p;
  if cur_tok<right_brace_limit then
    if cur_tok<left_brace_limit then decr(align_state)
    else incr(align_state);
  end
else  begin back_input; a:=eTeX_ex;
  end;
cur_tok:=t;
@z

@x l.7064
incr(in_open); push_input; index:=in_open;
@y
incr(in_open); push_input; index:=in_open;
eof_seen[index]:=false;
grp_stack[index]:=cur_boundary; if_stack[index]:=cond_ptr;
@z

@x l.7074
if name>17 then a_close(cur_file); {forget it}
@y
if (name=18)or(name=19) then pseudo_close else
if name>17 then a_close(cur_file); {forget it}
@z

@x l.7093
in_open:=0; open_parens:=0; max_buf_stack:=0;
@y
in_open:=0; open_parens:=0; max_buf_stack:=0;
grp_stack[0]:=0; if_stack[0]:=null;
@z

@x l.7095
first:=buf_size; repeat buffer[first]:=0; decr(first); until first=0;
@y
bufindx:=buf_size; repeat buffer[bufindx]:=0; decr(bufindx); until bufindx=0;
@z

@x l.7128
is needed because a blank line of input is supposed to be exactly equivalent
to the appearance of \.{\\par}; we must set |cur_cs:=par_loc|
when detecting a blank line.

@<Glob...@>=
@!par_loc:pointer; {location of `\.{\\par}' in |eqtb|}
@!par_token:halfword; {token representing `\.{\\par}'}
@y
is needed because a blank line of input is supposed to be exactly equivalent
to the appearance of \.{\\par}; we must set |cur_cs:=par_loc|
when detecting a blank line.

The same is true for the input, for the warning message, since input
is expected by default before every scanning and hence setting of
\.{cur_cs}.

@<Glob...@>=
@!par_loc:pointer; {location of `\.{\\par}' in |eqtb|}
@!par_token:halfword; {token representing `\.{\\par}'}
@!input_loc:pointer; {location of `\.{\\input}' in |eqtb|}
@!input_token:halfword; {token representing `\.{\\input}'}
@z

@x l.7566
if not force_eof then
@y
if not force_eof then
  if name<=19 then
    begin if pseudo_input then {not end of file}
      firm_up_the_line {this sets |limit|}
    else if (every_eof<>null)and not eof_seen[index] then
      begin limit:=first-1; eof_seen[index]:=true; {fake one empty line}
      begin_token_list(every_eof,every_eof_text); goto restart;
      end
    else force_eof:=true;
    end
  else
@z

@x l.7569
  else force_eof:=true;
@y
  else if (every_eof<>null)and not eof_seen[index] then
    begin limit:=first-1; eof_seen[index]:=true; {fake one empty line}
    begin_token_list(every_eof,every_eof_text); goto restart;
    end
  else force_eof:=true;
@z

@x l.7572
  begin print_char(")"); decr(open_parens);
  update_terminal; {show user that file has been read}
@y
  begin if tracing_nesting>0 then
    if (grp_stack[in_open]<>cur_boundary)or@|
        (if_stack[in_open]<>cond_ptr) then file_warning;
    {give warning for some unfinished groups and/or conditionals}
  if name>=19 then
  begin print_char(")"); decr(open_parens);
  update_terminal; {show user that file has been read}
  end;
@z

@x l.7656
@t\4@>@<Declare the procedure called |insert_relax|@>@;@/
@y
@t\4@>@<Declare the procedure called |insert_relax|@>@;@/
@t\4@>@<Declare \eTeX\ procedures for expanding@>@;@/
@t\4@>@<Declare \Prote\ procedures for expanding@>@;@/
@z

@x l.7663
procedure expand;
@y
procedure expand;
label reswitch;
@z

@x l.7674
if cur_cmd<call then @<Expand a nonmacro@>
@y
reswitch:
if cur_cmd<call then @<Expand a nonmacro@>
@z

@x l.7685
expand_after:@<Expand the token after the next token@>;
@y
expand_after: case cur_chr of
0: @<Expand the token after the next token@>;
1: @<Negate a boolean conditional and |goto reswitch|@>;
@/@<Cases for |expandafter|@>@/
end; {there are no other cases}
@z

@x l.7746
begin r:=get_avail; p:=r; {head of the list of characters}
@y
begin r:=get_avail; p:=r; {head of the list of characters}
incr(incsname_state);
@z

@x l.7750
if cur_cmd<>end_cs_name then @<Complain about missing \.{\\endcsname}@>;
@y
if cur_cmd<>end_cs_name then @<Complain about missing \.{\\endcsname}@>;
decr(incsname_state);
@z

@x l.7799
primitive("input",input,0);@/
@!@:input_}{\.{\\input} primitive@>
@y
primitive("input",input,0);@/
@!@:input_}{\.{\\input} primitive@>
input_loc:=cur_val; input_token:=cs_token_flag+input_loc;
@z

@x l.7805
input: if chr_code=0 then print_esc("input")@+else print_esc("endinput");
@y
input: if chr_code=0 then print_esc("input")
  @/@<Cases of |input| for |print_cmd_chr|@>@/
  else print_esc("endinput");
@z

@x l.7808
if cur_chr>0 then force_eof:=true
@y
if cur_chr=1 then force_eof:=true
@/@<Cases for |input|@>@/
@z

@x l.7864
@d top_mark_code=0 {the mark in effect at the previous page break}
@y
@d marks_code==5 {add this for \.{\\topmarks} etc.}
@#
@d top_mark_code=0 {the mark in effect at the previous page break}
@z

@x l.7896
top_bot_mark: case chr_code of
@y
top_bot_mark: begin case (chr_code mod marks_code) of
@z

@x l.7902
  endcases;
@y
  endcases;
  if chr_code>=marks_code then print_char("s");
  end;
@z

@x l.7908
begin if cur_mark[cur_chr]<>null then
  begin_token_list(cur_mark[cur_chr],mark_text);
@y
begin t:=cur_chr mod marks_code;
if cur_chr>=marks_code then scan_register_num@+else cur_val:=0;
if cur_val=0 then cur_ptr:=cur_mark[t]
else @<Compute the mark pointer for mark type |t| and class |cur_val|@>;
if cur_ptr<>null then begin_token_list(cur_ptr,mark_text);
@z

@x l.7971
if info(r)<>end_match_token then
@y
if info(r)=protected_token then r:=link(r);
if info(r)<>end_match_token then
@z

@x l.8283
@t\4\4@>@<Declare procedures that scan font-related stuff@>
@y
@t\4\4@>@<Declare \eTeX\ procedures for scanning@>@;
@t\4\4@>@<Declare \Prote\ procedures for scanning@>@;
@t\4\4@>@<Declare procedures that scan font-related stuff@>
@z

@x l.8327
|glue_val|, or |mu_val|.
@y
|glue_val|, or |mu_val| more than |mem_bot| (dynamic variable-size nodes
cannot have these values)
@z

@x l.8330
primitive("count",register,int_val);
@!@:count_}{\.{\\count} primitive@>
primitive("dimen",register,dimen_val);
@!@:dimen_}{\.{\\dimen} primitive@>
primitive("skip",register,glue_val);
@!@:skip_}{\.{\\skip} primitive@>
primitive("muskip",register,mu_val);
@y
primitive("count",register,mem_bot+int_val);
@!@:count_}{\.{\\count} primitive@>
primitive("dimen",register,mem_bot+dimen_val);
@!@:dimen_}{\.{\\dimen} primitive@>
primitive("skip",register,mem_bot+glue_val);
@!@:skip_}{\.{\\skip} primitive@>
primitive("muskip",register,mem_bot+mu_val);
@z

@x l.8340
register: if chr_code=int_val then print_esc("count")
  else if chr_code=dimen_val then print_esc("dimen")
  else if chr_code=glue_val then print_esc("skip")
  else print_esc("muskip");
@y
register: @<Cases of |register| for |print_cmd_chr|@>;
@z

@x l.8356
var m:halfword; {|chr_code| part of the operand token}
@y
label exit;
var m:halfword; {|chr_code| part of the operand token}
@!q,@!r:pointer; {general purpose indices}
@!tx:pointer; {effective tail node}
@!i:four_quarters; {character info}
@z

@x l.8382
end;
@y
exit:end;
@z

@x l.8403
    begin scan_eight_bit_int; m:=toks_base+cur_val;
    end;
  scanned_result(equiv(m))(tok_val);
@y
    if m=mem_bot then
      begin scan_register_num;
      if cur_val<256 then cur_val:=equiv(toks_base+cur_val)
      else  begin find_sa_element(tok_val,cur_val,false);
        if cur_ptr=null then cur_val:=null
        else cur_val:=sa_ptr(cur_ptr);
        end;
      end
    else cur_val:=sa_ptr(m)
  else cur_val:=equiv(m);
  cur_val_level:=tok_val;
@z

@x l.8418
|glue_val|, |input_line_no_code|, or |badness_code|.
@y
|glue_val|, |input_line_no_code|, or |badness_code|.
\eTeX\ inserts |last_node_type_code| after |glue_val| and adds
the codes for its extensions: |eTeX_version_code|, \dots\ .
@z

@x l.8420
@d input_line_no_code=glue_val+1 {code for \.{\\inputlineno}}
@d badness_code=glue_val+2 {code for \.{\\badness}}
@y
@d last_node_type_code=glue_val+1 {code for \.{\\lastnodetype}}
@d input_line_no_code=glue_val+2 {code for \.{\\inputlineno}}
@d badness_code=input_line_no_code+1 {code for \.{\\badness}}
@#
@d eTeX_int=badness_code+1 {first of \eTeX\ codes for integers}
@d eTeX_dim=eTeX_int+8 {first of \eTeX\ codes for dimensions}
@d eTeX_glue=eTeX_dim+9 {first of \eTeX\ codes for glue}
@d eTeX_mu=eTeX_glue+1 {first of \eTeX\ codes for muglue}
@d eTeX_expr=eTeX_mu+1 {first of \eTeX\ codes for expressions}
@d eTeX_last_last_item_cmd_mod=eTeX_expr-int_val+mu_val {\.{\\muexpr}}
@z

@x l.8453
@+else print_esc("insertpenalties");
@y
@/@<Cases of |set_page_int| for |print_cmd_chr|@>@/
@+else print_esc("insertpenalties");
@z

@x l.8462
  othercases print_esc("badness")
@y
  @/@<Cases of |last_item| for |print_cmd_chr|@>@/
  othercases print_esc("badness")
@z

@x l.8482
begin if m=0 then cur_val:=dead_cycles@+else cur_val:=insert_penalties;
@y
begin if m=0 then cur_val:=dead_cycles
@/@<Cases for `Fetch the |dead_cycles| or the |insert_penalties|'@>@/
else cur_val:=insert_penalties;
@z

@x l.8487
begin scan_eight_bit_int;
if box(cur_val)=null then cur_val:=0 @+else cur_val:=mem[box(cur_val)+m].sc;
@y
begin scan_register_num; fetch_box(q);
if q=null then cur_val:=0 @+else cur_val:=mem[q+m].sc;
@z

@x l.8512
begin if par_shape_ptr=null then cur_val:=0
@y
begin if m>par_shape_loc then @<Fetch a penalties array element@>
else if par_shape_ptr=null then cur_val:=0
@z

@x l.8517
@ Here is where \.{\\lastpenalty}, \.{\\lastkern}, and \.{\\lastskip} are
@y
@ Here is where \.{\\lastpenalty}, \.{\\lastkern}, \.{\\lastskip}, and
\.{\\lastnodetype} are
@z

@x l.8521
legal in similar contexts.
@y
legal in similar contexts.

The macro |find_effective_tail_eTeX| sets |tx| to the last non-\.{\\endM}
node of the current list.
@z

@x l.8523
@<Fetch an item in the current node...@>=
@y
@d find_effective_tail_eTeX==
tx:=tail;
if not is_char_node(tx) then
  if (type(tx)=math_node)and(subtype(tx)=end_M_code) then
    begin r:=head;
    repeat q:=r; r:=link(q);
    until r=tx;
    tx:=q;
    end
@#
@d find_effective_tail==find_effective_tail_eTeX

@<Fetch an item in the current node...@>=
@z

@x l.8524
if cur_chr>glue_val then
@y
if m>eTeX_last_last_item_cmd_mod then
  @/@<Fetch a \Prote\ item@>@/
else if m>=input_line_no_code then
@z

@x l.8525
  begin if cur_chr=input_line_no_code then cur_val:=line
  else cur_val:=last_badness; {|cur_chr=badness_code|}
@y
 if m>=eTeX_glue then @<Process an expression and |return|@>@;
 else if m>=eTeX_dim then
  begin case m of
  @/@<Cases for fetching a dimension value@>@/
  end; {there are no other cases}
  cur_val_level:=dimen_val;
  end
 else begin case m of
  input_line_no_code: cur_val:=line;
  badness_code: cur_val:=last_badness;
  @/@<Cases for fetching an integer value@>@/
  end; {there are no other cases}
@z

@x l.8530
  cur_val_level:=cur_chr;
  if not is_char_node(tail)and(mode<>0) then
    case cur_chr of
    int_val: if type(tail)=penalty_node then cur_val:=penalty(tail);
    dimen_val: if type(tail)=kern_node then cur_val:=width(tail);
    glue_val: if type(tail)=glue_node then
      begin cur_val:=glue_ptr(tail);
      if subtype(tail)=mu_glue then cur_val_level:=mu_val;
      end;
    end {there are no other cases}
  else if (mode=vmode)and(tail=head) then
@y
  find_effective_tail;
  if cur_chr=last_node_type_code then
    begin cur_val_level:=int_val;
    if (tx=head)or(mode=0) then cur_val:=-1;
    end
  else cur_val_level:=cur_chr;
  if not is_char_node(tx)and(mode<>0) then
    case cur_chr of
    int_val: if type(tx)=penalty_node then cur_val:=penalty(tx);
    dimen_val: if type(tx)=kern_node then cur_val:=width(tx);
    glue_val: if type(tx)=glue_node then
      begin cur_val:=glue_ptr(tx);
      if subtype(tx)=mu_glue then cur_val_level:=mu_val;
      end;
    last_node_type_code: if type(tx)<=unset_node then cur_val:=type(tx)+1
      else cur_val:=unset_node+2;
    end {there are no other cases}
  else if (mode=vmode)and(tx=head) then
@z

@x l.8544
    glue_val: if last_glue<>max_halfword then cur_val:=last_glue;
@y
    glue_val: if last_glue<>max_halfword then cur_val:=last_glue;
    last_node_type_code: cur_val:=last_node_type;
@z

@x l.8560
begin scan_eight_bit_int;
case m of
@y
begin if (m<mem_bot)or(m>lo_mem_stat_max) then
  begin cur_val_level:=sa_type(m);
  if cur_val_level<glue_val then cur_val:=sa_int(m)
  else cur_val:=sa_ptr(m);
  end
else  begin scan_register_num; cur_val_level:=m-mem_bot;
  if cur_val>255 then
    begin find_sa_element(cur_val_level,cur_val,false);
    if cur_ptr=null then
      if cur_val_level<glue_val then cur_val:=0
      else cur_val:=zero_glue
    else if cur_val_level<glue_val then cur_val:=sa_int(cur_ptr)
    else cur_val:=sa_ptr(cur_ptr);
    end
  else
  case cur_val_level of
@z

@x l.8567
cur_val_level:=m;
@y
  end;
@z

@x l.9095
exit:end;
@y
exit:end;
@#
@<Declare procedures needed for expressions@>@;
@z

@x l.9154
@p function str_toks(@!b:pool_pointer):pointer;
@y
@p @t\4@>@<Declare \eTeX\ procedures for token lists@>@;@/
function str_toks(@!b:pool_pointer):pointer;
@z

@x l.9179
@p function the_toks:pointer;
@y
@p function the_toks:pointer;
label exit;
@z

@x l.9183
begin get_x_token; scan_something_internal(tok_val,false);
@y
@!c:small_number; {value of |cur_chr|}
begin @<Handle \.{\\unexpanded} or \.{\\detokenize} and |return|@>;@/
get_x_token; scan_something_internal(tok_val,false);
@z

@x l.9197
end;
@y
exit:end;
@z

@x l.9220
@d number_code=0 {command code for \.{\\number}}
@y
@d number_code=0 {command code for \.{\\number}}
@z

@x l.9225
@d job_name_code=5 {command code for \.{\\jobname}}
@y
@d job_name_code=5 {command code for \.{\\jobname}}
@d etex_convert_base=job_name_code+1 {base for \eTeX's command codes}
@d eTeX_revision_code=etex_convert_base {command code for \.{\\eTeXrevision}}
@d etex_convert_codes=etex_convert_base+1 {end of \eTeX's command codes}
@d eTeX_last_convert_cmd_mod=etex_convert_codes
@z

@x l.9248
  othercases print_esc("jobname")
@y
  job_name_code: print_esc("jobname");
  eTeX_revision_code: print_esc("eTeXrevision");
  @/@<Cases of |convert| for |print_cmd_chr|@>@/
@z

@x l.9258
@!save_scanner_status:small_number; {|scanner_status| upon entry}
@!b:pool_pointer; {base of temporary string}
@y
@!save_scanner_status:small_number; {|scanner_status| upon entry}
@!b:pool_pointer; {base of temporary string}
@!i,@!k,@!l:integer; {general purpose index}
@!m,@!n:pool_pointer; {general purpose pool pointer}
@!r:boolean; {general purpose refraction i.e. changing the way}
@!s,@!t:str_number; {general purpose; de dicto}
@z

@x l.9273
job_name_code: if job_name=0 then open_log_file;
@y
job_name_code: if job_name=0 then open_log_file;
eTeX_revision_code: do_nothing;
@/@<Cases of `Scan the argument for command |c|'@>@/
@z

@x l.9289
job_name_code: print(job_name);
@y
eTeX_revision_code: print(eTeX_revision);
job_name_code: print(job_name);
@/@<Cases of `Print the result of command |c|'@>@/
@z

@x l.9333
scan_toks:=p;
end;
@y
scan_toks:=p;
end;
@t\4@>@<Declare \Prote\ procedures for token lists@>@;@/
@z

@x l.9400
  if cur_cmd<=max_command then goto done2;
@y
  if cur_cmd>=call then
    if info(link(cur_chr))=protected_token then
      begin cur_cmd:=relax; cur_chr:=no_expand_flag;
      end;
  if cur_cmd<=max_command then goto done2;
@z

@x l.9448
@p procedure read_toks(@!n:integer;@!r:pointer);
@y
@p procedure read_toks(@!n:integer;@!r:pointer;@!j:halfword);
@z

@x l.9474
loop@+  begin get_token;
@y
@<Handle \.{\\readline} and |goto done|@>;@/
loop@+  begin get_token;
@z

@x l.9526
@d if_char_code=0 { `\.{\\if}' }
@y
@d unless_code=32 {amount added for `\.{\\unless}' prefix}
@#
@d if_char_code=0 { `\.{\\if}' }
@z

@x l.9581
if_test: case chr_code of
@y
if_test: begin if chr_code>=unless_code then print_esc("unless");
case chr_code mod unless_code of
@z

@x l.9598
  othercases print_esc("if")
  endcases;
@y
  @/@<Cases of |if_test| for |print_cmd_chr|@>@/
  othercases print_esc("if")
  endcases;
end;
@z

@x l.9672
done: scanner_status:=save_scanner_status;
@y
done: scanner_status:=save_scanner_status;
if tracing_ifs>0 then show_cur_cmd_chr;
@z

@x l.9688
begin p:=cond_ptr; if_line:=if_line_field(p);
@y
begin if if_stack[in_open]=cond_ptr then if_warning;
  {conditionals possibly not properly nested with files}
p:=cond_ptr; if_line:=if_line_field(p);
@z

@x l.9725
begin @<Push the condition stack@>;@+save_cond_ptr:=cond_ptr;this_if:=cur_chr;@/
@<Either process \.{\\ifcase} or set |b| to the value of a boolean condition@>;
@y
@!is_unless:boolean; {was this if preceded by `\.{\\unless}' ?}
begin if tracing_ifs>0 then if tracing_commands<=1 then show_cur_cmd_chr;
@<Push the condition stack@>;@+save_cond_ptr:=cond_ptr;
is_unless:=(cur_chr>=unless_code); this_if:=cur_chr mod unless_code;@/
@<Either process \.{\\ifcase} or set |b| to the value of a boolean condition@>;
if is_unless then b:=not b;
@z

@x l.9768
if_false_code: b:=false;
@y
if_false_code: b:=false;
@/@<Cases for |conditional|@>@/
@z

@x l.9807
begin scan_eight_bit_int; p:=box(cur_val);
@y
begin scan_register_num; fetch_box(p);
@z

@x l.9897
if cur_chr>if_limit then
@y
begin if tracing_ifs>0 then if tracing_commands<=1 then show_cur_cmd_chr;
if cur_chr>if_limit then
@z

@x l.9908
  end
@y
  end;
end
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

@x l.10018
being scanned, since a new \.{\\csname} might be entered; therefore we keep
|area_delimiter| and |ext_delimiter| relative to the beginning of the current
string, instead of assigning an absolute address like |pool_ptr| to them.
@^system dependencies@>

@p function more_name(@!c:ASCII_code):boolean;
begin if c=" " then more_name:=false
@y
being scanned, since a new \.{\\csname} might be entered; therefore we keep
|area_delimiter| and |ext_delimiter| relative to the beginning of the current
string, instead of assigning an absolute address like |pool_ptr| to them.
@^system dependencies@>

The |ASCII_code| to use as a delimiter is specified also as a parameter.

@p function more_name(@!c,d:ASCII_code):boolean;
begin if c=d then more_name:=false
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
@d format_extension=".fmt" {the extension, as a \.{WEB} constant}
@y
Under {\mc UNIX} we don't give the area part, instead depending
on the path searching that will happen during file opening. \.{pp2rc}
adds one to the array sizes so that the indices do point inside the
array. When the array is declared in the Pascal code and used by Pascal
routines, we do not need the C trailing nul character since this is not
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

@x l.10098
@!TEX_format_default:packed array[1..format_default_length] of char;

@ @<Set init...@>=
TEX_format_default:='TeXformats:plain.fmt';
@y
@!TEX_format_default:packed array[1..format_default_length] of 0..255;

@ @<Set init...@>=
vstrncpy(TEX_format_default + 1, 'plain.dgst', format_default_length);
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

@x l.10202
routines by which \TeX\ deals with file names
in a system-independent manner.  First comes a procedure that looks for a
file name in the input by calling |get_x_token| for the information.

@p procedure scan_file_name;
label done;
begin name_in_progress:=true; begin_name;
@<Get the next non-blank non-call...@>;
loop@+begin if (cur_cmd>other_char)or(cur_chr>255) then {not a character}
@y
routines by which \TeX\ deals with file names
in a system-independent manner.  First comes a procedure that looks for a
file name. There are two ways to specify the file name and a variant: by
specifying it as a general text argument or as a token (after expansion)
with the traditional token delimiter being the space. This last has a
variant: if the first character is a double quote, the spaces are not
considered a token delimitation and whatever is between two double
quotes is taken, the same expansion being done as for space
tokenization.

Once the |area_delimiter| and the |ext_delimiter| are defined,
according to the current string, the final processing is common,
including the tentative extension.

We bypass \.{\\relax} as well as blanks and non-call as prefix.

Here we test for the |left_brace| first for the case of a user having
defined the double quote as such an active character to be used for
grouping...

@p procedure scan_file_name;
label done;
var d: ASCII_code; {the delimiter for |more_name|}
@!j,k:pool_pointer; {index into |str_pool|}
@!old_setting:0..max_selector; {holds |selector| setting}
begin name_in_progress:=true; begin_name;
d:=" "; {traditional token delimiter}
@<Get the next non-blank non-relax...@>;
if cur_cmd=left_brace then
  @<Define a general text file name and |goto done|@>@;
if cur_chr="""" then begin d:=""""; get_x_token; end;
loop@+begin if (cur_cmd>other_char)or(cur_chr>255) then {not a character}
@z

@x l.10213
  if not more_name(cur_chr) then goto done;
  get_x_token;
@y
  if not more_name(cur_chr,d) then goto done;
  get_x_token;
@z

@x l.10258
is the default extension if none is given. Upon exit from the routine,
variables |cur_name|, |cur_area|, |cur_ext|, and |name_of_file| are
ready for another attempt at file opening.

@p procedure prompt_file_name(@!s,@!e:str_number);
label done;
var k:0..buf_size; {index into |buffer|}
@y
is the default extension if none is given. We handle the specification
of a file name with possibly spaces in double quotes (the last one
is optional if this is the end of line i.e. the end of the buffer).
Upon exit from the routine,
variables |cur_name|, |cur_area|, |cur_ext|, and |name_of_file| are
ready for another attempt at file opening.

@p procedure prompt_file_name(@!s,@!e:str_number);
label done;
var k:0..buf_size; {index into |buffer|}
d: ASCII_code; {the delimiter for |more_name|}
@z

@x l.10283
begin begin_name; k:=first;
while (buffer[k]=" ")and(k<last) do incr(k);
loop@+  begin if k=last then goto done;
  if not more_name(buffer[k]) then goto done;
  incr(k);
  end;
@y
begin begin_name; k:=first;
d:=" "; {traditional delimiter}
while (buffer[k]=" ")and(k<last) do incr(k);
if buffer[k]="""" then begin incr(k); d:=""""; end;
loop@+  begin if k=last then goto done;
  if not more_name(buffer[k],d) then goto done;
  incr(k);
  end;
@z

@x l.10359
months:='JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC';
@y
vstrncpy(months + 1, 'JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC', 36);
@z

@x l.10362
print_two(sys_time div 60); print_char(":"); print_two(sys_time mod 60);
end
@y
print_two(sys_time div 60); print_char(":"); print_two(sys_time mod 60);
if eTeX_ex then
  begin; wlog_cr; wlog('entering extended mode');
  end;
if Prote_ex then
  begin; wlog_cr; wlog('entering Prote mode');
  end;
end
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

@x l.11299
begin if tracing_lost_chars>0 then
@y
var old_setting: integer; {saved value of |tracing_online|}
begin if tracing_lost_chars>0 then
 begin old_setting:=tracing_online;
 if eTeX_ex and(tracing_lost_chars>1) then tracing_online:=1;
@z

@x l.11306
end;
@y
 tracing_online:=old_setting;
 end;
end;
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

@x l.12274
this is essentially the depth of |push| commands in the \.{DVI} output.
@y
this is essentially the depth of |push| commands in the \.{DVI} output.

For mixed direction text (\TeXXeT) the current text direction is called
|cur_dir|. As the box being shipped out will never be used again and
soon be recycled, we can simply reverse any R-text (i.e., right-to-left)
segments of hlist nodes as well as complete hlist nodes embedded in such
segments. Moreover this can be done iteratively rather than recursively.
There are, however, two complications related to leaders that require
some additional bookkeeping: (1)~One and the same hlist node might be
used more than once (but never inside both L- and R-text); and
(2)~leader boxes inside hlists must be aligned with respect to the left
edge of the original hlist.

A math node is changed into a kern node whenever the text direction
remains the same, it is replaced by an |edge_node| if the text direction
changes; the subtype of an an |hlist_node| inside R-text is changed to
|reversed| once its hlist has been reversed.
@!@^data structure assumptions@>
@z

@x l.12276
@d synch_h==if cur_h<>dvi_h then
@y
@d reversed=1 {subtype for an |hlist_node| whose hlist has been reversed}
@d dlist=2 {subtype for an |hlist_node| from display math mode}
@d box_lr(#) == (qo(subtype(#))) {direction mode of a box}
@d set_box_lr(#) ==  subtype(#):=set_box_lr_end
@d set_box_lr_end(#) == qi(#)
@#
@d left_to_right=0
@d right_to_left=1
@d reflected==1-cur_dir {the opposite of |cur_dir|}
@#
@d synch_h==if cur_h<>dvi_h then
@z

@x l.12344
@!edge:scaled; {left edge of sub-box, or right edge of leader space}
@y
@!edge:scaled; {right edge of sub-box or leader space}
@!prev_p:pointer; {one step behind |p|}
@z

@x l.12354
save_loc:=dvi_offset+dvi_ptr; base_line:=cur_v; left_edge:=cur_h;
@y
save_loc:=dvi_offset+dvi_ptr; base_line:=cur_v;
prev_p:=this_box+list_offset;
@<Initialize |hlist_out| for mixed direction typesetting@>;
left_edge:=cur_h;
@z

@x l.12357
prune_movements(save_loc);
@y
@<Finish |hlist_out| for mixed direction typesetting@>;
prune_movements(save_loc);
@z

@x l.12376
  p:=link(p);
@y
  prev_p:=link(prev_p); {N.B.: not |prev_p:=p|, |p| might be |lig_trick|}
  p:=link(p);
@z

@x l.12401
kern_node,math_node:cur_h:=cur_h+width(p);
@y
kern_node:cur_h:=cur_h+width(p);
math_node: @<Handle a math node in |hlist_out|@>;
@z

@x l.12403
othercases do_nothing
@y
@/@<Cases of |hlist_out| that arise in mixed direction text only@>@;
othercases do_nothing
@z

@x l.12408
next_p:p:=link(p);
@y
next_p:prev_p:=p; p:=link(p);
@z

@x l.12415
  temp_ptr:=p; edge:=cur_h;
@y
  temp_ptr:=p; edge:=cur_h+width(p);
  if cur_dir=right_to_left then cur_h:=edge;
@z

@x l.12418
  cur_h:=edge+width(p); cur_v:=base_line;
@y
  cur_h:=edge; cur_v:=base_line;
@z

@x l.12436
           glue_temp:=-billion

@<Move right or output leaders@>=
begin g:=glue_ptr(p); rule_wd:=width(g)-cur_g;
@y
           glue_temp:=-billion
@#
@d round_glue==g:=glue_ptr(p); rule_wd:=width(g)-cur_g;
@z

@x l.12455
rule_wd:=rule_wd+cur_g;
@y
rule_wd:=rule_wd+cur_g

@<Move right or output leaders@>=
begin round_glue;
if eTeX_ex then @<Handle a glue node for mixed direction typesetting@>;
@z

@x l.12471
  edge:=cur_h+rule_wd; lx:=0;
@y
  if cur_dir=right_to_left then cur_h:=cur_h-10;
  edge:=cur_h+rule_wd; lx:=0;
@z

@x l.12477
  cur_h:=edge-10; goto next_p;
@y
  if cur_dir=right_to_left then cur_h:=edge
  else cur_h:=edge-10;
  goto next_p;
@z

@x l.12516
synch_h; save_h:=dvi_h; temp_ptr:=leader_box;
@y
synch_h; save_h:=dvi_h; temp_ptr:=leader_box;
if cur_dir=right_to_left then cur_h:=cur_h+leader_wd;
@z

@x l.12590
  cur_h:=left_edge+shift_amount(p); {shift the box right}
@y
  if cur_dir=right_to_left then cur_h:=left_edge-shift_amount(p)
  else cur_h:=left_edge+shift_amount(p); {shift the box right}
@z

@x l.12602
  begin synch_h; synch_v;
  dvi_out(put_rule); dvi_four(rule_ht); dvi_four(rule_wd);
@y
  begin if cur_dir=right_to_left then cur_h:=cur_h-rule_wd;
  synch_h; synch_v;
  dvi_out(put_rule); dvi_four(rule_ht); dvi_four(rule_wd);
  cur_h:=left_edge;
@z

@x l.12668
begin cur_h:=left_edge+shift_amount(leader_box); synch_h; save_h:=dvi_h;@/
@y
begin if cur_dir=right_to_left then
  cur_h:=left_edge-shift_amount(leader_box)
  else cur_h:=left_edge+shift_amount(leader_box);
synch_h; save_h:=dvi_h;@/
@z

@x l.12705
@<Ship box |p| out@>;
@y
@<Ship box |p| out@>;
if eTeX_ex then @<Check for LR anomalies at the end of |ship_out|@>;
@z

@x l.12926
h:=0; @<Clear dimensions to zero@>;
@y
h:=0; @<Clear dimensions to zero@>;
if TeXXeT_en then @<Initialize the LR stack@>;
@z

@x l.12936
exit: hpack:=r;
@y
exit: if TeXXeT_en then @<Check for LR anomalies at the end of |hpack|@>;
hpack:=r;
@z

@x l.12960
  kern_node,math_node: x:=x+width(p);
@y
  kern_node: x:=x+width(p);
  math_node: begin x:=x+width(p);
    if TeXXeT_en then @<Adjust \(t)the LR stack for the |hpack| routine@>;
    end;
@z

@x l.13531
\TeX's \.{\\left} and \.{\\right}. The |nucleus| of such noads is
@y
\TeX's \.{\\left} and \.{\\right} as well as \eTeX's \.{\\middle}.
The |nucleus| of such noads is
@z

@x l.13548
@d delimiter==nucleus {|delimiter| field in left and right noads}
@y
@d delimiter==nucleus {|delimiter| field in left and right noads}
@d middle_noad==1 {|subtype| of right noad representing \.{\\middle}}
@z

@x l.13721
right_noad: begin print_esc("right"); print_delimiter(delimiter(p));
  end;
end;
if subtype(p)<>normal then
  if subtype(p)=limits then print_esc("limits")
  else print_esc("nolimits");
if type(p)<left_noad then print_subsidiary_data(nucleus(p),".");
@y
right_noad: begin if subtype(p)=normal then print_esc("right")
  else print_esc("middle");
  print_delimiter(delimiter(p));
  end;
end;
if type(p)<left_noad then
  begin if subtype(p)<>normal then
    if subtype(p)=limits then print_esc("limits")
    else print_esc("nolimits");
  print_subsidiary_data(nucleus(p),".");
  end;
@z

@x l.14319
done_with_noad: r:=q; r_type:=type(r);
@y
done_with_noad: r:=q; r_type:=type(r);
if r_type=right_noad then
  begin r_type:=left_noad; cur_style:=style; @<Set up the values...@>;
  end;
@z

@x l.14980
  r_type:=t;
@y
  if type(q)=right_noad then t:=open_noad;
  r_type:=t;
@z

@x l.15020
begin if style<script_style then cur_size:=text_size
else cur_size:=16*((style-text_style) div 2);
@y
begin cur_style:=style; @<Set up the values...@>;
@z

@x l.15512
begin restart: align_state:=1000000; @<Get the next non-blank non-call token@>;
@y
begin restart: align_state:=1000000;
repeat get_x_or_protected;
until cur_cmd<>spacer;
@z

@x l.15623
align_state:=1000000; @<Get the next non-blank non-call token@>;
@y
align_state:=1000000;
repeat get_x_or_protected;
until cur_cmd<>spacer;
@z

@x l.15886
  begin type(q):=hlist_node; width(q):=width(p);
@y
  begin type(q):=hlist_node; width(q):=width(p);
  if nest[nest_ptr-1].mode_field=mmode then set_box_lr(q)(dlist); {for |ship_out|}
@z

@x l.15904
n:=span_count(r); t:=width(s); w:=t; u:=hold_head;
@y
n:=span_count(r); t:=width(s); w:=t; u:=hold_head;
set_box_lr(r)(0); {for |ship_out|}
@z

@x l.16027
There is one explicit parameter:  |final_widow_penalty| is the amount of
additional penalty to be inserted before the final line of the paragraph.
@y
There is one explicit parameter:  |d| is true for partial paragraphs
preceding display math mode; in this case the amount of additional
penalty inserted before the final line is |display_widow_penalty|
instead of |widow_penalty|.
@z

@x l.16054
procedure line_break(@!final_widow_penalty:integer);
@y
procedure line_break(@!d:boolean);
@z

@x l.16064
end;
@y
end;
@#
@t\4@>@<Declare \eTeX\ procedures for use by |main_control|@>
@z

@x l.16084
link(tail):=new_param_glue(par_fill_skip_code);
@y
link(tail):=new_param_glue(par_fill_skip_code);
last_line_fill:=link(tail);
@z

@x l.16149
@d active_node_size=3 {number of words in active nodes}
@y
@d active_node_size_normal=3 {number of words in normal active nodes}
@z

@x l.16314
background[6]:=shrink(q)+shrink(r);
@y
background[6]:=shrink(q)+shrink(r);
@<Check for special treatment of last line of paragraph@>;
@z

@x l.16365
label exit,done,done1,continue,deactivate;
@y
label exit,done,done1,continue,deactivate,found,not_found;
@z

@x l.16657
total_demerits(q):=minimal_demerits[fit_class];
@y
total_demerits(q):=minimal_demerits[fit_class];
if do_last_line_fit then
  @<Store \(a)additional data in the new active node@>;
@z

@x l.16670
print(" t="); print_int(total_demerits(q));
@y
print(" t="); print_int(total_demerits(q));
if do_last_line_fit then @<Print additional data in the new active node@>;
@z

@x l.16769
if (b>inf_bad)or(pi=eject_penalty) then
@y
if do_last_line_fit then @<Adjust \(t)the additional data for last line@>;
found:
if (b>inf_bad)or(pi=eject_penalty) then
@z

@x l.16793
  begin b:=0; fit_class:=decent_fit; {infinite stretch}
@y
  begin if do_last_line_fit then
    begin if cur_p=null then {the last line of a paragraph}
      @<Perform computations for last line and |goto found|@>;
    shortfall:=0;
    end;
  b:=0; fit_class:=decent_fit; {infinite stretch}
@z

@x l.16850
  best_place[fit_class]:=break_node(r); best_pl_line[fit_class]:=l;
@y
  best_place[fit_class]:=break_node(r); best_pl_line[fit_class]:=l;
  if do_last_line_fit then
    @<Store \(a)additional data for this feasible break@>;
@z

@x l.16909
if abs(fit_class-fitness(r))>1 then d:=d+adj_demerits;
@y
if abs(toint(fit_class)-toint(fitness(r)))>1 then d:=d+adj_demerits;
@z

@x l.17023
  end;@+tats@/
@y
  end;@+tats@/
if do_last_line_fit then @<Adjust \(t)the final line of the paragraph@>;
@z

@x l.17034
line_number(q):=prev_graf+1; total_demerits(q):=0; link(active):=q;
@y
line_number(q):=prev_graf+1; total_demerits(q):=0; link(active):=q;
if do_last_line_fit then
  @<Initialize additional fields of the first active node@>;
@z

@x l.17084
math_node: begin auto_breaking:=(subtype(cur_p)=after); kern_break;
@y
math_node: begin if subtype(cur_p)<L_code then auto_breaking:=odd(subtype(cur_p));
  kern_break;
@z

@x l.17223
repeat if type(r)<>delta_node then
  begin line_diff:=line_number(r)-best_line;
@y
repeat if type(r)<>delta_node then
  begin line_diff:=toint(line_number(r))-toint(best_line);
@z

@x l.17246
post_line_break(final_widow_penalty)
@y
post_line_break(d)
@z

@x l.17260
procedure post_line_break(@!final_widow_penalty:integer);
@y
procedure post_line_break(@!d:boolean);
@z

@x l.17270
begin @<Reverse the links of the relevant passive nodes, setting |cur_p| to the
@y
@!LR_ptr:pointer; {stack of LR codes}
begin LR_ptr:=LR_save;
@<Reverse the links of the relevant passive nodes, setting |cur_p| to the
@z

@x l.17283
prev_graf:=best_line-1;
@y
prev_graf:=best_line-1;
LR_save:=LR_ptr;
@z

@x l.17313
  r:=q; {now |type(q)=glue_node|, |kern_node|, |math_node|, or |penalty_node|}
@y
  r:=q; {now |type(q)=glue_node|, |kern_node|, |math_node|, or |penalty_node|}
  if type(q)=math_node then if TeXXeT_en then
    @<Adjust \(t)the LR stack for the |post_line_break| routine@>;
@z

@x l.17330
@<Modify the end of the line to reflect the nature of the break and to include
  \.{\\rightskip}; also set the proper value of |disc_break|@>;
@y
if TeXXeT_en then
  @<Insert LR nodes at the beginning of the current line and adjust
    the LR stack based on LR nodes in this line@>;
@<Modify the end of the line to reflect the nature of the break and to include
  \.{\\rightskip}; also set the proper value of |disc_break|@>;
if TeXXeT_en then @<Insert LR nodes at the end of the current line@>;
@z

@x l.17353
    else if (type(q)=math_node)or(type(q)=kern_node) then width(q):=0;
@y
    else if type(q)=kern_node then width(q):=0
    else if type(q)=math_node then
      begin width(q):=0;
      if TeXXeT_en then @<Adjust \(t)the LR stack for the |p...@>;
      end;
@z

@x l.17447
  begin pen:=inter_line_penalty;
  if cur_line=prev_graf+1 then pen:=pen+club_penalty;
  if cur_line+2=best_line then pen:=pen+final_widow_penalty;
@y
  begin q:=inter_line_penalties_ptr;
  if q<>null then
    begin r:=cur_line;
    if r>penalty(q) then r:=penalty(q);
    pen:=penalty(q+r);
    end
  else pen:=inter_line_penalty;
  q:=club_penalties_ptr;
  if q<>null then
    begin r:=cur_line-prev_graf;
    if r>penalty(q) then r:=penalty(q);
    pen:=pen+penalty(q+r);
    end
  else if cur_line=prev_graf+1 then pen:=pen+club_penalty;
  if d then q:=display_widow_penalties_ptr
  else q:=widow_penalties_ptr;
  if q<>null then
    begin r:=best_line-cur_line-1;
    if r>penalty(q) then r:=penalty(q);
    pen:=pen+penalty(q+r);
    end
  else if cur_line+2=best_line then
    if d then pen:=pen+display_widow_penalty
    else pen:=pen+widow_penalty;
@z

@x l.17475
implicit kern nodes, and $p_m$ is a glue or penalty or insertion or adjust
@y
implicit kern or text direction nodes, and $p_m$ is a glue or penalty or
insertion or adjust
@z

@x l.17514
cur_lang:=init_cur_lang; l_hyf:=init_l_hyf; r_hyf:=init_r_hyf;
@y
cur_lang:=init_cur_lang; l_hyf:=init_l_hyf; r_hyf:=init_r_hyf;
set_hyph_index;
@z

@x l.17578
  else if (type(s)=kern_node)and(subtype(s)=normal) then goto continue
@y
  else if (type(s)=kern_node)and(subtype(s)=normal) then goto continue
  else if (type(s)=math_node)and(subtype(s)>=L_code) then goto continue
@z

@x l.17584
  if lc_code(c)<>0 then
    if (lc_code(c)=c)or(uc_hyph>0) then goto done2
@y
  set_lc_code(c);
  if hc[0]<>0 then
    if (hc[0]=c)or(uc_hyph>0) then goto done2
@z

@x l.17601
    if lc_code(c)=0 then goto done3;
    if hn=63 then goto done3;
    hb:=s; incr(hn); hu[hn]:=c; hc[hn]:=lc_code(c); hyf_bchar:=non_char;
@y
    set_lc_code(c);
    if hc[0]=0 then goto done3;
    if hn=63 then goto done3;
    hb:=s; incr(hn); hu[hn]:=c; hc[hn]:=hc[0]; hyf_bchar:=non_char;
@z

@x l.17627
  if lc_code(c)=0 then goto done3;
  if j=63 then goto done3;
  incr(j); hu[j]:=c; hc[j]:=lc_code(c);@/
@y
  set_lc_code(c);
  if hc[0]=0 then goto done3;
  if j=63 then goto done3;
  incr(j); hu[j]:=c; hc[j]:=hc[0];@/
@z

@x l.17644
    othercases goto done1
@y
    math_node: if subtype(s)>=L_code then goto done4@+else goto done1;
    othercases goto done1
@z

@x l.18266
label reswitch, exit, found, not_found;
@y
label reswitch, exit, found, not_found, not_found1;
@z

@x l.18276
set_cur_lang;
@y
set_cur_lang;
@!init if trie_not_ready then
  begin hyph_index:=0; goto not_found1;
  end;
tini@/
set_hyph_index;
not_found1:
@z

@x l.18308
else  begin if lc_code(cur_chr)=0 then
@y
else  begin set_lc_code(cur_chr);
  if hc[0]=0 then
@z

@x l.18316
    begin incr(n); hc[n]:=lc_code(cur_chr);
@y
    begin incr(n); hc[n]:=hc[0];
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

@x l.18604
trie_root:=compress_trie(trie_root); {identify equivalent subtries}
@y
hyph_root:=compress_trie(hyph_root);
trie_root:=compress_trie(trie_root); {identify equivalent subtries}
@z

@x l.18692
if trie_root=0 then {no patterns were given}
@y
if trie_max=0 then {no patterns were given}
@z

@x l.18696
else begin trie_fix(trie_root); {this fixes the non-holes in |trie|}
@y
else begin if hyph_root>0 then trie_fix(hyph_root);
  if trie_root>0 then trie_fix(trie_root); {this fixes the non-holes in |trie|}
@z

@x l.18739
  brace@>;
@y
  brace@>;
  if saving_hyph_codes>0 then
    @<Store hyphenation codes for current language@>;
@z

@x l.18846
@<Move the data into |trie|@>;
@y
if hyph_root<>0 then @<Pack all stored |hyph_codes|@>;
@<Move the data into |trie|@>;
@z

@x l.18862
whenever this is possible without backspacing.
@y
whenever this is possible without backspacing.

When the second argument |s| is |false| the deleted nodes are destroyed,
otherwise they are collected in a list starting at |split_disc|.
@z

@x l.18869
@p function prune_page_top(@!p:pointer):pointer; {adjust top after page break}
var prev_p:pointer; {lags one step behind |p|}
@!q:pointer; {temporary variable for list manipulation}
@y
@p function prune_page_top(@!p:pointer;@!s:boolean):pointer;
  {adjust top after page break}
var prev_p:pointer; {lags one step behind |p|}
@!q,@!r:pointer; {temporary variables for list manipulation}
@z

@x l.18880
    link(prev_p):=p; flush_node_list(q);
@y
    link(prev_p):=p;
    if s then
      begin if split_disc=null then split_disc:=q@+else link(r):=q;
      r:=q;
      end
    else flush_node_list(q);
@z

@x l.19047
@p function vsplit(@!n:eight_bits; @!h:scaled):pointer;
@y
@p @t\4@>@<Declare the function called |do_marks|@>@;
function vsplit(@!n:halfword; @!h:scaled):pointer;
@z

@x l.19053
begin v:=box(n);
@y
begin cur_val:=n; fetch_box(v);
@z

@x l.19054
if split_first_mark<>null then
@y
flush_node_list(split_disc); split_disc:=null;
if sa_mark<>null then
  if do_marks(vsplit_init,0,sa_mark) then sa_mark:=null;
if split_first_mark<>null then
@z

@x l.19062
q:=prune_page_top(q); p:=list_ptr(v); free_node(v,box_node_size);
@y
q:=prune_page_top(q,saving_vdiscards>0);
p:=list_ptr(v); free_node(v,box_node_size);
@z

@x l.19063
if q=null then box(n):=null {the |eq_level| of the box stays the same}
else box(n):=vpack(q,natural);
@y
if q<>null then q:=vpack(q,natural);
change_box(q); {the |eq_level| of the box stays the same}
@z

@x l.19088
    if split_first_mark=null then
@y
    if mark_class(p)<>0 then @<Update the current marks for |vsplit|@>
    else if split_first_mark=null then
@z

@x l.19222
The variables |last_penalty| and |last_kern| are similar.  And
@y
The variables |last_penalty|, |last_kern|, and |last_node_type|
are similar.  And
@z

@x l.19235
@!last_kern:scaled; {used to implement \.{\\lastkern}}
@y
@!last_kern:scaled; {used to implement \.{\\lastkern}}
@!last_node_type:integer; {used to implement \.{\\lastnodetype}}
@z

@x l.19375
last_glue:=max_halfword; last_penalty:=0; last_kern:=0;
@y
last_glue:=max_halfword; last_penalty:=0; last_kern:=0;
last_node_type:=-1;
@z

@x l.19442
last_penalty:=0; last_kern:=0;
@y
last_penalty:=0; last_kern:=0;
last_node_type:=type(p)+1;
@z

@x l.19479
link(contrib_head):=link(p); link(p):=null; flush_node_list(p)
@y
link(contrib_head):=link(p); link(p):=null;
if saving_vdiscards>0 then
  begin if page_disc=null then page_disc:=p@+else link(tail_page_disc):=p;
  tail_page_disc:=p;
  end
else flush_node_list(p)
@z

@x l.19719
if bot_mark<>null then
@y
if sa_mark<>null then
  if do_marks(fire_up_init,0,sa_mark) then sa_mark:=null;
if bot_mark<>null then
@z

@x l.19727
if (top_mark<>null)and(first_mark=null) then
@y
if sa_mark<>null then
  if do_marks(fire_up_done,0,sa_mark) then sa_mark:=null;
if (top_mark<>null)and(first_mark=null) then
@z

@x l.19764
  else if type(p)=mark_node then @<Update the values of
@y
  else if type(p)=mark_node then
    if mark_class(p)<>0 then @<Update the current marks for |fire_up|@>
    else @<Update the values of
@z

@x l.19876
    ins_ptr(p):=prune_page_top(broken_ptr(r));
@y
    ins_ptr(p):=prune_page_top(broken_ptr(r),false);
@z

@x l.19912
ship_out(box(255)); box(255):=null;
@y
flush_node_list(page_disc); page_disc:=null;
ship_out(box(255)); box(255):=null;
@z

@x l.19954
pop_nest; build_page;
@y
flush_node_list(page_disc); page_disc:=null;
pop_nest; build_page;
@z

@x l.20760
if par_shape_ptr<>null then eq_define(par_shape_loc,shape_ref,null);
@y
if par_shape_ptr<>null then eq_define(par_shape_loc,shape_ref,null);
if inter_line_penalties_ptr<>null then
  eq_define(inter_line_penalties_loc,shape_ref,null);
@z

@x l.20781
|box_flag+255| represent `\.{\\setbox0}' through `\.{\\setbox255}';
codes |box_flag+256| through |box_flag+511| represent `\.{\\global\\setbox0}'
through `\.{\\global\\setbox255}';
code |box_flag+512| represents `\.{\\shipout}'; and codes |box_flag+513|
through |box_flag+515| represent `\.{\\leaders}', `\.{\\cleaders}',
@y
|global_box_flag-1| represent `\.{\\setbox0}' through `\.{\\setbox32767}';
codes |global_box_flag| through |ship_out_flag-1| represent
`\.{\\global\\setbox0}' through `\.{\\global\\setbox32767}';
code |ship_out_flag| represents `\.{\\shipout}'; and codes |leader_flag|
through |leader_flag+2| represent `\.{\\leaders}', `\.{\\cleaders}',
@z

@x l.20795
@d ship_out_flag==box_flag+512 {context code for `\.{\\shipout}'}
@d leader_flag==box_flag+513 {context code for `\.{\\leaders}'}
@y
@d global_box_flag==@'10000100000 {context code for `\.{\\global\\setbox0}'}
@d ship_out_flag==@'10000200000  {context code for `\.{\\shipout}'}
@d leader_flag==@'10000200001  {context code for `\.{\\leaders}'}
@z

@x l.20878
var p:pointer; {|ord_noad| for new box in math mode}
@y
var p:pointer; {|ord_noad| for new box in math mode}
@!a:small_number; {global prefix}
@z

@x l.20916
if box_context<box_flag+256 then
  eq_define(box_base-box_flag+box_context,box_ref,cur_box)
else geq_define(box_base-box_flag-256+box_context,box_ref,cur_box)
@y
begin if box_context<global_box_flag then
  begin cur_val:=box_context-box_flag; a:=0;
  end
else  begin cur_val:=box_context-global_box_flag; a:=4;
  end;
if cur_val<256 then define(box_base+cur_val,box_ref,cur_box)
else sa_def_box;
end
@z

@x l.20945
@!m:quarterword; {the length of a replacement list}
@y
@!r:pointer; {running behind |p|}
@!fm:boolean; {a final \.{\\beginM} \.{\\endM} node pair?}
@!tx:pointer; {effective tail node}
@!m:quarterword; {the length of a replacement list}
@z

@x l.20947
@!n:eight_bits; {a box number}
begin case cur_chr of
box_code: begin scan_eight_bit_int; cur_box:=box(cur_val);
  box(cur_val):=null; {the box becomes void, at the same level}
  end;
copy_code: begin scan_eight_bit_int; cur_box:=copy_node_list(box(cur_val));
@y
@!n:halfword; {a box number}
begin case cur_chr of
box_code: begin scan_register_num; fetch_box(cur_box);
  change_box(null); {the box becomes void, at the same level}
  end;
copy_code: begin scan_register_num; fetch_box(q); cur_box:=copy_node_list(q);
@z

@x l.20965
@<If the current list ends with a box node, delete it...@>=
@y
@d fetch_effective_tail_eTeX(#)== {extract |tx|,
  drop \.{\\beginM} \.{\\endM} pair}
q:=head; p:=null;
repeat r:=p; p:=q; fm:=false;
if not is_char_node(q) then
  if type(q)=disc_node then
    begin for m:=1 to replace_count(q) do p:=link(p);
    if p=tx then #;
    end
  else if (type(q)=math_node)and(subtype(q)=begin_M_code) then fm:=true;
q:=link(p);
until q=tx; {found |r|$\to$|p|$\to$|q=tx|}
q:=link(tx); link(p):=q; link(tx):=null;
if q=null then if fm then confusion("tail1")
@:this can't happen tail1}{\quad tail1@>
  else tail:=p
else if fm then {|r|$\to$|p=begin_M|$\to$|q=end_M|}
  begin tail:=r; link(r):=null; flush_node_list(p);@+end
@#
@d check_effective_tail(#)==find_effective_tail_eTeX
@d fetch_effective_tail==fetch_effective_tail_eTeX

@<If the current list ends with a box node, delete it...@>=
@z

@x l.20975
else  begin if not is_char_node(tail) then
    if (type(tail)=hlist_node)or(type(tail)=vlist_node) then
      @<Remove the last box, unless it's part of a discretionary@>;
  end;
@y
else  begin check_effective_tail(goto done);
  if not is_char_node(tx) then
    if (type(tx)=hlist_node)or(type(tx)=vlist_node) then
      @<Remove the last box, unless it's part of a discretionary@>;
  done:end;
@z

@x l.20982
begin q:=head;
repeat p:=q;
if not is_char_node(q) then if type(q)=disc_node then
  begin for m:=1 to replace_count(q) do p:=link(p);
  if p=tail then goto done;
  end;
q:=link(p);
until q=tail;
cur_box:=tail; shift_amount(cur_box):=0;
tail:=p; link(p):=null;
done:end
@y
begin fetch_effective_tail(goto done);
cur_box:=tx; shift_amount(cur_box):=0;
end
@z

@x l.20997
begin scan_eight_bit_int; n:=cur_val;
@y
begin scan_register_num; n:=cur_val;
@z

@x l.21181
  else line_break(widow_penalty);
@y
  else line_break(false);
  if LR_save<>null then
    begin flush_list(LR_save); LR_save:=null;
    end;
@z

@x l.21237
begin p:=scan_toks(false,true); p:=get_node(small_node_size);
@y
@!c:halfword; {the mark class}
begin if cur_chr=0 then c:=0
else  begin scan_register_num; c:=cur_val;
  end;
p:=scan_toks(false,true); p:=get_node(small_node_size);
mark_class(p):=c;
@z

@x l.21271
@!m:quarterword; {the length of a replacement list}
@y
@!r:pointer; {running behind |p|}
@!fm:boolean; {a final \.{\\beginM} \.{\\endM} node pair?}
@!tx:pointer; {effective tail node}
@!m:quarterword; {the length of a replacement list}
@z

@x l.21275
else  begin if not is_char_node(tail) then if type(tail)=cur_chr then
    begin q:=head;
    repeat p:=q;
    if not is_char_node(q) then if type(q)=disc_node then
      begin for m:=1 to replace_count(q) do p:=link(p);
      if p=tail then return;
      end;
    q:=link(p);
    until q=tail;
    link(p):=null; flush_node_list(tail); tail:=p;
@y
else  begin check_effective_tail(return);
  if not is_char_node(tx) then if type(tx)=cur_chr then
    begin fetch_effective_tail(return);
    flush_node_list(tx);
@z

@x l.21324
un_vbox: if chr_code=copy_code then print_esc("unvcopy")
@y
un_vbox: if chr_code=copy_code then print_esc("unvcopy")
  @<Cases of |un_vbox| for |print_cmd_chr|@>@/
@z

@x l.21334
label exit;
@y
label done, exit;
@z

@x l.21337
begin c:=cur_chr; scan_eight_bit_int; p:=box(cur_val);
@y
begin if cur_chr>copy_code then @<Handle saved items and |goto done|@>;
c:=cur_chr; scan_register_num; fetch_box(p);
@z

@x l.21349
else  begin link(tail):=list_ptr(p); box(cur_val):=null;
@y
else  begin link(tail):=list_ptr(p); change_box(null);
@z

@x l.21352
while link(tail)<>null do tail:=link(tail);
@y
done:
while link(tail)<>null do tail:=link(tail);
@z

@x l.21624
vmode+halign,hmode+valign:init_align;
@y
vmode+halign:init_align;
hmode+valign:@<Cases of |main_control| for |hmode+valign|@>@; init_align;
@z

@x l.21703
procedure init_math;
label reswitch,found,not_found,done;
var w:scaled; {new or partial |pre_display_size|}
@y
@t\4@>@<Declare subprocedures for |init_math|@>@;
procedure init_math;
label reswitch,found,not_found,done;
var w:scaled; {new or partial |pre_display_size|}
@!j:pointer; {prototype box for display}
@!x:integer; {new |pre_display_direction|}
@z

@x l.21761
begin if head=tail then {`\.{\\noindent\$\$}' or `\.{\$\${ }\$\$}'}
  begin pop_nest; w:=-max_dimen;
  end
else  begin line_break(display_widow_penalty);@/
@y
begin j:=null; w:=-max_dimen;
if head=tail then {`\.{\\noindent\$\$}' or `\.{\$\${ }\$\$}'}
  @<Prepare for display after an empty paragraph@>
else  begin line_break(true);@/
@z

@x l.21774
eq_word_define(dimen_base+pre_display_size_code,w);
@y
eq_word_define(dimen_base+pre_display_size_code,w);
LR_box:=j;
if eTeX_ex then eq_word_define(int_base+pre_display_direction_code,x);
@z

@x l.21782
v:=shift_amount(just_box)+2*quad(cur_font); w:=-max_dimen;
p:=list_ptr(just_box);
@y
@<Prepare for display after a non-empty paragraph@>;
@z

@x l.21797
done:
@y
done:
@<Finish the natural width computation@>
@z

@x l.21808
kern_node,math_node: d:=width(p);
@y
kern_node: d:=width(p);
@t\4@>@<Cases of `Let |d| be the natural width' that need special treatment@>@;
@z

@x l.22317
  if type(q)<>left_noad then confusion("right");
@:this can't happen right}{\quad right@>
  info(numerator(incompleat_noad)):=link(q);
  link(q):=incompleat_noad; link(incompleat_noad):=p;
@y
  if (type(q)<>left_noad)or(delim_ptr=null) then confusion("right");
@:this can't happen right}{\quad right@>
  info(numerator(incompleat_noad)):=link(delim_ptr);
  link(delim_ptr):=incompleat_noad; link(incompleat_noad):=p;
@z

@x l.22362
else print_esc("right");
@y
@/@<Cases of |left_right| for |print_cmd_chr|@>@/
else print_esc("right");
@z

@x l.22371
begin t:=cur_chr;
if (t=right_noad)and(cur_group<>math_left_group) then
@y
@!q:pointer; {resulting mlist}
begin t:=cur_chr;
if (t<>left_noad)and(cur_group<>math_left_group) then
@z

@x l.22376
  if t=left_noad then
    begin push_math(math_left_group); link(head):=p; tail:=p;
    end
  else  begin p:=fin_mlist(p); unsave; {end of |math_left_group|}
@y
  if t=middle_noad then
    begin type(p):=right_noad; subtype(p):=middle_noad;
    end;
  if t=left_noad then q:=p
  else  begin q:=fin_mlist(p); unsave; {end of |math_left_group|}
    end;
  if t<>right_noad then
    begin push_math(math_left_group); link(head):=q; tail:=p;
    delim_ptr:=p;
    end
  else  begin
@z

@x l.22382
    info(nucleus(tail)):=p;
@y
    info(nucleus(tail)):=q;
@z

@x l.22390
  print_err("Extra "); print_esc("right");
@.Extra \\right.@>
  help1("I'm ignoring a \right that had no matching \left.");
@y
  print_err("Extra ");
  if t=middle_noad then
    begin print_esc("middle");
@.Extra \\middle.@>
    help1("I'm ignoring a \middle that had no matching \left.");
    end
  else  begin print_esc("right");
@.Extra \\right.@>
    help1("I'm ignoring a \right that had no matching \left.");
    end;
@z

@x l.22405
procedure after_math;
@y
@t\4@>@<Declare subprocedures for |after_math|@>@;
procedure after_math;
@z

@x l.22412
begin danger:=false;
@y
begin danger:=false;
@<Retrieve the prototype box@>;
@z

@x l.22419
  mlist_to_hlist; a:=hpack(link(temp_head),natural);
@y
  mlist_to_hlist; a:=hpack(link(temp_head),natural);
  set_box_lr(a)(dlist);
@z

@x l.22422
  danger:=false;
@y
  danger:=false;
  @<Retrieve the prototype box@>;
@z

@x l.22509
w:=width(b); z:=display_width; s:=display_indent;
@y
w:=width(b); z:=display_width; s:=display_indent;
if pre_display_direction<0 then s:=-s-z;
@z

@x l.22524
resume_after_display
@y
@<Flush the prototype box@>;
resume_after_display
@z

@x l.22566
d:=half(z-w);
@y
set_box_lr(b)(dlist);
d:=half(z-w);
@z

@x l.22587
  begin shift_amount(a):=s; append_to_vlist(a);
@y
  begin app_display(j,a,0);
@z

@x l.22602
shift_amount(b):=s+d; append_to_vlist(b)
@y
app_display(j,b,d)
@z

@x l.22607
  shift_amount(a):=s+z-width(a);
  append_to_vlist(a);
@y
  app_display(j,a,z-width(a));
@z

@x l.22626
pop_nest;
@y
flush_node_list(LR_box);
pop_nest;
@z

@x l.22651
control sequence can be defined to be `\.{\\long}' or `\.{\\outer}', and
it might or might not be expanded. The prefixes `\.{\\global}', `\.{\\long}',
@y
control sequence can be defined to be `\.{\\long}', `\.{\\protected}',
or `\.{\\outer}', and it might or might not be expanded. The prefixes
`\.{\\global}', `\.{\\long}', `\.{\\protected}',
@z

@x l.22677
  else print_esc("global");
@y
  @/@<Cases of |prefix| for |print_cmd_chr|@>@/
  else print_esc("global");
@z

@x l.22739
    @<Discard erroneous prefixes and |return|@>;
@y
    @<Discard erroneous prefixes and |return|@>;
  if tracing_commands>2 then if eTeX_ex then show_cur_cmd_chr;
@z

@x l.22755
help1("I'll pretend you didn't say \long or \outer or \global.");
@y
help1("I'll pretend you didn't say \long or \outer or \global.");
if eTeX_ex then help_line[0]:=@|
  "I'll pretend you didn't say \long or \outer or \global or \protected.";
@z

@x l.22760
if (cur_cmd<>def)and(a mod 4<>0) then
  begin print_err("You can't use `"); print_esc("long"); print("' or `");
  print_esc("outer"); print("' with `");
@y
if a>=8 then
  begin j:=protected_token; a:=a-8;
  end
else j:=0;
if (cur_cmd<>def)and((a mod 4<>0)or(j<>0)) then
  begin print_err("You can't use `"); print_esc("long"); print("' or `");
  print_esc("outer");
  help1("I'll pretend you didn't say \long or \outer here.");
  if eTeX_ex then
    begin  help_line[0]:=@|
      "I'll pretend you didn't say \long or \outer or \protected here.";
    print("' or `"); print_esc("protected");
    end;
  print("' with `");
@z

@x l.22765
  help1("I'll pretend you didn't say \long or \outer here.");
@y
@z

@x l.22824
  q:=scan_toks(true,e); define(p,call+(a mod 4),def_ref);
@y
  q:=scan_toks(true,e);
  if j<>0 then
    begin q:=get_avail; info(q):=j; link(q):=link(def_ref);
    link(def_ref):=q;
    end;
  define(p,call+(a mod 4),def_ref);
@z

@x l.22852
  if cur_cmd>=call then add_token_ref(cur_chr);
@y
  if cur_cmd>=call then add_token_ref(cur_chr)
  else if (cur_cmd=register)or(cur_cmd=toks_register) then
    if (cur_chr<mem_bot)or(cur_chr>lo_mem_stat_max) then
      add_sa_ref(cur_chr);
@z

@x l.22915
  othercases begin scan_eight_bit_int;
@y
  othercases begin scan_register_num;
    if cur_val>255 then
      begin j:=n-count_def_code; {|int_val..box_val|}
      if j>mu_val then j:=tok_val; {|int_val..mu_val| or |tok_val|}
      find_sa_element(j,cur_val,true); add_sa_ref(cur_ptr);
      if j=tok_val then j:=toks_register@+else j:=register;
      define(p,j,cur_ptr);
      end
    else
@z

@x l.22928
read_to_cs: begin scan_int; n:=cur_val;
@y
read_to_cs: begin j:=cur_chr; scan_int; n:=cur_val;
@z

@x l.22937
  p:=cur_cs; read_toks(n,p); define(p,call,cur_val);
@y
  p:=cur_cs; read_toks(n,p,j); define(p,call,cur_val);
@z

@x l.22946
  if cur_cmd=toks_register then
    begin scan_eight_bit_int; p:=toks_base+cur_val;
    end
  else p:=cur_chr; {|p=every_par_loc| or |output_routine_loc| or \dots}
@y
  e:=false; {just in case, will be set |true| for sparse array elements}
  if cur_cmd=toks_register then
    if cur_chr=mem_bot then
      begin scan_register_num;
      if cur_val>255 then
        begin find_sa_element(tok_val,cur_val,true);
        cur_chr:=cur_ptr; e:=true;
        end
      else cur_chr:=toks_base+cur_val;
      end
    else e:=true;
  p:=cur_chr; {|p=every_par_loc| or |output_routine_loc| or \dots}
@z

@x l.22956
    begin define(p,undefined_cs,null); free_avail(def_ref);
    end
  else  begin if p=output_routine_loc then {enclose in curlies}
@y
    begin sa_define(p,null)(p,undefined_cs,null); free_avail(def_ref);
    end
  else  begin if (p=output_routine_loc)and not e then {enclose in curlies}
@z

@x l.22964
    define(p,call,def_ref);
@y
    sa_define(p,def_ref)(p,call,def_ref);
@z

@x l.22969
begin if cur_cmd=toks_register then
  begin scan_eight_bit_int; cur_cmd:=assign_toks; cur_chr:=toks_base+cur_val;
  end;
if cur_cmd=assign_toks then
  begin q:=equiv(cur_chr);
  if q=null then define(p,undefined_cs,null)
  else  begin add_token_ref(q); define(p,call,q);
    end;
  goto done;
  end;
end
@y
if (cur_cmd=toks_register)or(cur_cmd=assign_toks) then
  begin if cur_cmd=toks_register then
    if cur_chr=mem_bot then
      begin scan_register_num;
      if cur_val<256 then q:=equiv(toks_base+cur_val)
      else  begin find_sa_element(tok_val,cur_val,false);
        if cur_ptr=null then q:=null
        else q:=sa_ptr(cur_ptr);
        end;
      end
    else q:=sa_ptr(cur_chr)
  else q:=equiv(cur_chr);
  if q=null then sa_define(p,null)(p,undefined_cs,null)
  else  begin add_token_ref(q); sa_define(p,q)(p,call,q);
    end;
  goto done;
  end
@z

@x l.23085
begin q:=cur_cmd;
@y
@!e:boolean; {does |l| refer to a sparse array element?}
@!w:integer; {integer or dimen value of |l|}
begin q:=cur_cmd;
e:=false; {just in case, will be set |true| for sparse array elements}
@z

@x l.23102
if p<glue_val then word_define(l,cur_val)
else  begin trap_zero_glue; define(l,glue_ref,cur_val);
@y
if p<glue_val then sa_word_define(l,cur_val)
else  begin trap_zero_glue; sa_define(l,cur_val)(l,glue_ref,cur_val);
@z

@x l.23124
p:=cur_chr; scan_eight_bit_int;
@y
if (cur_chr<mem_bot)or(cur_chr>lo_mem_stat_max) then
  begin l:=cur_chr; p:=sa_type(l); e:=true;
  end
else  begin p:=cur_chr-mem_bot; scan_register_num;
  if cur_val>255 then
    begin find_sa_element(p,cur_val,true); l:=cur_ptr; e:=true;
    end
  else
@z

@x l.23131
end;
found:
@y
  end;
end;
found: if p<glue_val then@+if e then w:=sa_int(l)@+else w:=eqtb[l].int
else if e then s:=sa_ptr(l)@+else s:=equiv(l)
@z

@x l.23137
  if q=advance then cur_val:=cur_val+eqtb[l].int;
@y
  if q=advance then cur_val:=cur_val+w;
@z

@x l.23144
begin q:=new_spec(cur_val); r:=equiv(l);
@y
begin q:=new_spec(cur_val); r:=s;
@z

@x l.23164
    if p=int_val then cur_val:=mult_integers(eqtb[l].int,cur_val)
    else cur_val:=nx_plus_y(eqtb[l].int,cur_val,0)
  else cur_val:=x_over_n(eqtb[l].int,cur_val)
else  begin s:=equiv(l); r:=new_spec(s);
@y
    if p=int_val then cur_val:=mult_integers(w,cur_val)
    else cur_val:=nx_plus_y(w,cur_val,0)
  else cur_val:=x_over_n(w,cur_val)
else  begin r:=new_spec(s);
@z

@x l.23186
set_box: begin scan_eight_bit_int;
  if global then n:=256+cur_val@+else n:=cur_val;
  scan_optional_equals;
  if set_box_allowed then scan_box(box_flag+n)
@y
set_box: begin scan_register_num;
  if global then n:=global_box_flag+cur_val@+else n:=box_flag+cur_val;
  scan_optional_equals;
  if set_box_allowed then scan_box(n)
@z

@x l.23257
var c:0..1; {0 for \.{\\deadcycles}, 1 for \.{\\insertpenalties}}
begin c:=cur_chr; scan_optional_equals; scan_int;
if c=0 then dead_cycles:=cur_val
@y
var c:small_number;
  {0 for \.{\\deadcycles}, 1 for \.{\\insertpenalties}, etc.}
begin c:=cur_chr; scan_optional_equals; scan_int;
if c=0 then dead_cycles:=cur_val
@/@<Cases for |alter_integer|@>@/
@z

@x l.23266
@!b:eight_bits; {box number}
begin c:=cur_chr; scan_eight_bit_int; b:=cur_val; scan_optional_equals;
scan_normal_dimen;
if box(b)<>null then mem[box(b)+c].sc:=cur_val;
@y
@!b:pointer; {box register}
begin c:=cur_chr; scan_register_num; fetch_box(b); scan_optional_equals;
scan_normal_dimen;
if b<>null then mem[b+c].sc:=cur_val;
@z

@x l.23275
set_shape: begin scan_optional_equals; scan_int; n:=cur_val;
  if n<=0 then p:=null
@y
set_shape: begin q:=cur_chr; scan_optional_equals; scan_int; n:=cur_val;
  if n<=0 then p:=null
  else if q>par_shape_loc then
    begin n:=(cur_val div 2)+1; p:=get_node(2*n+1); info(p):=n;
    n:=cur_val; mem[p+1].int:=n; {number of penalties}
    for j:=p+2 to p+n+1 do
      begin scan_int; mem[j].int:=cur_val; {penalty values}
      end;
    if not odd(n) then mem[p+n+2].int:=0; {unused}
    end
@z

@x l.23285
  define(par_shape_loc,shape_ref,p);
@y
  define(q,shape_ref,p);
@z

@x l.23372
common_ending: equiv(u):=f; eqtb[font_id_base+f]:=eqtb[u]; font_id_text(f):=t;
@y
common_ending: define(u,set_font,f); eqtb[font_id_base+f]:=eqtb[u]; font_id_text(f):=t;
@z

@x l.23521
  if a_open_in(read_file[n]) then read_open[n]:=just_open;
@y
  if a_open_in(read_file[n],TEX_INPUTS_PATH_SPEC) then read_open[n]:=just_open;
@z

@x l.23659
  show_lists_code:print_esc("showlists");
@y
  show_lists_code:print_esc("showlists");
  @<Cases of |xray| for |print_cmd_chr|@>@;@/
@z

@x l.23666
var p:pointer; {tail of a token list to show}
@y
var p:pointer; {tail of a token list to show}
@!t:small_number; {type of conditional being shown}
@!m:normal..or_code; {upper bound on |fi_or_else| codes}
@!l:integer; {line where that conditional began}
@!n:integer; {level of \.{\\if...\\fi} nesting}
@z

@x l.23672
othercases @<Show the current value of some parameter or register,
@y
@<Cases for |show_whatever|@>@;@/
othercases @<Show the current value of some parameter or register,
@z

@x l.23707
call: print("macro");
long_call: print_esc("long macro");
outer_call: print_esc("outer macro");
long_outer_call: begin print_esc("long"); print_esc("outer macro");
@y
call,long_call,outer_call,long_outer_call: begin n:=cmd-call;
  if info(link(chr_code))=protected_token then n:=n+4;
  if odd(n div 4) then print_esc("protected");
  if odd(n) then print_esc("long");
  if odd(n div 2) then print_esc("outer");
  if n>0 then print_char(" ");
  print("macro");
@z

@x l.23715
begin scan_eight_bit_int; begin_diagnostic;
print_nl("> \box"); print_int(cur_val); print_char("=");
if box(cur_val)=null then print("void")
else show_box(box(cur_val));
@y
begin scan_register_num; fetch_box(p); begin_diagnostic;
print_nl("> \box"); print_int(cur_val); print_char("=");
if p=null then print("void")@+else show_box(p);
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

@x l.23859
dump_int(@$);@/
@y
dump_int(@$);@/
@<Dump the \eTeX\ state@>@/
@<Dump the \Prote\ state@>@/
@<Dump the |ROM| array@>@/
@z

@x l.23873
x:=fmt_file^.int;
@y
get_fmt_int(x);    {This is reading the first word of the fmt file}
@z

@x l.23874
if x<>@$ then goto bad_fmt; {check that strings are the same}
@y
if x<>@$ then goto bad_fmt; {check that strings are the same}
@/@<Undump the \eTeX\ state@>@/
@/@<Undump the \Prote\ state@>@/
@/@<Undump the |ROM| array@>@/
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

@x l.23928
dump_int(lo_mem_max); dump_int(rover);
@y
dump_int(lo_mem_max); dump_int(rover);
if eTeX_ex then for k:=int_val to tok_val do dump_int(sa_root[k]);
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

@x l.23951
undump(lo_mem_stat_max+1)(lo_mem_max)(rover);
@y
undump(lo_mem_stat_max+1)(lo_mem_max)(rover);
if eTeX_ex then for k:=int_val to tok_val do
  undump(null)(lo_mem_max)(sa_root[k]);
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

@x l.23974
dump_int(par_loc); dump_int(write_loc);@/
@y
dump_int(par_loc); dump_int(write_loc);@/
dump_int(input_loc);@/
@z

@x l.23981
undump(hash_base)(frozen_control_sequence)(write_loc);@/
@y
undump(hash_base)(frozen_control_sequence)(write_loc);@/
undump(hash_base)(frozen_control_sequence)(input_loc);
input_token:=cs_token_flag+input_loc;@/
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

@x l.24145
dump_int(trie_max);
@y
dump_int(trie_max);
dump_int(hyph_start);
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

@x l.24173
undump_size(0)(trie_size)('trie size')(j); @+init trie_max:=j;@+tini
@y
undump_size(0)(trie_size)('trie size')(j); @+init trie_max:=j;@+tini
undump(0)(j)(hyph_start);
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
set_paths(PROTE_PATHS_SET); {get default file paths from the Unix environment}
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

@x l.24393
  print_int(cur_level-level_one); print_char(")");
@y
  print_int(cur_level-level_one); print_char(")");
  if eTeX_ex then show_save_groups;
@z

@x l.24416
    if cur_mark[c]<>null then delete_token_ref(cur_mark[c]);
@y
    if cur_mark[c]<>null then delete_token_ref(cur_mark[c]);
  if sa_mark<>null then
    if do_marks(destroy_marks,0,sa_mark) then sa_mark:=null;
  for c:=last_box_code to vsplit_code do flush_node_list(disc_ptr[c]);
@z

@x l.24426
begin no_new_control_sequence:=false;
@y
begin no_new_control_sequence:=false;
first:=0;
@z

@x l.24441
if (format_ident=0)or(buffer[loc]="&") then
@y
@<Enable \eTeX\ and furthermore Prote, if requested@>@;@/
if (format_ident=0)or(buffer[loc]="&") then
@z

@x l.24449
  end;
@y
  end;
if eTeX_ex then wterm_ln('entering extended mode');
if Prote_ex then begin Prote_initialize;
  wterm_ln('entering prote mode');
  end;
@z

@x l.24493
    begin goto breakpoint;@/ {go to every declared label at least once}
    breakpoint: m:=0; @{'BREAKPOINT'@}@/
    end
@y
    dump_core {Do something to cause a core dump}
@z

@x l.24615
@d set_language_code=5 {command modifier for \.{\\setlanguage}}
@y
@d set_language_code=5 {command modifier for \.{\\setlanguage}}
@d TeX_last_extension_cmd_mod=set_language_code
@z

@x l.24644
  set_language_code:print_esc("setlanguage");
@y
  set_language_code:print_esc("setlanguage");
  @/@<Cases of |extension| for |print_cmd_chr|@>@/
@z

@x l.24665
set_language_code:@<Implement \.{\\setlanguage}@>;
@y
set_language_code:@<Implement \.{\\setlanguage}@>;
@/@<Cases for |do_extension|@>@/
@z

@x l.24754
othercases print("whatsit?")
@y
@/@<Cases for displaying the |whatsit| node@>@/
othercases print("whatsit?")
@z

@x l.24767
othercases confusion("ext2")
@y
@/@<Cases for making a partial copy of the whatsit node@>@/
othercases confusion("ext2")
@z

@x l.24777
close_node,language_node: free_node(p,small_node_size);
othercases confusion("ext3")
@y
close_node,language_node: free_node(p,small_node_size);
@/@<Cases for wiping out the whatsit node@>@/
othercases confusion("ext3")
@z

@x l.24791
    begin cur_lang:=what_lang(#); l_hyf:=what_lhm(#); r_hyf:=what_rhm(#);@+end
@y
    begin cur_lang:=what_lang(#); l_hyf:=what_lhm(#); r_hyf:=what_rhm(#);
    set_hyph_index;
    end
@z

@x l.24902
procedure out_what(@!p:pointer);
@y
@t\4@>@<Declare procedures needed in |out_what|@>@;
procedure out_what(@!p:pointer);
@z

@x l.24908
language_node:do_nothing;
othercases confusion("ext4")
@y
language_node:do_nothing;
@/@<Cases for |out_what|@>@/
othercases confusion("ext4")
@z

@x l.24985
@* \[54] System-dependent changes.
@y
@* \[53a] The extended features of \eTeX.
The program has three modes of operation:  (1)~In \TeX\ compatibility mode
it fully deserves the name \TeX\ and there are neither extended features
nor additional primitive commands.  There are, however, a few
modifications that would be legitimate in any implementation of \TeX\
such as, e.g., preventing inadequate results of the glue to \.{DVI}
unit conversion during |ship_out|.  (2)~In extended mode there are
additional primitive commands and the extended features of \eTeX\ are
available.  (3)~In \Prote\ mode there are supplementary primitive
commands that will be discussed in the \[53b] section below.

The distinction between these three modes of operation initially takes
place when a `virgin' \.{eINITEX} starts without reading a format file.
Later on the values of all \eTeX\ state variables are inherited when
\.{eVIRTEX} (or \.{eINITEX}) reads a format file.

The code below is designed to work for cases where `$|init|\ldots|tini|$'
is a run-time switch.

@<Enable \eTeX\ and furthermore Prote, if requested@>=
@!init if (buffer[loc]="*")and(format_ident=" (INITEX)") then
  begin no_new_control_sequence:=false;
  @<Generate all \eTeX\ primitives@>@;
  incr(loc); eTeX_mode:=1; {enter extended mode}
  @<Initialize variables for \eTeX\ extended mode@>@;
  if buffer[loc]="*" then begin
    @<Check \Prote\ ``constant'' values for consistency@>@;
    @<Generate all \Prote\ primitives@>@;
    incr(loc); Prote_mode:=1; {enter \Prote\ mode}
    end;
  end;
tini@;@/
if not no_new_control_sequence then {just entered extended mode ?}
  no_new_control_sequence:=true@+else

@ The \eTeX\ features available in extended mode are grouped into two
categories:  (1)~Some of them are permanently enabled and have no
semantic effect as long as none of the additional primitives are
executed.  (2)~The remaining \eTeX\ features are optional and can be
individually enabled and disabled.  For each optional feature there is
an \eTeX\ state variable named \.{\\...state}; the feature is enabled,
resp.\ disabled by assigning a positive, resp.\ non-positive value to
that integer.

@d eTeX_state_base=int_base+eTeX_state_code
@d eTeX_state(#)==eqtb[eTeX_state_base+#].int {an \eTeX\ state variable}
@#
@d eTeX_version_code=eTeX_int {code for \.{\\eTeXversion}}

@<Generate all \eTeX...@>=
primitive("lastnodetype",last_item,last_node_type_code);
@!@:last_node_type_}{\.{\\lastnodetype} primitive@>
primitive("eTeXversion",last_item,eTeX_version_code);
@!@:eTeX_version_}{\.{\\eTeXversion} primitive@>
primitive("eTeXrevision",convert,eTeX_revision_code);@/
@!@:eTeX_revision_}{\.{\\eTeXrevision} primitive@>

@ @<Cases of |last_item| for |print_cmd_chr|@>=
last_node_type_code: print_esc("lastnodetype");
eTeX_version_code: print_esc("eTeXversion");

@ @<Cases for fetching an integer value@>=
eTeX_version_code: cur_val:=eTeX_version;

@ @d eTeX_ex==(eTeX_mode=1) {is this extended mode?}

@<Glob...@>=
@!eTeX_mode: 0..1; {identifies compatibility and extended mode}

@ @<Initialize table entries...@>=
eTeX_mode:=0; {initially we are in compatibility mode}
@<Initialize variables for \eTeX\ compatibility mode@>@;

@ @<Dump the \eTeX\ state@>=
dump_int(eTeX_mode);
for j:=0 to eTeX_states-1 do eTeX_state(j):=0; {disable all enhancements}

@ @<Undump the \eTeX\ state@>=
undump(0)(1)(eTeX_mode);
if eTeX_ex then
  begin @<Initialize variables for \eTeX\ extended mode@>@;
  end
else  begin @<Initialize variables for \eTeX\ compatibility mode@>@;
  end;

@ The |eTeX_enabled| function simply returns its first argument as
result.  This argument is |true| if an optional \eTeX\ feature is
currently enabled; otherwise, if the argument is |false|, the function
gives an error message.

@<Declare \eTeX\ procedures for use...@>=
function eTeX_enabled(@!b:boolean;@!j:quarterword;@!k:halfword):boolean;
begin if not b then
  begin print_err("Improper "); print_cmd_chr(j,k);
  help1("Sorry, this optional e-TeX feature has been disabled."); error;
  end;
eTeX_enabled:=b;
end;

@ First we implement the additional \eTeX\ parameters in the table of
equivalents.

@<Generate all \eTeX...@>=
primitive("everyeof",assign_toks,every_eof_loc);
@!@:every_eof_}{\.{\\everyeof} primitive@>
primitive("tracingassigns",assign_int,int_base+tracing_assigns_code);@/
@!@:tracing_assigns_}{\.{\\tracingassigns} primitive@>
primitive("tracinggroups",assign_int,int_base+tracing_groups_code);@/
@!@:tracing_groups_}{\.{\\tracinggroups} primitive@>
primitive("tracingifs",assign_int,int_base+tracing_ifs_code);@/
@!@:tracing_ifs_}{\.{\\tracingifs} primitive@>
primitive("tracingscantokens",assign_int,int_base+tracing_scan_tokens_code);@/
@!@:tracing_scan_tokens_}{\.{\\tracingscantokens} primitive@>
primitive("tracingnesting",assign_int,int_base+tracing_nesting_code);@/
@!@:tracing_nesting_}{\.{\\tracingnesting} primitive@>
primitive("predisplaydirection",
  assign_int,int_base+pre_display_direction_code);@/
@!@:pre_display_direction_}{\.{\\predisplaydirection} primitive@>
primitive("lastlinefit",assign_int,int_base+last_line_fit_code);@/
@!@:last_line_fit_}{\.{\\lastlinefit} primitive@>
primitive("savingvdiscards",assign_int,int_base+saving_vdiscards_code);@/
@!@:saving_vdiscards_}{\.{\\savingvdiscards} primitive@>
primitive("savinghyphcodes",assign_int,int_base+saving_hyph_codes_code);@/
@!@:saving_hyph_codes_}{\.{\\savinghyphcodes} primitive@>

@ @d every_eof==equiv(every_eof_loc)

@<Cases of |assign_toks| for |print_cmd_chr|@>=
every_eof_loc: print_esc("everyeof");

@ @<Cases for |print_param|@>=
tracing_assigns_code:print_esc("tracingassigns");
tracing_groups_code:print_esc("tracinggroups");
tracing_ifs_code:print_esc("tracingifs");
tracing_scan_tokens_code:print_esc("tracingscantokens");
tracing_nesting_code:print_esc("tracingnesting");
pre_display_direction_code:print_esc("predisplaydirection");
last_line_fit_code:print_esc("lastlinefit");
saving_vdiscards_code:print_esc("savingvdiscards");
saving_hyph_codes_code:print_esc("savinghyphcodes");

@ In order to handle \.{\\everyeof} we need an array |eof_seen| of
boolean variables.

@<Glob...@>=
@!eof_seen : array[1..max_in_open] of boolean; {has eof been seen?}

@ The |print_group| procedure prints the current level of grouping and
the name corresponding to |cur_group|.

@<Declare \eTeX\ procedures for tr...@>=
procedure print_group(@!e:boolean);
label exit;
begin case cur_group of
  bottom_level: begin print("bottom level"); return;
    end;
  simple_group,semi_simple_group:
    begin if cur_group=semi_simple_group then print("semi ");
    print("simple");
    end;
  hbox_group,adjusted_hbox_group:
    begin if cur_group=adjusted_hbox_group then print("adjusted ");
    print("hbox");
    end;
  vbox_group: print("vbox");
  vtop_group: print("vtop");
  align_group,no_align_group:
    begin if cur_group=no_align_group then print("no ");
    print("align");
    end;
  output_group: print("output");
  disc_group: print("disc");
  insert_group: print("insert");
  vcenter_group: print("vcenter");
  math_group,math_choice_group,math_shift_group,math_left_group:
    begin print("math");
    if cur_group=math_choice_group then print(" choice")
    else if cur_group=math_shift_group then print(" shift")
    else if cur_group=math_left_group then print(" left");
    end;
  end; {there are no other cases}
print(" group (level "); print_int(qo(cur_level)); print_char(")");
if saved(-1)<>0 then
  begin if e then print(" entered at line ") else print(" at line ");
  print_int(saved(-1));
  end;
exit:end;

@ The |group_trace| procedure is called when a new level of grouping
begins (|e=false|) or ends (|e=true|) with |saved(-1)| containing the
line number.

@<Declare \eTeX\ procedures for tr...@>=
@!stat procedure group_trace(@!e:boolean);
begin begin_diagnostic; print_char("{");
if e then print("leaving ") else print("entering ");
print_group(e); print_char("}"); end_diagnostic(false);
end;
tats

@ The \.{\\currentgrouplevel} and \.{\\currentgrouptype} commands return
the current level of grouping and the type of the current group
respectively.

@d current_group_level_code=eTeX_int+1 {code for \.{\\currentgrouplevel}}
@d current_group_type_code=eTeX_int+2 {code for \.{\\currentgrouptype}}

@<Generate all \eTeX...@>=
primitive("currentgrouplevel",last_item,current_group_level_code);
@!@:current_group_level_}{\.{\\currentgrouplevel} primitive@>
primitive("currentgrouptype",last_item,current_group_type_code);
@!@:current_group_type_}{\.{\\currentgrouptype} primitive@>

@ @<Cases of |last_item| for |print_cmd_chr|@>=
current_group_level_code: print_esc("currentgrouplevel");
current_group_type_code: print_esc("currentgrouptype");

@ @<Cases for fetching an integer value@>=
current_group_level_code: cur_val:=cur_level-level_one;
current_group_type_code: cur_val:=cur_group;

@ The \.{\\currentiflevel}, \.{\\currentiftype}, and
\.{\\currentifbranch} commands return the current level of conditionals
and the type and branch of the current conditional.

@d current_if_level_code=eTeX_int+3 {code for \.{\\currentiflevel}}
@d current_if_type_code=eTeX_int+4 {code for \.{\\currentiftype}}
@d current_if_branch_code=eTeX_int+5 {code for \.{\\currentifbranch}}

@<Generate all \eTeX...@>=
primitive("currentiflevel",last_item,current_if_level_code);
@!@:current_if_level_}{\.{\\currentiflevel} primitive@>
primitive("currentiftype",last_item,current_if_type_code);
@!@:current_if_type_}{\.{\\currentiftype} primitive@>
primitive("currentifbranch",last_item,current_if_branch_code);
@!@:current_if_branch_}{\.{\\currentifbranch} primitive@>

@ @<Cases of |last_item| for |print_cmd_chr|@>=
current_if_level_code: print_esc("currentiflevel");
current_if_type_code: print_esc("currentiftype");
current_if_branch_code: print_esc("currentifbranch");

@ @<Cases for fetching an integer value@>=
current_if_level_code: begin q:=cond_ptr; cur_val:=0;
  while q<>null do
    begin incr(cur_val); q:=link(q);
    end;
  end;
current_if_type_code: if cond_ptr=null then cur_val:=0
  else if cur_if<unless_code then cur_val:=cur_if+1
  else cur_val:=-(cur_if-unless_code+1);
current_if_branch_code:
  if (if_limit=or_code)or(if_limit=else_code) then cur_val:=1
  else if if_limit=fi_code then cur_val:=-1
  else cur_val:=0;

@ The \.{\\fontcharwd}, \.{\\fontcharht}, \.{\\fontchardp}, and
\.{\\fontcharic} commands return information about a character in a
font.

@d font_char_wd_code=eTeX_dim {code for \.{\\fontcharwd}}
@d font_char_ht_code=eTeX_dim+1 {code for \.{\\fontcharht}}
@d font_char_dp_code=eTeX_dim+2 {code for \.{\\fontchardp}}
@d font_char_ic_code=eTeX_dim+3 {code for \.{\\fontcharic}}

@<Generate all \eTeX...@>=
primitive("fontcharwd",last_item,font_char_wd_code);
@!@:font_char_wd_}{\.{\\fontcharwd} primitive@>
primitive("fontcharht",last_item,font_char_ht_code);
@!@:font_char_ht_}{\.{\\fontcharht} primitive@>
primitive("fontchardp",last_item,font_char_dp_code);
@!@:font_char_dp_}{\.{\\fontchardp} primitive@>
primitive("fontcharic",last_item,font_char_ic_code);
@!@:font_char_ic_}{\.{\\fontcharic} primitive@>

@ @<Cases of |last_item| for |print_cmd_chr|@>=
font_char_wd_code: print_esc("fontcharwd");
font_char_ht_code: print_esc("fontcharht");
font_char_dp_code: print_esc("fontchardp");
font_char_ic_code: print_esc("fontcharic");

@ @<Cases for fetching a dimension value@>=
font_char_wd_code,
font_char_ht_code,
font_char_dp_code,
font_char_ic_code: begin scan_font_ident; q:=cur_val; scan_char_num;
  if (font_bc[q]<=cur_val)and(font_ec[q]>=cur_val) then
    begin i:=char_info(q)(qi(cur_val));
    case m of
    font_char_wd_code: cur_val:=char_width(q)(i);
    font_char_ht_code: cur_val:=char_height(q)(height_depth(i));
    font_char_dp_code: cur_val:=char_depth(q)(height_depth(i));
    font_char_ic_code: cur_val:=char_italic(q)(i);
    end; {there are no other cases}
    end
  else cur_val:=0;
  end;

@ The \.{\\parshapedimen}, \.{\\parshapeindent}, and \.{\\parshapelength}
commands return the indent and length parameters of the current
\.{\\parshape} specification.

@d par_shape_length_code=eTeX_dim+4 {code for \.{\\parshapelength}}
@d par_shape_indent_code=eTeX_dim+5 {code for \.{\\parshapeindent}}
@d par_shape_dimen_code=eTeX_dim+6 {code for \.{\\parshapedimen}}

@<Generate all \eTeX...@>=
primitive("parshapelength",last_item,par_shape_length_code);
@!@:par_shape_length_}{\.{\\parshapelength} primitive@>
primitive("parshapeindent",last_item,par_shape_indent_code);
@!@:par_shape_indent_}{\.{\\parshapeindent} primitive@>
primitive("parshapedimen",last_item,par_shape_dimen_code);
@!@:par_shape_dimen_}{\.{\\parshapedimen} primitive@>

@ @<Cases of |last_item| for |print_cmd_chr|@>=
par_shape_length_code: print_esc("parshapelength");
par_shape_indent_code: print_esc("parshapeindent");
par_shape_dimen_code: print_esc("parshapedimen");

@ @<Cases for fetching a dimension value@>=
par_shape_length_code,
par_shape_indent_code,
par_shape_dimen_code: begin q:=cur_chr-par_shape_length_code; scan_int;
  if (par_shape_ptr=null)or(cur_val<=0) then cur_val:=0
  else  begin if q=2 then
      begin q:=cur_val mod 2; cur_val:=(cur_val+q)div 2;
      end;
    if cur_val>info(par_shape_ptr) then cur_val:=info(par_shape_ptr);
    cur_val:=mem[par_shape_ptr+2*cur_val-q].sc;
    end;
  cur_val_level:=dimen_val;
  end;

@ The \.{\\showgroups} command displays all currently active grouping
levels.

@d show_groups=4 { \.{\\showgroups} }

@<Generate all \eTeX...@>=
primitive("showgroups",xray,show_groups);
@!@:show_groups_}{\.{\\showgroups} primitive@>

@ @<Cases of |xray| for |print_cmd_chr|@>=
show_groups:print_esc("showgroups");

@ @<Cases for |show_whatever|@>=
show_groups: begin begin_diagnostic; show_save_groups;
  end;

@ @<Types...@>=
@!save_pointer=0..save_size; {index into |save_stack|}

@ The modifications of \TeX\ required for the display produced by the
|show_save_groups| procedure were first discussed by Donald~E. Knuth in
{\sl TUGboat\/} {\bf 11}, 165--170 and 499--511, 1990.
@^Knuth, Donald Ervin@>

In order to understand a group type we also have to know its mode.
Since unrestricted horizontal modes are not associated with grouping,
they are skipped when traversing the semantic nest.

@<Declare \eTeX\ procedures for use...@>=
procedure show_save_groups;
label found1,found2,found,done;
var p:0..nest_size; {index into |nest|}
@!m:-mmode..mmode; {mode}
@!v:save_pointer; {saved value of |save_ptr|}
@!l:quarterword; {saved value of |cur_level|}
@!c:group_code; {saved value of |cur_group|}
@!a:-1..1; {to keep track of alignments}
@!i:integer;
@!j:quarterword;
@!s:str_number;
begin p:=nest_ptr; nest[p]:=cur_list; {put the top level into the array}
v:=save_ptr; l:=cur_level; c:=cur_group;
save_ptr:=cur_boundary; decr(cur_level);@/
a:=1;
print_nl(""); print_ln;
loop@+begin print_nl("### "); print_group(true);
  if cur_group=bottom_level then goto done;
  repeat m:=nest[p].mode_field;
  if p>0 then decr(p) else m:=vmode;
  until m<>hmode;
  print(" (");
  case cur_group of
    simple_group: begin incr(p); goto found2;
      end;
    hbox_group,adjusted_hbox_group: s:="hbox";
    vbox_group: s:="vbox";
    vtop_group: s:="vtop";
    align_group: if a=0 then
        begin if m=-vmode then s:="halign" else s:="valign";
        a:=1; goto found1;
        end
      else  begin if a=1 then print("align entry") else print_esc("cr");
        if p>=a then p:=p-a;
        a:=0; goto found;
        end;
    no_align_group:
      begin incr(p); a:=-1; print_esc("noalign"); goto found2;
      end;
    output_group:
      begin print_esc("output"); goto found;
      end;
    math_group: goto found2;
    disc_group,math_choice_group:
      begin if cur_group=disc_group then print_esc("discretionary")
      else print_esc("mathchoice");
      for i:=1 to 3 do if i<=saved(-2) then print("{}");
      goto found2;
      end;
    insert_group:
      begin if saved(-2)=255 then print_esc("vadjust")
      else  begin print_esc("insert"); print_int(saved(-2));
        end;
      goto found2;
      end;
    vcenter_group: begin s:="vcenter"; goto found1;
      end;
    semi_simple_group: begin incr(p); print_esc("begingroup"); goto found;
      end;
    math_shift_group:
      begin if m=mmode then print_char("$")
      else if nest[p].mode_field=mmode then
        begin print_cmd_chr(eq_no,saved(-2)); goto found;
        end;
      print_char("$"); goto found;
      end;
    math_left_group:
      begin if type(nest[p+1].eTeX_aux_field)=left_noad then print_esc("left")
      else print_esc("middle");
      goto found;
      end;
    end; {there are no other cases}
  @<Show the box context@>;
  found1: print_esc(s); @<Show the box packaging info@>;
  found2: print_char("{");
  found: print_char(")"); decr(cur_level);
  cur_group:=save_level(save_ptr); save_ptr:=save_index(save_ptr)
  end;
done: save_ptr:=v; cur_level:=l; cur_group:=c;
end;

@ @<Show the box packaging info@>=
if saved(-2)<>0 then
  begin print_char(" ");
  if saved(-3)=exactly then print("to") else print("spread");
  print_scaled(saved(-2)); print("pt");
  end

@ @<Show the box context@>=
i:=saved(-4);
if i<>0 then
  if i<box_flag then
    begin if abs(nest[p].mode_field)=vmode then j:=hmove else j:=vmove;
    if i>0 then print_cmd_chr(j,0) else print_cmd_chr(j,1);
    print_scaled(abs(i)); print("pt");
    end
  else if i<ship_out_flag then
    begin if i>=global_box_flag then
      begin print_esc("global"); i:=i-(global_box_flag-box_flag);
      end;
    print_esc("setbox"); print_int(i-box_flag); print_char("=");
    end
  else print_cmd_chr(leader_ship,i-(leader_flag-a_leaders))

@ The |scan_general_text| procedure is much like |scan_toks(false,false)|,
but will be invoked via |expand|, i.e., recursively.
@^recursion@>

@<Declare \eTeX\ procedures for sc...@>=
procedure@?scan_general_text; forward;@t\2@>

@ The token list (balanced text) created by |scan_general_text| begins
at |link(temp_head)| and ends at |cur_val|.  (If |cur_val=temp_head|,
the list is empty.)

@<Declare \eTeX\ procedures for tok...@>=
procedure scan_general_text;
label found;
var s:normal..absorbing; {to save |scanner_status|}
@!w:pointer; {to save |warning_index|}
@!d:pointer; {to save |def_ref|}
@!p:pointer; {tail of the token list being built}
@!q:pointer; {new node being added to the token list via |store_new_token|}
@!unbalance:halfword; {number of unmatched left braces}
begin s:=scanner_status; w:=warning_index; d:=def_ref;
scanner_status:=absorbing; warning_index:=cur_cs;
def_ref:=get_avail; token_ref_count(def_ref):=null; p:=def_ref;
scan_left_brace; {remove the compulsory left brace}
unbalance:=1;
loop@+  begin get_token;
  if cur_tok<right_brace_limit then
    if cur_cmd<right_brace then incr(unbalance)
    else  begin decr(unbalance);
      if unbalance=0 then goto found;
      end;
  store_new_token(cur_tok);
  end;
found: q:=link(def_ref); free_avail(def_ref); {discard reference count}
if q=null then cur_val:=temp_head @+ else cur_val:=p;
link(temp_head):=q;
scanner_status:=s; warning_index:=w; def_ref:=d;
end;

@ The \.{\\showtokens} command displays a token list.

@d show_tokens=5 { \.{\\showtokens} , must be odd! }

@<Generate all \eTeX...@>=
primitive("showtokens",xray,show_tokens);
@!@:show_tokens_}{\.{\\showtokens} primitive@>

@ @<Cases of |xray| for |print_cmd_chr|@>=
show_tokens:print_esc("showtokens");

@ The \.{\\unexpanded} primitive prevents expansion of tokens much as
the result from \.{\\the} applied to a token variable.  The
\.{\\detokenize} primitive converts a token list into a list of
character tokens much as if the token list were written to a file.  We
use the fact that the command modifiers for \.{\\unexpanded} and
\.{\\detokenize} are odd whereas those for \.{\\the} and \.{\\showthe}
are even.

@<Generate all \eTeX...@>=
primitive("unexpanded",the,1);@/
@!@:unexpanded_}{\.{\\unexpanded} primitive@>
primitive("detokenize",the,show_tokens);@/
@!@:detokenize_}{\.{\\detokenize} primitive@>

@ @<Cases of |the| for |print_cmd_chr|@>=
else if chr_code=1 then print_esc("unexpanded")
else print_esc("detokenize")

@ @<Handle \.{\\unexpanded} or \.{\\detokenize} and |return|@>=
if odd(cur_chr) then
  begin c:=cur_chr; scan_general_text;
  if c=1 then the_toks:=cur_val
  else begin old_setting:=selector; selector:=new_string; b:=pool_ptr;
    p:=get_avail; link(p):=link(temp_head);
    token_show(p); flush_list(p);
    selector:=old_setting; the_toks:=str_toks(b);
    end;
  return;
  end

@ The \.{\\showifs} command displays all currently active conditionals.

@d show_ifs=6 { \.{\\showifs} }

@<Generate all \eTeX...@>=
primitive("showifs",xray,show_ifs);
@!@:show_ifs_}{\.{\\showifs} primitive@>

@ @<Cases of |xray| for |print_cmd_chr|@>=
show_ifs:print_esc("showifs");

@
@d print_if_line(#)==if #<>0 then
  begin print(" entered on line "); print_int(#);
  end

@<Cases for |show_whatever|@>=
show_ifs: begin begin_diagnostic; print_nl(""); print_ln;
  if cond_ptr=null then
    begin print_nl("### "); print("no active conditionals");
    end
  else  begin p:=cond_ptr; n:=0;
    repeat incr(n); p:=link(p);@+until p=null;
    p:=cond_ptr; t:=cur_if; l:=if_line; m:=if_limit;
    repeat print_nl("### level "); print_int(n); print(": ");
    print_cmd_chr(if_test,t);
    if m=fi_code then print_esc("else");
    print_if_line(l);
    decr(n); t:=subtype(p); l:=if_line_field(p); m:=type(p); p:=link(p);
    until p=null;
    end;
  end;

@ The \.{\\interactionmode} primitive allows to query and set the
interaction mode.

@<Generate all \eTeX...@>=
primitive("interactionmode",set_page_int,2);
@!@:interaction_mode_}{\.{\\interactionmode} primitive@>

@ @<Cases of |set_page_int| for |print_cmd_chr|@>=
else if chr_code=2 then print_esc("interactionmode")

@ @<Cases for `Fetch the |dead_cycles| or the |insert_penalties|'@>=
else if m=2 then cur_val:=interaction

@ @<Declare \eTeX\ procedures for use...@>=
procedure@?new_interaction; forward;@t\2@>

@ @<Cases for |alter_integer|@>=
else if c=2 then
  begin if (cur_val<batch_mode)or(cur_val>error_stop_mode) then
    begin print_err("Bad interaction mode");
@.Bad interaction mode@>
    help2("Modes are 0=batch, 1=nonstop, 2=scroll, and")@/
    ("3=errorstop. Proceed, and I'll ignore this case.");
    int_error(cur_val);
    end
  else  begin cur_chr:=cur_val; new_interaction;
    end;
  end

@ The |middle| feature of \eTeX\ allows one ore several \.{\\middle}
delimiters to appear between \.{\\left} and \.{\\right}.

@<Generate all \eTeX...@>=
primitive("middle",left_right,middle_noad);
@!@:middle_}{\.{\\middle} primitive@>

@ @<Cases of |left_right| for |print_cmd_chr|@>=
else if chr_code=middle_noad then print_esc("middle")

@ In constructions such as
$$\vbox{\halign{\.{#}\hfil\cr
{}\\hbox to \\hsize\{\cr
\hskip 25pt \\hskip 0pt plus 0.0001fil\cr
\hskip 25pt ...\cr
\hskip 25pt \\hfil\\penalty-200\\hfilneg\cr
\hskip 25pt ...\}\cr}}$$
the stretch components of \.{\\hfil} and \.{\\hfilneg} compensate; they may,
however, get modified in order to prevent arithmetic overflow during
|hlist_out| when each of them is multiplied by a large |glue_set| value.

Since this ``glue rounding'' depends on state variables |cur_g| and
|cur_glue| and \TeXXeT\ is supposed to emulate the behaviour of \TeXeT\
(plus a suitable postprocessor) as close as possible the glue rounding
cannot be postponed until (segments of) an hlist has been reversed.

The code below is invoked after the effective width, |rule_wd|, of a glue
node has been computed. The glue node is either converted into a kern node
or, for leaders, the glue specification is replaced by an equivalent rigid
one; the subtype of the glue node remains unchanged.

@<Handle a glue node for mixed...@>=
if (((g_sign=stretching) and (stretch_order(g)=g_order)) or
    ((g_sign=shrinking) and (shrink_order(g)=g_order))) then
  begin fast_delete_glue_ref(g);
  if subtype(p)<a_leaders then
    begin type(p):=kern_node; width(p):=rule_wd;
    end
  else  begin g:=get_node(glue_spec_size);@/
    stretch_order(g):=filll+1; shrink_order(g):=filll+1; {will never match}
    width(g):=rule_wd; stretch(g):=0; shrink(g):=0; glue_ptr(p):=g;
    end;
  end

@ The optional |TeXXeT| feature of \eTeX\ contains the code for mixed
left-to-right and right-to-left typesetting.  This code is inspired by
but different from \TeXeT\ as presented by Donald~E. Knuth and Pierre
MacKay in {\sl TUGboat\/} {\bf 8}, 14--25, 1987.
@^Knuth, Donald Ervin@>
@^MacKay, Pierre@>

In order to avoid confusion with \TeXeT\ the present implementation of
mixed direction typesetting is called \TeXXeT.  It differs from \TeXeT\
in several important aspects:  (1)~Right-to-left text is reversed
explicitly by the |ship_out| routine and is written to a normal \.{DVI}
file without any |begin_reflect| or |end_reflect| commands; (2)~a
|math_node| is (ab)used instead of a |whatsit_node| to record the
\.{\\beginL}, \.{\\endL}, \.{\\beginR}, and \.{\\endR} text direction
primitives in order to keep the influence on the line breaking algorithm
for pure left-to-right text as small as possible; (3)~right-to-left text
interrupted by a displayed equation is automatically resumed after that
equation; and (4)~the |valign| command code with a non-zero command
modifier is (ab)used for the text direction primitives.

Nevertheless there is a subtle difference between \TeX\ and \TeXXeT\
that may influence the line breaking algorithm for pure left-to-right
text.  When a paragraph containing math mode material is broken into
lines \TeX\ may generate lines where math mode material is not enclosed
by properly nested \.{\\mathon} and \.{\\mathoff} nodes.  Unboxing such
lines as part of a new paragraph may have the effect that hyphenation is
attempted for `words' originating from math mode or that hyphenation is
inhibited for words originating from horizontal mode.

In \TeXXeT\ additional \.{\\beginM}, resp.\ \.{\\endM} math nodes are
supplied at the start, resp.\ end of lines such that math mode material
inside a horizontal list always starts with either \.{\\mathon} or
\.{\\beginM} and ends with \.{\\mathoff} or \.{\\endM}.  These
additional nodes are transparent to operations such as \.{\\unskip},
\.{\\lastpenalty}, or \.{\\lastbox} but they do have the effect that
hyphenation is never attempted for `words' originating from math mode
and is never inhibited for words originating from horizontal mode.

@d TeXXeT_state==eTeX_state(TeXXeT_code)
@d TeXXeT_en==(TeXXeT_state>0) {is \TeXXeT\ enabled?}

@<Cases for |print_param|@>=
eTeX_state_code+TeXXeT_code:print_esc("TeXXeTstate");

@ @<Generate all \eTeX...@>=
primitive("TeXXeTstate",assign_int,eTeX_state_base+TeXXeT_code);
@!@:TeXXeT_state_}{\.{\\TeXXeT_state} primitive@>
primitive("beginL",valign,begin_L_code);
@!@:beginL_}{\.{\\beginL} primitive@>
primitive("endL",valign,end_L_code);
@!@:endL_}{\.{\\endL} primitive@>
primitive("beginR",valign,begin_R_code);
@!@:beginR_}{\.{\\beginR} primitive@>
primitive("endR",valign,end_R_code);
@!@:endR_}{\.{\\endR} primitive@>

@ @<Cases of |valign| for |print_cmd_chr|@>=
else case chr_code of
  begin_L_code: print_esc("beginL");
  end_L_code: print_esc("endL");
  begin_R_code: print_esc("beginR");
  othercases print_esc("endR")
  endcases

@ @<Cases of |main_control| for |hmode+valign|@>=
if cur_chr>0 then
  begin if eTeX_enabled(TeXXeT_en,cur_cmd,cur_chr) then
@.Improper \\beginL@>
@.Improper \\endL@>
@.Improper \\beginR@>
@.Improper \\endR@>
    tail_append(new_math(0,cur_chr));
  end
else

@ An hbox with subtype dlist will never be reversed, even when embedded
in right-to-left text.

@<Display if this box is never to be reversed@>=
if (type(p)=hlist_node)and(box_lr(p)=dlist) then print(", display")

@ A number of routines are based on a stack of one-word nodes whose
|info| fields contain |end_M_code|, |end_L_code|, or |end_R_code|.  The
top of the stack is pointed to by |LR_ptr|.

When the stack manipulation macros of this section are used below,
variable |LR_ptr| might be the global variable declared here for |hpack|
and |ship_out|, or might be local to |post_line_break|.

@d put_LR(#)==begin temp_ptr:=get_avail; info(temp_ptr):=#;
  link(temp_ptr):=LR_ptr; LR_ptr:=temp_ptr;
  end
@#
@d push_LR(#)==put_LR(end_LR_type(#))
@#
@d pop_LR==begin temp_ptr:=LR_ptr; LR_ptr:=link(temp_ptr);
  free_avail(temp_ptr);
  end

@<Glob...@>=
@!LR_ptr:pointer; {stack of LR codes for |hpack|, |ship_out|, and |init_math|}
@!LR_problems:integer; {counts missing begins and ends}
@!cur_dir:small_number; {current text direction}

@ @<Set init...@>=
LR_ptr:=null; LR_problems:=0; cur_dir:=left_to_right;

@ @<Insert LR nodes at the beg...@>=
begin q:=link(temp_head);
if LR_ptr<>null then
  begin temp_ptr:=LR_ptr; r:=q;
  repeat s:=new_math(0,begin_LR_type(info(temp_ptr))); link(s):=r; r:=s;
  temp_ptr:=link(temp_ptr);
  until temp_ptr=null;
  link(temp_head):=r;
  end;
while q<>cur_break(cur_p) do
  begin if not is_char_node(q) then
    if type(q)=math_node then @<Adjust \(t)the LR stack for the |p...@>;
  q:=link(q);
  end;
end

@ @<Adjust \(t)the LR stack for the |p...@>=
if end_LR(q) then
  begin if LR_ptr<>null then if info(LR_ptr)=end_LR_type(q) then pop_LR;
  end
else push_LR(q)

@ We use the fact that |q| now points to the node with \.{\\rightskip} glue.

@<Insert LR nodes at the end...@>=
if LR_ptr<>null then
  begin s:=temp_head; r:=link(s);
  while r<>q do
    begin s:=r; r:=link(s);
    end;
  r:=LR_ptr;
  while r<>null do
    begin temp_ptr:=new_math(0,info(r));
    link(s):=temp_ptr; s:=temp_ptr; r:=link(r);
    end;
  link(s):=q;
  end

@ @<Initialize the LR stack@>=
put_LR(before) {this will never match}

@ @<Adjust \(t)the LR stack for the |hp...@>=
if end_LR(p) then
  if info(LR_ptr)=end_LR_type(p) then pop_LR
  else  begin incr(LR_problems); type(p):=kern_node; subtype(p):=explicit;
    end
else push_LR(p)

@ @<Check for LR anomalies at the end of |hp...@>=
begin if info(LR_ptr)<>before then
  begin while link(q)<>null do q:=link(q);
  repeat temp_ptr:=q; q:=new_math(0,info(LR_ptr)); link(temp_ptr):=q;
  LR_problems:=LR_problems+10000; pop_LR;
  until info(LR_ptr)=before;
  end;
if LR_problems>0 then
  begin @<Report LR problems@>; goto common_ending;
  end;
pop_LR;
if LR_ptr<>null then confusion("LR1");
@:this can't happen LR1}{\quad LR1@>
end

@ @<Report LR problems@>=
begin print_ln; print_nl("\endL or \endR problem (");@/
print_int(LR_problems div 10000); print(" missing, ");@/
print_int(LR_problems mod 10000); print(" extra");@/
LR_problems:=0;
end

@ @<Initialize |hlist_out| for mixed...@>=
if eTeX_ex then
  begin @<Initialize the LR stack@>;
  if box_lr(this_box)=dlist then
    if cur_dir=right_to_left then
      begin cur_dir:=left_to_right; cur_h:=cur_h-width(this_box);
      end
    else set_box_lr(this_box)(0);
  if (cur_dir=right_to_left)and(box_lr(this_box)<>reversed) then
    @<Reverse the complete hlist and set the subtype to |reversed|@>;
  end

@ @<Finish |hlist_out| for mixed...@>=
if eTeX_ex then
  begin @<Check for LR anomalies at the end of |hlist_out|@>;
  if box_lr(this_box)=dlist then cur_dir:=right_to_left;
  end

@ @<Handle a math node in |hlist_out|@>=
begin if eTeX_ex then
    @<Adjust \(t)the LR stack for the |hlist_out| routine; if necessary
      reverse an hlist segment and |goto reswitch|@>;
  cur_h:=cur_h+width(p);
  end

@ Breaking a paragraph into lines while \TeXXeT\ is disabled may result
in lines whith unpaired math nodes.  Such hlists are silently accepted
in the absence of text direction directives.

@d LR_dir(#)==(subtype(#) div R_code) {text direction of a `math node'}

@<Adjust \(t)the LR stack for the |hl...@>=
begin if end_LR(p) then
  if info(LR_ptr)=end_LR_type(p) then pop_LR
  else  begin if subtype(p)>L_code then incr(LR_problems);
    end
else  begin push_LR(p);
  if LR_dir(p)<>cur_dir then
    @<Reverse an hlist segment and |goto reswitch|@>;
  end;
type(p):=kern_node;
end

@ @<Check for LR anomalies at the end of |hl...@>=
begin while info(LR_ptr)<>before do
  begin if info(LR_ptr)>L_code then LR_problems:=LR_problems+10000;
  pop_LR;
  end;
pop_LR;
end

@ @d edge_node=style_node {a |style_node| does not occur in hlists}
@d edge_node_size=style_node_size {number of words in an edge node}
@d edge_dist(#)==depth(#) {new |left_edge| position relative to |cur_h|
   (after |width| has been taken into account)}

@<Declare procedures needed in |hlist_out|, |vlist_out|@>=
function new_edge(@!s:small_number;@!w:scaled):pointer;
  {create an edge node}
var p:pointer; {the new node}
begin p:=get_node(edge_node_size); type(p):=edge_node; subtype(p):=s;
width(p):=w; edge_dist(p):=0; {the |edge_dist| field will be set later}
new_edge:=p;
end;

@ @<Cases of |hlist_out| that arise...@>=
edge_node: begin cur_h:=cur_h+width(p);
  left_edge:=cur_h+edge_dist(p); cur_dir:=subtype(p);
  end;

@ We detach the hlist, start a new one consisting of just one kern node,
append the reversed list, and set the width of the kern node.

@<Reverse the complete hlist...@>=
begin save_h:=cur_h; temp_ptr:=p; p:=new_kern(0); link(prev_p):=p;
cur_h:=0; link(p):=v_reverse(this_box,null,cur_g,cur_glue); width(p):=-cur_h;
cur_h:=save_h; set_box_lr(this_box)(reversed);
end

@ We detach the remainder of the hlist, replace the math node by
an edge node, and append the reversed hlist segment to it; the tail of
the reversed segment is another edge node and the remainder of the
original list is attached to it.

@<Reverse an hlist segment...@>=
begin save_h:=cur_h; temp_ptr:=link(p); rule_wd:=width(p);
free_node(p,small_node_size);
cur_dir:=reflected; p:=new_edge(cur_dir,rule_wd); link(prev_p):=p;
cur_h:=cur_h-left_edge+rule_wd;
link(p):=v_reverse(this_box,new_edge(reflected,0),cur_g,cur_glue);
edge_dist(p):=cur_h; cur_dir:=reflected; cur_h:=save_h;
goto reswitch;
end

@ OLD VERSION.
The |reverse| function defined here is responsible to reverse the
nodes of an hlist (segment). The first parameter |this_box| is the enclosing
hlist node, the second parameter |t| is to become the tail of the reversed
list, and the global variable |temp_ptr| is the head of the list to be
reversed. Finally |cur_g| and |cur_glue| are the current glue rounding state
variables, to be updated by this function. We remove nodes from the original
list and add them to the head of the new one.

@<Declare procedures needed in |hlist_out|, |vlist_out|@>=
function reverse(@!this_box,@!t:pointer; var cur_g:scaled;
  var cur_glue:real):pointer;
label reswitch,next_p,done;
var l:pointer; {the new list}
@!p:pointer; {the current node}
@!q:pointer; {the next node}
@!g_order: glue_ord; {applicable order of infinity for glue}
@!g_sign: normal..shrinking; {selects type of glue}
@!glue_temp:real; {glue value before rounding}
@!m,@!n:halfword; {count of unmatched math nodes}
begin g_order:=glue_order(this_box); g_sign:=glue_sign(this_box);
l:=t; p:=temp_ptr; m:=min_halfword; n:=min_halfword;
loop@+  begin while p<>null do
    @<Move node |p| to the new list and go to the next node;
    or |goto done| if the end of the reflected segment has been reached@>;
  if (t=null)and(m=min_halfword)and(n=min_halfword) then goto done;
  p:=new_math(0,info(LR_ptr)); LR_problems:=LR_problems+10000;
    {manufacture one missing math node}
  end;
done:reverse:=l;
end;

@ NEW VERSION.
The |reverse| function defined here is responsible to reverse (parts of)
the nodes of an hlist.  The first parameter |this_box| is the enclosing
hlist node, the second parameter |t| is to become the tail of the reversed
list, and the global variable |temp_ptr| is the head of the list to be
reversed.  Finally |cur_g| and |cur_glue| are the current glue rounding
state variables, to be updated by this function.

@<Declare procedures needed in |hlist_out|, |vlist_out|@>=
@{
@t\4@>@<Declare subprocedures for |reverse|@>@;
function reverse(@!this_box,@!t:pointer; var cur_g:scaled;
  var cur_glue:real):pointer;
label reswitch,next_p,done;
var l:pointer; {the new list}
@!p:pointer; {the current node}
@!q:pointer; {the next node}
@!g_order: glue_ord; {applicable order of infinity for glue}
@!g_sign: normal..shrinking; {selects type of glue}
@!glue_temp:real; {glue value before rounding}
@!m,@!n:halfword; {count of unmatched math nodes}
begin g_order:=glue_order(this_box); g_sign:=glue_sign(this_box);
@<Build a list of segments and determine their widths@>;
l:=t; p:=temp_ptr; m:=min_halfword; n:=min_halfword;
loop@+  begin while p<>null do
    @<Move node |p| to the new list and go to the next node;
    or |goto done| if the end of the reflected segment has been reached@>;
  if (t=null)and(m=min_halfword)and(n=min_halfword) then goto done;
  p:=new_math(0,info(LR_ptr)); LR_problems:=LR_problems+10000;
    {manufacture one missing math node}
  end;
done:reverse:=l;
end;
@}

@ We cannot simply remove nodes from the original list and add them to the
head of the new one; this might reverse the order of whatsit nodes such
that, e.g., a |write_node| for a stream appears before the |open_node|
and\slash or after the |close_node| for that stream.

All whatsit nodes as well as hlist and vlist nodes containing such nodes
must not be permuted.  A sequence of hlist and vlist nodes not containing
whatsit nodes as well as char, ligature, rule, kern, and glue nodes together
with math nodes not changing the text direction can be explicitly reversed.
Embedded sections of left-to-right text are treated as a unit and all
remaining nodes are irrelevant and can be ignored.

In a first step we determine the width of various segments of the hlist to
be reversed: (1)~embedded left-to-right text, (2)~sequences of permutable or
irrelevant nodes, (3)~sequences of whatsit or irrelevant nodes, and
(4)~individual hlist and vlist nodes containing whatsit nodes.

@d segment_node=style_node
@d segment_node_size=style_node_size {number of words in a segment node}
@d segment_first(#)==info(#+2) {first node of the segment}
@d segment_last(#)==link(#+2) {last node of the segment}

@<Declare subprocedures for |reverse|@>=
function new_segment(@!s:small_number;@!f:pointer):pointer;
  {create a segment node}
var p:pointer; {the new node}
begin p:=get_node(segment_node_size); type(p):=segment_node; subtype(p):=s;
width(p):=0; {the |width| field will be set later}
segment_first(p):=f; segment_last(p):=f;
new_segment:=p;
end;

@ @<Build a list of segments and determine their widths@>=
begin
end

@ Here is a recursive subroutine that determines if the hlist or vlist
node~|p| contains whatsit nodes.

@<Declare subprocedures for |reverse|@>=
function has_whatsit(@!p:pointer):boolean;
label exit;
begin p:=list_ptr(p); has_whatsit:=true;
while p<>null do
  begin if not is_char_node(p) then
    case type(p) of
    hlist_node, vlist_node: if has_whatsit(p) then goto exit;
    whatsit_node: goto exit;
    othercases do_nothing
    endcases;@/
  p:=link(p);
  end;
has_whatsit:=false;
exit: end;

@ @<Move node |p| to the new list...@>=
reswitch: if is_char_node(p) then
  repeat f:=font(p); c:=character(p);
  cur_h:=cur_h+char_width(f)(char_info(f)(c));
  q:=link(p); link(p):=l; l:=p; p:=q;
  until not is_char_node(p)
else @<Move the non-|char_node| |p| to the new list@>

@ @<Move the non-|char_node| |p| to the new list@>=
begin q:=link(p);
case type(p) of
hlist_node,vlist_node,rule_node,kern_node: rule_wd:=width(p);
@t\4@>@<Cases of |reverse| that need special treatment@>@;
edge_node: confusion("LR2");
@:this can't happen LR2}{\quad LR2@>
othercases goto next_p
endcases;@/
cur_h:=cur_h+rule_wd;
next_p: link(p):=l;
if type(p)=kern_node then if (rule_wd=0)or(l=null) then
  begin free_node(p,small_node_size); p:=l;
  end;
l:=p; p:=q;
end

@ Here we compute the effective width of a glue node as in |hlist_out|.

@<Cases of |reverse|...@>=
glue_node: begin round_glue;
  @<Handle a glue node for mixed...@>;
  end;

@ A ligature node is replaced by a char node.

@<Cases of |reverse|...@>=
ligature_node: begin flush_node_list(lig_ptr(p));
  temp_ptr:=p; p:=get_avail; mem[p]:=mem[lig_char(temp_ptr)]; link(p):=q;
  free_node(temp_ptr,small_node_size); goto reswitch;
  end;

@ Math nodes in an inner reflected segment are modified, those at the
outer level are changed into kern nodes.

@<Cases of |reverse|...@>=
math_node: begin rule_wd:=width(p);
if end_LR(p) then
  if info(LR_ptr)<>end_LR_type(p) then
    begin type(p):=kern_node; incr(LR_problems);
    end
  else  begin pop_LR;
    if n>min_halfword then
      begin decr(n); decr(subtype(p)); {change |after| into |before|}
      end
    else  begin type(p):=kern_node;
      if m>min_halfword then decr(m)
      else @<Finish the reversed hlist segment and |goto done|@>;
      end;
    end
else  begin push_LR(p);
  if (n>min_halfword)or(LR_dir(p)<>cur_dir) then
    begin incr(n); incr(subtype(p)); {change |before| into |after|}
    end
  else  begin type(p):=kern_node; incr(m);
    end;
  end;
end;

@ Finally we have found the end of the hlist segment to be reversed; the
final math node is released and the remaining list attached to the
edge node terminating the reversed segment.

@<Finish the reversed...@>=
begin free_node(p,small_node_size);
link(t):=q; width(t):=rule_wd; edge_dist(t):=-cur_h-rule_wd; goto done;
end

@ @<Check for LR anomalies at the end of |s...@>=
begin if LR_problems>0 then
  begin @<Report LR problems@>; print_char(")"); print_ln;
  end;
if (LR_ptr<>null)or(cur_dir<>left_to_right) then confusion("LR3");
@:this can't happen LR3}{\quad LR3@>
end

@ Some special actions are required for displayed equation in paragraphs
with mixed direction texts.  First of all we have to set the text
direction preceding the display.

@<Set the value of |x| to the text direction before the display@>=
if LR_save=null then x:=0
else if info(LR_save)>=R_code then x:=-1@+else x:=1

@ @<Prepare for display after an empty...@>=
begin pop_nest; @<Set the value of |x|...@>;
end

@ When calculating the natural width, |w|, of the final line preceding
the display, we may have to copy all or part of its hlist.  We copy,
however, only those parts of the original list that are relevant for the
computation of |pre_display_size|.
@^data structure assumptions@>

@<Declare subprocedures for |init_math|@>=
procedure just_copy(@!p,@!h,@!t:pointer);
label found,not_found;
var @!r:pointer; {current node being fabricated for new list}
@!words:0..5; {number of words remaining to be copied}
begin while p<>null do
  begin words:=1; {this setting occurs in more branches than any other}
  if is_char_node(p) then r:=get_avail
  else case type(p) of
  hlist_node,vlist_node: begin r:=get_node(box_node_size);
    mem[r+6]:=mem[p+6]; mem[r+5]:=mem[p+5]; {copy the last two words}
    words:=5; list_ptr(r):=null; {this affects |mem[r+5]|}
    end;
  rule_node: begin r:=get_node(rule_node_size); words:=rule_node_size;
    end;
  ligature_node: begin r:=get_avail; {only |font| and |character| are needed}
    mem[r]:=mem[lig_char(p)]; goto found;
    end;
  kern_node,math_node: begin r:=get_node(small_node_size);
    words:=small_node_size;
    end;
  glue_node: begin r:=get_node(small_node_size); add_glue_ref(glue_ptr(p));
    glue_ptr(r):=glue_ptr(p); leader_ptr(r):=null;
    end;
  whatsit_node:@<Make a partial copy of the whatsit...@>;
  othercases goto not_found
  endcases;
  while words>0 do
    begin decr(words); mem[r+words]:=mem[p+words];
    end;
  found: link(h):=r; h:=r;
  not_found: p:=link(p);
  end;
link(h):=t;
end;

@ When the final line ends with R-text, the value |w| refers to the line
reflected with respect to the left edge of the enclosing vertical list.

@<Prepare for display after a non-empty...@>=
if eTeX_ex then @<Let |j| be the prototype box for the display@>;
v:=shift_amount(just_box);
@<Set the value of |x|...@>;
if x>=0 then
  begin p:=list_ptr(just_box); link(temp_head):=null;
  end
else  begin v:=-v-width(just_box);
  p:=new_math(0,begin_L_code); link(temp_head):=p;
  just_copy(list_ptr(just_box),p,new_math(0,end_L_code));
  cur_dir:=right_to_left;
  end;
v:=v+2*quad(cur_font);
if TeXXeT_en then @<Initialize the LR stack@>

@ @<Finish the natural width computation@>=
if TeXXeT_en then
  begin while LR_ptr<>null do pop_LR;
  if LR_problems<>0 then
    begin w:=max_dimen; LR_problems:=0;
    end;
  end;
cur_dir:=left_to_right; flush_node_list(link(temp_head))

@ In the presence of text direction directives we assume that any LR
problems have been fixed by the |hpack| routine.  If the final line
contains, however, text direction directives while \TeXXeT\ is disabled,
then we set |w:=max_dimen|.

@<Cases of `Let |d| be the natural...@>=
math_node: begin d:=width(p);
  if TeXXeT_en then @<Adjust \(t)the LR stack for the |init_math| routine@>
  else if subtype(p)>=L_code then
    begin w:=max_dimen; goto done;
    end;
  end;
edge_node: begin d:=width(p); cur_dir:=subtype(p);
  end;

@ @<Adjust \(t)the LR stack for the |i...@>=
if end_LR(p) then
  begin if info(LR_ptr)=end_LR_type(p) then pop_LR
  else if subtype(p)>L_code then
    begin w:=max_dimen; goto done;
    end
  end
else  begin push_LR(p);
  if LR_dir(p)<>cur_dir then
    begin just_reverse(p); p:=temp_head;
    end;
  end

@ @<Declare subprocedures for |init_math|@>=
procedure just_reverse(@!p:pointer);
label found,done;
var l:pointer; {the new list}
@!t:pointer; {tail of reversed segment}
@!q:pointer; {the next node}
@!m,@!n:halfword; {count of unmatched math nodes}
begin m:=min_halfword; n:=min_halfword;
if link(temp_head)=null then
  begin just_copy(link(p),temp_head,null); q:=link(temp_head);
  end
else  begin q:=link(p); link(p):=null; flush_node_list(link(temp_head));
  end;
t:=new_edge(cur_dir,0); l:=t; cur_dir:=reflected;
while q<>null do
  if is_char_node(q) then
    repeat p:=q; q:=link(p); link(p):=l; l:=p;
    until not is_char_node(q)
  else  begin p:=q; q:=link(p);
    if type(p)=math_node then
      @<Adjust \(t)the LR stack for the |just_reverse| routine@>;
    link(p):=l; l:=p;
    end;
goto done;
found:width(t):=width(p); link(t):=q; free_node(p,small_node_size);
done:link(temp_head):=l;
end;

@ @<Adjust \(t)the LR stack for the |j...@>=
if end_LR(p) then
  if info(LR_ptr)<>end_LR_type(p) then
    begin type(p):=kern_node; incr(LR_problems);
    end
  else  begin pop_LR;
    if n>min_halfword then
      begin decr(n); decr(subtype(p)); {change |after| into |before|}
      end
    else  begin if m>min_halfword then decr(m)@+else goto found;
      type(p):=kern_node;
      end;
    end
else  begin push_LR(p);
  if (n>min_halfword)or(LR_dir(p)<>cur_dir) then
    begin incr(n); incr(subtype(p)); {change |before| into |after|}
    end
  else  begin type(p):=kern_node; incr(m);
    end;
  end

@ The prototype box is an hlist node with the width, glue set, and shift
amount of |just_box|, i.e., the last line preceding the display.  Its
hlist reflects the current \.{\\leftskip} and \.{\\rightskip}.

@<Let |j| be the prototype box for the display@>=
begin if right_skip=zero_glue then j:=new_kern(0)
else j:=new_param_glue(right_skip_code);
if left_skip=zero_glue then p:=new_kern(0)
else p:=new_param_glue(left_skip_code);
link(p):=j; j:=new_null_box; width(j):=width(just_box);
shift_amount(j):=shift_amount(just_box); list_ptr(j):=p;
glue_order(j):=glue_order(just_box); glue_sign(j):=glue_sign(just_box);
glue_set(j):=glue_set(just_box);
end

@ At the end of a displayed equation we retrieve the prototype box.

@<Local variables for finishing...@>=
@!j:pointer; {prototype box}

@ @<Retrieve the prototype box@>=
if mode=mmode then j:=LR_box

@ @<Flush the prototype box@>=
flush_node_list(j)

@ The |app_display| procedure used to append the displayed equation
and\slash or equation number to the current vertical list has three
parameters:  the prototype box, the hbox to be appended, and the
displacement of the hbox in the display line.

@<Declare subprocedures for |after_math|@>=
procedure app_display(@!j,@!b:pointer;@!d:scaled);
var z:scaled; {width of the line}
@!s:scaled; {move the line right this much}
@!e:scaled; {distance from right edge of box to end of line}
@!x:integer; {|pre_display_direction|}
@!p,@!q,@!r,@!t,@!u:pointer; {for list manipulation}
begin s:=display_indent; x:=pre_display_direction;
if x=0 then shift_amount(b):=s+d
else  begin z:=display_width; p:=b;
  @<Set up the hlist for the display line@>;
  @<Package the display line@>;
  end;
append_to_vlist(b);
end;

@ Here we construct the hlist for the display, starting with node |p|
and ending with node |q|. We also set |d| and |e| to the amount of
kerning to be added before and after the hlist (adjusted for the
prototype box).

@<Set up the hlist for the display line@>=
if x>0 then e:=z-d-width(p)
else  begin e:=d; d:=z-e-width(p);
  end;
if j<>null then
  begin b:=copy_node_list(j); height(b):=height(p); depth(b):=depth(p);
  s:=s-shift_amount(b); d:=d+s; e:=e+width(b)-z-s;
  end;
if box_lr(p)=dlist then q:=p {display or equation number}
else  begin {display and equation number}
  r:=list_ptr(p); free_node(p,box_node_size);
  if r=null then confusion("LR4");
  if x>0 then
    begin p:=r;
    repeat q:=r; r:=link(r); {find tail of list}
    until r=null;
    end
  else  begin p:=null; q:=r;
    repeat t:=link(r); link(r):=p; p:=r; r:=t; {reverse list}
    until r=null;
    end;
  end

@ In the presence of a prototype box we use its shift amount and width
to adjust the values of kerning and add these values to the glue nodes
inserted to cancel the \.{\\leftskip} and \.{\\rightskip}.  If there is
no prototype box (because the display is preceded by an empty
paragraph), or if the skip parameters are zero, we just add kerns.

The |cancel_glue| macro creates and links a glue node that is, together
with another glue node, equivalent to a given amount of kerning.  We can
use |j| as temporary pointer, since all we need is |j<>null|.

@d cancel_glue(#)==j:=new_skip_param(#); cancel_glue_cont
@d cancel_glue_cont(#)==link(#):=j; cancel_glue_cont_cont
@d cancel_glue_cont_cont(#)==link(j):=#; cancel_glue_end
@d cancel_glue_end(#)==j:=glue_ptr(#); cancel_glue_end_end
@d cancel_glue_end_end(#)==
stretch_order(temp_ptr):=stretch_order(j);
shrink_order(temp_ptr):=shrink_order(j); width(temp_ptr):=#-width(j);
stretch(temp_ptr):=-stretch(j); shrink(temp_ptr):=-shrink(j)

@<Package the display line@>=
if j=null then
  begin r:=new_kern(0); t:=new_kern(0); {the widths will be set later}
  end
else  begin r:=list_ptr(b); t:=link(r);
  end;
u:=new_math(0,end_M_code);
if type(t)=glue_node then {|t| is \.{\\rightskip} glue}
  begin cancel_glue(right_skip_code)(q)(u)(t)(e); link(u):=t;
  end
else  begin width(t):=e; link(t):=u; link(q):=t;
  end;
u:=new_math(0,begin_M_code);
if type(r)=glue_node then {|r| is \.{\\leftskip} glue}
  begin cancel_glue(left_skip_code)(u)(p)(r)(d); link(r):=u;
  end
else  begin width(r):=d; link(r):=p; link(u):=r;
  if j=null then
    begin b:=hpack(u,natural); shift_amount(b):=s;
    end
  else list_ptr(b):=u;
  end

@ The |scan_tokens| feature of \eTeX\ defines the \.{\\scantokens}
primitive.

@<Generate all \eTeX...@>=
primitive("scantokens",input,2);
@!@:scan_tokens_}{\.{\\scantokens} primitive@>

@ @<Cases of |input| for |print_cmd_chr|@>=
else if chr_code=2 then print_esc("scantokens")

@ @<Cases for |input|@>=
else if cur_chr=2 then pseudo_start

@ The global variable |pseudo_files| is used to maintain a stack of
pseudo files.  The |info| field of each pseudo file points to a linked
list of variable size nodes representing lines not yet processed: the
|info| field of the first word contains the size of this node, all the
following words contain ASCII codes.

@<Glob...@>=
@!pseudo_files:pointer; {stack of pseudo files}

@ @<Set init...@>=
pseudo_files:=null;

@ The |pseudo_start| procedure initiates reading from a pseudo file.

@<Declare \eTeX\ procedures for ex...@>=
procedure@?pseudo_start; forward;@t\2@>

@ @<Declare \eTeX\ procedures for tok...@>=
procedure pseudo_start;
var old_setting:0..max_selector; {holds |selector| setting}
@!s:str_number; {string to be converted into a pseudo file}
@!l,@!m:pool_pointer; {indices into |str_pool|}
@!p,@!q,@!r:pointer; {for list construction}
@!w: four_quarters; {four ASCII codes}
@!nl,@!sz:integer;
begin scan_general_text;
old_setting:=selector; selector:=new_string;
token_show(temp_head); selector:=old_setting;
flush_list(link(temp_head));
str_room(1); s:=make_string;
@<Convert string |s| into a new pseudo file@>;
flush_string;
@<Initiate input from new pseudo file@>;
end;

@ @<Convert string |s| into a new pseudo file@>=
str_pool[pool_ptr]:=si(" "); l:=str_start[s];
nl:=si(new_line_char);
p:=get_avail; q:=p;
while l<pool_ptr do
  begin m:=l;
  while (l<pool_ptr)and(str_pool[l]<>nl) do incr(l);
  sz:=(l-m+7)div 4;
  if sz=1 then sz:=2;
  r:=get_node(sz); link(q):=r; q:=r; info(q):=hi(sz);
  while sz>2 do
    begin decr(sz); incr(r);
    w.b0:=qi(so(str_pool[m])); w.b1:=qi(so(str_pool[m+1]));
    w.b2:=qi(so(str_pool[m+2])); w.b3:=qi(so(str_pool[m+3]));
    mem[r].qqqq:=w; m:=m+4;
    end;
  w.b0:=qi(" "); w.b1:=qi(" "); w.b2:=qi(" "); w.b3:=qi(" ");
  if l>m then
    begin w.b0:=qi(so(str_pool[m]));
    if l>m+1 then
      begin  w.b1:=qi(so(str_pool[m+1]));
      if l>m+2 then
        begin  w.b2:=qi(so(str_pool[m+2]));
        if l>m+3 then w.b3:=qi(so(str_pool[m+3]));
        end;
      end;
    end;
  mem[r+1].qqqq:=w;
  if str_pool[l]=nl then incr(l);
  end;
info(p):=link(p); link(p):=pseudo_files; pseudo_files:=p

@ @<Initiate input from new pseudo file@>=
begin_file_reading; {set up |cur_file| and new level of input}
line:=0; limit:=start; loc:=limit+1; {force line read}
if tracing_scan_tokens>0 then
  begin if term_offset>max_print_line-3 then print_ln
  else if (term_offset>0)or(file_offset>0) then print_char(" ");
  name:=19; print("( "); incr(open_parens); update_terminal;
  end
else name:=18

@ Here we read a line from the current pseudo file into |buffer|.

@<Declare \eTeX\ procedures for tr...@>=
function pseudo_input: boolean; {inputs the next line or returns |false|}
var p:pointer; {current line from pseudo file}
@!sz:integer; {size of node |p|}
@!w:four_quarters; {four ASCII codes}
@!r:pointer; {loop index}
begin last:=first; {cf.\ Matthew 19\thinspace:\thinspace30}
p:=info(pseudo_files);
if p=null then pseudo_input:=false
else  begin info(pseudo_files):=link(p); sz:=ho(info(p));
  if 4*sz-3>=buf_size-last then
    @<Report overflow of the input buffer, and abort@>;
  last:=first;
  for r:=p+1 to p+sz-1 do
    begin w:=mem[r].qqqq;
    buffer[last]:=w.b0; buffer[last+1]:=w.b1;
    buffer[last+2]:=w.b2; buffer[last+3]:=w.b3;
    last:=last+4;
    end;
  if last>=max_buf_stack then max_buf_stack:=last+1;
  while (last>first)and(buffer[last-1]=" ") do decr(last);
  free_node(p,sz);
  pseudo_input:=true;
  end;
end;

@ When we are done with a pseudo file we `close' it.

@<Declare \eTeX\ procedures for tr...@>=
procedure pseudo_close; {close the top level pseudo file}
var p,@!q: pointer;
begin p:=link(pseudo_files); q:=info(pseudo_files);
free_avail(pseudo_files); pseudo_files:=p;
while q<>null do
  begin p:=q; q:=link(p); free_node(p,ho(info(p)));
  end;
end;

@ @<Dump the \eTeX\ state@>=
while pseudo_files<>null do pseudo_close; {flush pseudo files}

@ @<Generate all \eTeX...@>=
primitive("readline",read_to_cs,1);@/
@!@:read_line_}{\.{\\readline} primitive@>

@ @<Cases of |read| for |print_cmd_chr|@>=
else print_esc("readline")

@ @<Handle \.{\\readline} and |goto done|@>=
if j=1 then
  begin while loc<=limit do {current line not yet finished}
    begin cur_chr:=buffer[loc]; incr(loc);
    if cur_chr=" " then cur_tok:=space_token
    @+else cur_tok:=cur_chr+other_token;
    store_new_token(cur_tok);
    end;
  goto done;
  end

@ Here we define the additional conditionals of \eTeX\ as well as the
\.{\\unless} prefix.

@d if_def_code=17 { `\.{\\ifdefined}' }
@d if_cs_code=18 { `\.{\\ifcsname}' }
@d if_font_char_code=19 { `\.{\\iffontchar}' }
@d eTeX_last_if_test_cmd_mod=if_font_char_code
@d eTeX_last_expand_after_cmd_mod=1

@<Generate all \eTeX...@>=
primitive("unless",expand_after,1);@/
@!@:unless_}{\.{\\unless} primitive@>
primitive("ifdefined",if_test,if_def_code);
@!@:if_defined_}{\.{\\ifdefined} primitive@>
primitive("ifcsname",if_test,if_cs_code);
@!@:if_cs_name_}{\.{\\ifcsname} primitive@>
primitive("iffontchar",if_test,if_font_char_code);
@!@:if_font_char_}{\.{\\iffontchar} primitive@>

@ @<Cases of |expandafter| for |print_cmd_chr|@>=
1: print_esc("unless");

@ @<Cases of |if_test| for |print_cmd_chr|@>=
if_def_code:print_esc("ifdefined");
if_cs_code:print_esc("ifcsname");
if_font_char_code:print_esc("iffontchar");

@ The result of a boolean condition is reversed when the conditional is
preceded by \.{\\unless}.

@<Negate a boolean conditional and |goto reswitch|@>=
begin get_token;
if (cur_cmd=if_test)and(cur_chr<>if_case_code) then
  begin cur_chr:=cur_chr+unless_code; goto reswitch;
  end;
print_err("You can't use `"); print_esc("unless"); print("' before `");
@.You can't use \\unless...@>
print_cmd_chr(cur_cmd,cur_chr); print_char("'");
help1("Continue, and I'll forget that it ever happened.");
back_error;
end

@ The conditional \.{\\ifdefined} tests if a control sequence is
defined.

We need to reset |scanner_status|, since \.{\\outer} control sequences
are allowed, but we might be scanning a macro definition or preamble.

@<Cases for |conditional|@>=
if_def_code:begin save_scanner_status:=scanner_status;
  scanner_status:=normal;
  get_next; b:=(cur_cmd<>undefined_cs);
  scanner_status:=save_scanner_status;
  end;

@ The conditional \.{\\ifcsname} is equivalent to \.{\{\\expandafter}
\.{\}\\expandafter} \.{\\ifdefined} \.{\\csname}, except that no new
control sequence will be entered into the hash table (once all tokens
preceding the mandatory \.{\\endcsname} have been expanded).

@<Cases for |conditional|@>=
if_cs_code:begin n:=get_avail; p:=n; {head of the list of characters}
  repeat get_x_token;
  if cur_cs=0 then store_new_token(cur_tok);
  until cur_cs<>0;
  if cur_cmd<>end_cs_name then @<Complain about missing \.{\\endcsname}@>;
  @<Look up the characters of list |n| in the hash table, and set |cur_cs|@>;
  flush_list(n);
  b:=(eq_type(cur_cs)<>undefined_cs);
  end;

@ @<Look up the characters of list |n| in the hash table...@>=
m:=first; p:=link(n);
while p<>null do
  begin if m>=max_buf_stack then
    begin max_buf_stack:=m+1;
    if max_buf_stack=buf_size then
      overflow("buffer size",buf_size);
@:TeX capacity exceeded buffer size}{\quad buffer size@>
    end;
  buffer[m]:=info(p) mod @'400; incr(m); p:=link(p);
  end;
if m>first+1 then
  cur_cs:=id_lookup(first,m-first) {|no_new_control_sequence| is |true|}
else if m=first then cur_cs:=null_cs {the list is empty}
else cur_cs:=single_base+buffer[first] {the list has length one}

@ The conditional \.{\\iffontchar} tests the existence of a character in
a font.

@<Cases for |conditional|@>=
if_font_char_code:begin scan_font_ident; n:=cur_val; scan_char_num;
  if (font_bc[n]<=cur_val)and(font_ec[n]>=cur_val) then
    b:=char_exists(char_info(n)(qi(cur_val)))
  else b:=false;
  end;

@ The |protected| feature of \eTeX\ defines the \.{\\protected} prefix
command for macro definitions.  Such macros are protected against
expansions when lists of expanded tokens are built, e.g., for \.{\\edef}
or during \.{\\write}.

@<Generate all \eTeX...@>=
primitive("protected",prefix,8);
@!@:protected_}{\.{\\protected} primitive@>

@ @<Cases of |prefix| for |print_cmd_chr|@>=
else if chr_code=8 then print_esc("protected")

@ The |get_x_or_protected| procedure is like |get_x_token| except that
protected macros are not expanded.

@<Declare \eTeX\ procedures for sc...@>=
procedure get_x_or_protected; {sets |cur_cmd|, |cur_chr|, |cur_tok|,
  and expands non-protected macros}
label exit;
begin loop@+begin get_token;
  if cur_cmd<=max_command then return;
  if (cur_cmd>=call)and(cur_cmd<end_template) then
    if info(link(cur_chr))=protected_token then return;
  expand;
  end;
exit:end;

@ A group entered (or a conditional started) in one file may end in a
different file.  Such slight anomalies, although perfectly legitimate,
may cause errors that are difficult to locate.  In order to be able to
give a warning message when such anomalies occur, \eTeX\ uses the
|grp_stack| and |if_stack| arrays to record the initial |cur_boundary|
and |cond_ptr| values for each input file.

@<Glob...@>=
@!grp_stack : array[0..max_in_open] of save_pointer; {initial |cur_boundary|}
@!if_stack : array[0..max_in_open] of pointer; {initial |cond_ptr|}

@ When a group ends that was apparently entered in a different input
file, the |group_warning| procedure is invoked in order to update the
|grp_stack|.  If moreover \.{\\tracingnesting} is positive we want to
give a warning message.  The situation is, however, somewhat complicated
by two facts:  (1)~There may be |grp_stack| elements without a
corresponding \.{\\input} file or \.{\\scantokens} pseudo file (e.g.,
error insertions from the terminal); and (2)~the relevant information is
recorded in the |name_field| of the |input_stack| only loosely
synchronized with the |in_open| variable indexing |grp_stack|.

@<Declare \eTeX\ procedures for tr...@>=
procedure group_warning;
var i:0..max_in_open; {index into |grp_stack|}
@!w:boolean; {do we need a warning?}
begin base_ptr:=input_ptr; input_stack[base_ptr]:=cur_input;
  {store current state}
i:=in_open; w:=false;
while (grp_stack[i]=cur_boundary)and(i>0) do
  begin @<Set variable |w| to indicate if this case should be reported@>;
  grp_stack[i]:=save_index(save_ptr); decr(i);
  end;
if w then
  begin print_nl("Warning: end of "); print_group(true);
@.Warning: end of...@>
  print(" of a different file"); print_ln;
  if tracing_nesting>1 then show_context;
  if history=spotless then history:=warning_issued;
  end;
end;

@ This code scans the input stack in order to determine the type of the
current input file.

@<Set variable |w| to...@>=
if tracing_nesting>0 then
  begin while (input_stack[base_ptr].state_field=token_list)or@|
    (input_stack[base_ptr].index_field>i) do decr(base_ptr);
  if input_stack[base_ptr].name_field>17 then w:=true;
  end

@ When a conditional ends that was apparently started in a different
input file, the |if_warning| procedure is invoked in order to update the
|if_stack|.  If moreover \.{\\tracingnesting} is positive we want to
give a warning message (with the same complications as above).

@<Declare \eTeX\ procedures for tr...@>=
procedure if_warning;
var i:0..max_in_open; {index into |if_stack|}
@!w:boolean; {do we need a warning?}
begin base_ptr:=input_ptr; input_stack[base_ptr]:=cur_input;
  {store current state}
i:=in_open; w:=false;
while if_stack[i]=cond_ptr do
  begin @<Set variable |w| to...@>;
  if_stack[i]:=link(cond_ptr); decr(i);
  end;
if w then
  begin print_nl("Warning: end of "); print_cmd_chr(if_test,cur_if);
@.Warning: end of...@>
  print_if_line(if_line); print(" of a different file"); print_ln;
  if tracing_nesting>1 then show_context;
  if history=spotless then history:=warning_issued;
  end;
end;

@ Conversely, the |file_warning| procedure is invoked when a file ends
and some groups entered or conditionals started while reading from that
file are still incomplete.

@<Declare \eTeX\ procedures for tr...@>=
procedure file_warning;
var p:pointer; {saved value of |save_ptr| or |cond_ptr|}
@!l:quarterword; {saved value of |cur_level| or |if_limit|}
@!c:quarterword; {saved value of |cur_group| or |cur_if|}
@!i:integer; {saved value of |if_line|}
begin p:=save_ptr; l:=cur_level; c:=cur_group; save_ptr:=cur_boundary;
while grp_stack[in_open]<>save_ptr do
  begin decr(cur_level);
  print_nl("Warning: end of file when ");
@.Warning: end of file when...@>
  print_group(true); print(" is incomplete");@/
  cur_group:=save_level(save_ptr); save_ptr:=save_index(save_ptr)
  end;
save_ptr:=p; cur_level:=l; cur_group:=c; {restore old values}
p:=cond_ptr; l:=if_limit; c:=cur_if; i:=if_line;
while if_stack[in_open]<>cond_ptr do
  begin print_nl("Warning: end of file when ");
@.Warning: end of file when...@>
  print_cmd_chr(if_test,cur_if);
  if if_limit=fi_code then print_esc("else");
  print_if_line(if_line); print(" is incomplete");@/
  if_line:=if_line_field(cond_ptr); cur_if:=subtype(cond_ptr);
  if_limit:=type(cond_ptr); cond_ptr:=link(cond_ptr);
  end;
cond_ptr:=p; if_limit:=l; cur_if:=c; if_line:=i; {restore old values}
print_ln;
if tracing_nesting>1 then show_context;
if history=spotless then history:=warning_issued;
end;

@ Here are the additional \eTeX\ primitives for expressions.

@<Generate all \eTeX...@>=
primitive("numexpr",last_item,eTeX_expr-int_val+int_val);
@!@:num_expr_}{\.{\\numexpr} primitive@>
primitive("dimexpr",last_item,eTeX_expr-int_val+dimen_val);
@!@:dim_expr_}{\.{\\dimexpr} primitive@>
primitive("glueexpr",last_item,eTeX_expr-int_val+glue_val);
@!@:glue_expr_}{\.{\\glueexpr} primitive@>
primitive("muexpr",last_item,eTeX_expr-int_val+mu_val);
@!@:mu_expr_}{\.{\\muexpr} primitive@>

@ @<Cases of |last_item| for |print_cmd_chr|@>=
eTeX_expr-int_val+int_val: print_esc("numexpr");
eTeX_expr-int_val+dimen_val: print_esc("dimexpr");
eTeX_expr-int_val+glue_val: print_esc("glueexpr");
eTeX_expr-int_val+mu_val: print_esc("muexpr");

@ This code for reducing |cur_val_level| and\slash or negating the
result is similar to the one for all the other cases of
|scan_something_internal|, with the difference that |scan_expr| has
already increased the reference count of a glue specification.

@<Process an expression and |return|@>=
begin if m<eTeX_mu then
  begin case m of
  @/@<Cases for fetching a glue value@>@/
  end; {there are no other cases}
  cur_val_level:=glue_val;
  end
else if m<eTeX_expr then
  begin case m of
  @/@<Cases for fetching a mu value@>@/
  end; {there are no other cases}
  cur_val_level:=mu_val;
  end
else  begin cur_val_level:=m-eTeX_expr+int_val; scan_expr;
  end;
while cur_val_level>level do
  begin if cur_val_level=glue_val then
    begin m:=cur_val; cur_val:=width(m); delete_glue_ref(m);
    end
  else if cur_val_level=mu_val then mu_error;
  decr(cur_val_level);
  end;
if negative then
  if cur_val_level>=glue_val then
    begin m:=cur_val; cur_val:=new_spec(m); delete_glue_ref(m);
    @<Negate all three glue components of |cur_val|@>;
    end
  else negate(cur_val);
return;
end

@ @<Declare \eTeX\ procedures for sc...@>=
procedure@?scan_expr; forward;@t\2@>

@ The |scan_expr| procedure scans and evaluates an expression.

@<Declare procedures needed for expressions@>=
@t\4@>@<Declare subprocedures for |scan_expr|@>
procedure scan_expr; {scans and evaluates an expression}
label restart, continue, found;
var a,@!b:boolean; {saved values of |arith_error|}
@!l:small_number; {type of expression}
@!r:small_number; {state of expression so far}
@!s:small_number; {state of term so far}
@!o:small_number; {next operation or type of next factor}
@!e:integer; {expression so far}
@!t:integer; {term so far}
@!f:integer; {current factor}
@!n:integer; {numerator of combined multiplication and division}
@!p:pointer; {top of expression stack}
@!q:pointer; {for stack manipulations}
begin l:=cur_val_level; a:=arith_error; b:=false; p:=null;
incr(expand_depth_count);
if expand_depth_count>=expand_depth then overflow("expansion depth",expand_depth);
@<Scan and evaluate an expression |e| of type |l|@>;
decr(expand_depth_count);
if b then
  begin print_err("Arithmetic overflow");
@.Arithmetic overflow@>
  help2("I can't evaluate this expression,")@/
    ("since the result is out of range.");
  error;
  if l>=glue_val then
    begin delete_glue_ref(e); e:=zero_glue; add_glue_ref(e);
    end
  else e:=0;
  end;
arith_error:=a; cur_val:=e; cur_val_level:=l;
end;

@ Evaluating an expression is a recursive process:  When the left
parenthesis of a subexpression is scanned we descend to the next level
of recursion; the previous level is resumed with the matching right
parenthesis.

@d expr_none=0 {\.( seen, or \.( $\langle\it expr\rangle$ \.) seen}
@d expr_add=1 {\.( $\langle\it expr\rangle$ \.+ seen}
@d expr_sub=2 {\.( $\langle\it expr\rangle$ \.- seen}
@d expr_mult=3 {$\langle\it term\rangle$ \.* seen}
@d expr_div=4 {$\langle\it term\rangle$ \./ seen}
@d expr_scale=5 {$\langle\it term\rangle$ \.*
  $\langle\it factor\rangle$ \./ seen}

@<Scan and eval...@>=
restart: r:=expr_none; e:=0; s:=expr_none; t:=0; n:=0;
continue: if s=expr_none then o:=l@+else o:=int_val;
@<Scan a factor |f| of type |o| or start a subexpression@>;
found: @<Scan the next operator and set |o|@>;
arith_error:=b;
@<Make sure that |f| is in the proper range@>;
case s of @<Cases for evaluation of the current term@>@;
end; {there are no other cases}
if o>expr_sub then s:=o@+else @<Evaluate the current expression@>;
b:=arith_error;
if o<>expr_none then goto continue;
if p<>null then @<Pop the expression stack and |goto found|@>

@ @<Scan the next op...@>=
@<Get the next non-blank non-call token@>;
if cur_tok=other_token+"+" then o:=expr_add
else if cur_tok=other_token+"-" then o:=expr_sub
else if cur_tok=other_token+"*" then o:=expr_mult
else if cur_tok=other_token+"/" then o:=expr_div
else  begin o:=expr_none;
  if p=null then
    begin if cur_cmd<>relax then back_input;
    end
  else if cur_tok<>other_token+")" then
    begin print_err("Missing ) inserted for expression");
@.Missing ) inserted@>
    help1("I was expecting to see `+', `-', `*', `/', or `)'. Didn't.");
    back_error;
    end;
  end

@ @<Scan a factor...@>=
@<Get the next non-blank non-call token@>;
if cur_tok=other_token+"(" then
  @<Push the expression stack and |goto restart|@>;
back_input;
if o=int_val then scan_int
else if o=dimen_val then scan_normal_dimen
else if o=glue_val then scan_normal_glue
else scan_mu_glue;
f:=cur_val

@ @<Declare \eTeX\ procedures for sc...@>=
procedure@?scan_normal_glue; forward;@t\2@>@/
procedure@?scan_mu_glue; forward;@t\2@>

@ Here we declare two trivial procedures in order to avoid mutually
recursive procedures with parameters.

@<Declare procedures needed for expressions@>=
procedure scan_normal_glue;
begin scan_glue(glue_val);
end;
@#
procedure scan_mu_glue;
begin scan_glue(mu_val);
end;

@ Parenthesized subexpressions can be inside expressions, and this
nesting has a stack.  Seven local variables represent the top of the
expression stack:  |p| points to pushed-down entries, if any; |l|
specifies the type of expression currently beeing evaluated; |e| is the
expression so far and |r| is the state of its evaluation; |t| is the
term so far and |s| is the state of its evaluation; finally |n| is the
numerator for a combined multiplication and division, if any.

@d expr_node_size=4 {number of words in stack entry for subexpressions}
@d expr_e_field(#)==mem[#+1].int {saved expression so far}
@d expr_t_field(#)==mem[#+2].int {saved term so far}
@d expr_n_field(#)==mem[#+3].int {saved numerator}

@<Push the expression...@>=
begin q:=get_node(expr_node_size); link(q):=p; type(q):=l;
subtype(q):=4*s+r;
expr_e_field(q):=e; expr_t_field(q):=t; expr_n_field(q):=n;
p:=q; l:=o; goto restart;
end

@ @<Pop the expression...@>=
begin f:=e; q:=p;
e:=expr_e_field(q); t:=expr_t_field(q); n:=expr_n_field(q);
s:=subtype(q) div 4; r:=subtype(q) mod 4;
l:=type(q); p:=link(q); free_node(q,expr_node_size);
goto found;
end

@ We want to make sure that each term and (intermediate) result is in
the proper range.  Integer values must not exceed |infinity|
($2^{31}-1$) in absolute value, dimensions must not exceed |max_dimen|
($2^{30}-1$).  We avoid the absolute value of an integer, because this
might fail for the value $-2^{31}$ using 32-bit arithmetic.

@d num_error(#)== {clear a number or dimension and set |arith_error|}
  begin arith_error:=true; #:=0;
  end
@d glue_error(#)== {clear a glue spec and set |arith_error|}
  begin arith_error:=true; delete_glue_ref(#); #:=new_spec(zero_glue);
  end

@<Make sure that |f|...@>=
if (l=int_val)or(s>expr_sub) then
  begin if (f>infinity)or(f<-infinity) then num_error(f);
  end
else if l=dimen_val then
  begin if abs(f)>max_dimen then num_error(f);
  end
else  begin if (abs(width(f))>max_dimen)or@|
   (abs(stretch(f))>max_dimen)or@|
   (abs(shrink(f))>max_dimen) then glue_error(f);
  end

@ Applying the factor |f| to the partial term |t| (with the operator
|s|) is delayed until the next operator |o| has been scanned.  Here we
handle the first factor of a partial term.  A glue spec has to be copied
unless the next operator is a right parenthesis; this allows us later on
to simply modify the glue components.

@d normalize_glue(#)==
  if stretch(#)=0 then stretch_order(#):=normal;
  if shrink(#)=0 then shrink_order(#):=normal

@<Cases for evaluation of the current term@>=
expr_none: if (l>=glue_val)and(o<>expr_none) then
    begin t:=new_spec(f); delete_glue_ref(f); normalize_glue(t);
    end
  else t:=f;

@ When a term |t| has been completed it is copied to, added to, or
subtracted from the expression |e|.

@d expr_add_sub(#)==add_or_sub(#,r=expr_sub)
@d expr_a(#)==expr_add_sub(#,max_dimen)

@<Evaluate the current expression@>=
begin s:=expr_none;
if r=expr_none then e:=t
else if l=int_val then e:=expr_add_sub(e,t,infinity)
else if l=dimen_val then e:=expr_a(e,t)
else @<Compute the sum or difference of two glue specs@>;
r:=o;
end

@ The function |add_or_sub(x,y,max_answer,negative)| computes the sum
(for |negative=false|) or difference (for |negative=true|) of |x| and
|y|, provided the absolute value of the result does not exceed
|max_answer|.

@<Declare subprocedures for |scan_expr|@>=
function add_or_sub(@!x,@!y,@!max_answer:integer;@!negative:boolean):integer;
var a:integer; {the answer}
begin if negative then negate(y);
if x>=0 then
  if y<=max_answer-x then a:=x+y@+else num_error(a)
else if y>=-max_answer-x then a:=x+y@+else num_error(a);
add_or_sub:=a;
end;

@ We know that |stretch_order(e)>normal| implies |stretch(e)<>0| and
|shrink_order(e)>normal| implies |shrink(e)<>0|.

@<Compute the sum or diff...@>=
begin width(e):=expr_a(width(e),width(t));
if stretch_order(e)=stretch_order(t) then
  stretch(e):=expr_a(stretch(e),stretch(t))
else if (stretch_order(e)<stretch_order(t))and(stretch(t)<>0) then
  begin stretch(e):=stretch(t); stretch_order(e):=stretch_order(t);
  end;
if shrink_order(e)=shrink_order(t) then
  shrink(e):=expr_a(shrink(e),shrink(t))
else if (shrink_order(e)<shrink_order(t))and(shrink(t)<>0) then
  begin shrink(e):=shrink(t); shrink_order(e):=shrink_order(t);
  end;
delete_glue_ref(t); normalize_glue(e);
end

@ If a multiplication is followed by a division, the two operations are
combined into a `scaling' operation.  Otherwise the term |t| is
multiplied by the factor |f|.

@d expr_m(#)==#:=nx_plus_y(#,f,0)

@<Cases for evaluation of the current term@>=
expr_mult: if o=expr_div then
    begin n:=f; o:=expr_scale;
    end
  else if l=int_val then t:=mult_integers(t,f)
  else if l=dimen_val then expr_m(t)
  else  begin expr_m(width(t)); expr_m(stretch(t)); expr_m(shrink(t));
    end;

@ Here we divide the term |t| by the factor |f|.

@d expr_d(#)==#:=quotient(#,f)

@<Cases for evaluation of the current term@>=
expr_div: if l<glue_val then expr_d(t)
  else  begin expr_d(width(t)); expr_d(stretch(t)); expr_d(shrink(t));
    end;

@ The function |quotient(n,d)| computes the rounded quotient
$q=\lfloor n/d+{1\over2}\rfloor$, when $n$ and $d$ are positive.

@<Declare subprocedures for |scan_expr|@>=
function quotient(@!n,@!d:integer):integer;
var negative:boolean; {should the answer be negated?}
@!a:integer; {the answer}
begin if d=0 then num_error(a)
else  begin if d>0 then negative:=false
  else  begin negate(d); negative:=true;
    end;
  if n<0 then
    begin negate(n); negative:=not negative;
    end;
  a:=n div d; n:=n-a*d; d:=n-d; {avoid certain compiler optimizations!}
  if d+n>=0 then incr(a);
  if negative then negate(a);
  end;
quotient:=a;
end;

@ Here the term |t| is multiplied by the quotient $n/f$.

@d expr_s(#)==#:=fract(#,n,f,max_dimen)

@<Cases for evaluation of the current term@>=
expr_scale: if l=int_val then t:=fract(t,n,f,infinity)
  else if l=dimen_val then expr_s(t)
  else  begin expr_s(width(t)); expr_s(stretch(t)); expr_s(shrink(t));
    end;

@ Finally, the function |fract(x,n,d,max_answer)| computes the integer
$q=\lfloor xn/d+{1\over2}\rfloor$, when $x$, $n$, and $d$ are positive
and the result does not exceed |max_answer|.  We can't use floating
point arithmetic since the routine must produce identical results in all
cases; and it would be too dangerous to multiply by~|n| and then divide
by~|d|, in separate operations, since overflow might well occur.  Hence
this subroutine simulates double precision arithmetic, somewhat
analogous to \MF's |make_fraction| and |take_fraction| routines.

@d too_big=88 {go here when the result is too big}

@<Declare subprocedures for |scan_expr|@>=
function fract(@!x,@!n,@!d,@!max_answer:integer):integer;
label found, found1, too_big, done;
var negative:boolean; {should the answer be negated?}
@!a:integer; {the answer}
@!f:integer; {a proper fraction}
@!h:integer; {smallest integer such that |2*h>=d|}
@!r:integer; {intermediate remainder}
@!t:integer; {temp variable}
begin if d=0 then goto too_big;
a:=0;
if d>0 then negative:=false
else  begin negate(d); negative:=true;
  end;
if x<0 then
  begin negate(x); negative:=not negative;
  end
else if x=0 then goto done;
if n<0 then
  begin negate(n); negative:=not negative;
  end;
t:=n div d;
if t>max_answer div x then goto too_big;
a:=t*x; n:=n-t*d;
if n=0 then goto found;
t:=x div d;
if t>(max_answer-a) div n then goto too_big;
a:=a+t*n; x:=x-t*d;
if x=0 then goto found;
if x<n then
  begin t:=x; x:=n; n:=t;
  end; {now |0<n<=x<d|}
@<Compute \(f)$f=\lfloor xn/d+{1\over2}\rfloor$@>@;
if f>(max_answer-a) then goto too_big;
a:=a+f;
found: if negative then negate(a);
goto done;
too_big: num_error(a);
done: fract:=a;
end;

@ The loop here preserves the following invariant relations
between |f|, |x|, |n|, and~|r|:
(i)~$f+\lfloor(xn+(r+d))/d\rfloor=\lfloor x_0n_0/d+{1\over2}\rfloor$;
(ii)~|-d<=r<0<n<=x<d|, where $x_0$, $n_0$ are the original values of~$x$
and $n$.

Notice that the computation specifies |(x-d)+x| instead of |(x+x)-d|,
because the latter could overflow.

@<Compute \(f)$f=\lfloor xn/d+{1\over2}\rfloor$@>=
f:=0; r:=(d div 2)-d; h:=-r;
loop@+begin if odd(n) then
    begin r:=r+x;
    if r>=0 then
      begin r:=r-d; incr(f);
      end;
    end;
  n:=n div 2;
  if n=0 then goto found1;
  if x<h then x:=x+x
  else  begin t:=x-d; x:=t+x; f:=f+n;
      if x<n then
        begin if x=0 then goto found1;
        t:=x; x:=n; n:=t;
        end;
    end;
  end;
found1:

@ The \.{\\gluestretch}, \.{\\glueshrink}, \.{\\gluestretchorder}, and
\.{\\glueshrinkorder} commands return the stretch and shrink components
and their orders of ``infinity'' of a glue specification.

@d glue_stretch_order_code=eTeX_int+6 {code for \.{\\gluestretchorder}}
@d glue_shrink_order_code=eTeX_int+7 {code for \.{\\glueshrinkorder}}
@d glue_stretch_code=eTeX_dim+7 {code for \.{\\gluestretch}}
@d glue_shrink_code=eTeX_dim+8 {code for \.{\\glueshrink}}

@<Generate all \eTeX...@>=
primitive("gluestretchorder",last_item,glue_stretch_order_code);
@!@:glue_stretch_order_}{\.{\\gluestretchorder} primitive@>
primitive("glueshrinkorder",last_item,glue_shrink_order_code);
@!@:glue_shrink_order_}{\.{\\glueshrinkorder} primitive@>
primitive("gluestretch",last_item,glue_stretch_code);
@!@:glue_stretch_}{\.{\\gluestretch} primitive@>
primitive("glueshrink",last_item,glue_shrink_code);
@!@:glue_shrink_}{\.{\\glueshrink} primitive@>

@ @<Cases of |last_item| for |print_cmd_chr|@>=
glue_stretch_order_code: print_esc("gluestretchorder");
glue_shrink_order_code: print_esc("glueshrinkorder");
glue_stretch_code: print_esc("gluestretch");
glue_shrink_code: print_esc("glueshrink");

@ @<Cases for fetching an integer value@>=
glue_stretch_order_code, glue_shrink_order_code:
  begin scan_normal_glue; q:=cur_val;
  if m=glue_stretch_order_code then cur_val:=stretch_order(q)
  else cur_val:=shrink_order(q);
  delete_glue_ref(q);
  end;

@ @<Cases for fetching a dimension value@>=
glue_stretch_code, glue_shrink_code:
  begin scan_normal_glue; q:=cur_val;
  if m=glue_stretch_code then cur_val:=stretch(q)
  else cur_val:=shrink(q);
  delete_glue_ref(q);
  end;

@ The \.{\\mutoglue} and \.{\\gluetomu} commands convert ``math'' glue
into normal glue and vice versa; they allow to manipulate math glue with
\.{\\gluestretch} etc.

@d mu_to_glue_code=eTeX_glue {code for \.{\\mutoglue}}
@d glue_to_mu_code=eTeX_mu {code for \.{\\gluetomu}}

@<Generate all \eTeX...@>=
primitive("mutoglue",last_item,mu_to_glue_code);
@!@:mu_to_glue_}{\.{\\mutoglue} primitive@>
primitive("gluetomu",last_item,glue_to_mu_code);
@!@:glue_to_mu_}{\.{\\gluetomu} primitive@>

@ @<Cases of |last_item| for |print_cmd_chr|@>=
mu_to_glue_code: print_esc("mutoglue");
glue_to_mu_code: print_esc("gluetomu");

@ @<Cases for fetching a glue value@>=
mu_to_glue_code: scan_mu_glue;

@ @<Cases for fetching a mu value@>=
glue_to_mu_code: scan_normal_glue;

@ \eTeX\ (in extended mode) supports 32768 (i.e., $2^{15}$) count,
dimen, skip, muskip, box, and token registers.  As in \TeX\ the first
256 registers of each kind are realized as arrays in the table of
equivalents; the additional registers are realized as tree structures
built from variable-size nodes with individual registers existing only
when needed.  Default values are used for nonexistent registers:  zero
for count and dimen values, |zero_glue| for glue (skip and muskip)
values, void for boxes, and |null| for token lists (and current marks
discussed below).

Similarly there are 32768 mark classes; the command \.{\\marks}|n|
creates a mark node for a given mark class |0<=n<=32767| (where
\.{\\marks0} is synonymous to \.{\\mark}).  The page builder (actually
the |fire_up| routine) and the |vsplit| routine maintain the current
values of |top_mark|, |first_mark|, |bot_mark|, |split_first_mark|, and
|split_bot_mark| for each mark class.  They are accessed as
\.{\\topmarks}|n| etc., and \.{\\topmarks0} is again synonymous to
\.{\\topmark}.  As in \TeX\ the five current marks for mark class zero
are realized as |cur_mark| array.  The additional current marks are
again realized as tree structure with individual mark classes existing
only when needed.

@<Generate all \eTeX...@>=
primitive("marks",mark,marks_code);
@!@:marks_}{\.{\\marks} primitive@>
primitive("topmarks",top_bot_mark,top_mark_code+marks_code);
@!@:top_marks_}{\.{\\topmarks} primitive@>
primitive("firstmarks",top_bot_mark,first_mark_code+marks_code);
@!@:first_marks_}{\.{\\firstmarks} primitive@>
primitive("botmarks",top_bot_mark,bot_mark_code+marks_code);
@!@:bot_marks_}{\.{\\botmarks} primitive@>
primitive("splitfirstmarks",top_bot_mark,split_first_mark_code+marks_code);
@!@:split_first_marks_}{\.{\\splitfirstmarks} primitive@>
primitive("splitbotmarks",top_bot_mark,split_bot_mark_code+marks_code);
@!@:split_bot_marks_}{\.{\\splitbotmarks} primitive@>

@ The |scan_register_num| procedure scans a register number that must
not exceed 255 in compatibility mode resp.\ 32767 in extended mode.

@<Declare \eTeX\ procedures for ex...@>=
procedure@?scan_register_num; forward;@t\2@>

@ @<Declare procedures that scan restricted classes of integers@>=
procedure scan_register_num;
begin scan_int;
if (cur_val<0)or(cur_val>max_reg_num) then
  begin print_err("Bad register code");
@.Bad register code@>
  help2(max_reg_help_line)("I changed this one to zero.");
  int_error(cur_val); cur_val:=0;
  end;
end;

@ @<Initialize variables for \eTeX\ comp...@>=
max_reg_num:=255;
max_reg_help_line:="A register number must be between 0 and 255.";

@ @<Initialize variables for \eTeX\ ext...@>=
max_reg_num:=32767;
max_reg_help_line:="A register number must be between 0 and 32767.";

@ @<Glob...@>=
@!max_reg_num: halfword; {largest allowed register number}
@!max_reg_help_line: str_number; {first line of help message}

@ There are seven almost identical doubly linked trees, one for the
sparse array of the up to 32512 additional registers of each kind and
one for the sparse array of the up to 32767 additional mark classes.
The root of each such tree, if it exists, is an index node containing 16
pointers to subtrees for 4096 consecutive array elements.  Similar index
nodes are the starting points for all nonempty subtrees for 4096, 256,
and 16 consecutive array elements.  These four levels of index nodes are
followed by a fifth level with nodes for the individual array elements.

Each index node is nine words long.  The pointers to the 16 possible
subtrees or are kept in the |info| and |link| fields of the last eight
words.  (It would be both elegant and efficient to declare them as
array, unfortunately \PASCAL\ doesn't allow this.)

The fields in the first word of each index node and in the nodes for the
array elements are closely related.  The |link| field points to the next
lower index node and the |sa_index| field contains four bits (one
hexadecimal digit) of the register number or mark class.  For the lowest
index node the |link| field is |null| and the |sa_index| field indicates
the type of quantity (|int_val|, |dimen_val|, |glue_val|, |mu_val|,
|box_val|, |tok_val|, or |mark_val|).  The |sa_used| field in the index
nodes counts how many of the 16 pointers are non-null.

The |sa_index| field in the nodes for array elements contains the four
bits plus 16 times the type.  Therefore such a node represents a count
or dimen register if and only if |sa_index<dimen_val_limit|; it
represents a skip or muskip register if and only if
|dimen_val_limit<=sa_index<mu_val_limit|; it represents a box register
if and only if |mu_val_limit<=sa_index<box_val_limit|; it represents a
token list register if and only if
|box_val_limit<=sa_index<tok_val_limit|; finally it represents a mark
class if and only if |tok_val_limit<=sa_index|.

The |new_index| procedure creates an index node (returned in |cur_ptr|)
having given contents of the |sa_index| and |link| fields.

@d box_val==4 {the additional box registers}
@d mark_val=6 {the additional mark classes}
@#
@d dimen_val_limit=@"20 {$2^4\cdot(|dimen_val|+1)$}
@d mu_val_limit=@"40 {$2^4\cdot(|mu_val|+1)$}
@d box_val_limit=@"50 {$2^4\cdot(|box_val|+1)$}
@d tok_val_limit=@"60 {$2^4\cdot(|tok_val|+1)$}
@#
@d index_node_size=9 {size of an index node}
@d sa_index==type {a four-bit address or a type or both}
@d sa_used==subtype {count of non-null pointers}

@<Declare \eTeX\ procedures for ex...@>=
procedure new_index(@!i:quarterword; @!q:pointer);
var k:small_number; {loop index}
begin cur_ptr:=get_node(index_node_size); sa_index(cur_ptr):=i;
sa_used(cur_ptr):=0; link(cur_ptr):=q;
for k:=1 to index_node_size-1 do {clear all 16 pointers}
  mem[cur_ptr+k]:=sa_null;
end;

@ The roots of the seven trees for the additional registers and mark
classes are kept in the |sa_root| array.  The first six locations must
be dumped and undumped; the last one is also known as |sa_mark|.

@d sa_mark==sa_root[mark_val] {root for mark classes}

@<Glob...@>=
@!sa_root:array[int_val..mark_val] of pointer; {roots of sparse arrays}
@!cur_ptr:pointer; {value returned by |new_index| and |find_sa_element|}
@!sa_null:memory_word; {two |null| pointers}

@ @<Set init...@>=
sa_mark:=null; sa_null.hh.lh:=null; sa_null.hh.rh:=null;

@ @<Initialize table...@>=
for i:=int_val to tok_val do sa_root[i]:=null;

@ Given a type |t| and a sixteen-bit number |n|, the |find_sa_element|
procedure returns (in |cur_ptr|) a pointer to the node for the
corresponding array element, or |null| when no such element exists.  The
third parameter |w| is set |true| if the element must exist, e.g.,
because it is about to be modified.  The procedure has two main
branches:  one follows the existing tree structure, the other (only used
when |w| is |true|) creates the missing nodes.

We use macros to extract the four-bit pieces from a sixteen-bit register
number or mark class and to fetch or store one of the 16 pointers from
an index node.

@d if_cur_ptr_is_null_then_return_or_goto(#)== {some tree element is missing}
  begin if cur_ptr=null then
    if w then goto #@+else return;
  end
@#
@d hex_dig1(#)==# div 4096 {the fourth lowest hexadecimal digit}
@d hex_dig2(#)==(# div 256) mod 16 {the third lowest hexadecimal digit}
@d hex_dig3(#)==(# div 16) mod 16 {the second lowest hexadecimal digit}
@d hex_dig4(#)==# mod 16 {the lowest hexadecimal digit}
@#
@d get_sa_ptr==if odd(i) then cur_ptr:=link(q+(i div 2)+1)
  else cur_ptr:=info(q+(i div 2)+1)
    {set |cur_ptr| to the pointer indexed by |i| from index node |q|}
@d put_sa_ptr(#)==if odd(i) then link(q+(i div 2)+1):=#
  else info(q+(i div 2)+1):=#
    {store the pointer indexed by |i| in index node |q|}
@d add_sa_ptr==begin put_sa_ptr(cur_ptr); incr(sa_used(q));
  end {add |cur_ptr| as the pointer indexed by |i| in index node |q|}
@d delete_sa_ptr==begin put_sa_ptr(null); decr(sa_used(q));
  end {delete the pointer indexed by |i| in index node |q|}

@<Declare \eTeX\ procedures for ex...@>=
procedure find_sa_element(@!t:small_number;@!n:halfword;@!w:boolean);
  {sets |cur_val| to sparse array element location or |null|}
label not_found,not_found1,not_found2,not_found3,not_found4,exit;
var q:pointer; {for list manipulations}
@!i:small_number; {a four bit index}
begin cur_ptr:=sa_root[t];
if_cur_ptr_is_null_then_return_or_goto(not_found);@/
q:=cur_ptr; i:=hex_dig1(n); get_sa_ptr;
if_cur_ptr_is_null_then_return_or_goto(not_found1);@/
q:=cur_ptr; i:=hex_dig2(n); get_sa_ptr;
if_cur_ptr_is_null_then_return_or_goto(not_found2);@/
q:=cur_ptr; i:=hex_dig3(n); get_sa_ptr;
if_cur_ptr_is_null_then_return_or_goto(not_found3);@/
q:=cur_ptr; i:=hex_dig4(n); get_sa_ptr;
if (cur_ptr=null)and w then goto not_found4;
return;
not_found: new_index(t,null); {create first level index node}
sa_root[t]:=cur_ptr; q:=cur_ptr; i:=hex_dig1(n);
not_found1: new_index(i,q); {create second level index node}
add_sa_ptr; q:=cur_ptr; i:=hex_dig2(n);
not_found2: new_index(i,q); {create third level index node}
add_sa_ptr; q:=cur_ptr; i:=hex_dig3(n);
not_found3: new_index(i,q); {create fourth level index node}
add_sa_ptr; q:=cur_ptr; i:=hex_dig4(n);
not_found4: @<Create a new array element of type |t| with index |i|@>;
link(cur_ptr):=q; add_sa_ptr;
exit:end;

@ The array elements for registers are subject to grouping and have an
|sa_lev| field (quite analogous to |eq_level|) instead of |sa_used|.
Since saved values as well as shorthand definitions (created by e.g.,
\.{\\countdef}) refer to the location of the respective array element,
we need a reference count that is kept in the |sa_ref| field.  An array
element can be deleted (together with all references to it) when its
|sa_ref| value is |null| and its value is the default value.
@^reference counts@>

Skip, muskip, box, and token registers use two word nodes, their values
are stored in the |sa_ptr| field.
Count and dimen registers use three word nodes, their
values are stored in the |sa_int| resp.\ |sa_dim| field in the third
word; the |sa_ptr| field is used under the name |sa_num| to store
the register number.  Mark classes use four word nodes.  The last three
words contain the five types of current marks

@d sa_lev==sa_used {grouping level for the current value}
@d pointer_node_size=2 {size of an element with a pointer value}
@d sa_type(#)==(sa_index(#) div 16) {type part of combined type/index}
@d sa_ref(#)==info(#+1) {reference count of a sparse array element}
@d sa_ptr(#)==link(#+1) {a pointer value}
@#
@d word_node_size=3 {size of an element with a word value}
@d sa_num==sa_ptr {the register number}
@d sa_int(#)==mem[#+2].int {an integer}
@d sa_dim(#)==mem[#+2].sc {a dimension (a somewhat esotheric distinction)}
@#
@d mark_class_node_size=4 {size of an element for a mark class}
@#
@d fetch_box(#)== {fetch |box(cur_val)|}
  if cur_val<256 then #:=box(cur_val)
  else  begin find_sa_element(box_val,cur_val,false);
    if cur_ptr=null then #:=null@+else #:=sa_ptr(cur_ptr);
    end

@<Create a new array element...@>=
if t=mark_val then {a mark class}
  begin cur_ptr:=get_node(mark_class_node_size);
  mem[cur_ptr+1]:=sa_null; mem[cur_ptr+2]:=sa_null; mem[cur_ptr+3]:=sa_null;
  end
else  begin if t<=dimen_val then {a count or dimen register}
    begin cur_ptr:=get_node(word_node_size); sa_int(cur_ptr):=0;
    sa_num(cur_ptr):=n;
    end
  else  begin cur_ptr:=get_node(pointer_node_size);
    if t<=mu_val then {a skip or muskip register}
      begin sa_ptr(cur_ptr):=zero_glue; add_glue_ref(zero_glue);
      end
    else sa_ptr(cur_ptr):=null; {a box or token list register}
    end;
  sa_ref(cur_ptr):=null; {all registers have a reference count}
  end;
sa_index(cur_ptr):=16*t+i; sa_lev(cur_ptr):=level_one

@ The |delete_sa_ref| procedure is called when a pointer to an array
element representing a register is being removed; this means that the
reference count should be decreased by one.  If the reduced reference
count is |null| and the register has been (globally) assigned its
default value the array element should disappear, possibly together with
some index nodes.  This procedure will never be used for mark class
nodes.
@^reference counts@>

@d add_sa_ref(#)==incr(sa_ref(#)) {increase reference count}
@#
@d change_box(#)== {change |box(cur_val)|, the |eq_level| stays the same}
  if cur_val<256 then box(cur_val):=#@+else set_sa_box(#)
@#
@d set_sa_box(#)==begin find_sa_element(box_val,cur_val,false);
  if cur_ptr<>null then
    begin sa_ptr(cur_ptr):=#; add_sa_ref(cur_ptr); delete_sa_ref(cur_ptr);
    end;
  end

@<Declare \eTeX\ procedures for tr...@>=
procedure delete_sa_ref(@!q:pointer); {reduce reference count}
label exit;
var p:pointer; {for list manipulations}
@!i:small_number; {a four bit index}
@!s:small_number; {size of a node}
begin decr(sa_ref(q));
if sa_ref(q)<>null then return;
if sa_index(q)<dimen_val_limit then
 if sa_int(q)=0 then s:=word_node_size
 else return
else  begin if sa_index(q)<mu_val_limit then
    if sa_ptr(q)=zero_glue then delete_glue_ref(zero_glue)
    else return
  else if sa_ptr(q)<>null then return;
  s:=pointer_node_size;
  end;
repeat i:=hex_dig4(sa_index(q)); p:=q; q:=link(p); free_node(p,s);
if q=null then {the whole tree has been freed}
  begin sa_root[i]:=null; return;
  end;
delete_sa_ptr; s:=index_node_size; {node |q| is an index node}
until sa_used(q)>0;
exit:end;

@ The |print_sa_num| procedure prints the register number corresponding
to an array element.

@<Basic print...@>=
procedure print_sa_num(@!q:pointer); {print register number}
var @!n:halfword; {the register number}
begin if sa_index(q)<dimen_val_limit then n:=sa_num(q) {the easy case}
else  begin n:=hex_dig4(sa_index(q)); q:=link(q); n:=n+16*sa_index(q);
  q:=link(q); n:=n+256*(sa_index(q)+16*sa_index(link(q)));
  end;
print_int(n);
end;

@ Here is a procedure that displays the contents of an array element
symbolically.  It is used under similar circumstances as is
|restore_trace| (together with |show_eqtb|) for the quantities kept in
the |eqtb| array.

@<Declare \eTeX\ procedures for tr...@>=
@!stat procedure show_sa(@!p:pointer;@!s:str_number);
var t:small_number; {the type of element}
begin begin_diagnostic; print_char("{"); print(s); print_char(" ");
if p=null then print_char("?") {this can't happen}
else  begin t:=sa_type(p);
  if t<box_val then print_cmd_chr(register,p)
  else if t=box_val then
    begin print_esc("box"); print_sa_num(p);
    end
  else if t=tok_val then print_cmd_chr(toks_register,p)
  else print_char("?"); {this can't happen either}
  print_char("=");
  if t=int_val then print_int(sa_int(p))
  else if t=dimen_val then
    begin print_scaled(sa_dim(p)); print("pt");
    end
  else  begin p:=sa_ptr(p);
    if t=glue_val then print_spec(p,"pt")
    else if t=mu_val then print_spec(p,"mu")
    else if t=box_val then
      if p=null then print("void")
      else  begin depth_threshold:=0; breadth_max:=1; show_node_list(p);
        end
    else if t=tok_val then
      begin if p<>null then show_token_list(link(p),null,32);
      end
    else print_char("?"); {this can't happen either}
    end;
  end;
print_char("}"); end_diagnostic(false);
end;
tats

@ Here we compute the pointer to the current mark of type |t| and mark
class |cur_val|.

@<Compute the mark pointer...@>=
begin find_sa_element(mark_val,cur_val,false);
if cur_ptr<>null then
  if odd(t) then cur_ptr:=link(cur_ptr+(t div 2)+1)
  else cur_ptr:=info(cur_ptr+(t div 2)+1);
end

@ The current marks for all mark classes are maintained by the |vsplit|
and |fire_up| routines and are finally destroyed (for \.{INITEX} only)
@.INITEX@>
by the |final_cleanup| routine.  Apart from updating the current marks
when mark nodes are encountered, these routines perform certain actions
on all existing mark classes.  The recursive |do_marks| procedure walks
through the whole tree or a subtree of existing mark class nodes and
preforms certain actions indicted by its first parameter |a|, the action
code.  The second parameter |l| indicates the level of recursion (at
most four); the third parameter points to a nonempty tree or subtree.
The result is |true| if the complete tree or subtree has been deleted.

@d vsplit_init==0 {action code for |vsplit| initialization}
@d fire_up_init==1 {action code for |fire_up| initialization}
@d fire_up_done==2 {action code for |fire_up| completion}
@d destroy_marks==3 {action code for |final_cleanup|}
@#
@d sa_top_mark(#)==info(#+1) {\.{\\topmarks}|n|}
@d sa_first_mark(#)==link(#+1) {\.{\\firstmarks}|n|}
@d sa_bot_mark(#)==info(#+2) {\.{\\botmarks}|n|}
@d sa_split_first_mark(#)==link(#+2) {\.{\\splitfirstmarks}|n|}
@d sa_split_bot_mark(#)==info(#+3) {\.{\\splitbotmarks}|n|}

@<Declare the function called |do_marks|@>=
function do_marks(@!a,@!l:small_number;@!q:pointer):boolean;
var i:small_number; {a four bit index}
begin if l<4 then {|q| is an index node}
  begin for i:=0 to 15 do
    begin get_sa_ptr;
    if cur_ptr<>null then if do_marks(a,l+1,cur_ptr) then delete_sa_ptr;
    end;
  if sa_used(q)=0 then
    begin free_node(q,index_node_size); q:=null;
    end;
  end
else {|q| is the node for a mark class}
  begin case a of
  @<Cases for |do_marks|@>@;
  end; {there are no other cases}
  if sa_bot_mark(q)=null then if sa_split_bot_mark(q)=null then
    begin free_node(q,mark_class_node_size); q:=null;
    end;
  end;
do_marks:=(q=null);
end;

@ At the start of the |vsplit| routine the existing |split_fist_mark|
and |split_bot_mark| are discarded.

@<Cases for |do_marks|@>=
vsplit_init: if sa_split_first_mark(q)<>null then
  begin delete_token_ref(sa_split_first_mark(q)); sa_split_first_mark(q):=null;
  delete_token_ref(sa_split_bot_mark(q)); sa_split_bot_mark(q):=null;
  end;

@ We use again the fact that |split_first_mark=null| if and only if
|split_bot_mark=null|.

@<Update the current marks for |vsplit|@>=
begin find_sa_element(mark_val,mark_class(p),true);
if sa_split_first_mark(cur_ptr)=null then
  begin sa_split_first_mark(cur_ptr):=mark_ptr(p);
  add_token_ref(mark_ptr(p));
  end
else delete_token_ref(sa_split_bot_mark(cur_ptr));
sa_split_bot_mark(cur_ptr):=mark_ptr(p);
add_token_ref(mark_ptr(p));
end

@ At the start of the |fire_up| routine the old |top_mark| and
|first_mark| are discarded, whereas the old |bot_mark| becomes the new
|top_mark|.  An empty new |top_mark| token list is, however, discarded
as well in order that mark class nodes can eventually be released.  We
use again the fact that |bot_mark<>null| implies |first_mark<>null|; it
also knows that |bot_mark=null| implies |top_mark=first_mark=null|.

@<Cases for |do_marks|@>=
fire_up_init: if sa_bot_mark(q)<>null then
  begin if sa_top_mark(q)<>null then delete_token_ref(sa_top_mark(q));
  delete_token_ref(sa_first_mark(q)); sa_first_mark(q):=null;
  if link(sa_bot_mark(q))=null then {an empty token list}
    begin delete_token_ref(sa_bot_mark(q)); sa_bot_mark(q):=null;
    end
  else add_token_ref(sa_bot_mark(q));
  sa_top_mark(q):=sa_bot_mark(q);
  end;

@ @<Cases for |do_marks|@>=
fire_up_done: if (sa_top_mark(q)<>null)and(sa_first_mark(q)=null) then
  begin sa_first_mark(q):=sa_top_mark(q); add_token_ref(sa_top_mark(q));
  end;

@ @<Update the current marks for |fire_up|@>=
begin find_sa_element(mark_val,mark_class(p),true);
if sa_first_mark(cur_ptr)=null then
  begin sa_first_mark(cur_ptr):=mark_ptr(p);
  add_token_ref(mark_ptr(p));
  end;
if sa_bot_mark(cur_ptr)<>null then delete_token_ref(sa_bot_mark(cur_ptr));
sa_bot_mark(cur_ptr):=mark_ptr(p); add_token_ref(mark_ptr(p));
end

@ Here we use the fact that the five current mark pointers in a mark
class node occupy the same locations as the the first five pointers of
an index node.  For systems using a run-time switch to distinguish
between \.{VIRTEX} and \.{INITEX}, the codewords `$|init|\ldots|tini|$'
surrounding the following piece of code should be removed.
@.INITEX@>
@^system dependencies@>

@<Cases for |do_marks|@>=
@!init destroy_marks: for i:=top_mark_code to split_bot_mark_code do
  begin get_sa_ptr;
  if cur_ptr<>null then
    begin delete_token_ref(cur_ptr); put_sa_ptr(null);
    end;
  end;
tini

@ The command code |register| is used for `\.{\\count}', `\.{\\dimen}',
etc., as well as for references to sparse array elements defined by
`\.{\\countdef}', etc.

@<Cases of |register| for |print_cmd_chr|@>=
begin if (chr_code<mem_bot)or(chr_code>lo_mem_stat_max) then
  cmd:=sa_type(chr_code)
else  begin cmd:=chr_code-mem_bot; chr_code:=null;
  end;
if cmd=int_val then print_esc("count")
else if cmd=dimen_val then print_esc("dimen")
else if cmd=glue_val then print_esc("skip")
else print_esc("muskip");
if chr_code<>null then print_sa_num(chr_code);
end

@ Similarly the command code |toks_register| is used for `\.{\\toks}' as
well as for references to sparse array elements defined by
`\.{\\toksdef}'.

@<Cases of |toks_register| for |print_cmd_chr|@>=
begin print_esc("toks");
if chr_code<>mem_bot then print_sa_num(chr_code);
end

@ When a shorthand definition for an element of one of the sparse arrays
is destroyed, we must reduce the reference count.

@<Cases for |eq_destroy|@>=
toks_register,register:
  if (equiv_field(w)<mem_bot)or(equiv_field(w)>lo_mem_stat_max) then
    delete_sa_ref(equiv_field(w));

@ The task to maintain (change, save, and restore) register values is
essentially the same when the register is realized as sparse array
element or entry in |eqtb|.  The global variable |sa_chain| is the head
of a linked list of entries saved at the topmost level |sa_level|; the
lists for lowel levels are kept in special save stack entries.

@<Glob...@>=
@!sa_chain: pointer; {chain of saved sparse array entries}
@!sa_level: quarterword; {group level for |sa_chain|}

@ @<Set init...@>=
sa_chain:=null; sa_level:=level_zero;

@ The individual saved items are kept in pointer or word nodes similar
to those used for the array elements: a word node with value zero is,
however, saved as pointer node with the otherwise impossible |sa_index|
value |tok_val_limit|.

@d sa_loc==sa_ref {location of saved item}

@<Declare \eTeX\ procedures for tr...@>=
procedure sa_save(@!p:pointer); {saves value of |p|}
var q:pointer; {the new save node}
@!i:quarterword; {index field of node}
begin if cur_level<>sa_level then
  begin check_full_save_stack; save_type(save_ptr):=restore_sa;
  save_level(save_ptr):=sa_level; save_index(save_ptr):=sa_chain;
  incr(save_ptr); sa_chain:=null; sa_level:=cur_level;
  end;
i:=sa_index(p);
if i<dimen_val_limit then
  begin if sa_int(p)=0 then
    begin q:=get_node(pointer_node_size); i:=tok_val_limit;
    end
  else  begin q:=get_node(word_node_size); sa_int(q):=sa_int(p);
    end;
  sa_ptr(q):=null;
  end
else  begin q:=get_node(pointer_node_size); sa_ptr(q):=sa_ptr(p);
  end;
sa_loc(q):=p; sa_index(q):=i; sa_lev(q):=sa_lev(p);
link(q):=sa_chain; sa_chain:=q; add_sa_ref(p);
end;

@ @<Declare \eTeX\ procedures for tr...@>=
procedure sa_destroy(@!p:pointer); {destroy value of |p|}
begin if sa_index(p)<mu_val_limit then delete_glue_ref(sa_ptr(p))
else if sa_ptr(p)<>null then
  if sa_index(p)<box_val_limit then flush_node_list(sa_ptr(p))
  else delete_token_ref(sa_ptr(p));
end;

@ The procedure |sa_def| assigns a new value to sparse array elements,
and saves the former value if appropriate.  This procedure is used only
for skip, muskip, box, and token list registers.  The counterpart of
|sa_def| for count and dimen registers is called |sa_w_def|.

@d sa_define(#)==if e then
    if global then gsa_def(#)@+else sa_def(#)
  else define
@#
@d sa_def_box== {assign |cur_box| to |box(cur_val)|}
  begin find_sa_element(box_val,cur_val,true);
  if global then gsa_def(cur_ptr,cur_box)@+else sa_def(cur_ptr,cur_box);
  end
@#
@d sa_word_define(#)==if e then
    if global then gsa_w_def(#)@+else sa_w_def(#)
  else word_define(#)

@<Declare \eTeX\ procedures for tr...@>=
procedure sa_def(@!p:pointer;@!e:halfword);
  {new data for sparse array elements}
begin add_sa_ref(p);
if sa_ptr(p)=e then
  begin @!stat if tracing_assigns>0 then show_sa(p,"reassigning");@+tats@;@/
  sa_destroy(p);
  end
else  begin @!stat if tracing_assigns>0 then show_sa(p,"changing");@+tats@;@/
  if sa_lev(p)=cur_level then sa_destroy(p)@+else sa_save(p);
  sa_lev(p):=cur_level; sa_ptr(p):=e;
  @!stat if tracing_assigns>0 then show_sa(p,"into");@+tats@;@/
  end;
delete_sa_ref(p);
end;
@#
procedure sa_w_def(@!p:pointer;@!w:integer);
begin add_sa_ref(p);
if sa_int(p)=w then
  begin @!stat if tracing_assigns>0 then show_sa(p,"reassigning");@+tats@;@/
  end
else  begin @!stat if tracing_assigns>0 then show_sa(p,"changing");@+tats@;@/
  if sa_lev(p)<>cur_level then sa_save(p);
  sa_lev(p):=cur_level; sa_int(p):=w;
  @!stat if tracing_assigns>0 then show_sa(p,"into");@+tats@;@/
  end;
delete_sa_ref(p);
end;

@ The |sa_def| and |sa_w_def| routines take care of local definitions.
@^global definitions@>
Global definitions are done in almost the same way, but there is no need
to save old values, and the new value is associated with |level_one|.

@<Declare \eTeX\ procedures for tr...@>=
procedure gsa_def(@!p:pointer;@!e:halfword); {global |sa_def|}
begin add_sa_ref(p);
@!stat if tracing_assigns>0 then show_sa(p,"globally changing");@+tats@;@/
sa_destroy(p); sa_lev(p):=level_one; sa_ptr(p):=e;
@!stat if tracing_assigns>0 then show_sa(p,"into");@+tats@;@/
delete_sa_ref(p);
end;
@#
procedure gsa_w_def(@!p:pointer;@!w:integer); {global |sa_w_def|}
begin add_sa_ref(p);
@!stat if tracing_assigns>0 then show_sa(p,"globally changing");@+tats@;@/
sa_lev(p):=level_one; sa_int(p):=w;
@!stat if tracing_assigns>0 then show_sa(p,"into");@+tats@;@/
delete_sa_ref(p);
end;

@ The |sa_restore| procedure restores the sparse array entries pointed
at by |sa_chain|

@<Declare \eTeX\ procedures for tr...@>=
procedure sa_restore;
var p:pointer; {sparse array element}
begin repeat p:=sa_loc(sa_chain);
if sa_lev(p)=level_one then
  begin if sa_index(p)>=dimen_val_limit then sa_destroy(sa_chain);
  @!stat if tracing_restores>0 then show_sa(p,"retaining");@+tats@;@/
  end
else  begin if sa_index(p)<dimen_val_limit then
    if sa_index(sa_chain)<dimen_val_limit then sa_int(p):=sa_int(sa_chain)
    else sa_int(p):=0
  else  begin sa_destroy(p); sa_ptr(p):=sa_ptr(sa_chain);
    end;
  sa_lev(p):=sa_lev(sa_chain);
  @!stat if tracing_restores>0 then show_sa(p,"restoring");@+tats@;@/
  end;
delete_sa_ref(p);
p:=sa_chain; sa_chain:=link(p);
if sa_index(p)<dimen_val_limit then free_node(p,word_node_size)
else free_node(p,pointer_node_size);
until sa_chain=null;
end;

@ When the value of |last_line_fit| is positive, the last line of a
(partial) paragraph is treated in a special way and we need additional
fields in the active nodes.

@d active_node_size_extended=5 {number of words in extended active nodes}
@d active_short(#)==mem[#+3].sc {|shortfall| of this line}
@d active_glue(#)==mem[#+4].sc {corresponding glue stretch or shrink}

@<Glob...@>=
@!last_line_fill:pointer; {the |par_fill_skip| glue node of the new paragraph}
@!do_last_line_fit:boolean; {special algorithm for last line of paragraph?}
@!active_node_size:small_number; {number of words in active nodes}
@!fill_width:array[0..2] of scaled; {infinite stretch components of
  |par_fill_skip|}
@!best_pl_short:array[very_loose_fit..tight_fit] of scaled; {|shortfall|
  corresponding to |minimal_demerits|}
@!best_pl_glue:array[very_loose_fit..tight_fit] of scaled; {corresponding
  glue stretch or shrink}

@ The new algorithm for the last line requires that the stretchability of
|par_fill_skip| is infinite and the stretchability of |left_skip| plus
|right_skip| is finite.

@<Check for special...@>=
do_last_line_fit:=false; active_node_size:=active_node_size_normal;
  {just in case}
if last_line_fit>0 then
  begin q:=glue_ptr(last_line_fill);
  if (stretch(q)>0)and(stretch_order(q)>normal) then
    if (background[3]=0)and(background[4]=0)and(background[5]=0) then
    begin do_last_line_fit:=true;
    active_node_size:=active_node_size_extended;
    fill_width[0]:=0; fill_width[1]:=0; fill_width[2]:=0;
    fill_width[stretch_order(q)-1]:=stretch(q);
    end;
  end

@ @<Other local variables for |try_break|@>=
@!g:scaled; {glue stretch or shrink of test line, adjustment for last line}

@ Here we initialize the additional fields of the first active node
representing the beginning of the paragraph.

@<Initialize additional fields of the first active node@>=
begin active_short(q):=0; active_glue(q):=0;
end

@ Here we compute the adjustment |g| and badness |b| for a line from |r|
to the end of the paragraph.  When any of the criteria for adjustment is
violated we fall through to the normal algorithm.

The last line must be too short, and have infinite stretch entirely due
to |par_fill_skip|.

@<Perform computations for last line and |goto found|@>=
begin if (active_short(r)=0)or(active_glue(r)<=0) then goto not_found;
  {previous line was neither stretched nor shrunk, or was infinitely bad}
if (cur_active_width[3]<>fill_width[0])or@|
  (cur_active_width[4]<>fill_width[1])or@|
  (cur_active_width[5]<>fill_width[2]) then goto not_found;
  {infinite stretch of this line not entirely due to |par_fill_skip|}
if active_short(r)>0 then g:=cur_active_width[2]
else g:=cur_active_width[6];
if g<=0 then goto not_found; {no finite stretch resp.\ no shrink}
arith_error:=false; g:=fract(g,active_short(r),active_glue(r),max_dimen);
if last_line_fit<1000 then g:=fract(g,last_line_fit,1000,max_dimen);
if arith_error then
  if active_short(r)>0 then g:=max_dimen@+else g:=-max_dimen;
if g>0 then
  @<Set the value of |b| to the badness of the last line for stretching,
    compute the corresponding |fit_class|, and |goto found|@>
else if g<0 then
  @<Set the value of |b| to the badness of the last line for shrinking,
    compute the corresponding |fit_class|, and |goto found|@>;
not_found:end

@ These badness computations are rather similar to those of the standard
algorithm, with the adjustment amount |g| replacing the |shortfall|.

@<Set the value of |b| to the badness of the last line for str...@>=
begin if g>shortfall then g:=shortfall;
if g>7230584 then if cur_active_width[2]<1663497 then
  begin b:=inf_bad; fit_class:=very_loose_fit; goto found;
  end;
b:=badness(g,cur_active_width[2]);
if b>12 then
  if b>99 then fit_class:=very_loose_fit
  else fit_class:=loose_fit
else fit_class:=decent_fit;
goto found;
end

@ @<Set the value of |b| to the badness of the last line for shr...@>=
begin if -g>cur_active_width[6] then g:=-cur_active_width[6];
b:=badness(-g,cur_active_width[6]);
if b>12 then fit_class:=tight_fit@+else fit_class:=decent_fit;
goto found;
end

@ Vanishing values of |shortfall| and |g| indicate that the last line is
not adjusted.

@<Adjust \(t)the additional data for last line@>=
begin if cur_p=null then shortfall:=0;
if shortfall>0 then g:=cur_active_width[2]
else if shortfall<0 then g:=cur_active_width[6]
else g:=0;
end

@ For each feasible break we record the shortfall and glue stretch or
shrink (or adjustment).

@<Store \(a)additional data for this feasible break@>=
begin best_pl_short[fit_class]:=shortfall; best_pl_glue[fit_class]:=g;
end

@ Here we save these data in the active node representing a potential
line break.

@<Store \(a)additional data in the new active node@>=
begin active_short(q):=best_pl_short[fit_class];
active_glue(q):=best_pl_glue[fit_class];
end

@ @<Print additional data in the new active node@>=
begin print(" s="); print_scaled(active_short(q));
if cur_p=null then print(" a=")@+else print(" g=");
print_scaled(active_glue(q));
end

@ Here we either reset |do_last_line_fit| or adjust the |par_fill_skip|
glue.

@<Adjust \(t)the final line of the paragraph@>=
if active_short(best_bet)=0 then do_last_line_fit:=false
else  begin q:=new_spec(glue_ptr(last_line_fill));
  delete_glue_ref(glue_ptr(last_line_fill));
  width(q):=width(q)+active_short(best_bet)-active_glue(best_bet);
  stretch(q):=0; glue_ptr(last_line_fill):=q;
  end

@ When reading \.{\\patterns} while \.{\\savinghyphcodes} is positive
the current |lc_code| values are stored together with the hyphenation
patterns for the current language.  They will later be used instead of
the |lc_code| values for hyphenation purposes.

The |lc_code| values are stored in the linked trie analogous to patterns
$p_1$ of length~1, with |hyph_root=trie_r[0]| replacing |trie_root| and
|lc_code(p_1)| replacing the |trie_op| code.  This allows to compress
and pack them together with the patterns with minimal changes to the
existing code.

@d hyph_root==trie_r[0] {root of the linked trie for |hyph_codes|}

@<Initialize table entries...@>=
hyph_root:=0; hyph_start:=0;

@ @<Store hyphenation codes for current language@>=
begin c:=cur_lang; first_child:=false; p:=0;
repeat q:=p; p:=trie_r[q];
until (p=0)or(c<=so(trie_c[p]));
if (p=0)or(c<so(trie_c[p])) then
  @<Insert a new trie node between |q| and |p|, and
    make |p| point to it@>;
q:=p; {now node |q| represents |cur_lang|}
@<Store all current |lc_code| values@>;
end

@ We store all nonzero |lc_code| values, overwriting any previously
stored values (and possibly wasting a few trie nodes that were used
previously and are not needed now).  We always store at least one
|lc_code| value such that |hyph_index| (defined below) will not be zero.

@<Store all current |lc_code| values@>=
p:=trie_l[q]; first_child:=true;
for c:=0 to 255 do
  if (lc_code(c)>0)or((c=255)and first_child) then
    begin if p=0 then
      @<Insert a new trie node between |q| and |p|, and
        make |p| point to it@>
    else trie_c[p]:=si(c);
    trie_o[p]:=qi(lc_code(c));
    q:=p; p:=trie_r[q]; first_child:=false;
    end;
if first_child then trie_l[q]:=0@+else trie_r[q]:=0

@ We must avoid to ``take'' location~1, in order to distinguish between
|lc_code| values and patterns.

@<Pack all stored |hyph_codes|@>=
begin if trie_root=0 then for p:=0 to 255 do trie_min[p]:=p+2;
first_fit(hyph_root); trie_pack(hyph_root);
hyph_start:=trie_ref[hyph_root];
end

@ The global variable |hyph_index| will point to the hyphenation codes
for the current language.

@d set_hyph_index== {set |hyph_index| for current language}
  if trie_char(hyph_start+cur_lang)<>qi(cur_lang)
    then hyph_index:=0 {no hyphenation codes for |cur_lang|}
  else hyph_index:=trie_link(hyph_start+cur_lang)
@#
@d set_lc_code(#)== {set |hc[0]| to hyphenation or lc code for |#|}
  if hyph_index=0 then hc[0]:=lc_code(#)
  else if trie_char(hyph_index+#)<>qi(#) then hc[0]:=0
  else hc[0]:=qo(trie_op(hyph_index+#))

@<Glob...@>=
@!hyph_start:trie_pointer; {root of the packed trie for |hyph_codes|}
@!hyph_index:trie_pointer; {pointer to hyphenation codes for |cur_lang|}

@ When |saving_vdiscards| is positive then the glue, kern, and penalty
nodes removed by the page builder or by \.{\\vsplit} from the top of a
vertical list are saved in special lists instead of being discarded.

@d tail_page_disc==disc_ptr[copy_code] {last item removed by page builder}
@d page_disc==disc_ptr[last_box_code] {first item removed by page builder}
@d split_disc==disc_ptr[vsplit_code] {first item removed by \.{\\vsplit}}

@<Glob...@>=
@!disc_ptr:array[copy_code..vsplit_code] of pointer; {list pointers}

@ @<Set init...@>=
page_disc:=null; split_disc:=null;

@ The \.{\\pagediscards} and \.{\\splitdiscards} commands share the
command code |un_vbox| with \.{\\unvbox} and \.{\\unvcopy}, they are
distinguished by their |chr_code| values |last_box_code| and
|vsplit_code|.  These |chr_code| values are larger than |box_code| and
|copy_code|.

@<Generate all \eTeX...@>=
primitive("pagediscards",un_vbox,last_box_code);@/
@!@:page_discards_}{\.{\\pagediscards} primitive@>
primitive("splitdiscards",un_vbox,vsplit_code);@/
@!@:split_discards_}{\.{\\splitdiscards} primitive@>

@ @<Cases of |un_vbox| for |print_cmd_chr|@>=
else if chr_code=last_box_code then print_esc("pagediscards")
else if chr_code=vsplit_code then print_esc("splitdiscards")

@ @<Handle saved items and |goto done|@>=
begin link(tail):=disc_ptr[cur_chr]; disc_ptr[cur_chr]:=null;
goto done;
end

@ The \.{\\interlinepenalties}, \.{\\clubpenalties}, \.{\\widowpenalties},
and \.{\\displaywidowpenalties} commands allow to define arrays of
penalty values to be used instead of the corresponding single values.

@d inter_line_penalties_ptr==equiv(inter_line_penalties_loc)
@d club_penalties_ptr==equiv(club_penalties_loc)
@d widow_penalties_ptr==equiv(widow_penalties_loc)
@d display_widow_penalties_ptr==equiv(display_widow_penalties_loc)

@<Generate all \eTeX...@>=
primitive("interlinepenalties",set_shape,inter_line_penalties_loc);@/
@!@:inter_line_penalties_}{\.{\\interlinepenalties} primitive@>
primitive("clubpenalties",set_shape,club_penalties_loc);@/
@!@:club_penalties_}{\.{\\clubpenalties} primitive@>
primitive("widowpenalties",set_shape,widow_penalties_loc);@/
@!@:widow_penalties_}{\.{\\widowpenalties} primitive@>
primitive("displaywidowpenalties",set_shape,display_widow_penalties_loc);@/
@!@:display_widow_penalties_}{\.{\\displaywidowpenalties} primitive@>

@ @<Cases of |set_shape| for |print_cmd_chr|@>=
inter_line_penalties_loc: print_esc("interlinepenalties");
club_penalties_loc: print_esc("clubpenalties");
widow_penalties_loc: print_esc("widowpenalties");
display_widow_penalties_loc: print_esc("displaywidowpenalties");

@ @<Fetch a penalties array element@>=
begin scan_int;
if (equiv(m)=null)or(cur_val<0) then cur_val:=0
else  begin if cur_val>penalty(equiv(m)) then cur_val:=penalty(equiv(m));
  cur_val:=penalty(equiv(m)+cur_val);
  end;
end

@ |expand_depth| and |expand_depth_count| are used in the \eTeX\ code
above, but not defined. So we correct this in the following modules,
|expand_depth| having been defined by us as an integer paramater (hence
there is a new primitive to create in \eTeX\ mode), and
|expand_depth_count| needing to be a global. Both have to be defined to
some sensible value.

@<Glob...@>=
@!expand_depth_count:integer; {current expansion depth}

@ @<Generate all \eTeX...@>=
primitive("expanddepth",assign_int,int_base+expand_depth_code);@/
@!@:expand_depth_}{\.{\\expanddepth} primitive@>

@ @<Cases for |print_param|@>=
expand_depth_code:print_esc("expanddepth");

@ @<Initialize variables for \eTeX\ extended mode@>=
expand_depth:=10000; {value taken for compatibility with Web2C}
expand_depth_count:=0;

@* \[53b] The extended features of \Prote.
\Prote\ extends furthermore \eTeX\ i.e. \eTeX\ is thus required
before adding \Prote\ own extensions. But if \eTeX\ mode has not
be enabled, the engine is still compatible with \TeX with no added
primitive commands and with a modification of code---from
\eTeX\ exclusively for now---that is sufficiently minor so that
the engine still deserves the name \TeX.

@d Prote_ex==(Prote_mode=1) {is this prote mode?}

@<Glob...@>=
@!Prote_mode: 0..1; {to be or not to be; but an int to dump}

@ We begin in \TeX\ compatibility mode. The state |Prote_mode| will be
set to $1$ only if activated by the supplementary `*' added to the one
activating the \eTeX\ extensions (in fact, this means for the user two
initial `*' in a row).

@<Initialize table entries...@>=
Prote_mode:=0; {initially we are in compatibility mode}

@ @<Dump the \Prote\ state@>=
dump_int(Prote_mode);

@ @<Undump the \Prote\ state@>=
undump(0)(1)(Prote_mode);

@ In order to not clobber the global scope with variables that are
locally used, the initializations for \Prote, if the mode is
activated, are done in a dedicated procedure. These are not part of
what is dumped.

@<Last-minute procedures@>=
procedure Prote_initialize;
var k: integer; {all-purpose index}
begin @<\Prote\ initializations@>@;
end;

@ There are commands and command modifiers, these command modifiers
maybe encoding too a type. So we must not step on each other toes.

@ When we are adding primitives that deal intimately with the variables
of \TeX, in the |eqtb| regions (in our case regions 5 for integers, and
6 for dimensions), the command modifier to the various
\.{assign\_*} classes is simply the address. So we have interpolated
our added variables above since this is done by the way of WEB
pre-processing.

@ For the conditional primitives, the way is straightforward.

@d if_incsname_code=eTeX_last_if_test_cmd_mod+1 { `\.{\\ifincsname}' }
@d if_primitive_code=eTeX_last_if_test_cmd_mod+2 { `\.{\\ifprimitive}' }
@d Prote_last_if_test_com_mod=if_primitive_code

@ The \.{last_item} class is for secondary internal values, that can be
dereferenced by \.{\\the} but are read-only and are mainly related to
the value of a current state or are such values but their assignation
shall trigger an action, and we shall not hook in the \.{assign\_*}
processing.

The command modifiers for the \.{last_item} class were, originally,
encoding too the type of the item (see m.410). But \eTeX\ has added its
extensions and we won't try to be smart: the type |cur_val_level| will
be set by switching between contiguous ranges of values of the same
type.

And we will define here all the instances of \.{last_item} that we add
in order to keep our number assignations gathered.

@d Prote_version_code=eTeX_last_last_item_cmd_mod+1
  {code for \.{\\Proteversion}}
@d random_seed_code=eTeX_last_last_item_cmd_mod+2 { \.{\\randomseed} }
@d elapsed_time_code=eTeX_last_last_item_cmd_mod+3 { \.{\\elapsedtime} }
@d shell_escape_code=eTeX_last_last_item_cmd_mod+4 { \.{\\shellescape} }
@d last_xpos_code=eTeX_last_last_item_cmd_mod+5 { \.{\\lastxpos} }
@d last_ypos_code=eTeX_last_last_item_cmd_mod+6 { \.{\\lastypos} }
@d Prote_last_last_item_cmd_mod=last_ypos_code

@<Fetch a \Prote\ item@>=
begin case m of
    @/@<Cases for fetching a \Prote\ int value@>@/
    end; {there are no other cases}
    cur_val_level:=int_val;
end

@ The \.{convert} class is for conversion of some external stuff to put
it, as a token list, into the scanner. It is not an internal value that
could be dereferenced by \.{\\the} and it is obviously not settable: it
expands to the token list.

@d Prote_revision_code=eTeX_last_convert_cmd_mod+1 { \.{\\Proterevision}}
@d strcmp_code=eTeX_last_convert_cmd_mod+2 { \.{\\strcmp} }
@d set_random_seed_code=eTeX_last_convert_cmd_mod+3 { \.{\\setrandomseed} }
@d normal_deviate_code=eTeX_last_convert_cmd_mod+4{ \.{\\normaldeviate} }
@d uniform_deviate_code=eTeX_last_convert_cmd_mod+5 { \.{\\uniformdeviate} }
@d creation_date_code=eTeX_last_convert_cmd_mod+6 { \.{\\creationdate} }
@d file_size_code=eTeX_last_convert_cmd_mod+7 { \.{\\filesize} }
@d file_mod_date_code=eTeX_last_convert_cmd_mod+8 { \.{\\filemodedate} }
@d file_dump_code=eTeX_last_convert_cmd_mod+9 { \.{\\filedump} }
@d mdfive_sum_code=eTeX_last_convert_cmd_mod+10 { \.{\\mdfivesum} }
@d Prote_last_convert_cmd_mod=mdfive_sum_code

@ When modifying the meaning of something---in this case, for now,
switching to the primitive meaning if it exists---or modifying the
way expansion is done, it seems that it can be thought as a special
case of expansion, hence a variant of |expand_after|.

@d primitive_code=eTeX_last_expand_after_cmd_mod+1 { `\.{\\primitive}' }
@d expanded_code=eTeX_last_expand_after_cmd_mod+2 { `\.{\\expanded}' }
@d Prote_last_expand_after_cmd_mod=expanded_code

@ When the primitive manipulate something really external, whether
trying to insert something in the output format---\.{DVI} for
us---or dealing with the system, it doesn't fit in any cmd group and
could be called an exception. So it will be a variant of the |extension|
cmd group.

\eTeX\ didn't add new primitives to the extension command group, so we
add a related macro, equal to |TeX_last_extension_cmd_mod|, simply so
that it is locally obvious.

@d eTeX_last_extension_cmd_mod=TeX_last_extension_cmd_mod {none added}
@d reset_timer_code=eTeX_last_extension_cmd_mod+1 { `\.{\\resettimer}' }
@d save_pos_code=eTeX_last_extension_cmd_mod+2 { `\.{\\savepos}' }
@d Prote_last_extension_cmd_mod=save_pos_code

@*1 Identifying \Prote.

We will start by giving a mean to test that \Prote\ is activated and
to identify the version.

@<Generate all \Prote\ primitives@>=
primitive("Proteversion",last_item,Prote_version_code);
@!@:Prote_version_}{\.{\\Proteversion} primitive@>
primitive("Proterevision",convert,Prote_revision_code);@/
@!@:Prote_revision_}{\.{\\Proterevision} primitive@>

@ We use the different hooks added to insert our cases.

@<Cases of |last_item| for |print_cmd_chr|@>=
Prote_version_code: print_esc("Proteversion");

@ @<Cases for fetching a \Prote\ int value@>=
Prote_version_code: cur_val:=Prote_version;

@ @<Cases of |convert| for |print_cmd_chr|@>=
Prote_revision_code: print_esc("Proterevision");

@ @<Cases of `Scan the argument for command |c|'@>=
Prote_revision_code: do_nothing;

@ @<Cases of `Print the result of command |c|'@>=
Prote_revision_code: print(Prote_revision);

@*1 \Prote\ added token lists routines.

We will, more than once, convert a general normally expanded text
to a string. Due to the unfelicity of \PASCAL\ about forward
declarations of functions, we declare procedures that do their task
by defining global variables. In this case, |garbage| is used.

|link(garbage)| will hold the pointer to the head of the token list,
|info(garbage)| to the tail. If the two are equals, then the list is
empty. The routine making a string will take |link(garbage)| and
put the number in |info(garbage)|.

@ The first procedure scan a general text (normally) expanded. The
head of the reference count is returned in |link(garbage)|, the
tail in |info(garbage)| and if the two are equals, the list is empty.
User must keep in mind that this has to be flushed when done with!

@<Declare \Prote\ procedures for expanding@>=
procedure@?scan_general_x_text; forward;@t\2@>

@ @<Declare \Prote\ procedures for token lists@>=
procedure scan_general_x_text;
var d:pointer; {to save |def_ref|}
begin d:=def_ref; info(garbage):=scan_toks(false,true);
link(garbage):=def_ref;
def_ref:=d; {restore whatever}
end;

@ The second procedure takes a token list defined in |link(garbage)|
and converts it to a string number that is returned in |info(garbage)|.
Neither the token list nor the string (obviously) are flushed.

@<Declare \Prote\ procedures for scanning@>=
procedure@?toks_to_str; forward;@t\2@>

@ Here we are using |token_show| that has to take a reference count.

@<Declare \Prote\ procedures for token lists@>=
procedure toks_to_str;
var old_setting:0..max_selector; {holds |selector| setting}
begin old_setting:=selector; selector:=new_string;
  token_show(link(garbage)); selector:=old_setting;
  str_room(1); {flirting with the limit means probably truncation}
  info(garbage):=make_string;
end;

@*1 \Prote\ added strings routines.

The next procedure sets |name_of_file| from the string given as an
argument, mimicking the |input| primitive by adding an |.tex| extension
if there is none. It silently truncates if the length of the string
exceeds the size of the name buffer and doesn't use |cur_area| and
|cur_ext|, but |name_length| is set to the real name length (without
truncating) so a test about |k<=file_name_size| allows to detect the
impossibility of opening the file without having to call external code.
The string is not flushed: it is the responsability of the code calling
the procedure to flush it if wanted.

@<Declare \Prote\ procedures for strings@>=
procedure str_to_name(@!s:str_number);
var k:integer; {number of positions filled in |name_of_file|}
@!c,@!p,@!d: ASCII_code; {character being packed; path sep; dot}
@!j:pool_pointer; {index into |str_pool|}
begin k:=0; p:=0; d:=0; for j:=str_start[s] to str_start[s+1]-1 do begin
  c:=so(str_pool[j]); incr(k);
  if c="/" then begin p:=k; d:=0; end;
  if c="." then d:=k;
  if k<=file_name_size then name_of_file[k]:=xchr[c];
  end;
if d=0 then begin
  if k<=(file_name_size-4) then begin
    name_of_file[k+1]:=xchr["."]; name_of_file[k+2]:=xchr["t"];
    name_of_file[k+3]:=xchr["e"]; name_of_file[k+4]:=xchr["x"];
    end;
  k:=k+4; {in every case, set length as if extension was added}
  end;
name_length:=k;
for k:=name_length+1 to file_name_size do name_of_file[k]:=' ';
end;

@*1 Exchanging data with external routines.

In order to try to sever external handling from our core, we
introduce an all purpose exchange buffer |xchg_buffer|, that will
be an array of bytes (these can be interpreted as \.{text\_char}
or \.{ASCII\_char} or \.{eight\_bits}).

The data to be used starts at index $1$ and ends at index
|xchg_buffer_length|.

For the moment, this buffer must accommodate a numerical MD5
hash value, i.e. $16$ bytes long; will also be used to exchange $64$
bytes chunks to feed MD5 hash generation, and will have to accommodate
too the maximal size of the date returned by \.{\\creationdate} or
\.{\\filemoddate} that is $23$ \.{text\_char}. So at least $64$ for now.

@ @<Check \Prote\ ``constant'' values for consistency@>=
if xchg_buffer_size<64 then bad:=51;

@ When there is data in the exchange buffer, the length of the data has
to be set. When an external routine has consumed the data, it shall
reset the length to $0$.

@<\Prote\ initializations@>=
xchg_buffer_length:=0;

@ There is too the problem of what is referred as a stream of data.
Since the conversion in another language is not easy, we dedicate a
global variable that has to hold a reference to the stream: |data_in|.
It is a stream of bytes, without making assumptions about what they may
represent.

In the code, we verify the opening and define |data_in| and this is this
variable external routine may refer to for processing.

|data_in| is externally defined in order to be able to test the external
code independantly.

@*1 \Prote\ states.

\.{\\shellescape} depends on a pdf\TeX\ feature, namely the ability to
escape to shell. There is no such thing in \Prote. So it expands to $0$.
Note: this a status primitive; it does not allow to set the status but
simply expands to a read-only integer reflecting it. In \Prote, it is
always $0$.

@<Generate all \Prote\ primitives@>=
primitive("shellescape",last_item,shell_escape_code);
@!@:shellescape_}{\.{\\shellescape} primitive@>

@ @<Cases of |last_item| for |print_cmd_chr|@>=
shell_escape_code: print_esc("shellescape");

@ @<Cases for fetching a \Prote\ int value@>=
shell_escape_code: cur_val:=0;

@*1 \Prote\ conditionals.

We add the following conditionals, that are susceptible of the same
expansion rules as the other |if_test| ones.

@<Generate all \Prote\ primitives@>=
primitive("ifincsname",if_test,if_incsname_code);
@!@:if_incsname_}{\.{\\if} primitive@>
primitive("ifprimitive",if_test,if_primitive_code);
@!@:if_primitive_}{\.{\\if} primitive@>

@ @<Cases of |if_test| for |print_cmd_chr|@>=
if_incsname_code:print_esc("ifincsname");
if_primitive_code:print_esc("ifprimitive");

@ The conditional \.{\\ifincsname} is simple since we increment a global
variable |incsname_state| when we enter the \.{\\csname} command and
decrement it when we have reached and passed the \.{\\endcsname}---a
scope depth index.

@<\Prote\ initializations@>=
incsname_state:=0;

@ @<Cases for |conditional|@>=
if_incsname_code:b:=(incsname_state>0);

@ The conditional \.{\\ifprimitive} is true when the following control
sequence is a primitive; false otherwise. |id_lookup| can return
|undefined_control_sequence| (for a control sequence not entered in the
hash since |no_new_control_sequence| is |true|), but since it has the
\.{eq\_type} set to |undefined_cs|, the test of this latter works as
for a control sequence entered but never defined.

@ @<Cases for |conditional|@>=
if_primitive_code: begin repeat get_token; until cur_tok<>space_token;
if (cur_cs<>0)and(cur_cmd<>undefined_cs)and(cur_cmd<call) then b:=true else b:=false;
end;

@*1 \Prote\ primitives changing definition or expansion.

The next primitives, here, are more involved since they are whether
changing the definition of a control sequence, or modifying how the
tokens will be treated.

@ Since a user level control sequence can give a new definition to a
primitive, the \.{primitive}... primitive, if the argument is a control
sequence whose name is the name of a primitive, will make this primitive
meaning the meaning of the control sequence {\it hic et nunc}. If there
was no primitive meaning, no error is raised and nothing is changed.
It can be seen as a kind of \.{expand\_after} command since it is in the
external handling of the token list creation.

Since we need to redefine the token and hence give a valid control
sequence in the |eqtb|, we have defined |frozen_primitive|. This
``frozen'' is, actually, not quite frozen by itself since we will
redefine its values according to the primitive definition we have
to restablish momentarily.  But it is indeed ``permanent'' since
it only refers to the permanently defined meanings. Hence, the
initialization of the |frozen_primitive| address is just to document
the code: these values will be overwritten on each actual call.

@<Generate all \Prote\ primitives@>=
primitive("primitive",expand_after,primitive_code);
@!@:primitive_}{\.{\\primitive} primitive@>
text(frozen_primitive):="primitive:"; eqtb[frozen_primitive]:=eqtb[cur_val];

@ @<Cases of |expandafter| for |print_cmd_chr|@>=
primitive_code: print_esc("primitive");

@ The problem is that the primitives are added at |level_one| and that a
redefinition as a macro at this same level by a user simply overwrites
the definition. We need then to keep these definitions.

Primitives are only added by \.{INITEX}. So we can consider what we will
call a |ROM|, since it can be only ``flashed'' by \.{INITEX} and is
read-only afterwards, a kind of BIOS table holding initial system calls
(primitives).

Since primitives are not macros (they don't need to expand or to
evaluate parameters since their definition is directly in the code),
the definition of a primitive is a couple: the command class (|cur_cmd|)
and the modifier (|cur_chr|) to distinguish between the cases---the
instances. But since, at the user level, a primitive is identified by
its name, and that a redefinition is, mandatorily, a homonym, the
location of the macro shadowing the primitive is at the same address as
was the primitive in the |eqtb|. So in order to speed-up the check, we
should organize things so that the address in the |eqtb| of a control
sequence (one character or multiletter) can be readily
converted in an address in the |ROM| array.

This array will be an array of memory word, of type |two_halves|, in
order to re-use the macro definitions set for the table of equivalents.

The one character primitives are added by direct addressing relative to
|single_base|. The multiletter primitives are added starting at
|frozen_control_sequence-1|, downwards; but there are only, at the
moment, $322$ multileter primitives defined by \TeX, $78$ such
primitives defined by \eTeX, and we are adding $24$ more. It is clear
that, looking at primitives, region 2 of |eqtb| is really a sparse array
and that, when |hash_size| is increased for format needs, there will be
a fair amount of space wasted if we simply copy, in fact, second part
of region 1 and region 2 in the |ROM|.

Yes, but it is simpler as a first approach---premature optimization is
the root of all evil. So a simple translation scheme will be enough.

The index in |ROM| will start at $1$ and will go up to $256 + 1 +
hash\_size$, that is a simple translation from |single_base| to
|ROM_base|, but only for addresses of interest, the other pointing to
an |ROM_undefined_primitive| that will allow an easy test.

@d ROM_base=1
@d ROM_size=256+1+hash_size {256 oc, undefined and ml}
@d ROM_undefined_primitive=257
@d ROM_type_field(#)==#.hh.b0
@d ROM_equiv_field(#)==#.hh.rh
@d ROM_type(#)==ROM_type_field(ROM[#]) {command code for equivalent}
@d ROM_equiv(#)==ROM_equiv_field(ROM[#]) {equivalent value}
@#
@d set_ROM_p_from_cs(#) == if (#>=single_base)
  and(#<frozen_control_sequence) then
  p:=#-single_base+ROM_base
  else p:=ROM_undefined_primitive

@<Global...@>=
@!ROM:array[ROM_base..ROM_size] of memory_word;

@ Even if it will be unused in \TeX\ or \eTeX\ modes, we will initialize
it since we add code to the |primitive| procedure and we need \TeX\
and \eTeX\ ones to be registered as well, whether \.{INITEX} switches to
\Prote\ mode later or not.

@<Initialize table entries...@>=
ROM[ROM_undefined_primitive]:=eqtb[undefined_control_sequence];
for k:=ROM_base to 256 do ROM[k]:=ROM[ROM_undefined_primitive];
for k:=ROM_undefined_primitive+1 to ROM_size do
  ROM[k]:=ROM[ROM_undefined_primitive];

@ When a primitive is added---and this only happens in \.{INITEX}---we
have to define the corresponding address in the \.{ROM}.

@ |cur_val| has the pointer in second part of region 1 or in region 2
of |eqtb|.

@<Add primitive definition to the |ROM| array@>=
set_ROM_p_from_cs(cur_val);
ROM[p]:=eqtb[cur_val];

@ This array has to be dumped since it is only defined by \.{INITEX}. It
is always dumped even if it is unused unless in \Prote\ mode.

@<Dump the |ROM| array@>=
for k:=ROM_base to ROM_size do dump_wd(ROM[k]);

@ And what has been dumped shall be undumped.

@<Undump the |ROM| array@>=
for k:=ROM_base to ROM_size do undump_wd(ROM[k]);

@ Once all this is done, the processing of \.{\\primitive} is simple:
we read the next token that has to be a control sequence. If this
control sequence belongs to region 1 or 2 and is defined in |ROM|, we
redefine the token to be the |frozen_primitive| control sequence,
redefining its codes from the |ROM| and setting the text associated for
printing purposes. If not, the token is unchanged. Then we put back the
token so that it will be processed again, maybe redefined.

@<Cases for |expandafter|@>=
primitive_code: begin get_token;
set_ROM_p_from_cs(cur_cs);
if (p<>ROM_undefined_primitive)and(ROM_type(p)<>undefined_cs) then begin
  eqtb[frozen_primitive]:=ROM[p];
  text(frozen_primitive):=text(cur_cs);
  cur_tok:=cs_token_flag+frozen_primitive;
  end;
back_input;
end;

@ The next primitive changes the expansion of its argument that is like
a general text expanded, except that protected macros (an \eTeX\
extension) are not extanded.

@ @<Generate all \Prote\ primitives@>=
primitive("expanded",expand_after,expanded_code);@/
@!@:expanded_}{\.{\\expanded} primitive@>

@ @<Cases of |expandafter| for |print_cmd_chr|@>=
expanded_code: print_esc("expanded");

@ This intervenes in |expand| and we must substitute a token list to our
current token, putting it back for further reprocessing.

@<Cases for |expandafter|@>=
expanded_code: begin scan_general_x_text;
  back_list(link(link(garbage)));
  free_avail(link(garbage)); {drop reference count}
  end;

@*1 \Prote\ strings related primitives.

The primitive \.{\\strcmp} text two parameters that are general text
without expansion. The two token lists created are converted to strings
and this couple of strings is then compared, character by character. If
the first string is lexicographically sorted before the second, the
expansion is $-1$; if the two strings are equal, the expansion is $0$;
if the first string is lexicographically sorted after the second, the
expansion is $1$.

@<Generate all \Prote\ primitives@>=
primitive("strcmp",convert,strcmp_code);
@!@:strcmp_}{\.{\\strcmp} primitive@>

@ @<Cases of |convert| for |print_cmd_chr|@>=
strcmp_code: print_esc("strcmp");

@ It should be noted that the strings comparison is \TeX\ strings
comparison: the arguments are subject to the manipulation done when
scanning a general text (squeezing non escaped blanks), and the
characters are converted according to the |xord| array. Thus it is
an |ASCII_code|---in the \TeX\ sense explained at the very beginning
of the web file, part 2---comparison and the result is the same,
as long as relative characters are mapped to the same value, whatever
the system. Nul strings are valid.

@<Cases of `Scan the argument for command |c|'@>=
strcmp_code: begin scan_general_x_text; toks_to_str;
  s:=info(garbage); flush_list(link(garbage));
  scan_general_x_text; toks_to_str;
  t:=info(garbage); flush_list(link(garbage));
  if (length(s)=0)and(length(t)=0) then cur_val:=0
  else if length(s)=0 then cur_val:=-1
  else if length(t)=0 then cur_val:=1
  else begin m:=str_start[s];n:=str_start[t];r:=false;
    while (not r)and(m<str_start[s+1])and(n<str_start[t+1]) do begin
      cur_val:=str_pool[m]-str_pool[n]; if cur_val<>0 then r:=true;
      incr(m);incr(n);
      end;
    if cur_val=0 then begin if length(s)<>length(t) then
      if m<>str_start[s+1] then cur_val:=1 else cur_val:=-1;
      end
    else cur_val:=cur_val/abs(cur_val);
    end;
  flush_string;flush_string;
  end;

@ @<Cases of `Print the result of command |c|'@>=
strcmp_code: print_int(cur_val);

@*1 \Prote\ date and time related primitives.

The following primitives are related to the time elapsed since a
defined moment in time. The creation date is fixed at the moment when
|fix_date_and_time| has been called and stays fixed afterwards. This
moment is also, by default, the reference moment for computing the time
elapsed.

@ The creation date is retrieved by the \.{\\creationdate} primitive. As
explained above, the date corresponds to the moment when
|fix_date_and_time| was called taking into account |FORCE_SOURCE_DATE|
and |SOURCE_DATE_EPOCH| (see above, m.241). If the creation date is
forced, the string will be UTC related.

The format of the string is |D:YYYYMMDDHHmmSSOHH'mm'|, `O' being the
relationship of local time to UT, that is `-' (minus), `+' or `Z';
HH followed by a single quote being the absolute value of the offset
from UT in hours (00--23), mm followed by a single quote being the
absolute value of the offset from UT in minutes (00--59). All fields
after the year are optional and default to zero values.

@ @<Generate all \Prote\ primitives@>=
primitive("creationdate",convert,creation_date_code);@/
@!@:creationdate_}{\.{\\creationdate} primitive@>

@ @<Cases of |convert| for |print_cmd_chr|@>=
creation_date_code: print_esc("creationdate");

@ |get_creation_date| has to be provided by the system.
@^system dependencies@>


@<Cases of `Scan the argument for command |c|'@>=
creation_date_code: get_creation_date;

@ The date is in the |xchg_buffer| so we have simply to convert the
characters.

@<Cases of `Print the result of command |c|'@>=
creation_date_code: for k:=1 to xchg_buffer_length do
   print_char(xord[xchg_buffer[k]]);

@ Here is the implementation of |set_invalid_date| that is used
for the default (invalid) value when the information is not
available---which is the case in standard \PASCAL. It has to be
kept, but routines that are aliased to it have to be provided by
system integrators. The invalid date will set to reference time
for the vanilla |fix_date_and_time| i.e. noon on 4 July 1776, local
time.

@<Declare \Prote\ procedures for expanding@>=
procedure@?set_invalid_date; forward;@t\2@>

@ @<Declare \Prote\ procedures for token lists@>=
procedure set_invalid_date;
begin xchg_buffer[1]:=xord["D"];xchg_buffer[2]:=xord[":"];
xchg_buffer[3]:=xord["1"];xchg_buffer[4]:=xord["7"];
xchg_buffer[5]:=xord["7"];xchg_buffer[6]:=xord["6"];
xchg_buffer[7]:=xord["0"];xchg_buffer[8]:=xord["7"];
xchg_buffer[9]:=xord["0"];xchg_buffer[10]:=xord["4"];
xchg_buffer[11]:=xord["1"];xchg_buffer[12]:=xord["2"];
xchg_buffer[13]:=xord["0"];xchg_buffer[14]:=xord["0"];
xchg_buffer[15]:=xord["0"];xchg_buffer[16]:=xord["0"];
xchg_buffer_length:=16;
end;

@ The time elapsed is a scaled integer the unit being scaled seconds,
i.e. $1/65536$ of a second.  Since our scaled integers have a
defined range, the value can not reach or pass, in plain seconds,
$32767$.

The elapsed time returned is relative to some defined moment. At
start, the reference moment is the time the date was set for
|fix_date_and_time|. This requires system support and the default
implementation here will then fix this moment at noon on 4 July 1776
and what would be returned by the function is here simply defined by
a macro: with this reference time and this basic code, |infinity| is
the permanent answer.
@^system dependencies@>

@ @<Generate all \Prote\ primitives@>=
primitive("resettimer",extension,reset_timer_code);@/
@!@:resettimer_}{\.{\\resettimer} primitive@>
primitive("elapsedtime",last_item,elapsed_time_code);@/
@!@:elapsedtime_}{\.{\\elapsedtime} primitive@>

@ @<Cases of |last_item| for |print_cmd_chr|@>=
elapsed_time_code: print_esc("elapsedtime");

@ @<Cases of |extension| for |print_cmd_chr|@>=
reset_timer_code: print_esc("resettimer");

@ @<Cases for fetching a \Prote\ int value@>=
elapsed_time_code: cur_val:=get_elapsed_time;

@ The reference moment can be reset by a call to the primitive
\.{\\resettimer}. It simply resets the reference moment to the moment
the primitive was called. The counter is not regularily incremented.
When asked about the time elapsed what is returned is the difference, in
scaled seconds, from the moment of the call to the moment of reference.
So there is no persistent variable neither a kind of clock implemented.
@^system dependencies@>


@ Since to reset the timer a simple call to the routine is necessary,
we simply add it to \.{main\_control} by adding it to the cases handled
by \.{do\_extension}. It contributes nothing to the token list: it is a
``fire and forget'', so no need to handle the special \.{subtype} in the
other hooks.

@<Cases for |do_extension|@>=
reset_timer_code: reset_timer;

@*1 \Prote\ file related primitives.

The presence of the following primitives in the engine can be
questioned. Since they are very external, and their implementation, for
example in C, requires things that are not in the C standard (the
date of modification of the file, for example). So these should not be
multiplied.

@ The \.{\\filesize} primitive expands to the size, in bytes, of the
file.

@<Generate all \Prote\ primitives@>=
primitive("filesize",convert,file_size_code);
@!@:filesize_}{\.{\\filesize} primitive@>

@ @<Cases of |convert| for |print_cmd_chr|@>=
file_size_code: print_esc("filesize");

@ In order to be able to treat the problem when trying to open the file,
we open here and pass the file pointer, if success, to a dedicated
function in order to get its size. In case of problem, nothing is
returned.
@^system dependencies@>

@<Cases of `Scan the argument for command |c|'@>=
file_size_code: begin scan_general_x_text; toks_to_str;
  s:=info(garbage); flush_list(link(garbage)); str_to_name(s);
  cur_val:=-1; {invalid value if error}
  if (name_length<=file_name_size)and(b_open_in(data_in)) then begin
    cur_val:=get_file_size; b_close(data_in);
  end;
  flush_string;
  end;

@ @<Cases of `Print the result of command |c|'@>=
file_size_code: if cur_val<>-1 then print_int(cur_val);

@ The |get_file_size| function handles the file |data_in| that must
have been correctly defined by caller, and returns its length in bytes.

This routine is externally implemented.

@ The \.{\\filemoddate} expands to a date with the same format as the
creation date (see \.{\\creationdate}).

@<Generate all \Prote\ primitives@>=
primitive("filemoddate",convert,file_mod_date_code);
@!@:filemoddate_}{\.{\\filemoddate} primitive@>

@ @<Cases of |convert| for |print_cmd_chr|@>=
file_mod_date_code: print_esc("filemoddate");

@ For getting the argument, the treatment resembles that of
\.{\\filesize} obviously, since it is only the type of information
returned that changes. The availability of this information in system
dependent. The information shall be set in |xchg_buffer|.
@^system dependencies@>

This routine is externally provided.

@<Cases of `Scan the argument for command |c|'@>=
file_mod_date_code: begin scan_general_x_text; toks_to_str;
  s:=info(garbage); flush_list(link(garbage)); str_to_name(s);
  xchg_buffer_length:=0;
  if (name_length<=file_name_size)and(b_open_in(data_in)) then begin
    get_file_mtime; b_close(data_in);
  end;
  flush_string;
  end;

@ Printing the result consists simply in printing every
|text_char| in |xchg_buffer|, the length of the string being set in
|xchg_buffer_length|. If the length is $0$, nothing is printed.

@<Cases of `Print the result of command |c|'@>=
file_mod_date_code: for k:=1 to xchg_buffer_length do
   print_char(xord[xchg_buffer[k]]);

@ The primitive \.{\\filedump} expands to the dump of the first
 \.{length} bytes of the file, starting from \.{offset}. Offset and
length are optional integers given, in that order, introduced resp.
by the keywords ``offset'' and ``length''. If not specified, they
default to $0$. A length of $0$ expands to nothing (it is not an error).
The file name is given as a |general text|.

@<Generate all \Prote\ primitives@>=
primitive("filedump",convert,file_dump_code);
@!@:filedump_}{\.{\\filedump} primitive@>

@ @<Cases of |convert| for |print_cmd_chr|@>=
file_dump_code: print_esc("filedump");

@ The scanning of the arguments is obvious from the syntax above.

Since ``offset'' and ``length'' may be given in that order, we assign
the variables \.{k} and \.{l}, in alphabetical order. These have to be
positive or nul values.

Contrary to other blocks, and for optimization purposes (in order not to
clobber the string pool with data that we can read, when necessary, one
byte at a time), \.{k}, \.{l} and \.{f} will be defined here and used
when printing.

@<Cases of `Scan the argument for command |c|'@>=
file_dump_code: begin k:=0;l:=0; {defaults}
  if scan_keyword("offset") then begin scan_int;
    if cur_val<0 then begin print_err("Bad "); print_esc("filedump");
@.Bad \\filedump@>
      help2("I allow only nonnegative values here.")@/
        ("I changed this one to zero."); int_error(cur_val);
      end
    else k:=cur_val;
    end;
  if scan_keyword("length") then begin scan_int;
    if cur_val<0 then begin print_err("Bad "); print_esc("filedump");
@.Bad \\filedump@>
      help2("I allow only nonnegative values here.")@/
        ("I changed this one to zero."); int_error(cur_val);
      end
    else l:=cur_val;
    end;
  scan_general_x_text; toks_to_str; s:=info(garbage);
  flush_list(link(garbage)); str_to_name(s);
  flush_string; {this one was the filename argument}
  end;

@ The variables have been set, and the file name has been defined. We
simply print the uppercase hexadecimal transcription of every byte
requested before closing the file. Here we deal with bytes
(\.{eight\_bits} values) so there is no transcription.

@<Cases of `Print the result of command |c|'@>=
file_dump_code:
if (name_length<=file_name_size)and(b_open_in(data_in)) then begin
  while k>0 do begin read(data_in,i);decr(k); end;
  if (l>0)and(not eof(data_in)) then repeat read(data_in,i);
    dig[0]:=i mod 16; dig[1]:=i div 16; print_the_digs(2);decr(l);
    until eof(data_in)or(l=0);
  b_close(data_in);
  end;

@ The \.{\\mdfivesum} is obviously a variant of the \.{convert} class since
it takes values from external and put them as a token list in the
stream.

@<Generate all \Prote\ primitives@>=
primitive("mdfivesum",convert,mdfive_sum_code);
@!@:mdfivesum_}{\.{\\mdfivesum} primitive@>

@ @<Cases of |convert| for |print_cmd_chr|@>=
mdfive_sum_code: print_esc("mdfivesum");

@ There is an optional keyword "file" that will tell us if the |<general
text>| is to be taken as a filename or just as the string to hash. The
|<balanced text>| is expanded in both cases.

Once this is done, we ask to init the MD5 state; then fill the exchange
buffer with chunks of data and update the MD5 hash with every chunk
until source is exhausted and ask for the final ($16$ bytes numerical
value) result that will be put in the |xchg_buffer|.

Since we are looking for a ``general text'', that must be enclosed (at
least: ended; the opening brace can be implicit) by a |right_brace|,
an error will be caught with runaways.

The general text is converted to a string. It is legal to have an empty
string if the argument is not a file.

@<Cases of `Scan the argument for command |c|'@>=
mdfive_sum_code: begin r:=scan_keyword("file"); scan_general_x_text;
toks_to_str; s:=info(garbage); flush_list(link(garbage));
if r then @<Generate the MD5 hash for a file@>
  @+else @<Generate the MD5 hash for a string@>;
flush_string; {done with the filename or string to hash}
end;

@ As a result, there is $16$ bytes in the |xchg_buffer| representing the
MD5 hash. We simply print, byte by byte, the uppercase hexadecimal
representation of this hash.

@<Cases of `Print the result of command |c|'@>=
mdfive_sum_code: if xchg_buffer_length=16 then begin
  for k:=1 to 16 do begin dig[0]:=xchg_buffer[k] mod 16;
    dig[1]:=xchg_buffer[k] div 16; print_the_digs(2);
  end;
end;

@ This is something that we will be doing several times. We have scanned
a general text. The result is a token list that we will interpret as a
file name. We must then put this name in |name_of_file| and try to open
it, as a binary file.

|cur_area| and |cur_ext| are not set: we use the string as is.

@<Generate the MD5 hash for a file@>=
begin str_to_name(s);
xchg_buffer_length:=0; {empty if file not opened}
if (name_length<=file_name_size)and(b_open_in(data_in)) then begin
  mdfive_init;
  r:=false; {reset it to indicate eof}
  while not r do
    begin if xchg_buffer_length=64 then mdfive_update; {resets length}
    if not eof(data_in) then
      begin read(data_in,i); xchg_buffer[xchg_buffer_length+1]:=i;
      incr(xchg_buffer_length);
      end
    else r:=true;
    end;
  if xchg_buffer_length<>0 then mdfive_update; {treats remaining}
  b_close(data_in);
  mdfive_final; {may yield the empty file/nul string hash if nothing input}
  end;
end

@ For a string, the procedure is very similar. It is not an error for
the string to be the null one.

@<Generate the MD5 hash for a string@>=
begin mdfive_init; xchg_buffer_length:=0; {proceed by 64 chunks}
for k:=str_start[s] to str_start[s+1]-1 do
  begin if xchg_buffer_length=64 then mdfive_update; {resets length}
  xchg_buffer[xchg_buffer_length+1]:=xchr[so(str_pool[k])];
  incr(xchg_buffer_length);
  end;
if xchg_buffer_length<>0 then mdfive_update; {treats remaining}
mdfive_final;
end

@ A MD5 hash signature can be requested for a stream of bytes, this
being a string directly passed or a file.

Since the MD5 algorithm does a lot of bitwise operations, a standard
Pascal implementation has not been attempted. But since we aim to
limitate and to segregate the calls to external routines so that they do
not tamper with the internals of \TeX, we have to find a way to
communicate with the routines.

@ To obtain the MD5 hash signature of a file will need an external
implementation, since the algorithm requires bitwise operation that
standard \PASCAL does not provide. So we do not bother to try. The
present implementation returns nothing.
@^system dependencies@>

@ |mdfive_init| shall reinit the state to compute the hash value.
Nothing is taken from |xchg_buffer| and |xchg_buffer_length| is
unchanged.

This routine is externally provided.

@ |mdfive_update| takes |xchg_buffer_length| bytes to contribute to the
hash. The bytes being consumed, |xchg_buffer_length| shall be reset to
$0$.


This routine is externally provided.

@ |md5_final| puts the binary $16$ bytes long hash into |xchg_buffer|
and sets |xchg_buffer_length| to $16$.

This routine is externally provided.

@*1 Pseudo-random number generation.

These routines come from John Hobby's \MP\ and generate pseudo-random
numbers with the additive scheme recommended in Section 3.6 of
{\sl The Art of Computer Programming}; however, the results are
random fractions between 0 and |mpfract_one-1|, inclusive.

\MP\ uses 28~significant bits of precision and we have kept this in
order for the routines to behave the same way as in \MP. So the name
|mpfract| will be used instead of |scaled|, while the two are integers,
in the range defined by \TeX.

@d double(#) == #:=#+# {multiply a variable by two}
@d halfp(#)==(#) div 2 {when quantity is known to be positive or zero}

@ The subroutines for logarithm and exponential involve two tables.
The first is simple: |two_to_the[k]| equals $2^k$. The second involves
a bit more calculation, which the author claims to have done correctly:
|spec_log[k]| is $2^{27}$ times $\ln\bigl(1/(1-2^{-k})\bigr)=
2^{-k}+{1\over2}2^{-2k}+{1\over3}2^{-3k}+\cdots\,$, rounded to the
nearest integer.

@<Glob...@>=
@!two_to_the:array[0..30] of integer; {powers of two}
@!spec_log:array[1..28] of integer; {special logarithms}

@ @<\Prote\ initializations@>=
two_to_the[0]:=1;
for k:=1 to 30 do two_to_the[k]:=2*two_to_the[k-1];
spec_log[1]:=93032640;
spec_log[2]:=38612034;
spec_log[3]:=17922280;
spec_log[4]:=8662214;
spec_log[5]:=4261238;
spec_log[6]:=2113709;
spec_log[7]:=1052693;
spec_log[8]:=525315;
spec_log[9]:=262400;
spec_log[10]:=131136;
spec_log[11]:=65552;
spec_log[12]:=32772;
spec_log[13]:=16385;
for k:=14 to 27 do spec_log[k]:=two_to_the[27-k];
spec_log[28]:=1;

@ Here is the routine that calculates $2^8$ times the natural logarithm
of a |scaled| quantity; it is an integer approximation to $2^{24}\ln(x/2^{16})$,
when |x| is a given positive integer.

The method is based on exercise 1.2.2--25 in {\sl The Art of Computer
Programming\/}: During the main iteration we have $1\L 2^{-30}x<1/(1-2^{1-k})$,
and the logarithm of $2^{30}x$ remains to be added to an accumulator
register called~$y$. Three auxiliary bits of accuracy are retained in~$y$
during the calculation, and sixteen auxiliary bits to extend |y| are
kept in~|z| during the initial argument reduction. (We add
$100\cdot2^{16}=6553600$ to~|z| and subtract 100 from~|y| so that |z| will
not become negative; also, the actual amount subtracted from~|y| is~96,
not~100, because we want to add~4 for rounding before the final division by~8.)

@<Declare \Prote\ arithmetic routines@>=
function m_log(@!x:scaled):scaled;
var @!y,@!z:integer; {auxiliary registers}
@!k:integer; {iteration counter}
begin if x<=0 then @<Handle non-positive logarithm@>
else  begin y:=1302456956+4-100; {$14\times2^{27}\ln2\approx1302456956.421063$}
  z:=27595+6553600; {and $2^{16}\times .421063\approx 27595$}
  while x<mpfract_four do
    begin double(x); y:=y-93032639; z:=z-48782;
    end; {$2^{27}\ln2\approx 93032639.74436163$
      and $2^{16}\times.74436163\approx 48782$}
  y:=y+(z div unity); k:=2;
  while x>mpfract_four+4 do
    @<Increase |k| until |x| can be multiplied by a
      factor of $2^{-k}$, and adjust $y$ accordingly@>;
  m_log:=y div 8;
  end;
end;

@ @<Increase |k| until |x| can...@>=
begin z:=((x-1) div two_to_the[k])+1; {$z=\lceil x/2^k\rceil$}
while x<mpfract_four+z do
  begin z:=halfp(z+1); k:=k+1;
  end;
y:=y+spec_log[k]; x:=x-z;
end

@ @<Handle non-positive logarithm@>=
begin print_err("Logarithm of ");
@.Logarithm...replaced by 0@>
print_scaled(x); print(" has been replaced by 0");
help2("Since I don't take logs of non-positive numbers,")@/
  ("I'm zeroing this one. Proceed, with fingers crossed.");
error; m_log:=0;
end

@ Here is introduced the special 28bits significand |mpfract|.

@d el_gordo == @'17777777777 {$2^{31}-1$, the largest value that \TeX\ likes}
@d mpfract_half==@'1000000000 {$2^{27}$, represents 0.50000000}
@d mpfract_one==@'2000000000 {$2^{28}$, represents 1.00000000}
@d mpfract_four==@'10000000000 {$2^{30}$, represents 4.00000000}

@<Types...@>=
@!mpfract=integer; {this type is used for pseudo-random numbers}

@ The |make_mpfract| routine produces the |mpfract| equivalent of
|p/q|, given integers |p| and~|q|; it computes the integer
$f=\lfloor2^{28}p/q+{1\over2}\rfloor$, when $p$ and $q$ are
positive. If |p| and |q| are both of the same scaled type |t|,
the ``type relation'' |make_mpfract(t,t)=mpfract| is valid;
and it's also possible to use the subroutine ``backwards,'' using
the relation |make_mpfract(t,mpfract)=t| between scaled types.

If the result would have magnitude $2^{31}$ or more, |make_mpfract|
sets |arith_error:=true|. Most of \TeX's internal computations have
been designed to avoid this sort of error.

If this subroutine were programmed in assembly language on a typical
machine, we could simply compute |(@t$2^{28}$@>*p)div q|, since a
double-precision product can often be input to a fixed-point division
instruction. But when we are restricted to \PASCAL\ arithmetic it
is necessary either to resort to multiple-precision maneuvering
or to use a simple but slow iteration. The multiple-precision technique
would be about three times faster than the code adopted here, but it
would be comparatively long and tricky, involving about sixteen
additional multiplications and divisions.

The present implementation is highly portable, but slow; it avoids
multiplication and division except in the initial stage. But since it is
not part of \TeX\ inner loop, it doesn't matter.

@<Declare \Prote\ arithmetic routines@>=
function make_mpfract(@!p,@!q:integer):mpfract;
var @!f:integer; {the fraction bits, with a leading 1 bit}
@!n:integer; {the integer part of $\vert p/q\vert$}
@!negative:boolean; {should the result be negated?}
@!be_careful:integer; {disables certain compiler optimizations}
begin if p>=0 then negative:=false
else  begin negate(p); negative:=true;
  end;
if q<=0 then
  begin debug if q=0 then confusion("/");@;@+gubed@;@/
@:this can't happen /}{\quad \./@>
  negate(q); negative:=not negative;
  end;
n:=p div q; p:=p mod q;
if n>=8 then
  begin arith_error:=true;
  if negative then make_mpfract:=-el_gordo@+else make_mpfract:=el_gordo;
  end
else  begin n:=(n-1)*mpfract_one;
  @<Compute $f=\lfloor 2^{28}(1+p/q)+{1\over2}\rfloor$@>;
  if negative then make_mpfract:=-(f+n)@+else make_mpfract:=f+n;
  end;
end;

@ The |repeat| loop here preserves the following invariant relations
between |f|, |p|, and~|q|:
(i)~|0<=p<q|; (ii)~$fq+p=2^k(q+p_0)$, where $k$ is an integer and
$p_0$ is the original value of~$p$.

Notice that the computation specifies
|(p-q)+p| instead of |(p+p)-q|, because the latter could overflow.
Let us hope that optimizing compilers do not miss this point; a
special variable |be_careful| is used to emphasize the necessary
order of computation. Optimizing compilers should keep |be_careful|
in a register, not store it in memory.
@^inner loop@>

@<Compute $f=\lfloor 2^{28}(1+p/q)+{1\over2}\rfloor$@>=
f:=1;
repeat be_careful:=p-q; p:=be_careful+p;
if p>=0 then f:=f+f+1
else  begin double(f); p:=p+q;
  end;
until f>=mpfract_one;
be_careful:=p-q;
if be_careful+p>=0 then incr(f)

@ The dual of |make_mpfract| is |take_mpfract|, which multiplies a
given integer~|q| by a fraction~|f|. When the operands are positive, it
computes $p=\lfloor qf/2^{28}+{1\over2}\rfloor$, a symmetric function
of |q| and~|f|.

@<Declare \Prote\ arithmetic routines@>=
function take_mpfract(@!q:integer;@!f:mpfract):integer;
var @!p:integer; {the fraction so far}
@!negative:boolean; {should the result be negated?}
@!n:integer; {additional multiple of $q$}
@!be_careful:integer; {disables certain compiler optimizations}
begin @<Reduce to the case that |f>=0| and |q>0|@>;
if f<mpfract_one then n:=0
else  begin n:=f div mpfract_one; f:=f mod mpfract_one;
  if q<=el_gordo div n then n:=n*q
  else  begin arith_error:=true; n:=el_gordo;
    end;
  end;
f:=f+mpfract_one;
@<Compute $p=\lfloor qf/2^{28}+{1\over2}\rfloor-q$@>;
be_careful:=n-el_gordo;
if be_careful+p>0 then
  begin arith_error:=true; n:=el_gordo-p;
  end;
if negative then take_mpfract:=-(n+p)
else take_mpfract:=n+p;
end;

@ @<Reduce to the case that |f>=0| and |q>0|@>=
if f>=0 then negative:=false
else  begin negate(f); negative:=true;
  end;
if q<0 then
  begin negate(q); negative:=not negative;
  end;

@ The invariant relations in this case are (i)~$\lfloor(qf+p)/2^k\rfloor
=\lfloor qf_0/2^{28}+{1\over2}\rfloor$, where $k$ is an integer and
$f_0$ is the original value of~$f$; (ii)~$2^k\L f<2^{k+1}$.
@^inner loop@>

@<Compute $p=\lfloor qf/2^{28}+{1\over2}\rfloor-q$@>=
p:=mpfract_half; {that's $2^{27}$; the invariants hold now with $k=28$}
if q<mpfract_four then
  repeat if odd(f) then p:=halfp(p+q)@+else p:=halfp(p);
  f:=halfp(f);
  until f=1
else  repeat if odd(f) then p:=p+halfp(q-p)@+else p:=halfp(p);
  f:=halfp(f);
  until f=1

@ There's an auxiliary array |randoms| that contains 55 pseudo-random
fractions. Using the recurrence $x_n=(x_{n-55}-x_{n-31})\bmod 2^{28}$,
we generate batches of 55 new $x_n$'s at a time by calling |new_randoms|.
The global variable |j_random| tells which element has most recently
been consumed.

@<Glob...@>=
@!randoms:array[0..54] of mpfract; {the last 55 random values generated}
@!j_random:0..54; {the number of unused |randoms|}

@ This array of pseudo-random numbers is set starting from a seed value,
that is kept in the global integer |random_seed|.

@<Global...@>=
@!random_seed:integer; {seed for pseudo-random number generation}

@ @<Generate all \Prote\ primitives@>=
primitive("randomseed",last_item,random_seed_code);@/
@!@:randomseed_}{\.{\\randomseed} primitive@>

@ @<Cases of |last_item| for |print_cmd_chr|@>=
random_seed_code: print_esc("randomseed");

@ @<Cases for fetching a \Prote\ int value@>=
random_seed_code: cur_val:=random_seed;

@ We set the initial value from the system time. System integrators
could provide a better source of pseudo-randomness.

Every time a new seed value is assigned, the array has to be
regenerated for consumption by routines explained a little later.

@<\Prote\ initializations@>=
random_seed:=sys_time;
init_randoms;

@ Since changing the value must trigger the redefinition of the array,
a dedicated primitive is defined to take the new seed and call
|init_randoms|.

@<Generate all \Prote\ primitives@>=
primitive("setrandomseed",convert,set_random_seed_code);@/
@!@:setrandomseed_}{\.{\\setrandomseed} primitive@>

@ @<Cases of |convert| for |print_cmd_chr|@>=
set_random_seed_code: print_esc("setrandomseed");

@ Once we have retrieved and redefined |random_seed|, we must regenerate
the |randoms| array.

@<Cases of `Scan the argument for command |c|'@>=
set_random_seed_code: begin scan_int; random_seed:=cur_val;
  init_randoms;
  end;

@ @<Cases of `Print the result of command |c|'@>=
set_random_seed_code: print_int(random_seed);

@ To consume a random fraction, the program below will say `|next_random|'
and then it will fetch |randoms[j_random]|.

@d next_random==if j_random=0 then new_randoms
  else decr(j_random)

@<Declare \Prote\ arithmetic routines@>=
procedure new_randoms;
var @!k:0..54; {index into |randoms|}
@!x:integer; {accumulator}
begin for k:=0 to 23 do
  begin x:=randoms[k]-randoms[k+31];
  if x<0 then x:=x+mpfract_one;
  randoms[k]:=x;
  end;
for k:=24 to 54 do
  begin x:=randoms[k]-randoms[k-24];
  if x<0 then x:=x+mpfract_one;
  randoms[k]:=x;
  end;
j_random:=54;
end;

@ To initialize the |randoms| table, we call the following routine.

@<Declare \Prote\ arithmetic routines@>=
procedure init_randoms;
var @!j,@!jj,@!k:mpfract; {more or less random integers}
@!i:0..54; {index into |randoms|}
begin j:=abs(random_seed);
while j>=mpfract_one do j:=halfp(j);
k:=1;
for i:=0 to 54 do
  begin jj:=k; k:=j-k; j:=jj;
  if k<0 then k:=k+mpfract_one;
  randoms[(i*21)mod 55]:=j;
  end;
new_randoms; new_randoms; new_randoms; {``warm up'' the array}
end;

@ To produce a uniform random number in the range |0<=u<x| or |0>=u>x|
or |0=u=x|, given a |scaled| value~|x|, we proceed as shown here.

Note that the call of |mult_integers| will produce the values 0 and~|x|
with about half the probability that it will produce any other particular
values between 0 and~|x|, because it rounds its answers.

@<Declare \Prote\ arithmetic routines@>=
function unif_rand(@!x:scaled):scaled;
var @!y:scaled; {trial value}
begin next_random; y:=take_mpfract(abs(x),randoms[j_random]);
if y=abs(x) then unif_rand:=0
else if x>0 then unif_rand:=y
else unif_rand:=-y;
end;

@ This can be used by calling the following primitive.

@<Generate all \Prote\ primitives@>=
primitive("uniformdeviate",convert,uniform_deviate_code);@/
@!@:uniformdeviate_}{\.{\\uniformdeviate} primitive@>

@ @<Cases of |convert| for |print_cmd_chr|@>=
uniform_deviate_code: print_esc("uniformdeviate");

@ It takes one integer argument obviously that will be the argument
to the function.

@<Cases of `Scan the argument for command |c|'@>=
uniform_deviate_code: begin scan_int;
  cur_val:=unif_rand(cur_val);
  end;

@ @<Cases of `Print the result of command |c|'@>=
uniform_deviate_code: print_int(cur_val);

@ The following somewhat different subroutine tests rigorously if $ab$ is
greater than, equal to, or less than~$cd$,
given integers $(a,b,c,d)$. In most cases a quick decision is reached.
The result is $+1$, 0, or~$-1$ in the three respective cases.

@d return_sign(#)==begin ab_vs_cd:=#; return;
  end

@<Declare \Prote\ arithmetic routines@>=
function ab_vs_cd(@!a,b,c,d:integer):integer;
label exit;
var @!q,@!r:integer; {temporary registers}
begin @<Reduce to the case that |a,c>=0|, |b,d>0|@>;
loop@+  begin q := a div d; r := c div b;
  if q<>r then
    if q>r then return_sign(1)@+else return_sign(-1);
  q := a mod d; r := c mod b;
  if r=0 then
    if q=0 then return_sign(0)@+else return_sign(1);
  if q=0 then return_sign(-1);
  a:=b; b:=q; c:=d; d:=r;
  end; {now |a>d>0| and |c>b>0|}
exit:end;

@ @<Reduce to the case that |a...@>=
if a<0 then
  begin negate(a); negate(b);
  end;
if c<0 then
  begin negate(c); negate(d);
  end;
if d<=0 then
  begin if b>=0 then
    if ((a=0)or(b=0))and((c=0)or(d=0)) then return_sign(0)
    else return_sign(1);
  if d=0 then
    if a=0 then return_sign(0)@+else return_sign(-1);
  q:=a; a:=c; c:=q; q:=-b; b:=-d; d:=q;
  end
else if b<=0 then
  begin if b<0 then if a>0 then return_sign(-1);
  if c=0 then return_sign(0) else return_sign(-1);
  end

@ Finally, a normal deviate with mean zero and unit standard deviation
can readily be obtained with the ratio method (Algorithm 3.4.1R in
{\sl The Art of Computer Programming\/}).

@<Declare \Prote\ arithmetic routines@>=
function norm_rand:scaled;
var @!x,@!u,@!l:integer; {what the book would call $2^{16}X$, $2^{28}U$,
  and $-2^{24}\ln U$}
begin repeat
  repeat next_random;
  x:=take_mpfract(112429,randoms[j_random]-mpfract_half);
    {$2^{16}\sqrt{8/e}\approx 112428.82793$}
  next_random; u:=randoms[j_random];
  until abs(x)<u;
x:=make_mpfract(x,u);
l:=139548960-m_log(u); {$2^{24}\cdot12\ln2\approx139548959.6165$}
until ab_vs_cd(1024,l,x,x)>=0;
norm_rand:=x;
end;

@ This can be used by calling the following primitive.

@<Generate all \Prote\ primitives@>=
primitive("normaldeviate",convert,normal_deviate_code);@/
@!@:normaldeviate_}{\.{\\normaldeviate} primitive@>

@ @<Cases of |convert| for |print_cmd_chr|@>=
normal_deviate_code: print_esc("normaldeviate");

@ @<Cases of `Scan the argument for command |c|'@>=
normal_deviate_code: cur_val:=norm_rand;

@ @<Cases of `Print the result of command |c|'@>=
normal_deviate_code: print_int(cur_val);

@*1 DVI related primitives.

These primitives are related to positions in the DVI output.

The \TeX\ and DVI system coordinates relate to an origin that is at the
upper left corner. The \TeX\ coordinates are computed relative to an
origin that has $(0,0)$ coordinates. Coordinates grow then rightward and
downward. This is the {\sl page} coordinates relative to what is
typeset (what \TeX\ is dealing with).

But this typesetting material has to be put on what we will call {\sl
paper}. The material put into shape by \TeX\ is put on the paper. On
this paper, where will be put the \TeX\ origin? It is considered to be
$1in$ at the right and $1in$ down from the upper left corner of the
paper (see m.590, alinea 2).

@d DVI_std_x_offset=4736286 {1 inch in sp}
@d DVI_std_y_offset=4736286 {1 inch in sp}

@ But the paper size is not specified in the DVI file and is not being
dealt with by \TeX.

In order to have a common reference point, and since the \.{\\lastxpos}
and \.{\\lastypos} primitives originated in pdf\TeX, these two
primitives give positions, in scaled points, relative to the lower left
corner of the paper.

Hence the need, for these primitive, to define the paper size, with the
(misnamed) \.{\\pagewidth} and \.{\\pageheight}.

\.{\\pagewidth} and \.{\\pageheight} are dimension parameters,
initialized to $0$ by the generic \TeX\ code.

@<Generate all \Prote\ primitives@>=
primitive("pagewidth",assign_dimen,dimen_base+page_width_code);@/
@!@:pagewidth_}{\.{\\pagewidth} primitive@>
primitive("pageheight",assign_dimen,dimen_base+page_height_code);@/
@!@:pageheight_}{\.{\\pageheight} primitive@>

@ When instructed to, the \.{h} and \.{v} last values are transformed,
in the coordinates system defined above and saved in the global
variables |last_saved_xpos| and |last_saved_ypos|. They are
initialized to $0$ and we do not make any verification that a
call to the \.{\\savepos} primitive---to come---has been made before
retrieving their values.

@<Global...@>=
@!last_saved_xpos,last_saved_ypos: scaled; {last (x,y) DVI pos saved}

@ @<\Prote\ initializations@>=
last_saved_xpos:=0; last_saved_ypos:=0;

@ @<Set |last_saved_xpos| and |last_saved_ypos| with transformed
coordinates@>=
last_saved_xpos:=cur_h+DVI_std_x_offset;
last_saved_ypos:=page_height-(cur_v+DVI_std_y_offset);

@ @<Generate all \Prote\ primitives@>=
primitive("lastxpos",last_item,last_xpos_code);@/
@!@:lastxpos_}{\.{\\lastxpos} primitive@>
primitive("lastypos",last_item,last_ypos_code);@/
@!@:lastypos_}{\.{\\lastypos} primitive@>

@ @<Cases of |last_item| for |print_cmd_chr|@>=
last_xpos_code: print_esc("lastxpos");
last_ypos_code: print_esc("lastypos");

@ @<Cases for fetching a \Prote\ int value@>=
last_xpos_code: cur_val:=last_saved_xpos;
last_ypos_code: cur_val:=last_saved_ypos;

@ |last_saved_xpos| and |last_saved_ypos| are only defined when
instructed to by the call the the \.{\\savepos} primitive. Since the
real work has to be done at \.{shipout} time, it is a case to be treated
like the \.{\\special} primitive, that is it belongs to the
\.{extension} class.

We will add something more in the handling of the primitive: it will
insert a \.{whatsit} in the DVI file so that one, using the program
|dvitype|, could retrieve more than one {\it hic}. So there is a counter
incremented whenever the primitive is called.

@<Global...@>=
last_save_pos_number:integer; {identifying the order of the call}

@ @<\Prote\ initializations@>=
last_save_pos_number:=0; {i.e. none}

@ @<Generate all \Prote\ primitives@>=
primitive("savepos",extension,save_pos_code);@/
@!@:savepos_}{\.{\\savepos} primitive@>

@ @<Cases of |extension| for |print_cmd_chr|@>=
save_pos_code: print_esc("savepos");

@ @<Cases for |do_extension|@>=
save_pos_code:@<Implement \.{\\savepos}@>;

@ We need the basic two words node, since we don't pass any parameter
and it is just an instruction to do something. So the \.{whatsit} node
is just the call.

@<Implement \.{\\savepos}@>=
begin new_whatsit(save_pos_code,small_node_size); write_stream(tail):=null;
  write_tokens(tail):=null;
  end

@ @<Cases for displaying the |whatsit| node@>=
save_pos_code: print_esc("savepos");

@ @<Cases for making a partial copy of the whatsit node@>=
save_pos_code: begin r:=get_node(small_node_size);
  words:=small_node_size;
  end;

@ @<Cases for wiping out the whatsit node@>=
save_pos_code: free_node(p,small_node_size);

@ So, after these trivial initializations, what will we effectively do?
When the following procedure will be called, we define |last_saved_xpos|,
|last_saved_ypos|, increment |last_save_pos_number|, and a |warning|
followed by three
|key=value| space separated definitions as a \.{\\special}, the first
being prefixed by the string |__PROTE_| (shall be considered a reserved
prefix) and the string |SAVEPOS_|, equal to the index of the call, and
the |XPOS| and |YPOS| definitions.

This is obviously, from the previous description, a variation around
|special_out|.

@<Declare procedures needed in |out_what|@>=
procedure save_pos_out(@!p:pointer);
var old_setting:0..max_selector; {holds print |selector|}
@!k:pool_pointer; {index into |str_pool|}
begin synch_h; synch_v; incr(last_save_pos_number);
@<Set |last_saved_xpos| and |last_saved_ypos|...@>@;
old_setting:=selector; selector:=new_string;
print("warning __PROTE_");print("SAVEPOS");print_char("=");
print_int(last_save_pos_number);print_char(" ");
print("XPOS");print("=");print_int(last_saved_xpos);print_char(" ");
print("YPOS");print("=");print_int(last_saved_ypos);
selector:=old_setting;
str_room(1); {abort if probably overflowed and truncated}
dvi_out(xxx1); dvi_out(cur_length); {it's less than 256}
for k:=str_start[str_ptr] to pool_ptr-1 do dvi_out(so(str_pool[k]));
pool_ptr:=str_start[str_ptr]; {forget the not commited tentative string}
end;

@ @<Cases for |out_what|@>=
save_pos_code: save_pos_out(p);

@* \[54] System-dependent changes.
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

@*1 Passing a file name as a general text argument.

We allow to pass to |scan_file_name| an argument, in the more
general sense, subject to all the ``superficial'' expansions. Once what
is to be taken finally as the file name is defined, we put this as
a tentative new string (in the pool) without creating it actually,
and we define the area and the extension positions as relative to
the beginning of the tentative current string, the extension being
the last chunk introduced by a dot, and the extension being considered
only after the area---this insured by scanning the string from the
end.

Due to the existing behavior, double quotes are totally removed from
a tentative file name (this is questionable).

For the very same reason, this version of {\tt input} is recursive
(one can provide the content of an inputed file to be the name of
another file to input---input between called in the argument to
input...

And we free whatever temporary garbage we used.

@<Define a general text file name and |goto done|@>=
begin back_input; name_in_progress:=false; {this version is recursive...}
  cur_cs:=input_loc; {|scan_toks| will set |warning_index| from it}
  scan_general_x_text;
  old_setting:=selector; selector:=new_string;
  token_show(link(garbage)); selector:=old_setting;
  @<Suppress double quotes in braced input file name@>@;
  j:=pool_ptr-1; while (j>=str_start[str_ptr])and(area_delimiter=0) do
    begin
      if (str_pool[j]="/") then area_delimiter:=j-str_start[str_ptr];
      if (ext_delimiter=0)and(str_pool[j]=".") then
        ext_delimiter:=j-str_start[str_ptr];
      decr(j);
    end;
  flush_list(link(garbage));
  goto done;
end;

@ This is the behavior implemented in other engines and is quite
questionable: double quotes in the result are simply removed---meaning
that a double quote can not be a part of a name.

@<Suppress double quotes in braced input file name@>=
j:=str_start[str_ptr]; k:=j;
while k<pool_ptr do begin
  if str_pool[k]<>"""" then begin str_pool[j]:=str_pool[k];incr(j);end;
  incr(k);
end;
pool_ptr:=j;

@ More implementation modifications can come after this.
@z


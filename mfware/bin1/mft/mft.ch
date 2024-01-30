% mft.ch for C compilation under kerTeX.
% 
% 11/27/89 Karl Berry		version 2.0.
% 01/20/90 Karl			new mft.web (still 2.0, though).
% 2010-04-11 Thierry Laronde, cleaning for kerTeX.
% 2021-04-21 Thierry Laronde, D.E.K. 2021 tune-up.
% 2022-03-05 (TL) argfmt, rewrite and reset and general handling of
%   name_of_file and name_length for spaces handling.
% 
% From Pierre Mackay's version for pc, which was in turn based on Howard
% Trickey's and Pavel Curtis's change file for weave.
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [0] MFT: print changes only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=\contentspagenumber \advance\pageno by 1
\let\maybe=\iffalse
\def\title{MFT changes for Berkeley {\mc UNIX}}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [2] Change banner message
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d banner=='This is MFT, Version 2.1'
@y
@d banner=='This is MFT, kerTeX C Version 2.1'
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [3] Entry: arguments will be handled a la C main() way.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
@d end_of_MFT = 9999 {go here to wrap it up}

@p @t\4@>@<Compiler directives@>@/
program MFT(@!mf_file,@!change_file,@!style_file,@!tex_file);
label end_of_MFT; {go here to finish}
const @<Constants in the outer block@>@/
type @<Types in the outer block@>@/
var @<Globals in the outer block@>@/
@<Error handling procedures@>@/
procedure initialize;
  var @<Local variables for initialization@>@/
  begin @<Set initial values@>@/
  end;
@y

@p program MFT;
const @<Constants in the outer block@>@/
type @<Types in the outer block@>@/
var @<Globals in the outer block@>@/
@<Error handling procedures@>@/
@<|scan_args| procedure@>@/
procedure initialize;
  var @<Local variables for initialization@>@/
  begin @<Set initial values@>@/
  end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [4] No compiler directives.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@{@&$C+,A+,D-@} {range check, catch arithmetic overflow, no debug overhead}
@y
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [6] Let common macros be defined obviously by CPP.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ Here are some macros for common programming idioms.

@d incr(#) == #:=#+1 {increase a variable by unity}
@d decr(#) == #:=#-1 {decrease a variable by unity}
@y
@ Here are some macros for common programming idioms.

@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [12] The text_char type is used as an array index into xord.  The
% default type `char' produces signed integers, which are bad array
% indices in C.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
@d text_char == char {the data type of characters in text files}
@y
@d text_char == 0..255 {the data type of characters in text files}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [16] enable maximum character set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
for i:=0 to @'37 do xchr[i]:=' ';
for i:=@'177 to @'377 do xchr[i]:=' ';
@y
for i:=1 to @'37 do xchr[i]:=chr(i);
for i:=@'177 to @'377 do xchr[i]:=chr(i);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [19] terminal output: use standard i/o
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d print(#)==write(term_out,#) {`|print|' means write on the terminal}
@y
@d term_out==stdout
@d print(#)==write(term_out,#) {`|print|' means write on the terminal}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [20] Hence remove term_out as a WEB defined variable.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
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
on the \PASCAL\ system that was used in \.{WEAVE}'s initial development:
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
% [22] flush terminal buffer
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

@p procedure open_input; {prepare to read the inputs}
begin reset(mf_file); reset(change_file); reset(style_file);
end;
@y
@ The opening of files passed as arguments is handled during the
|scan_args| part, using the facilities shared between WEB programs in
the libweb under kerTeX. So there is no dedicated routine for this.
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
@ The |tex_file| will be opened after the scanning of arguments during
the initialization. Its name is ``deduced'' from the name of the mf
file, suffix replaced as can be guessed.

@<Set init...@>=
scan_args;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [28] Fix the f^ the translator doesn't handle. The input_ln is partly
% provided by a C extra routine (since it diverges from the one in
% METAFONT and TeX---implemented as libweb::cinputln()---we provide a
% special version.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p function input_ln(var f:text_file):boolean;
  {inputs a line or returns |false|}
var final_limit:0..buf_size; {|limit| without trailing blanks}
begin limit:=0; final_limit:=0;
if eof(f) then input_ln:=false
else  begin while not eoln(f) do
    begin buffer[limit]:=xord[f^]; get(f);
    incr(limit);
    if buffer[limit-1]<>" " then final_limit:=limit;
    if limit=buf_size then
      begin while not eoln(f) do get(f);
      decr(limit); {keep |buffer[buf_size]| empty}
      if final_limit>limit then final_limit:=limit;
      print_nl('! Input line too long'); loc:=0; error;
@.Input line too long@>
      end;
    end;
  read_ln(f); limit:=final_limit; input_ln:=true;
  end;
end;
@y
With C, we call an external C procedure, |line_read|.  That routine
fills |buffer| from 0 onwards with the |xord|'ed values of the next
line, setting |limit| appropriately (ignoring trailing blanks).  It will
stop if |limit=buf_size|, and the following will cause an error message.
For bootstrapping purposes it is all right to use the original
form of |input_ln|; it will just run slower.

@p function input_ln(var f:text_file):boolean;
  {inputs a line or returns |false|}
begin limit:=0;
if eof(f) then input_ln:=false
else  begin line_read(f);
    if limit=buf_size then
      begin
      decr(limit); {keep |buffer[buf_size]| empty}
      {if final_limit>limit then final_limit:=limit;}
      print_nl('! Input line too long'); loc:=0; error;
@.Input line too long@>
      end;
   input_ln:=true;
  end;
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [31] Fix jump_out
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ The |jump_out| procedure just cuts across all active procedure levels
and jumps out of the program. This is the only non-local \&{goto} statement
in \.{MFT}. It is used when no recovery from a particular error has
been provided.

Some \PASCAL\ compilers do not implement non-local |goto| statements.
@^system dependencies@>
In such cases the code that appears at label |end_of_MFT| should be
copied into the |jump_out| procedure, followed by a call to a system procedure
that terminates the program.

@d fatal_error(#)==begin new_line; print(#); error; mark_fatal; jump_out;
  end

@<Error handling...@>=
procedure jump_out;
begin goto end_of_MFT;
end;
@y
@ The |jump_out| procedure cleans up, prints appropriate messages,
and exits back to the operating system.

@d fatal_error(#)==begin new_line; print(#); error; mark_fatal; jump_out;
	end

@<Error handling...@>=
procedure jump_out;
begin
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
% [44] Remove open_input() call: we do everything when scanning the
% args.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@<Initialize the input system@>=
begin open_input; line:=0; other_line:=0;@/
@y
@<Initialize the input system@>=
begin line:=0; other_line:=0;@/
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [111] print newline at end of run, exit based upon value of history,
% and remove the end_of_MFT label.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
end_of_MFT:{here files should be closed if the operating system requires it}
@<Print the job |history|@>;
end.
@y
@<Print the job |history|@>;
new_line;
if (history <> spotless) and (history <> harmless_message) then
    cexit(1)
else
    cexit(0);
end.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [112] system dependent changes--the scan_args procedure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@* System-dependent changes.
This module should be replaced, if necessary, by changes to the program
that are necessary to make \.{MFT} work at a particular installation.
It is usually best to design your change file so that all changes to
previous modules preserve the module numbering; then everybody's version
will be consistent with the printed program. More extensive changes,
which introduce new modules, can be inserted here; then only the index
itself will get a new module number.
@^system dependencies@>
@y
@* System-dependent changes.

The user calls \.{MFT} with arguments on the command line.  These are
either file names or flags (beginning with `\.-').  The following globals
are for communicating the user's desires to the rest of the program. The
various |file_name| variables contain strings with the full names of
those files, as UNIX knows them.

The flags that affect \.{MFT} are \.{-c} and \.{-s}, whose 
statuses is kept in |no_change| and |no_style|, respectively.

@<Globals...@>=
@!c_buf_size: integer; {for |c_input_ln|}
@!no_change,no_style:boolean;

@ The |scan_args| procedure looks at the command line arguments to open,
and in some cases search, for file names passed as the argument value.

The three files specified on the command line are open read-only. The mf
file is search, using the facilities of the C libweb, in a colon
separated list of directories set a compile time, and including the
current directory.

The style file too is searched.

The change file is contingent, local, and is not searched.

Only the first METAFONT file is mandatory. The other ones are given
default values is they are not specified.

@<|scan_args|...@>=
procedure scan_args;
var dot_pos, sep_pos, i, a: integer; {indices}
max_suffix_length: integer; {we need this more at most}
@!which_file_next: char;
@!found_mf,@!found_change,found_style: boolean;
begin
c_buf_size:=buf_size;
set_paths(MFT_PATHS_SET); {Set paths for searching}
found_mf:=false; found_change:=false; found_style:=false;
for a:=1 to argc-1 do begin
  argfmt(a); {put argument number |a| into |name_of_file|}
  if name_of_file[1]<>'-' then begin
    if not found_mf then
      @<Get |mf_file_name| from |name_of_file|, and set up |tex_file_name@>
    else 
      if not found_change then begin
        if which_file_next <> 's' then begin
                @<Get |change_file_name| from |name_of_file|@>;
                which_file_next := 's'
                end
        else @<Get |style_file_name| from |name_of_file|@>
        end
      else if not found_style then begin
        if which_file_next = 's' then begin
                @<Get |style_file_name| from |name_of_file|@>; 
                which_file_next := 'c'
                end;
        end
    else  @<Print usage error message and quit@>;
    end
  else @<Handle flag argument in |name_of_file|@>;
  end;
if not found_mf then @<Print usage error message and quit@>;
if not found_change then @<Set up null change file@>;
if not found_style then @<Set up plain style file@>;
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

@ |name_of_file| is set with the argument, |name_length| is defined.
A suffix of |'.mf'| is appended if there is none. We then use libweb
path searching to open the file and give up if not found.

Note that the |reset| and |rewrite| procedures are C routines, 
understanding a ``name'' as pointer to a vector bytes whose defined
portion starts at index $1$ and is of length passed as an argument.

@<Get |mf_file_name|...@>=
begin
max_suffix_length:=4;
@<Set |dot_pos| and |sep_pos| from |name_of_file|...@>@;
if dot_pos=-1 then begin
        dot_pos:=name_length+1;
        name_of_file[dot_pos]:='.';
        name_of_file[dot_pos+1]:='m';
        name_of_file[dot_pos+2]:='f';
		name_length:=dot_pos+2;
        end;
if not b_open_in(mf_file, MFT_MF_INPUTS_PATH_SPEC) then begin
	print_string(stdout, name_of_file, name_length);
	print_ln(': MF file not found.');
	cexit(1);
end;
name_of_file[dot_pos+1]:='t';
name_of_file[dot_pos+2]:='e';
name_of_file[dot_pos+3]:='x';
name_length:=dot_pos+3;
if sep_pos=-1 then sep_pos:=0; {will be use as translation delta}
name_length:=dot_pos+1-sep_pos; {truncate to file name}
rewrite(tex_file, name_of_file+sep_pos, name_length);
which_file_next := 'z';
found_mf:=true;
end

@ |name_of_file| is set from the argument. If there is no extension,
|'.ch'| is appended.

@<Get |change_file_name|...@>=
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
which_file_next := 'z';
found_change:=true;
end

@ |name_of_file| is set with the name for the style. If there is no
extension, we add |'.mft'|. The the file is search using the facilities
offered by the libweb, the path specification being |TEXINPUTS|.

@<Get |style_file_name|...@>=
begin
max_suffix_length:=4;
@<Set |dot_pos| and |sep_pos| from |name_of_file|...@>@;
if dot_pos=-1 then begin
	dot_pos:=name_length+1;
	name_of_file[dot_pos]:='.';
	name_of_file[dot_pos+1]:='m';
	name_of_file[dot_pos+2]:='f';
	name_of_file[dot_pos+3]:='t';
	name_length:=dot_pos+3;
end;
if not b_open_in(style_file, MFT_TEX_INPUTS_PATH_SPEC) then begin
	print_string(stdout, name_of_file, name_length);
	print_ln(': style file not found.');
	cexit(1);
end;
which_file_next := 'z';
found_style:=true;
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
	if not b_open_in(change_file, MFT_TEX_INPUTS_PATH_SPEC) then begin
		print_ln('Unable to find an empty change file!');
		cexit(1);
	end;
end

@

@<Set up plain style file@>=
begin
	name_of_file[1]:='p';
	name_of_file[2]:='l';
	name_of_file[3]:='a';
	name_of_file[4]:='i';
	name_of_file[5]:='n';
	name_of_file[6]:='.';
	name_of_file[7]:='m';
	name_of_file[8]:='f';
	name_of_file[9]:='t';
	name_length:=9;
	if not b_open_in(style_file, MFT_TEX_INPUTS_PATH_SPEC) then begin
		print_ln('Unable to find the default style file!');
		cexit(1);
	end;
end

@

@<Handle flag...@>=
begin
i:=2;
while i<=name_length do begin
        if name_of_file[i]='c' then begin found_change:=false;
                if which_file_next <> 's' then which_file_next := 'c'
                end
        else if name_of_file[i]='s' then begin found_style:=false;
                  if which_file_next <> 'c' then which_file_next := 's'
                  end
	        else print_nl('Invalid flag ',xchr[xord[name_of_file[i]]], '.');
        incr(i);
        end;
end

@

@<Print usage error message and quit@>=
begin
print_ln('Usage: mft file[.mf] [-cs] [change[.ch]] [style[.mft]].');
cexit(1);
end
@z

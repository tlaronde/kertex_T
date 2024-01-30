% Change file for BibTeX for Berkeley UNIX, by H. Trickey, et al.
% 
% History:
% 05/28/84      Initial implementation, version 0.41 of BibTeX
% 07/01/84      Version 0.41a of BibTeX.
% 12/17/84      Version 0.97c of BibTeX.
% 02/12/85      Version 0.98c of BibTeX.
% 02/25/85      Newer version 0.98c of BibTeX.
% 03/25/85      Version 0.98f of BibTeX
% 05/23/85      Version 0.98i of BibTeX
% 02/11/88      Version 0.99b of BibTeX
% 04/04/88      Version 0.99c; converted for use with web2c (ETM).
% 11/30/89      Use FILENAMESIZE instead of 1024 (KB).
% 03/09/90  `int' is a bad variable name for some cc's.
% 2010-11-24  Version 0.99d for inclusion in kerTeX [Thierry Laronde].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% banner line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d banner=='This is BibTeX, Version 0.99d' {printed when the program starts}
@y
@d banner=='This is BibTeX, kerTeX C Version 0.99d' {printed when the program starts}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% term_in/out are input,output.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d term_out == tty
@d term_in == tty
@y
@d term_out == stdout
@d term_in == stdin
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% debug..gubed, stat..tats
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d debug == @{          { remove the `|@{|' when debugging }
@d gubed == @t@>@}      { remove the `|@}|' when debugging }
@f debug == begin
@f gubed == end
@#
@d stat == @{           { remove the `|@{|' when keeping statistics }
@d tats == @t@>@}       { remove the `|@}|' when keeping statistics }
@f stat == begin
@f tats == end
@#
@d trace == @{          { remove the `|@{|' when in |trace| mode }
@d ecart == @t@>@}      { remove the `|@}|' when in |trace| mode }
@f trace == begin
@f ecart == end
@y
@d debug == ifdef('DEBUG')
@d gubed == endif('DEBUG')
@f debug == begin
@f gubed == end
@#
@d stat == ifdef('STAT')
@d tats == endif('STAT')
@f stat==begin
@f tats==end
@#
@d trace == ifdef@&('TRACE')
@d ecart == endif@&('TRACE')
@f trace == begin
@f ecart == end
@z

@x
@d incr(#) == #:=#+1    {increase a variable by unity}
@d decr(#) == #:=#-1    {decrease a variable by unity}
@y
{These are defined as C macros}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Removing non local gotos and labels, and compiler directives.
% close_up_shop is made a procedure.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d close_up_shop=9998           {jump here after fatal errors}
@d exit_program=9999            {jump here if we couldn't even get started}

@p
@t\4@>@<Compiler directives@>@/
program BibTEX;                 {all files are opened dynamically}
label   close_up_shop,@!exit_program @<Labels in the outer block@>;
@y
@p
program BibTEX;                 {all files are opened dynamically}
label @<Labels in the outer block@>;
@z

@x
@<Read and execute the \.{.bst} file@>;
close_up_shop:
@<Clean up and leave@>;
exit_program:
end.
@y
@<Read and execute the \.{.bst} file@>;
close_up_shop;
end. { not reached }
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization: setpaths() and replace non local goto.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
    goto exit_program;
    end;
@<Set initial values of key variables@>;
pre_def_certain_strings;@/
get_the_top_level_aux_file_name;
end;
@y
    cexit(0);
    end;
@<Set initial values of key variables@>;
pre_def_certain_strings;@/
set_paths(BIBTEX_PATHS_SET); {get default file paths from Unix environment}
get_the_top_level_aux_file_name;
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove file_name_size which is defined externally in C libweb.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d file_name_size=40    {file names shouldn't be longer than this}
@y
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove name_of_file which is defined in C libweb.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
Most of what we need to do with respect to input and output can be handled
by the I/O facilities that are standard in \PASCAL, i.e., the routines
called |get|, |put|, |eof|, and so on. But
standard \PASCAL\ does not allow file variables to be associated with file
names that are determined at run time, so it cannot be used to implement
\BibTeX; some sort of extension to \PASCAL's ordinary |reset| and |rewrite|
is crucial for our purposes. We shall assume that |name_of_file| is a variable
of an appropriate type such that the \PASCAL\ run-time system being used to
implement \BibTeX\ can open a file whose external name is specified by
|name_of_file|. \BibTeX\ does no case conversion for file names.

@<Globals in the outer block@>=
@!name_of_file:packed array[1..file_name_size] of char;
                         {on some systems this is a \&{record} variable}
@!name_length:0..file_name_size;
  {this many characters are relevant in |name_of_file| (the rest are blank)}
@!name_ptr:0..file_name_size+1;         {index variable into |name_of_file|}
@y
Most of what we need to do with respect to input and output can be handled
by the I/O facilities that are standard in \PASCAL, i.e., the routines
called |get|, |put|, |eof|, and so on. But
standard \PASCAL\ does not allow file variables to be associated with file
names that are determined at run time, so it cannot be used to implement
\BibTeX; some sort of extension to \PASCAL's ordinary |reset| and |rewrite|
is crucial for our purposes. We shall assume that |name_of_file| is a variable
of an appropriate type such that the \PASCAL\ run-time system being used to
implement \BibTeX\ can open a file whose external name is specified by
|name_of_file|. \BibTeX\ does no case conversion for file names.

The C version of BibTeX uses search paths to look for files to open.
|name_of_file| is a string of |name_length| length looked for; when
found, the pathname is written in |real_name_of_file|,
|real_name_length| being defined to the definite name in the array.

@<Globals in the outer block@>=
@!name_ptr:integer;         {index variable into |name_of_file|}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file opening
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
The \ph\ compiler with which the present version of \TeX\ was prepared has
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
\TeX\ to undertake appropriate corrective action.

\TeX's file-opening procedures return |false| if no file identified by
|name_of_file| could be opened.

@d reset_OK(#)==erstat(#)=0
@d rewrite_OK(#)==erstat(#)=0

@<Procedures and functions for file-system interacting@>=
function erstat(var f:file):integer; extern;    {in the runtime library}
@#@t\2@>
function a_open_in(var f:alpha_file):boolean;   {open a text file for input}
begin reset(f,name_of_file,'/O'); a_open_in:=reset_OK(f);
end;
@#
function a_open_out(var f:alpha_file):boolean;  {open a text file for output}
begin rewrite(f,name_of_file,'/O'); a_open_out:=rewrite_OK(f);
end;
@y
{a_open_in and a_open_out will be defined as a C macro}
@z

@x
@<Procedures and functions for file-system interacting@>=
procedure a_close(var f:alpha_file);            {close a text file}
begin close(f);
end;
@y
{aclose will be defined as a C macro}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Turning non local goto close_up_shop into a procedure call.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d overflow(#)==begin           {fatal error---close up shop}
                print_overflow;
                print_ln(#:0);
                goto close_up_shop;
                end
@y
@d overflow(#)==begin           {fatal error---close up shop}
                print_overflow;
                print_ln(#:0);
                close_up_shop;
                end
@z

@x
@d confusion(#)==begin          {fatal error---close up shop}
                 print (#);
                 print_confusion;
                 goto close_up_shop;
                 end
@y
@d confusion(#)==begin          {fatal error---close up shop}
                 print (#);
                 print_confusion;
                 close_up_shop;
                 end
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% f^ fix. But since D.E. Knuth allows/suggests to replace the
% input_ln() routine with a more efficient implementation, we implement
% it with a call to an external in library.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
Standard \PASCAL\ says that a file should have |eoln| immediately
before |eof|, but \BibTeX\ needs only a weaker restriction: If |eof|
occurs in the middle of a line, the system function |eoln| should return
a |true| result (even though |f^| will be undefined).

@<Procedures and functions for all file I/O, error messages, and such@>=
function input_ln(var f:alpha_file) : boolean;
                                {inputs the next line or returns |false|}
label loop_exit;
begin
last:=0;
if (eof(f)) then input_ln:=false
else
  begin
  while (not eoln(f)) do
    begin
    if (last >= buf_size) then
        buffer_overflow;
    buffer[last]:=xord[f^];
    get(f); incr(last);
    end;
  get(f);
  while (last > 0) do           {remove trailing |white_space|}
    if (lex_class[buffer[last-1]] = white_space) then
      decr(last)
     else
      goto loop_exit;
loop_exit:
  input_ln:=true;
  end;
end;
@y
Since the handling of an input line in the buffer is not exactly the
same as in D.E.K.'s work, we can not use directly the external C
procedure |cinputln|. So we wrap the call in another external:
|line_read|.

That routine fills |buffer| from |0| onwards with the |xord|'ed values
of the next line, setting |last| appropriately.  It will stop if
|last=buf_size|, and the following will cause an ``overflow'' abort.

@<Procedures and functions for all file I/O, error messages, and such@>=
function input_ln(var f:alpha_file) : boolean;
  {inputs the next line or returns |false|}
label loop_exit;
begin
last:=0;
if eof(f) then input_ln:=false
else
  begin
  line_read(f,buf_size);
  if last>=buf_size then
        overflow('buffer size ',buf_size);
  while (last > 0) do           {remove trailing |white_space|}
    if lex_class[buffer[last-1]] = white_space then
      decr(last)
     else
      goto loop_exit;
loop_exit:
  input_ln:=true;
  end;
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adjusting indices in the arrays.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
if (length(file_name) > file_name_size) then
    begin
    print ('File=');
    print_pool_str (file_name);
    print_ln (',');
    file_nm_size_overflow;
    end;
name_ptr := 1;
@y
if (length(file_name) > file_name_size) then
    begin
    print ('File=');
    print_pool_str (file_name);
    print_ln (',');
    file_nm_size_overflow;
    end;
name_ptr := 1;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pp2rc(1) limits: name_of_file is not known to be a char * due to the
% way @define var is implemented. Using directly print_string().
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
if (name_length + length(ext) > file_name_size) then
    begin
    print ('File=',name_of_file,', extension=');
    print_pool_str (ext); print_ln (',');
    file_nm_size_overflow;
    end;
name_ptr := name_length + 1;
p_ptr := str_start[ext];
while (p_ptr < str_start[ext+1]) do
    begin
    name_of_file[name_ptr] := chr (str_pool[p_ptr]);
    incr(name_ptr); incr(p_ptr);
    end;
name_length := name_length + length(ext);
name_ptr := name_length+1;
while (name_ptr <= file_name_size) do   {pad with blanks}
    begin
    name_of_file[name_ptr] := ' ';
    incr(name_ptr);
    end;
@y
if (name_length + length(ext) > file_name_size) then
    begin
    print('File='); print_string(stdout, name_of_file, name_length);
    print(', extension=');
    print_pool_str (ext); print_ln (',');
    file_nm_size_overflow;
    end;
name_ptr := name_length + 1;
p_ptr := str_start[ext];
while (p_ptr < str_start[ext+1]) do
    begin
    name_of_file[name_ptr] := chr (str_pool[p_ptr]);
    incr(name_ptr); incr(p_ptr);
    end;
name_length := name_length + length(ext);
name_ptr := name_length+1;
@z

@x
    print_pool_str (area); print (name_of_file,',');
    file_nm_size_overflow;
    end;
name_ptr := name_length;
while (name_ptr > 0) do         {shift up name}
    begin
    name_of_file[name_ptr+length(area)] := name_of_file[name_ptr];
    decr(name_ptr);
    end;
name_ptr := 1;
p_ptr := str_start[area];
while (p_ptr < str_start[area+1]) do
@y
    print_pool_str (area);
    print_string(stdout, name_of_file, name_length); print(',');
    file_nm_size_overflow;
    end;
name_ptr := name_length;
while (name_ptr > 0) do         {shift up name}
    begin
    name_of_file[name_ptr+length(area)] := name_of_file[name_ptr];
    decr(name_ptr);
    end;
name_ptr := 0;
p_ptr := str_start[area];
while (p_ptr < str_start[area+1]) do
@z

@x
for i:=1 to len do
    buffer[i] := xord[pds[i]];
@y
for i:=1 to len do
    buffer[i] := xord[pds[i-1]];
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Our parser doesn't allow arithmetic with constants.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!aux_name_length : 0..file_name_size+1;        {\.{.aux} name sans extension}
@y
@!aux_name_length : integer;
@z

@x
procedure sam_too_long_file_name_print;
begin
write (term_out,'File name `');
name_ptr := 1;
while (name_ptr <= aux_name_length) do
    begin
    write (term_out,name_of_file[name_ptr]);
@y
procedure sam_too_long_file_name_print;
begin
write (term_out,'File name `');
name_ptr := 0;
while (name_ptr < aux_name_length) do
    begin
    write (term_out,name_of_file[name_ptr]);
@z

@x
procedure sam_wrong_file_name_print;
begin
write (term_out,'I couldn''t open file name `');
name_ptr := 1;
while (name_ptr <= name_length) do
    begin
    write (term_out,name_of_file[name_ptr]);
    incr(name_ptr);
    end;
write_ln (term_out,'''');
end;
@y
procedure sam_wrong_file_name_print;
begin
write (term_out,'I couldn''t open file name `');
name_ptr := 0;
while (name_ptr < name_length) do
    begin
    write (term_out,name_of_file[name_ptr]);
    incr(name_ptr);
    end;
write_ln (term_out,'''');
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Command line handling.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
This procedure consists of a loop that reads and processes a (nonnull)
\.{.aux} file name.  It's this module and the next two that must be
changed on those systems using command-line arguments.  Note: The
|term_out| and |term_in| files are system dependent.

@<Procedures and functions for the reading and processing of input files@>=
procedure get_the_top_level_aux_file_name;
label aux_found,@!aux_not_found;
var @<Variables for possible command-line processing@>@/
begin
check_cmnd_line := false;                       {many systems will change this}
loop
    begin
    if (check_cmnd_line) then
        @<Process a possible command line@>
      else
        begin
        write (term_out,'Please type input file name (no extension)--');
        if (eoln(term_in)) then                 {so the first |read| works}
            read_ln (term_in);
        aux_name_length := 0;
        while (not eoln(term_in)) do
            begin
            if (aux_name_length = file_name_size) then
                begin
                while (not eoln(term_in)) do    {discard the rest of the line}
                    get(term_in);
                sam_you_made_the_file_name_too_long;
                end;
            incr(aux_name_length);
            name_of_file[aux_name_length] := term_in^;
            get(term_in);
            end;
        end;
    @<Handle this \.{.aux} name@>;
aux_not_found:
    check_cmnd_line := false;
    end;
aux_found:                      {now we're ready to read the \.{.aux} file}
end;
@y
@<Procedures and functions for the reading and processing of input files@>=
procedure get_the_top_level_aux_file_name;
label aux_found,@!aux_not_found;
begin
loop
    begin
    if (argc > 1) then
        @<Process a possible command line@>
      else begin
        write (term_out,'Please type input file name (no extension)--');
        aux_name_length := 0;
        while (not eoln(term_in)) do begin
            if (aux_name_length = file_name_size) then begin
                readln(term_in);
                sam_you_made_the_file_name_too_long;
            end;
            name_of_file[aux_name_length+1] := getc(term_in);
            incr(aux_name_length);
        end;
        if (eof(term_in)) then begin
            writeln(term_out);
            writeln(term_out,'Unexpected end of file on terminal---giving up!');
            cexit(1);
        end;
        readln(term_in);
      end;
    name_length := aux_name_length;
    @<Handle this \.{.aux} name@>;
aux_not_found:
    argc := 0;
    end;
aux_found:                      {now we're ready to read the \.{.aux} file}
end;
@z

@x
@<Variables for possible command-line processing@>=
@!check_cmnd_line : boolean;    {|true| if we're to check the command line}
@y
@z

@x
@<Process a possible command line@>=
begin
do_nothing;             {the ``default system'' doesn't use the command line}
end
@y
@<Process a possible command line@>=
begin
argfmt(1);
aux_name_length := name_length;
end
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KerTeX path searching.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
if (not a_open_in(cur_aux_file)) then
    sam_you_made_the_file_name_wrong;
@y
if (not a_open_in(cur_aux_file,NO_PATH_SPEC)) then
    sam_you_made_the_file_name_wrong;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleaning list of labels: we have removed preceding ones.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@<Labels in the outer block@>=
,@!aux_done
@y
@<Labels in the outer block@>=
@!aux_done
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Suppressing the non local goto: inlining pop_the_aux_stack.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
loop
    begin                       {|pop_the_aux_stack| will exit the loop}
    incr(cur_aux_line);
    if (not input_ln(cur_aux_file)) then        {end of current \.{.aux} file}
        pop_the_aux_stack
      else
        get_aux_command_and_process;
    end;
@y
loop
    begin                       {|pop_the_aux_stack| will exit the loop}
    incr(cur_aux_line);
    if (not input_ln(cur_aux_file)) then        {end of current \.{.aux} file}
        @<Pop the aux stack@>@;
      else
        get_aux_command_and_process;
    end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KerTeX path searching.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
if (not a_open_in(cur_bib_file)) then
    begin
    add_area (s_bib_area);
    if (not a_open_in(cur_bib_file)) then
        open_bibdata_aux_err ('I couldn''t open database file ');
    end;
@y
if (not a_open_in(cur_bib_file,BIB_PATH_SPEC)) then
        open_bibdata_aux_err ('I couldn''t open database file ');
@z

@x
add_extension (s_bst_extension);
if (not a_open_in(bst_file)) then
    begin
    add_area (s_bst_area);
    if (not a_open_in(bst_file)) then
        begin
        print ('I couldn''t open style file ');
        print_bst_name;@/
        bst_str := 0;                           {mark as unused again}
        aux_err_return;
        end;
    end;
@y
add_extension (s_bst_extension);
if (not a_open_in(bst_file,BST_PATH_SPEC)) then
    begin
        print ('I couldn''t open style file ');
        print_bst_name;@/
        bst_str := 0;                           {mark as unused again}
        aux_err_return;
    end;
@z

@x
name_ptr := name_length+1;
@y
name_ptr := name_length;
@z

@x
if (not a_open_in(cur_aux_file)) then
@y
if (not a_open_in(cur_aux_file, NO_PATH_SPEC)) then
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Removing a non local goto: inlining pop_the_aux_stack.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@
Here we close the current-level \.{.aux} file and go back up a level,
if possible, by decrementing |aux_ptr|.

@<Procedures and functions for the reading and processing of input files@>=
procedure pop_the_aux_stack;
begin
a_close (cur_aux_file);
if (aux_ptr=0) then
    goto aux_done
  else
    decr(aux_ptr);
end;
@y
@
Here we close the current-level \.{.aux} file and go back up a level,
if possible, by decrementing |aux_ptr|.

@<Pop the aux stack@>=
begin
a_close (cur_aux_file);
if (aux_ptr=0) then
    goto aux_done
  else
    decr(aux_ptr);
end
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Removing a non local goto: interpolating the chunk of code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
while (last <> 0) do                    {look for a blank input line}
    if (not input_ln(bst_file)) then    {or the end of the file}
        goto bst_done
      else
        incr(bst_line_num);
@y
while (last <> 0) do                    {look for a blank input line}
    if (not input_ln(bst_file)) then    {or the end of the file}
      begin
        a_close (bst_file);
        a_close (bbl_file);
        close_up_shop;
      end
    else
      incr(bst_line_num);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ``int'' is a reserved work in C.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
This procedure takes the integer |int|, copies the appropriate
|ASCII_code| string into |int_buf| starting at |int_begin|, and sets
the |var| parameter |int_end| to the first unused |int_buf| location.
The ASCII string will consist of decimal digits, the first of which
will be not be a~0 if the integer is nonzero, with a prepended minus
sign if the integer is negative.

@<Procedures and functions for handling numbers, characters, and strings@>=
procedure int_to_ASCII (@!int:integer; var int_buf:buf_type;
                        @!int_begin:buf_pointer; var int_end:buf_pointer);
var int_ptr,@!int_xptr : buf_pointer;   {pointers into |int_buf|}
  @!int_tmp_val : ASCII_code;           {the temporary element in an exchange}
begin
int_ptr := int_begin;
if (int < 0) then       {add the |minus_sign| and use the absolute value}
    begin
    append_int_char (minus_sign);
    int := -int;
    end;
int_xptr := int_ptr;
repeat                          {copy digits into |int_buf|}
    append_int_char ("0" + (int mod 10));
    int := int div 10;
  until (int = 0);
@y
This procedure takes the integer |the_int|, copies the appropriate
|ASCII_code| string into |int_buf| starting at |int_begin|, and sets
the |var| parameter |int_end| to the first unused |int_buf| location.
The ASCII string will consist of decimal digits, the first of which
will be not be a~0 if the integer is nonzero, with a prepended minus
sign if the integer is negative.

We rename it to |pint_to_ASCII| since we need to use a \CEE/ macro in
order to take the address of the fourth parameter.

@<Procedures and functions for handling numbers, characters, and strings@>=
procedure pint_to_ASCII (@!the_int:integer; var int_buf:buf_type;
                        @!int_begin:buf_pointer; var int_end:buf_pointer);
var int_ptr,@!int_xptr : buf_pointer;   {pointers into |int_buf|}
  @!int_tmp_val : ASCII_code;           {the temporary element in an exchange}
begin
int_ptr := int_begin;
if (the_int < 0) then       {add the |minus_sign| and use the absolute value}
    begin
    append_int_char (minus_sign);
    the_int := -the_int;
    end;
int_xptr := int_ptr;
repeat                          {copy digits into |int_buf|}
    append_int_char ("0" + (the_int mod 10));
    the_int := the_int div 10;
  until (the_int = 0);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pascal idiosynchrasies: taking a C address via a C macro defined in
% bibtex.h.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
This procedure adds (or restores) to |cite_list| a cite key; it is
called only when |all_entries| is |true| or when adding
cross~references, and it assumes that |cite_loc| and |lc_cite_loc| are
set.  It also increments its argument.

@<Procedures and functions for handling numbers, characters, and strings@>=
procedure add_database_cite (var new_cite : cite_number);
@y
This procedure adds (or restores) to |cite_list| a cite key; it is
called only when |all_entries| is |true| or when adding
cross~references, and it assumes that |cite_loc| and |lc_cite_loc| are
set.  It also increments its argument.

We rename it to |padd_database_cite| since we need to go through a \CEE/
macro in order to take the address of the parameter.

@<Procedures and functions for handling numbers, characters, and strings@>=
procedure padd_database_cite (var new_cite : cite_number);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pascal idiosynchrasies: taking a C address via a C macro defined in
% bibtex.h.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
This procedure pops the stack, checking for, and trying to recover
from, stack underflow.  (Actually, this procedure is really a
function, since it returns the two values through its |var|
parameters.)  Also, if the literal being popped is a |stk_str| that's
been created during the execution of the current \.{.bst} command, pop
it from |str_pool| as well (it will be the string corresponding to
|str_ptr-1|).  Note that when this happens, the string is no longer
`officially' available so that it must be used before anything else is
added to |str_pool|.

@<Procedures and functions for style-file function execution@>=
procedure pop_lit_stk (var pop_lit:integer; var pop_type:stk_type);
@y
This procedure pops the stack, checking for, and trying to recover
from, stack underflow.  (Actually, this procedure is really a
function, since it returns the two values through its |var|
parameters.)  Also, if the literal being popped is a |stk_str| that's
been created during the execution of the current \.{.bst} command, pop
it from |str_pool| as well (it will be the string corresponding to
|str_ptr-1|).  Note that when this happens, the string is no longer
`officially' available so that it must be used before anything else is
added to |str_pool|.

We rename it to |ppop_lit_stk|, since we need to call a C macro to take
the addresses of the parameters.

@<Procedures and functions for style-file function execution@>=
procedure ppop_lit_stk (var pop_lit:integer; var pop_type:stk_type);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pascal idiosynchrasies: taking a C address via a C macro defined in
% bibtex.h.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
This procedure inserts a |built_in| function into the hash table and
initializes the corresponding pre-defined string (of length at most
|longest_pds|).  The array |fn_info| contains a number from 0 through
the number of |built_in| functions minus 1 (i.e., |num_blt_in_fns - 1|
if we're keeping statistics); this number is used by a |case|
statement to execute this function and is used for keeping execution
counts when keeping statistics.

@<Procedures and functions for handling numbers, characters, and strings@>=
procedure build_in (@!pds:pds_type; @!len:pds_len; var fn_hash_loc:hash_loc;
                                        @!blt_in_num:blt_in_range);
@y
This procedure inserts a |built_in| function into the hash table and
initializes the corresponding pre-defined string (of length at most
|longest_pds|).  The array |fn_info| contains a number from 0 through
the number of |built_in| functions minus 1 (i.e., |num_blt_in_fns - 1|
if we're keeping statistics); this number is used by a |case|
statement to execute this function and is used for keeping execution
counts when keeping statistics.

We rename it to |pbuild_in| since we need in \CEE/ to pass the address
of the third parameter.

@<Procedures and functions for handling numbers, characters, and strings@>=
procedure pbuild_in (@!pds:pds_type; @!len:pds_len; var fn_hash_loc:hash_loc;
                                        @!blt_in_num:blt_in_range);
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Turning the non local goto into a procedure call.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
This section does any last-minute printing and ends the program.

@<Clean up and leave@>=
begin
if ((read_performed) and (not reading_completed)) then
    begin
    print ('Aborted at line ',bib_line_num:0,' of file ');
    print_bib_name;
    end;
trace_and_stat_printing;
@<Print the job |history|@>;
a_close (log_file);
{turn out the lights, the fat lady has sung; it's over, Yogi}
end
@y
This procedure does any last-minute printing and ends the program.

@<Procedures and functions for all file I/O, error messages, and such@>=
procedure close_up_shop;
begin
if ((read_performed) and (not reading_completed)) then
    begin
    print ('Aborted at line ',bib_line_num:0,' of file ');
    print_bib_name;
    end;
trace_and_stat_printing;
@<Print the job |history|@>;
a_close (log_file);
{turn out the lights, the fat lady has sung; it's over, Yogi}
cexit(0);
end;
@z

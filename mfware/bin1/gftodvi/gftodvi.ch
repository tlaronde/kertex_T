% gftodvi.ch for C compilation under kerTeX.
%
% History:
%
% 2022-03-06 Thierry Laronde, print_string() fixing (supplementary
%   length parameter).
%
% 2010-04-10 Thierry Laronde, cleaning for kerTeX.
%
% 01/20/90 Karl		New gftodvi.web (same version number).
% 
% 12/02/89 Karl Berry	To version 3.
% 
% Revision 1.7.1.5  86/02/01  15:29:58  richards
% Released again for MF 1.0 package
% 
% Revision 1.7.1.4  86/02/01  15:06:50  richards
% Added: <nl> at end of successful run
% 
% Revision 1.7.1.3  86/01/27  16:39:48  richards
% Fixed: syntax error in previous edits
% 
% Revision 1.7.1.2  86/01/27  15:55:58  richards
% Added: dvi_buf_type declaration and redefined dvi_buf[] in
% 	terms of it, so we can use it as a parameter to b_write_buf()
% 
% Revision 1.7.1.1  86/01/27  15:39:10  richards
% First edit to use new binary I/O routines
% 
% Revision 1.7  85/10/21  21:55:50  richards
% Released for GFtoDVI 1.7
% 
% Revision 1.3.7.1  85/10/18  22:59:01  richards
% Updated for GFtoDVI Version 1.7 (Distributed w/ MF84 Version 0.9999)
% 
% Revision 1.3.5.1  85/10/09  17:02:35  richards
% First draft to run at 1.5 level
% 
% Revision 1.3  85/05/27  21:15:30  richards
% Updated for GFtoDVI Version 1.3 (Distributed w/ MF84 Version 0.91)
% 
% Revision 1.2  85/04/25  19:33:30  richards
% Updated to GFtoDVI Version 1.2 (Distributed w/ MF84 Version 0.81)
% 
% Revision 1.1  85/03/03  21:47:17  richards
% Updated for GF utilities distributed with MF Version 0.77
% 
% Revision 1.0  84/12/16  22:38:22  richards
% Updated for GFtoDVI Version 1.0 (New GF file format)
% 
% Revision 0.6  84/12/05  13:32:01  richards
% Updated for GFtoDVI Version 0.6; merged in changes from sdcarl!rusty
% 
% 	Note: still has BUGFIX in section 199 to keep GFtoDVI from trying
% 	to use non-existent characters in a gray font
% 
% Revision 0.3  84/11/17  23:51:56  richards
% Base version for GFtoDVI Version 0.3
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [0] WEAVE: print changes only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=\contentspagenumber \advance\pageno by 1
\let\maybe=\iffalse
\def\title{GF\lowercase{to}DVI changes for Berkeley {\mc UNIX}}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1] Change banner string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d banner=='This is GFtoDVI, Version 3.0' {printed when the program starts}
@y
@d banner=='This is GFtoDVI, kerTeX C Version 3.0'
		{printed when the program starts}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [3] Redirect output to term_out.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d print(#)==write(#)
@d print_ln(#)==write_ln(#)
@d print_nl(#)==@+begin write_ln; write(#);@+end
@y
@d term_out==stdout
@d print(#)==write(term_out, #)
@d print_ln(#)==write_ln(term_out, #)
@d print_nl(#)==@+begin write_ln(term_out); write(term_out, #);@+end
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [3] Add gftodvi_ext.h, standard input to program header
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p program GF_to_DVI(@!output);
label @<Labels in the outer block@>@/
const @<Constants in the outer block@>@/
type @<Types in the outer block@>@/
var @<Globals in the outer block@>@/
procedure initialize; {this procedure gets things started properly}
  var @!i,@!j,@!m,@!n:integer; {loop indices for initializations}
  begin print_ln(banner);@/
  @<Set initial values@>@/
  end;
@y
@p program GF_to_DVI;
const @<Constants in the outer block@>@/
type @<Types in the outer block@>@/
var @<Globals in the outer block@>@/
procedure initialize; {this procedure gets things started properly}
  var @!i,@!j,@!m,@!n:integer; {loop indices for initializations}
  begin print_ln(banner);@/
  @<Set initial values@>@/
  end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [??] Remove the final_end label.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
@ If the program has to stop prematurely, it goes to the
`|final_end|'.

@d final_end=9999 {label for the end of it all}

@<Labels...@>=final_end;
@y
@ This module deleted, since it only defined the label |final_end|.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [5] file_name_size is defined externally.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!file_name_size=50; {a file name shouldn't be longer than this}
@y
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [8] Add newline to end of abort() message, and exit abnormally.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d abort(#)==@+begin print(' ',#); jump_out;@+end
@y
@d abort(#)==@+begin print_ln(#); cexit(1);@+end
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [??] Fix jump_out to not do a nonlocal goto.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
@p procedure jump_out;
begin goto final_end;
end;
@y
@p procedure jump_out;
begin cexit(0);
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [??] The text_char type is used as an array index into xord.  The
% default type `char' produces signed integers, which are bad array
% indices in C.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
@d text_char == char {the data type of characters in text files}
@y
@d text_char == 0..255 {the data type of characters in text files}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [??] enable maximum character set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
for i:=0 to @'37 do xchr[i]:='?';
for i:=@'177 to @'377 do xchr[i]:='?';
@y
for i:=1 to @'37 do xchr[i]:=chr(i);
for i:=@'177 to @'377 do xchr[i]:=chr(i);
@z


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [15] change update_terminal to flush(), change def'n of term_in
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
Since the terminal is being used for both input and output, some systems
need a special routine to make sure that the user can see a prompt message
before waiting for input based on that message. (Otherwise the message
may just be sitting in a hidden buffer somewhere, and the user will have
no idea what the program is waiting for.) We shall call a system-dependent
subroutine |update_terminal| in order to avoid this problem.

@d update_terminal == break(output) {empty the terminal output buffer}

@<Glob...@>=
@!buffer:array[0..terminal_line_length] of 0..255;
@!term_in:text_file; {the terminal, considered as an input file}
@y
Since the terminal is being used for both input and output, some systems
need a special routine to make sure that the user can see a prompt message
before waiting for input based on that message. (Otherwise the message
may just be sitting in a hidden buffer somewhere, and the user will have
no idea what the program is waiting for.) We shall call a system-dependent
subroutine |update_terminal| in order to avoid this problem.
@^system dependencies@>

@d update_terminal == hbreak(stdout) {empty the terminal output buffer}
@d term_in == stdin {standard input}

@<Glob...@>=
@!buffer:array[0..terminal_line_length] of 0..255;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [16] Fix input_ln.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ A global variable |line_length| records the first buffer position after
the line just read.
@^system dependencies@>

@p procedure input_ln; {inputs a line from the terminal}
begin update_terminal; reset(term_in);
if eoln(term_in) then read_ln(term_in);
line_length:=0;
while (line_length<terminal_line_length)and not eoln(term_in) do
  begin buffer[line_length]:=xord[term_in^]; incr(line_length); get(term_in);
  end;
end;

@y
@ A global variable |line_length| records the first buffer position after
the line just read.
@^system dependencies@>

@p procedure input_ln; {inputs a line from the terminal}
begin update_terminal;
if eoln(term_in) then read_ln(term_in);
line_length:=0;
while (line_length<terminal_line_length)and not eoln(term_in) do
  begin buffer[line_length]:=xord[to_uchar(getc(term_in))]; incr(line_length);
  end;
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [47] Modify file open routines to match libweb.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
variable that specifies the file name.
@^system dependencies@>

@p procedure open_gf_file; {prepares to read packed bytes in |gf_file|}
begin reset(gf_file,name_of_file);
cur_loc:=0;
end;
@#
procedure open_tfm_file; {prepares to read packed bytes in |tfm_file|}
begin reset(tfm_file,name_of_file);
end;
@#
procedure open_dvi_file; {prepares to write packed bytes in |dvi_file|}
begin rewrite(dvi_file,name_of_file);
end;
@y
variable that specifies the file name.

We use the searching path routines of the external C libweb.

@p procedure open_gf_file; {prepares to read packed bytes in |gf_file|}
begin
	if not b_open_in(gf_file, GF_PATH_SPEC) then
		begin
			print_string(stdout, name_of_file, name_length);
			abort (': GF file not found.');
		end;
   cur_loc := 0;
end;
@#
procedure open_tfm_file; {prepares to read packed bytes in |tfm_file|}
begin
	if not b_open_in(tfm_file, TFM_PATH_SPEC) then
		begin
			print_string(stdout, name_of_file, name_length);
			abort (': TFM file not found.');
		end;
end;
@#
procedure open_dvi_file; {prepares to write packed bytes in |dvi_file|}
begin rewrite(dvi_file,name_of_file,name_length);
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [48] name_of_file is defined in C libweb.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!name_of_file:packed array[1..file_name_size] of char; {external file name}
@y
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [??] Fix bugs in get_n_bytes routines so they work with 16-bit math.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
get_two_bytes:=a*256+b;
@y
get_two_bytes:=a*toint(256)+b;
@z
@x
get_three_bytes:=(a*256+b)*256+c;
@y
get_three_bytes:=(a*toint(256)+b)*256+c;
@z
@x
if a<128 then signed_quad:=((a*256+b)*256+c)*256+d
else signed_quad:=(((a-256)*256+b)*256+c)*256+d;
@y
if a<128 then signed_quad:=((a*toint(256)+b)*256+c)*256+d
else signed_quad:=(((a-256)*toint(256)+b)*256+c)*256+d;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [??] The memory_word structure is too hard to translate via web2c, so
% we include a hand-coded memory.h.  Also, b0 (et al. )is used both as a field
% and as a regular variable.  web2c puts field names in the global
% symbol table, so this loses.  Rather than fix web2c (hard), we change
% the name of the field.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
@!four_quarters = packed record@;@/
  @!b0:quarterword;
  @!b1:quarterword;
  @!b2:quarterword;
  @!b3:quarterword;
  end;
@!memory_word = record@;@/
  case boolean of
  true: (@!sc:scaled);
  false: (@!qqqq:four_quarters);
  end;
@y
@\@/@=#include "memory.h";@>@\ {note the |;| so |web2c| will translate
                                types that come after this}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [??] fix 16-bit arithmetic bugs in TFM calculations.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
@ @d read_two_halves_end(#)==#:=b2*256+b3
@d read_two_halves(#)==read_tfm_word; #:=b0*256+b1; read_two_halves_end
@y
@ @d read_two_halves_end(#)==#:=b2*toint(256)+b3
@d read_two_halves(#)==read_tfm_word; #:=b0*toint(256)+b1; read_two_halves_end
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [??] more arithmetic fixes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
z:=((b0*256+b1)*256+b2)*16+(b3 div 16);
@y
z:=((b0*toint(256)+b1)*toint(256)+b2)*16+(b3 div 16);
@z
@x
      else if 256*(b2-128)+b3>=nk then abend;
@y
      else if toint(256)*(b2-128)+b3>=nk then abend;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [88] change home_font_area to null_string (b_open_in provides path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ Font metric files whose areas are not given
explicitly are assumed to appear in a standard system area called
|home_font_area|.  This system area name will, of course, vary from place
to place. The program here sets it to `\.{TeXfonts:}'.
@^system dependencies@>
@.TeXfonts@>

@<Initialize the strings@>=
l:=9; init_str9("T")("e")("X")("f")("o")("n")("t")("s")(":")(home_font_area);@/
@y
@ Font metric files whose areas are not given
explicitly are assumed to appear in a standard system area.

In kerTeX, these are set via path specifications---default value set at
compile time; but user can override via environment.
@^system dependencies@>

@<Initialize the strings@>=
l:=0; init_str0(home_font_area);@/
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [90] change more_name to understand UNIX file name paths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
else  begin if (c=">")or(c=":") then
    begin area_delimiter:=pool_ptr; ext_delimiter:=0;
    end
  else if (c=".")and(ext_delimiter=0) then ext_delimiter:=pool_ptr;
@y
else  begin if (c="/") then
    begin area_delimiter:=pool_ptr; ext_delimiter:=0;
    end
  else if c="." then ext_delimiter:=pool_ptr;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [92] name_length is global and defined externally
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!name_length:0..file_name_size; {number of characters packed}
@y
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [94] We _don't_ change start_gf to get file name from command line 
% arguments, since to do the work correctly, we will need to change
% between the characters set; to extend buffer to file_name_size (perhaps
% still restricting interactive input to terminal_line_length), to be
% sure to be consistant between C end of line and Pascal, and we need
% to set cur_name since it is used for dvi. We will see later. Let be
% correct, even if very slightly less practical (mind you: you can pipe
% the file name...)
% So just fix leading character of name_of_file (all 0's since C global
% but Pascal starts writing at 1, so C won't see anything; and
% printing string.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p procedure start_gf;
label found,done;
begin loop@+begin print_nl('GF file name: '); input_ln;
@y
@p procedure start_gf;
label found,done;
begin 
if (argc > 1) then abort('Usage: gftodvi');
loop@+begin print_nl('GF file name: '); input_ln;
@z

@x
    print_nl('Oops... I can''t find file '); print(name_of_file);
@.Oops...@>
@.I can't find...@>
@y
    print_nl('Oops... I can''t find file ');
    print_string(stdout, name_of_file, name_length);
@.Oops...@>
@.I can't find...@>
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [107] write_dvi is defined via a C macro.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p procedure write_dvi(@!a,@!b:dvi_index);
var k:dvi_index;
begin for k:=a to b do write(dvi_file,dvi_buf[k]);
end;
@y
In C, |write_dvi| is defined as macro which does an |fwrite| library
call.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [??] don't go to final_end, just exit.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
goto final_end;
@y
cexit(0);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [??] write_ln formatting.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
  begin print_nl('Sorry, I can''t make diagonal rules of slant ',r:10:5,'!');
@y
  begin print_nl('Sorry, I can''t make diagonal rules of slant ');
        print_real(stdout, r,10,5); print('!');
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [??] call set_paths before gf_start to initialize paths.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
start_gf; {open the input and output files}
@y
set_paths(FONTS_PATHS_SET);  {initialize paths for \.{TFM} files from environment if needed}
start_gf; {open the input and output files}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [217] Label final_end has to be suppressed.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
  cur_gf:=get_byte; str_ptr:=init_str_ptr; pool_ptr:=str_start[str_ptr];
  end;
final_end:end.
@y
  cur_gf:=get_byte; str_ptr:=init_str_ptr; pool_ptr:=str_start[str_ptr];
  end;
end.
@z


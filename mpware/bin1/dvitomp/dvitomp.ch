% Copyright 1990 - 1995 by AT&T Bell Laboratories.

% Permission to use, copy, modify, and distribute this software
% and its documentation for any purpose and without fee is hereby
% granted, provided that the above copyright notice appear in all
% copies and that both that the copyright notice and this
% permission notice and warranty disclaimer appear in supporting
% documentation, and that the names of AT&T Bell Laboratories or
% any of its entities not be used in advertising or publicity
% pertaining to distribution of the software without specific,
% written prior permission.

% AT&T disclaims all warranties with regard to this software,
% including all implied warranties of merchantability and fitness.
% In no event shall AT&T be liable for any special, indirect or
% consequential damages or any damages whatsoever resulting from
% loss of use, data or profits, whether in an action of contract,
% negligence or other tortious action, arising out of or in
% connection with the use or performance of this software.

%   Change file for the DVItype processor, for use with WEB to C
%   This file was created by John Hobby.  It is loosely based on the
%   change file for the WEB to C version of dvitype (due to Howard
%   Trickey and Pavel Curtis).

% History:
%   3/11/90  (JDH) Original version.
%   4/30/90  (JDH) Update to handle virtual fonts
%   4/16/93  (JDH) Make output go to standard output and require mpx file
%		to be a command line argument.
%	20110424	Adapted for kerTeX by Thierry Laronde
%   2022-03-03 (TL) argfmt modification for spaces handling.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WEAVE: print changes only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=\contentspagenumber \advance\pageno by 1
\let\maybe=\iffalse
\def\title{DVI$\,$\lowercase{type} changes for C}
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change banner string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d banner=='% Written by DVItoMP, Version 0.64'
@y
@d banner=='% Written by dvitomp, kerTeX C Version 0.64'
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change filenames in program statement
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p program DVI_to_MP(@!dvi_file,@!mpx_file,@!output);
@y
@p program DVI_to_MP;
@z

@x
  begin @<Set initial values@>@/
@y
  begin setpaths(FONTSPATHSSET); {read environment, to find TEXFONTS, if there}
  @<Set initial values@>@/
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% name_length is defined externally and used with name_of_file. Rename
% it to file_name_size that is defined externally i.e. don't declare it.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!name_length=50; {a file name shouldn't be longer than this}
@y
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove non-local goto
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
Such errors might be discovered inside of subroutines inside of subroutines,
so a procedure called |jump_out| has been introduced. This procedure, which
simply transfers control to the label |final_end| at the end of the program,
contains the only non-local |goto| statement in \.{DVItoMP}.
@^system dependencies@>

@d abort(#)==begin err_print_ln('DVItoMP abort: ',#);
    history:=fatal_error; jump_out;
    end
@d bad_dvi(#)==abort('Bad DVI file: ',#,'!')
@.Bad DVI file@>
@d warn(#)==begin err_print_ln('DVItoMP warning: ',#);
    history:=warning_given;
    end

@p procedure jump_out;
begin goto final_end;
end;
@y
Such errors might be discovered inside of subroutines inside of subroutines,
so a procedure called |jump_out| has been introduced. This procedure is
actually just a macro that calls |exit()| with non-zero exit status.
@^system dependencies@>

@d jump_out==cexit(history)
@d abort(#)==begin err_print_ln('dvitomp abort: ',#);
    history:=fatal_error; jump_out;
    end
@d bad_dvi(#)==abort('Bad DVI file: ',#,'!')
@.Bad DVI file@>
@d warn(#)==begin err_print_ln('dvitomp warning: ',#);
    history:=warning_given;
    end
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fix up opening of files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ To prepare the |mpx_file| for output, we |rewrite| it.
@^system dependencies@>

@p procedure open_mpx_file; {prepares to write text on |mpx_file|}
begin rewrite(mpx_file);
end;
@y
@ To prepare the |mpx_file| for output, we |rewrite| it.
In C we retrieve the file name from the command line and use the kerTeX
library routines.

This procedure takes the file name from the global variable
|name_of_file|.  It has two other arguments that we shall use later on
to control path searching for input files.
@^system dependencies@>

@p procedure test_usage;
begin if argc<>3 then
  begin err_print_ln('Usage: dvitomp <dvi-file> <mpx-file>');
  jump_out;
  end;
end;
@#
procedure open_mpx_file; {prepares to write text on |mpx_file|}
begin test_usage;
argfmt(2);
if not b_open_out(mpx_file) then
	begin
		abort('MPX not writable.');
	end;
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fix up opening the binary files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
specifies the file name. If |eof(f)| is true immediately after |reset(f,s)|
has acted, these routines assume that no file named |s| is accessible.
@^system dependencies@>

@p procedure open_dvi_file; {prepares to read packed bytes in |dvi_file|}
begin reset(dvi_file);
if eof(dvi_file) then abort('DVI file not found');
end;
@#
function open_tfm_file:boolean; {prepares to read packed bytes in |tfm_file|}
begin reset(tfm_file,cur_name);
open_tfm_file:=(not eof(tfm_file));
end;
@#
function open_vf_file:boolean; {prepares to read packed bytes in |vf_file|}
begin reset(vf_file,cur_name);
open_vf_file:=(not eof(vf_file));
end;
@y
specifies the file name.  In C, we use the kerTeX libweb routines.
@^system dependencies@>

@p procedure open_dvi_file; {prepares to read packed bytes in |dvi_file|}
begin test_usage;
    argfmt(1);
	if not b_open_in(dvi_file, NO_PATH_SPEC) then
		begin
			abort('DVI file not found.');
		end;
end;
@#
function open_tfm_file:boolean; {prepares to read packed bytes in |tfm_file|}
begin 
	open_tfm_file:=b_open_in(tfm_file, TFM_PATH_SPEC);
end;
@#
function open_vf_file:boolean; {prepares to read packed bytes in |vf_file|}
begin
	open_vf_file:=b_open_in(vf_file, TFM_PATH_SPEC);
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adjust declarations for name_of_file etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
variable: |cur_name| is a string variable that will be set to the
current font metric file name before |open_tfm_file| is called.

@<Glob...@>=
@!cur_name:packed array[1..name_length] of char; {external name,
  with no lower case letters}
@y
variable: |name_of_file| is a string variable, with defined portion
starting at index $1$ and whose length is defined in |name_length|,
that will be set to the current font metric file name before
|open_tfm_file| is called.
In C, we also have a |real_name_of_file| string, that gets
set by the external library routine doing path searching from the
pathname found with |real_name_length| being the defined length. All
are externally defined.

@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change the program name to match dvitomp.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d font_warn(#)==begin err_print('DVItoMP warning: ',#); font_warn_end
@d font_warn_end(#)==err_print_font(#);
    history:=warning_given;
    end
@d font_abort(#)==begin err_print('DVItoMP abort: ',#); font_abort_end
@y
@d font_warn(#)==begin err_print('dvitomp warning: ',#); font_warn_end
@d font_warn_end(#)==err_print_font(#);
    history:=warning_given;
    end
@d font_abort(#)==begin err_print('dvitomp abort: ',#); font_abort_end
@z

@x
begin if nf=max_fonts then abort('DVItoMP capacity exceeded (max fonts=',
@y
begin if nf=max_fonts then abort('dvitomp capacity exceeded (max fonts=',
@z

@x
if font_name[nf]+n>name_size then
  abort('DVItoMP capacity exceeded (name size=',name_size:1,')!');
@y
if font_name[nf]+n>name_size then
  abort('dvitomp capacity exceeded (name size=',name_size:1,')!');
@z

@x
if vf_ptr=nf then abort('DVItoMP capacity exceeded (max font numbers=',
    max_fnums:1,')');
@y
if vf_ptr=nf then abort('dvitomp capacity exceeded (max font numbers=',
    max_fnums:1,')');
@z

@x
if c>=limit then
  abort('DVItoMP capacity exceeded (max widths=', max_widths:1,')!');
@y
if c>=limit then
  abort('dvitomp capacity exceeded (max widths=', max_widths:1,')!');
@z

@x
if n_cmds+p>=virtual_space then
  abort('DVItoMP capacity exceeded (virtual font space=',virtual_space:1,')!');
@y
if n_cmds+p>=virtual_space then
  abort('dvitomp capacity exceeded (virtual font space=',virtual_space:1,')!');
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set default_directory_name
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d default_directory_name=='TeXfonts:' {change this to the correct name}
@d default_directory_name_length=9 {change this to the correct length}

@<Glob...@>=
@!default_directory:packed array[1..default_directory_name_length] of char;
@y
In kerTeX, the searching routines are shared and defined in libweb.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove initialization of now-defunct array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ @<Set init...@>=
default_directory:=default_directory_name;
@y
@ (No initialization to be done.  Keep this module to preserve numbering.)
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fix addition of ".vf" suffix for portability and keep lowercase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ The string |cur_name| is supposed to be set to the external name of the
\.{VF} file for the current font. This usually means that we need to
prepend the name of the default directory, and
to append the suffix `\.{.VF}'. Furthermore, we change lower case letters
to upper case, since |cur_name| is a \PASCAL\ string.
@y
@ The string |name_of_file| is supposed to be set to the external name of the
\.{VF} file for the current font. This usually means that we need to,
at most sites, append the
suffix ``.vf''.
@z

@x
for k:=1 to name_length do cur_name[k]:=' ';
if area_length[f]=0 then
  begin for k:=1 to default_directory_name_length do
    cur_name[k]:=default_directory[k];
  l:=default_directory_name_length;
  end
else l:=0;
@y
name_length:=0;
l:=0;
@z

@x
  if l+3>name_length then
    abort('DVItoMP capacity exceeded (max font name length=',
      name_length:1,')!');
@.DVItoMP capacity exceeded...@>
  if (names[k]>="a")and(names[k]<="z") then
      cur_name[l]:=xchr[names[k]-@'40]
  else cur_name[l]:=xchr[names[k]];
  end;
cur_name[l+1]:='.'; cur_name[l+2]:='V'; cur_name[l+3]:='F'
@y
  if l+3>file_name_size then
    abort('dvitomp capacity exceeded (max font name length=',
      file_name_size:1,')!');
@.DVItoMP capacity exceeded...@>
  name_of_file[l]:=xchr[names[k]];
  end;
name_of_file[l+1]:='.'; name_of_file[l+2]:='v'; name_of_file[l+3]:='f';
name_length:=l+3
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fix the changing of ".vf" to ".tfm" analogously
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
l:=area_length[f];
if l=0 then l:=default_directory_name_length;
l:=l+font_name[f+1]-font_name[f];
@y
l:=font_name[f+1]-font_name[f]; {we don't use area_length}
@z

@x
if l+4>name_length then
  abort('DVItoMP capacity exceeded (max font name length=',
    name_length:1,')!');
@.DVItoMP capacity exceeded...@>
cur_name[l+2]:='T'; cur_name[l+3]:='F'; cur_name[l+4]:='M'
@y
if l+4>file_name_size then
  abort('dvitomp capacity exceeded (max font name length=',
    file_name_size:1,')!');
@.DVItoMP capacity exceeded...@>
name_of_file[l+2]:='t'; name_of_file[l+3]:='f'; name_of_file[l+4]:='m';
name_length:=l+4
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change program name to match dvitomp. (more)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
  begin err_print('DVItoMP warning: Checksum mismatch for ');
@y
  begin err_print('dvitomp warning: Checksum mismatch for ');
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fix printing of real numbers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
  if (abs(x)>=4096.0)or(abs(y)>=4096.0)or(m>=4096.0)or(m<0) then
    begin warn('text scaled ',m:1:1,@|
        ' at (',x:1:1,',',y:1:1,') is out of range');
    end_char_string(60);
    end
  else end_char_string(40);
  print_ln(',_n',str_f:1,',',m:1:5,',',x:1:4,',',y:1:4,');');
@y
  if (abs(x)>=4096.0)or(abs(y)>=4096.0)or(m>=4096.0)or(m<0) then
    begin warn('text is out of range');
    end_char_string(60);
    end
  else end_char_string(40);
  print(',_n',str_f:1,',');
  print_real(mpxfile,m,1,5); print(',');
  print_real(mpxfile,x,1,4); print(',');
  print_real(mpxfile,y,1,4);
  print_ln(');');
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Another fix for printing of real numbers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
  if (abs(xx1)>=4096.0)or(abs(yy1)>=4096.0)or@|
      (abs(xx2)>=4096.0)or(abs(yy2)>=4096.0)or(ww>=4096.0) then
    warn('hrule or vrule near (',xx1:1:1,',',yy1:1:1,') is out of range');
  print_ln('_r((',xx1:1:4,',',yy1:1:4,')..(',xx2:1:4,',',yy2:1:4,
      '), ',ww:1:4,');');
@y
  if (abs(xx1)>=4096.0)or(abs(yy1)>=4096.0)or@|
      (abs(xx2)>=4096.0)or(abs(yy2)>=4096.0)or(ww>=4096.0) then
    warn('hrule or vrule is out of range');
  print('_r((');
  print_real(mpxfile,xx1,1,4); print(',');
  print_real(mpxfile,yy1,1,4); print(')..(');
  print_real(mpxfile,xx2,1,4); print(',');
  print_real(mpxfile,yy2,1,4); print('), ');
  print_real(mpxfile,ww,1,4);
  print_ln(');');
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Yet another fix for printing of real numbers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
print_ln('setbounds _p to (0,',dd:1:4,')--(',w:1:4,',',dd:1:4,')--');
print_ln(' (',w:1:4,',',h:1:4,')--(0,',h:1:4,')--cycle;')
@y
print('setbounds _p to (0,');
print_real(mpxfile,dd,1,4); print(')--(');
print_real(mpxfile,w,1,4);  print(',');
print_real(mpxfile,dd,1,4); print_ln(')--');@/
print(' (');
print_real(mpxfile,w,1,4);  print(',');
print_real(mpxfile,h,1,4);  print(')--(0,');
print_real(mpxfile,h,1,4);  print_ln(')--cycle;')
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change program name to match dvitomp. (more)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
begin if stk_siz=stack_size then
      abort('DVItoMP capacity exceeded (stack size=',stack_size:1,')');
@y
begin if stk_siz=stack_size then
      abort('dvitomp capacity exceeded (stack size=',stack_size:1,')');
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove unused label at end of program and exit() based on history
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
final_end:end.
@y
if history<=cksum_trouble then cexit(0)
else cexit(history);
end.
@z

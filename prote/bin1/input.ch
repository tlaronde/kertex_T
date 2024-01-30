% This is the change file to add two more ways of specifying a filename
% in addition to the traditional space tokenizing way.
%
% Copyright 2022, Thierry LARONDE <tlaronde@polynum.com>
% kerTeX Public Licence 1.0
%
% 2022-10-27: incorrect first assignment of input_token (25.376).
%   Spotted by Martin Ruckert.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [24.333] Keep the eqtb of input in a variable since start_input
% can be started before scanning and setting cur_cs.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [25.376] Keep the eqtb of input in a variable since start_input
% can be started before scanning and setting cur_cs.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
primitive("input",input,0);@/
@!@:input_}{\.{\\input} primitive@>
@y
primitive("input",input,0);@/
@!@:input_}{\.{\\input} primitive@>
input_loc:=cur_val; input_token:=cs_token_flag+input_loc;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [29.516] Allow to use another delimiter than space for more_name.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [29.526] Removing double quotes (allowing to bypass space tokenization
% and adding the general text specification of a file name.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
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

@x
  if not more_name(cur_chr) then goto done;
  get_x_token;
@y
  if not more_name(cur_chr,d) then goto done;
  get_x_token;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [29.530] Allow the use of double quotes when prompting for a file
% name.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [29.531] Still: Allow the use of double quotes when prompting for a
% file name.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [50.1313] Dumping input_loc and input_token.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
dump_int(par_loc); dump_int(write_loc);@/
@y
dump_int(par_loc); dump_int(write_loc);@/
dump_int(input_loc);@/
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [50.1314] Undumping input_loc and setting input_token.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
undump(hash_base)(frozen_control_sequence)(write_loc);@/
@y
undump(hash_base)(frozen_control_sequence)(write_loc);@/
undump(hash_base)(frozen_control_sequence)(input_loc);
input_token:=cs_token_flag+input_loc;@/
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [54] The special handling of a file name as a general text 
% argument to scan_file_name.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ More implementation modifications can come after this.
@y
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


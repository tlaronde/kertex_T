% pltotf.ch for C compilation under kerTeX.
% 
% The original version of this file was created by Pavel Curtis.
%
% History:
% 04/04/83 (PC)  Original version, made to work with version 1.2 of PLtoTF.
% 04/16/83 (PC)  Brought up to version 1.3 of PLtoTF.
% 06/30/83 (HWT) Revised changefile format for version 1.7 Tangle
% 07/28/83 (HWT) Brought up to version 2
% 12/19/86 (ETM) Brought up to version 2.1
% 07/05/87 (ETM) Brought up to version 2.3
% 03/22/88 (ETM) Converted for use with WEB to C
% 11/29/89 (KB)  Version 3.
% 01/16/90 (SR)  Version 3.2.
% 2010-04-08 (TL) Version 3.5 and cleaning for kerTeX.
% 2022-03-05 (TL) argfmt, reset and rewrite modifications for spaces
%   handling.
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [0] WEAVE: print changes only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=\contentspagenumber \advance\pageno by 1
\let\maybe=\iffalse
\def\title{PLTOTF changes for C}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1] Change banner string.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d banner=='This is PLtoTF, Version 3.6' {printed when the program starts}
@y
@d banner=='This is PLtoTF, kerTeX C Version 3.6'
		{printed when the program starts}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [2] Entry point: arguments will be handled the C main() way.
% Furthermore, redefine index so there is no conflict with not C89 but
% sometimes included via strings.h in string.h index() routine.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p program PLtoTF(@!pl_file,@!tfm_file,@!output);
@y
@d index==idx {index() is not C89, but sometimes string.h includes strings.h}

@p program PLtoTF;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [3] Larger constants.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!max_kerns=500; {the maximum number of distinct kern values}
@!hash_size=5003; {preferably a prime number, a bit larger than the number
  of character pairs in lig/kern steps}
@y
@!max_kerns=10000; {the maximum number of distinct kern values}
@!hash_size=15077; {preferably a prime number, a bit larger than the number
  of character pairs in lig/kern steps}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [4] incr() and decr() are C defined macros in libweb header.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ Here are some macros for common programming idioms.

@d incr(#) == #:=#+1 {increase a variable by unity}
@d decr(#) == #:=#-1 {decrease a variable by unity}
@d do_nothing == {empty statement}
@y
@ Here are some macros for common programming idioms.

@d do_nothing == {empty statement}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [6] Open PL file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
reset(pl_file);
@y
if argc < 3 then begin
    print_ln('Usage: pltotf <property list file> <tfm file>.');
    cexit(1);
end;
argfmt(1);
reset(pl_file, name_of_file, name_length);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [16] Open TFM file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ On some systems you may have to do something special to write a
packed file of bytes. For example, the following code didn't work
when it was first tried at Stanford, because packed files have to be
opened with a special switch setting on the \PASCAL\ that was used.
@^system dependencies@>

@<Set init...@>=
rewrite(tfm_file);
@y
@ On some systems you may have to do something special to write a
packed file of bytes with Pascal.  It's no problem in C.
@^system dependencies@>

@<Set init...@>=
argfmt(2);
rewrite(tfm_file, name_of_file, name_length);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [22] Used unsigned bytes as chars used as subscripts in arrays.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!buffer:array[1..buf_size] of char;
@y
@!buffer:array[1..buf_size] of 0..255;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [36] Name space pollution: name_length is defined externally and used
% with name_of_file. Rename the variable here to be cur_name_length.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!name_length:0..longest_name; {its length}
@y
@!cur_name_length:0..longest_name; {its length}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [40] name_length -> cur_name_length
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
  else  begin j:=start[nhash[cur_hash]];
    if start[nhash[cur_hash]+1]=j+name_length then
      begin not_found:=false;
      for k:=1 to name_length do
      if dictionary[j+k-1]<>cur_name[k] then not_found:=true;
      end;
@y
  else  begin j:=start[nhash[cur_hash]];
    if start[nhash[cur_hash]+1]=j+cur_name_length then
      begin not_found:=false;
      for k:=1 to cur_name_length do
      if dictionary[j+k-1]<>cur_name[k] then not_found:=true;
      end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [41] name_length -> cur_name_length
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
for k:=2 to name_length do
  cur_hash:=(cur_hash+cur_hash+cur_name[k]) mod hash_prime
@y
for k:=2 to cur_name_length do
  cur_hash:=(cur_hash+cur_hash+cur_name[k]) mod hash_prime
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [43] name_length -> cur_name_length
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
begin for k:=1 to name_length do
  cur_name[k]:=cur_name[k+longest_name-name_length];
@y
begin for k:=1 to cur_name_length do
  cur_name[k]:=cur_name[k+longest_name-cur_name_length];
@z

@x
for k:=1 to name_length do
  begin dictionary[dict_ptr]:=cur_name[k]; incr(dict_ptr);
  end;
@y
for k:=1 to cur_name_length do
  begin dictionary[dict_ptr]:=cur_name[k]; incr(dict_ptr);
  end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [44] name_length -> cur_name_length
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d load3==name_length:=3;t18
@d load4==name_length:=4;t17
@d load5==name_length:=5;t16
@d load6==name_length:=6;t15
@d load7==name_length:=7;t14
@d load8==name_length:=8;t13
@d load9==name_length:=9;t12
@d load10==name_length:=10;t11
@d load11==name_length:=11;t10
@d load12==name_length:=12;t9
@d load13==name_length:=13;t8
@d load14==name_length:=14;t7
@d load15==name_length:=15;t6
@d load16==name_length:=16;t5
@d load17==name_length:=17;t4
@d load18==name_length:=18;t3
@d load19==name_length:=19;t2
@d load20==name_length:=20;t1
@y
@d load3==cur_name_length:=3;t18
@d load4==cur_name_length:=4;t17
@d load5==cur_name_length:=5;t16
@d load6==cur_name_length:=6;t15
@d load7==cur_name_length:=7;t14
@d load8==cur_name_length:=8;t13
@d load9==cur_name_length:=9;t12
@d load10==cur_name_length:=10;t11
@d load11==cur_name_length:=11;t10
@d load12==cur_name_length:=12;t9
@d load13==cur_name_length:=13;t8
@d load14==cur_name_length:=14;t7
@d load15==cur_name_length:=15;t6
@d load16==cur_name_length:=16;t5
@d load17==cur_name_length:=17;t4
@d load18==cur_name_length:=18;t3
@d load19==cur_name_length:=19;t2
@d load20==cur_name_length:=20;t1
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [47] name_length -> cur_name_length
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
name_length:=0; get_keyword_char; {prepare to scan the name}
while cur_char<>" " do
  begin if name_length=longest_name then cur_name[1]:="X" {force error}
  else incr(name_length);
  cur_name[name_length]:=cur_char;
  get_keyword_char;
  end;
@y
cur_name_length:=0; get_keyword_char; {prepare to scan the name}
while cur_char<>" " do
  begin if cur_name_length=longest_name then cur_name[1]:="X" {force error}
  else incr(cur_name_length);
  cur_name[cur_name_length]:=cur_char;
  get_keyword_char;
  end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [115] Output of reals.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ @d round_message(#)==if delta>0 then print_ln('I had to round some ',
@.I had to round...@>
  #,'s by ',(((delta+1) div 2)/@'4000000):1:7,' units.')
@y
@ @d round_message(#)==if delta>0 then begin print('I had to round some ',
@.I had to round...@>
  #,'s by '); print_real(stdout,(((delta+1) div 2)/@'4000000),1,7);
  print_ln(' units.'); end
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [123] pp2rc can't handle these mutually recursive procedures.
% But let's do a fake definition of f here, so that it gets into pp2rc's
% symbol table...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
@p function f(@!h,@!x,@!y:indx):indx; forward;@t\2@>
  {compute $f$ for arguments known to be in |hash[h]|}
@y
@p 
ifdef('notdef') 
function f(@!h,@!x,@!y:indx):indx; begin end;@t\2@>
  {compute $f$ for arguments known to be in |hash[h]|}
endif('notdef')
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [124] ... and then really define it now.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
@p function f;
@y
@p function f(@!h,@!x,@!y:indx):indx; 
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [127] Fix up output of bytes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d out(#)==write(tfm_file,#)
@y
@d out(#)==putbyte(#,tfm_file)
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [136] Fix output of reals.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p procedure out_scaled(x:fix_word); {outputs a scaled |fix_word|}
var @!n:byte; {the first byte after the sign}
@!m:0..65535; {the two least significant bytes}
begin if abs(x/design_units)>=16.0 then
  begin print_ln('The relative dimension ',x/@'4000000:1:3,
    ' is too large.');
@.The relative dimension...@>
  print('  (Must be less than 16*designsize');
  if design_units<>unity then print(' =',design_units/@'200000:1:3,
      ' designunits');
@y
@p procedure out_scaled(x:fix_word); {outputs a scaled |fix_word|}
var @!n:byte; {the first byte after the sign}
@!m:0..65535; {the two least significant bytes}
begin if fabs(x/design_units)>=16.0 then
  begin print('The relative dimension ');
    print_real(stdout,x/@'4000000,1,3);
    print_ln(' is too large.');
@.The relative dimension...@>
  print('  (Must be less than 16*designsize');
  if design_units<>unity then begin print(' =');
	print_real(stdout,design_units/@'200000,1,3);
	print(' designunits');
  end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [141] char_remainder[c] is unsigned, and label_table[sort_ptr].rr
% might be -1, and if -1 is coerced to being unsigned, it will be bigger
% than anything else.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
  while label_table[sort_ptr].rr>char_remainder[c] do
@y
  while label_table[sort_ptr].rr>toint(char_remainder[c]) do
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [147] Print newline at end of program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
end.
@y
print_ln(' '); end.
@z

% tftopl.ch for C compilation under kerTeX.
% 
% The original version of this file was created by Pavel Curtis.
%
% History:
% 04/04/83 (PC)  Original version, made to work with version 1.0 of TFtoPL,
%                released with version 0.96 of TeX in February, 1983.
% 04/16/83 (PC)  Brought up to version 1.0 released with version 0.97 of TeX
%                in April, 1983.
% 06/30/83 (HWT) Revised changefile format, for use with version 1.7 Tangle.
% 07/28/83 (HWT) Brought up to version 2
% 11/21/83 (HWT) Brought up to version 2.1
% 03/24/84 (HWT) Brought up to version 2.2
% 07/12/84 (HWT) Brought up to version 2.3
% 07/05/87 (ETM) Brought up to version 2.5
% 03/22/88 (ETM) Converted for use with WEB to C.
% 11/30/89 (KB)  Version 3.
% 01/16/90 (SR)  Version 3.1.
% 2010-04-08 (TL) Version 3.2 and cleaning for kerTeX.
% 2017-03-26 (TL) Fixing Pascal/C string/array copy ('/0' overflow).
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
\def\title{TF\lowercase{to}PL changes for C}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1] Change banner string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d banner=='This is TFtoPL, Version 3.3' {printed when the program starts}
@y
@d banner=='This is TFtoPL, kerTeX C Version 3.3'
	{printed when the program starts}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [2] Entry point: the arguments will be set the C main() way.
% Furthermore, redefine index so there is no conflict with not C89 but
% sometimes included via strings.h in string.h index() routine.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d print_ln(#)==write_ln(#)

@p program TFtoPL(@!tfm_file,@!pl_file,@!output);
@y
@d print_ln(#)==write_ln(#)
@d index==idx {index() is not C89, but sometimes string.h includes strings.h}

@p program TFtoPL;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [5] incr() and decr() are macros defined by libweb C header.
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [6] Declare tfm_name as unsigned bytes array.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!tfm_file:packed file of 0..255;
@y
@!tfm_file:packed file of 0..255;
@!tfm_name:packed array [1..file_name_size] of 0..255;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [7] Open the TFM file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ On some systems you may have to do something special to read a
packed file of bytes. For example, the following code didn't work
when it was first tried at Stanford, because packed files have to be
opened with a special switch setting on the \PASCAL\ that was used.
@^system dependencies@>

@<Set init...@>=
reset(tfm_file);
@y
@ On some systems you may have to do something special to read a
packed file of bytes.  With C under Unix, we just open the file by name
and read characters from it.

@<Set init...@>=
if argc < 3 then begin
    print_ln('Usage: tftopl <tfm file> <property list file>.');
    cexit(1);
end;
argfmt(1);
reset(tfm_file, name_of_file, name_length);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [17] Open PL file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ @<Set init...@>=
rewrite(pl_file);
@y
@ @<Set init...@>=
argfmt(2);
rewrite(pl_file, name_of_file, name_length);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [28] We can't assign a constant string after definition in C. So
% we copy. Pp2rc will add one to the size of the buffer so the indices
% are OK, but these are not C strings but a defined length array: we
% do not copy the final '\0' (which would overflow the array). [TL]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
ASCII_04:=' !"#$%&''()*+,-./0123456789:;<=>?';@/
ASCII_10:='@@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';@/
ASCII_14:='`abcdefghijklmnopqrstuvwxyz{|}~ ';@/
MBL_string:='MBL'; RI_string:='RI '; RCE_string:='RCE';
@y
vstrncpy(ASCII_04 + 1, ' !"#$%&''()*+,-./0123456789:;<=>?', 32);@/
vstrncpy(ASCII_10 + 1, '@@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_', 32);@/
vstrncpy(ASCII_14 + 1, '`abcdefghijklmnopqrstuvwxyz{|}~ ', 32);@/
vstrncpy(MBL_string + 1, 'MBL', 3);
vstrncpy(RI_string + 1, 'RI ', 3);
vstrncpy(RCE_string + 1, 'RCE', 3);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [39] Don't output the face code as an integer.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
  out(MBL_string[1+(b mod 3)]);
  out(RI_string[1+s]);
  out(RCE_string[1+(b div 3)]);
@y
  put_byte(MBL_string[1+(b mod 3)], pl_file);
  put_byte(RI_string[1+s], pl_file);
  put_byte(RCE_string[1+(b div 3)], pl_file);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [40] Force 32-bit constant arithmetic for 16-bit machines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
f:=((tfm[k+1] mod 16)*@'400+tfm[k+2])*@'400+tfm[k+3];
@y
f:=((tfm[k+1] mod 16)*toint(@'400)+tfm[k+2])*@'400+tfm[k+3];
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [90] Change name of the function `f'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
     r:=f(r,(hash[r]-1)div 256,(hash[r]-1)mod 256);
@y
     r:=f_fn(r,(hash[r]-1)div 256,(hash[r]-1)mod 256);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [94] pp2rc can't handle these mutually recursive procedures.
% But let's do a fake definition of f here, so that it gets into pp2rc's
% symbol table. We also have to change the name, because pp2rc(1)
% doesn't handle scope and type difference for same name id.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p function f(@!h,@!x,@!y:index):index; forward;@t\2@>
  {compute $f$ for arguments known to be in |hash[h]|}
@y
@p 
ifdef('notdef') 
function f_fn(@!h,@!x,@!y:index):index; begin end;@t\2@>
  {compute $f$ for arguments known to be in |hash[h]|}
endif('notdef')
@z
@x
else eval:=f(h,x,y);
@y
else eval:=f_fn(h,x,y);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [95] The real definition of f.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
@p function f;
@y
@p function f_fn(@!h,@!x,@!y:index):index; 
@z
@x
f:=lig_z[h];
@y
f_fn:=lig_z[h];
@z


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [99] Add printing of newline at end of program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
final_end:end.
@y
final_end:print_ln(' '); end.
@z

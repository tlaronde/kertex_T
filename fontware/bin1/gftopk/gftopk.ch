% gftopk.ch for C compilation under kerTeX.
%
% 09/19/88 Pierre A. MacKay	Version 1.4.
% 12/02/89 Karl Berry		2.1.
% 01/20/90 Karl			2.2.
% 2010-04-10 Thierry Laronde, Version 2.3 and cleaning for kerTeX.
% 2017-03-26 Thierry Laronde, fix for Pascal/C array copy.
% 2022-03-05 (TL) argfmt and rewrite modifications for spaces handling.
% 
% One major change in output format is incorporated by this change
% file.  The local gftopk preamble comment is ignored and the 
% dated METAFONT comment is passed through unaltered.  This
% provides a continuous check on the origin of fonts in both
% gf and pk formats.  The program runs silently unless it is given the
% -v switch in the command line.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [0] WEAVE: print changes only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
\pageno=\contentspagenumber \advance\pageno by 1
@y
\pageno=\contentspagenumber \advance\pageno by 1
\let\maybe=\iffalse
\def\title{GF$\,$\lowercase{to}$\,$PK changes C}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1] Change banner string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d banner=='This is GFtoPK, Version 2.4' {printed when the program starts}
@y
@d banner=='This is GFtoPK, kerTeX C Version 2.4'
		{printed when the program starts}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [4] Entry: arguments will be handled a la C main() way, and we will
% do path searching.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ The binary input comes from |gf_file|, and the output font is written
on |pk_file|.  All text output is written on \PASCAL's standard |output|
file.  The term |print| is used instead of |write| when this program writes
on |output|, so that all such output could easily be redirected if desired.

@d print(#)==write(#)
@d print_ln(#)==write_ln(#)

@p program GFtoPK(@!gf_file,@!pk_file,@!output);
label @<Labels in the outer block@>@/
const @<Constants in the outer block@>@/
type @<Types in the outer block@>@/
var @<Globals in the outer block@>@/
procedure initialize; {this procedure gets things started properly}
  var i:integer; {loop index for initializations}
  begin print_ln(banner);@/
  @<Set initial values@>@/
  end;
@y
@ The binary input comes from |gf_file|, and the output font is written
on |pk_file|.  All text output is written on \PASCAL's standard |output|
file.  The term |print| is used instead of |write| when this program writes
on |output|, so that all such output could easily be redirected if desired.
Since the terminal output is really not very interesting, it is
produced only when the \.{-v} command line flag is presented.

@d term_out==stdout {standard output}
@d print(#)==if verbose then write(term_out, #)
@d print_ln(#)==if verbose then write_ln(term_out, #)

@p program GFtoPK;
const @<Constants in the outer block@>@/
type @<Types in the outer block@>@/
var @<Globals in the outer block@>@/
procedure initialize; {this procedure gets things started properly}
  var i:integer; {loop index for initializations}
  begin 
  setpaths(FONTS_PATHS_SET);@/
  @<Set initial values@>;@/
  end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [5] Eliminate the |final_end| label
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ If the program has to stop prematurely, it goes to the
`|final_end|'.

@d final_end=9999 {label for the end of it all}

@<Labels...@>=final_end;
@y
@ This module is deleted, because it is only useful for
a non-local goto, which we don't use in C.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [7] Let the macros be defined obviously by C header.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ Here are some macros for common programming idioms.

@d incr(#) == #:=#+1 {increase a variable by unity}
@d decr(#) == #:=#-1 {decrease a variable by unity}
@y
@ The |incr| and |decr| macros are obviously traducted by macro
definitions in C.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [8] have abort() add <nl> to end of msg and eliminate non-local goto
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d abort(#)==begin print(' ',#); jump_out;
    end
@d bad_gf(#)==abort('Bad GF file: ',#,'!')
@.Bad GF file@>

@p procedure jump_out;
begin goto final_end;
end;
@y
@d abort(#)==begin verbose := true; print_ln(' ',#); cexit(1);
    end
@d bad_gf(#)==abort('Bad GF file: ',#,'!')
@.Bad GF file@>
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [9] The text_char type is used as an array index into xord.  The
% default type `char' produces signed integers, which are bad array
% indices in C.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
@x
@ The \.{GFtoPK} processor converts between ASCII code and
the user's external character set by means of arrays |xord| and |xchr|
that are analogous to \PASCAL's |ord| and |chr| functions.

@<Globals...@>=
@!xord: array [text_char] of ASCII_code;
  {specifies conversion of input characters}
@!xchr: array [0..255] of text_char;
  {specifies conversion of output characters}
@y
@ The \.{GFtoPK} processor converts between ASCII code and
the user's external character set by means of arrays |xord| and |xchr|
that are analogous to \PASCAL's |ord| and |chr| functions. Since one can
be an index in the other, we need unsigned quantities---they are not
numbers, by the way...

@<Globals...@>=
@!xord: array [text_char] of ASCII_code;
  {specifies conversion of input characters}
@!xchr: array [0..255] of 0..255;
  {specifies conversion of output characters}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [39] add verbose to the globals.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!pk_file:byte_file; {the stuff we have \.{GFtoPK}ed}
@y
@!pk_file:byte_file; {the stuff we have \.{GFtoPK}ed}
verbose:boolean;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [40] redo open_gf_file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ To prepare the |gf_file| for input, we |reset| it.

@p procedure open_gf_file; {prepares to read packed bytes in |gf_file|}
begin reset(gf_file);
gf_loc := 0 ;
end;
@y
@ In C, we use the searching path routines of the external C libweb.
In the course of this routine we also check the command line for
the \.{-v} flag, and make other checks to see that it is worth
running this program at all.

@p procedure open_gf_file; {prepares to read packed bytes in |gf_file|}
var j:integer;
begin
    verbose := false;
    if argc < 2 then abort('Usage: gftopk [-v] <gf file> [pk_file].');
    argfmt(1);
    if name_of_file[1]=xchr["-"] then begin
        if argc > 4 then abort('Usage: gftopk [-v] <gf file> [pk_file].');
        if name_of_file[2]=xchr["v"] then begin
            verbose := true; argfmt(2);
			if argc = 3 then argc := 2; {no pk_file argument}
            end else abort('Usage: gftopk [-v] <gf file> [pk_file].');
        end;
    print_ln(banner);@/
	if not b_open_in(gf_file, GF_PATH_SPEC) then begin
		print_string(stdout, name_of_file, name_length);
    	abort('GF file not found.');
	  end;
    gf_loc:=0;
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [41] and open_pk_file...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ To prepare the |pk_file| for output, we |rewrite| it.

@p procedure open_pk_file; {prepares to write packed bytes in |pk_file|}
begin rewrite(pk_file);
pk_loc := 0 ; pk_open := true ;
end;
@y
@ If the new name of the |pk_file| is not provided as an argument, we
take the filename part of |gf_file|, replacing the suffix.

If there was no argument, even if a flag was given, the |open_gf_file|
procedure has modified |argc| so that we know to take the default.

@p procedure open_pk_file; {prepares to write packed bytes in |pk_file|}
var j,k:integer;
begin
    if argc > 2 then argfmt(argc-1)
    else
    begin
	j := real_name_length; k := 1;@/
	while (j > 1) and (real_name_of_file[j] <> xchr["/"]) do@/
	    decr(j);
	if (real_name_of_file[j]=xchr["/"]) then incr(j); { to avoid picking up the / }
        print(xchr["["]); print(xchr[" "]);
	while (j <= real_name_length)
	    and (not (real_name_of_file[j] = xchr["."]) or 
                     (real_name_of_file[j] = xchr[" "])) do begin @/
	    name_of_file[k] := real_name_of_file[j];
            print(xchr[xord[real_name_of_file[j]]]);
	    incr(j); incr(k)
	end;
	while (j <= real_name_length)
	and not (real_name_of_file[j] = xchr["g"]) do begin @/
 	    if real_name_of_file[j] = xchr[" "] then abort(' No gf in suffix!');
	    name_of_file[k] := real_name_of_file[j];
            print(xchr[xord[real_name_of_file[j]]]);
	    incr(k); incr(j)
	end;
        print(xchr[xord[real_name_of_file[j]]]); incr(j); 
		print(xchr[xord[real_name_of_file[j]]]);
        print(xchr[" "]);print(xchr["-"]);print(xchr[">"]); print(xchr[" "]);
	name_of_file[k] := xchr["p"]; incr(k);
	name_of_file[k] := xchr["k"];
	name_length:=k;
        for j:=1 to k do print(xchr[xord[name_of_file[j]]]);
        print_ln(xchr[" "]);
        print_ln(xchr["]"])
    end;
    rewrite(pk_file,name_of_file,name_length);
    pk_loc:=0; pk_open:=true
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [46] redefine pk_byte, pk_halfword, pk_three_bytes, and pk_word
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p procedure pk_byte(a:integer) ;
begin
   if pk_open then begin
      if a < 0 then a := a + 256 ;
      write(pk_file, a) ;
      incr(pk_loc) ;
   end ;
end ;
@#
procedure pk_halfword(a:integer) ;
begin
   if a < 0 then a := a + 65536 ;
   write(pk_file, a div 256) ;
   write(pk_file, a mod 256) ;
   pk_loc := pk_loc + 2 ;
end ;
@#
procedure pk_three_bytes(a:integer);
begin
   write(pk_file, a div 65536 mod 256) ;
   write(pk_file, a div 256 mod 256) ;
   write(pk_file, a mod 256) ;
   pk_loc := pk_loc + 3 ;
end ;
@#
procedure pk_word(a:integer) ;
var b : integer ;
begin
   if pk_open then begin
      if a < 0 then begin
         a := a + @'10000000000 ;
         a := a + @'10000000000 ;
         b := 128 + a div 16777216 ;
      end else b := a div 16777216 ;
      write(pk_file, b) ;
      write(pk_file, a div 65536 mod 256) ;
      write(pk_file, a div 256 mod 256) ;
      write(pk_file, a mod 256) ;
      pk_loc := pk_loc + 4 ;
   end ;
end ;
@y
@ Output is handled through |putbyte| defined as a C macro.

@d pk_byte(#)==begin putbyte(#, pk_file); incr(pk_loc) end

@p procedure pk_halfword(a:integer) ;
begin
   if a < 0 then a := a + 65536 ;
   putbyte(a div 256, pk_file) ;
   putbyte(a mod 256, pk_file) ;
   pk_loc := pk_loc + 2 ;
end ;
@#
procedure pk_three_bytes(a:integer);
begin
   putbyte(a div 65536 mod 256, pk_file) ;
   putbyte(a div 256 mod 256, pk_file) ;
   putbyte(a mod 256, pk_file) ;
   pk_loc := pk_loc + 3 ;
end ;
@#
procedure pk_word(a:integer) ;
var b : integer ;
begin
   if a < 0 then begin
      a := a + @'10000000000 ;
      a := a + @'10000000000 ;
      b := 128 + a div 16777216 ;
   end else b := a div 16777216 ;
   putbyte(b, pk_file) ;
   putbyte(a div 65536 mod 256, pk_file) ;
   putbyte(a div 256 mod 256, pk_file) ;
   putbyte(a mod 256, pk_file) ;
   pk_loc := pk_loc + 4 ;
end ;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [48] redefine find_gf_length and move_to_byte
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p procedure find_gf_length ;
begin
   set_pos(gf_file, -1) ; gf_len := cur_pos(gf_file) ;
end ;
@#
procedure move_to_byte(@!n : integer) ;
begin
   set_pos(gf_file, n); gf_loc := n ;
end ;
@y
@d find_gf_length==gf_len:=gf_length

@p function gf_length:integer;
begin zfseek(gf_file, 0, 2); gf_length:=ftell(gf_file);
end;
@#
procedure move_to_byte(n:integer);
begin zfseek(gf_file, n, 0);
end;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [53] make sure that |gf_byte| gets past the comment when not |verbose| 
% and add do_the_rows to break up huge run of cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
   repeat
     gf_com := gf_byte ;
     case gf_com of
@y
   repeat
     gf_com := gf_byte ;
     do_the_rows:=false;
     case gf_com of
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [54] declare |thirty_seven_cases| to avoid breaking yacc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d one_sixty_five_cases(#)==sixty_four_cases(#),sixty_four_cases(#+64),
         sixteen_cases(#+128),sixteen_cases(#+144),four_cases(#+160),#+164
@y
@d thirty_seven_cases(#)==sixteen_cases(#),sixteen_cases(#+16),
	 four_cases(#+32),#+36
@d new_row_64=new_row_0 + 64
@d new_row_128=new_row_64 + 64
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [59] Break up an oversized sequence of cases (or yacc breaks)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
one_sixty_five_cases(new_row_0) : begin
  if on = state then put_in_rows(extra) ;
  put_in_rows(end_of_row) ;
  on := true ; extra := gf_com - new_row_0 ; state := false ;
end ;
@t\4@>@<Specials and |no_op| cases@> ;
eoc : begin
  if on = state then put_in_rows(extra) ;
  if ( row_ptr > 2 ) and ( row[row_ptr - 1] <> end_of_row) then
    put_in_rows(end_of_row) ;
  put_in_rows(end_of_char) ;
  if bad then abort('Ran out of internal memory for row counts!') ;
@.Ran out of memory@>
  pack_and_send_character ;
  status[gf_ch_mod_256] := sent ;
  if pk_loc <> pred_pk_loc then
    abort('Internal error while writing character!') ;
@.Internal error@>
end ;
othercases bad_gf('Unexpected ',gf_com:1,' command in character definition')
@.Unexpected command@>
    endcases ;
@y
sixty_four_cases(new_row_0) : do_the_rows:=true;
sixty_four_cases(new_row_64) : do_the_rows:=true;
thirty_seven_cases(new_row_128) : do_the_rows:=true;
@<Specials and |no_op| cases@> ;
eoc : begin
  if on = state then put_in_rows(extra) ;
  if ( row_ptr > 2 ) and ( row[row_ptr - 1] <> end_of_row) then
    put_in_rows(end_of_row) ;
  put_in_rows(end_of_char) ;
  if bad then abort('Ran out of internal memory for row counts!') ;
@.Ran out of memory@>
  pack_and_send_character ;
  status[gf_ch_mod_256] := sent ;
  if pk_loc <> pred_pk_loc then
    abort('Internal error while writing character!') ;
@.Internal error@>
end ;
othercases bad_gf('Unexpected ',gf_com:1,' character in character definition');
    endcases ;
if do_the_rows then begin
  do_the_rows:=false;
  if on = state then put_in_rows(extra) ;
  put_in_rows(end_of_row) ;
  on := true ; extra := gf_com - new_row_0 ; state := false ;
end ;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [60] add do_the_rows to break up huge run of cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ A few more locals used above and below:

@<Locals to |convert_gf_file|@>=
@y
@ A few more locals used above and below:

@<Locals to |convert_gf_file|@>=
@!do_the_rows:boolean;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [83] The values of comment are used as indices in xord[]. They have
% to be unsigned quantities.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ Of course, we need an array to hold the comment.

@<Glob...@>=
@!comment : packed array[1..comm_length] of char ;
@y
@ Of course, we need an array to hold the comment.

@<Glob...@>=
@!comment : packed array[1..comm_length] of 0..255 ;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [84] C knows aliases (pointers) but does not copy the content of a
% string. It is here, indeed, an array but not a string (we do not
% need the final '\0' for the "Pascal" array. So we copy just the
% content starting at index 1. [TL]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ @<Set init...@>=
comment := preamble_comment ;
@y
@ @<Set init...@>=
vstrncpy(comment + 1, preamble_comment, comm_length) ;
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [87] Remove the final_end label
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
final_end : end .
@y
end.
@z

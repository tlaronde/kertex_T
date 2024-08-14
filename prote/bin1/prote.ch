% This is prote.ch, the change file to add to TeX and e-TeX new 
% primitives or functionalities.
%
% Copyright 2021, 2023--2024 Thierry LARONDE <tlaronde@polynum.com>
% MIT/X11 license.
%
% The TeX program is copyright (C) 1982 by D. E. Knuth.
% TeX is a trademark of the American Mathematical Society.
% e-TeX and NTS are trademarks of the NTS group.

%
% The TeX API will be set to 3.0 (note in preface of \TeX: The Program).
%
% The e-TeX API is fixed at 2.0
%
% First set of extensions added by Prote:
%
% La\TeX\ requires, supplementary to \eTeX\ primitives,
% primitives that were introduced in pdf\TeX.
% 
% In order to comply with ker\TeX\ aims, that is total independence,
% including in the license's domain, we implement the required
% primitives (as listed in ltnews31) but excluding PDF output format
% dependent (since we stick to DVI).
% 
% 
% The API contract has been taken from the pdf\TeX\ manual, without 
% referring to the actual implementation.
%

% All section numbers refer to TeX PART and WEB modules numbers
%  i.e. [1] m.1 means PART 1, first WEB module.

@x limbo - Copyrights
% e-TeX is copyright (C) 1999-2012 by P. Breitenlohner (1994,98 by the NTS
% team); all rights are reserved. Copying of this file is authorized only if
% (1) you are P. Breitenlohner, or if (2) you make absolutely no changes to
% your copy. (Programs such as TIE allow the application of several change
% files to tex.web; the master files tex.web and etex.ch should stay intact.)

% See etex_gen.tex for hints on how to install this program.
% And see etripman.tex for details about how to validate it.

% e-TeX and NTS are trademarks of the NTS group.
% TeX is a trademark of the American Mathematical Society.
% METAFONT is a trademark of Addison-Wesley Publishing Company.

% This program is directly derived from Donald E. Knuth's TeX;
% the change history which follows and the reward offered for finders of
% bugs refer specifically to TeX; they should not be taken as referring
% to e-TeX, although the change history is relevant in that it
% demonstrates the evolutionary path followed.  This program is not TeX;
% that name is reserved strictly for the program which is the creation
% and sole responsibility of Professor Knuth.
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

@x limbo - Prote history
% A preliminary version of TeX--XeT was released in April 1992.
% TeX--XeT version 1.0 was released in June 1992,
%   version 1.1 prevented arith overflow in glue computation (Oct 1992).
% A preliminary e-TeX version 0.95 was operational in March 1994.
% Version 1.0beta was released in May 1995.
% Version 1.01beta fixed bugs in just_copy and every_eof (December 1995).
% Version 1.02beta allowed 256 mark classes (March 1996).
% Version 1.1 changed \group{type,level} -> \currentgroup{type,level},
%             first public release (October 1996).
% Version 2.0 development was started in March 1997;
%             fixed a ligature-\beginR bug in January 1998;
%             was released in March 1998.
% Version 2.1 fixed a \marks bug (when min_halfword<>0) (January 1999).
% Version 2.2 development was started in Feb 2003; released in Oct 2004.
%             fixed a bug in sparse array handling (0=>null), Jun 2002;
%             fixed a bug in \lastnodetype (cur_val=>cur_val_level)
%                 reported by Hartmut Henkel <hartmut_henkel@@gmx.de>,
%                 fix by Fabrice Popineau <Fabrice.Popineau@@supelec.fr>,
%                 Jan 2004;
%             another bug in sparse array handling (cur_ptr=>cur_chr)
%                 reported by Taco Hoekwater <taco@@elvenkind.com>, Jul 2004;
%             fixed a sparse array reference count bug (\let,\futurelet),
%                 fix by Bernd Raichle <berd@@dante.de>, Aug 2004;
%             reorganized handling of banner, additional token list and
%                 integer parameters, and similar in order to reduce the
%                 interference between eTeX, pdfTeX, and web2c change files.
%             adapted to tex.web 3.141592, revised glue rounding for mixed
%                 direction typesetting;
%             fixed a bug in the revised glue rounding code, detected by
%                 Tigran Aivazian <tigran@@aivazian.fsnet.co.uk>, Oct 2004.
% Version 2.3 development was started in Feb 2008; released in Apr 2011.
%             fixed a bug in hyph_code handling (\savinghyphcodes)
%                 reported by Vladimir Volovich <vvv@@vsu.ru>, Feb 2008.
%             fixed the error messages for improper use of \protected,
%                 reported by Heiko Oberdiek
%                 <heiko.oberdiek@@googlemail.com>, May 2010.
%             some rearrangements to reduce interferences between
%                 e-TeX and pTeX, in part suggested by Hironori Kitagawa
%                 <h_kitagawa2001@@yahoo.co.jp>, Mar 2011.
% Version 2.4 fixed an uninitialized line number bug, released in May 2012.
% Version 2.5 development was started in Aug 2012; released in Feb 2013.
%             better tracing of font definitions, reported by
%                 Bruno Le Floch <blflatex@@gmail.com>, Jul 2012.
% Version 2.6 development was started in Mar 2013; released in ??? 201?.
%             enable hyphenation of text between \beginL and \endL or
%                 between \beginR and \endR, problem reported by
%                 Vafa Khalighi <vafalgk@@gmail.com>, Nov 2013.
%             better handling of right-to-left text -- to be done.

% Although considerable effort has been expended to make the e-TeX program
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
% 1.1.1: 2024-08-14: Andreas Scherer has provided some typographic
% improvements (formatting of the TeX generated doc) to Martin Ruckert
% who was kind enough to push them back to me. The corrections are
% incorporated and reflected only in the patchlevel number (third)
% number since there is strictly no change in the program behavior or
% implementation.
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

@x limbo - Macros for TeX'ing: our logo
\let\mc=\ninerm % medium caps for names like SAIL
@y
\let\mc=\ninerm % medium caps for names like SAIL
\def\Prote{{\tenrm P\kern-0.1em R\kern-0.15em\raise.11ex\hbox{o}%
  \kern-0.22em T\kern-0.05em E}}
\def\MP{{\tenlogo META}\-{\tenlogo POST}}
@z
%---------------------------------------
@x [1] m.1 - The name of the game
This is \eTeX, a program derived from and extending the capabilities of
\TeX, a document compiler intended to produce typesetting of high
@y
This is \Prote, a program derived from and extending the capabilities
of \TeX plus \eTeX,
a document compiler intended to produce typesetting of high
@z
%---------------------------------------
@x [1] m.2 - Who is who
based on some specifications that the author had made in May of that year.
@y
based on some specifications that the author (in the following, unless
specified, ``the author'' refers to D.E.~Knuth) had made in May of that year.
@z
@x [1] m.2 - Modified so modified name
This program contains code for various features extending \TeX,
therefore this program is called `\eTeX' and not
@y
This program contains code for various features extending \TeX,
therefore this program is called `\Prote' and not
@z
@x [1] m.2 - TRIP
A similar test suite called the ``\.{e-TRIP} test'' is available for
helping to determine whether a particular implementation deserves to be
known as `\eTeX'.
@y
A similar test suite called the ``\.{SELLETTE} test'' is available for
helping to determine whether a particular implementation deserves to be
known as `\Prote'.
@z
@x [1] m.2 - Identification
@d banner==eTeX_banner
@y
@z
@x
@d eTeX_states=1 {number of \eTeX\ state variables in |eqtb|}
@y
@d eTeX_states=1 {number of \eTeX\ state variables in |eqtb|}
@#
@d Prote_version_string=='3.141592653-2.6-1.1.1' {current \Prote\ version}
@d Prote_version=1 { \.{\\Proteversion} }
@d Prote_revision==".1.1" { \.{\\Proterevision} }
@#
@d Prote_banner=='This is Prote, Version ',Prote_version_string
  {printed when \Prote\ starts}
@#
@d banner==Prote_banner
@z
%---------------------------------------
@x [1] m.11 - Setting a Prote exchange buffer
@!pool_name='TeXformats:TEX.POOL                     ';
  {string of length |file_name_size|; tells where the string pool appears}
@.TeXformats@>
@y
@!xchg_buffer_size=64; {must be at least 64}
  {size of |eight_bits| buffer for exchange with system routines}
@!pool_name='TeXformats:TEX.POOL                     ';
  {string of length |file_name_size|; tells where the string pool appears}
@.TeXformats@>
@z
%---------------------------------------
@x [4] m.46 - Prote basics
not_found: str_eq_str:=result;
end;
@y
not_found: str_eq_str:=result;
end;
@#@<Declare \Prote\ procedures for strings@>@;
@z
%---------------------------------------
@x [7] m.108 - Hook other arithmetic routines definitions
@p function badness(@!t,@!s:scaled):halfword; {compute badness, given |t>=0|}
@y
@p @<Declare \Prote\ arithmetic routines@>@;
function badness(@!t,@!s:scaled):halfword; {compute badness, given |t>=0|}
@z
%---------------------------------------
@x [17] m.222 - Define frozen_primitive
@d frozen_null_font=frozen_control_sequence+10
  {permanent `\.{\\nullfont}'}
@y
@d frozen_primitive=frozen_control_sequence+10
  {permanent `\.{\\primitive:}'}
@d frozen_null_font=frozen_control_sequence+11
  {permanent `\.{\\nullfont}'}
@z
%---------------------------------------
@x [17] m.236 - Insert \eTeX\ undefined expand_depth as int parameter
@d saving_hyph_codes_code=etex_int_base+8 {save hyphenation codes for languages}
@d eTeX_state_code=etex_int_base+9 {\eTeX\ state variables}
@d etex_int_pars=eTeX_state_code+eTeX_states {total number of \eTeX's integer parameters}
@y
@d saving_hyph_codes_code=etex_int_base+8 {save hyphenation codes for languages}
@d expand_depth_code=etex_int_base+9 {maximum depth for expansion---\eTeX}
@d eTeX_state_code=etex_int_base+10 {\eTeX\ state variables}
@d etex_int_pars=eTeX_state_code+eTeX_states {total number of \eTeX's integer parameters}
@z
@x
@d saving_hyph_codes==int_par(saving_hyph_codes_code)
@y
@d saving_hyph_codes==int_par(saving_hyph_codes_code)
@d expand_depth==int_par(expand_depth_code)
@z
%---------------------------------------
@x [17] m.241 - Prote takes this moment as default reference time
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
%---------------------------------------
@x [17] m.247 - Insert Prote dimension parameters
@d emergency_stretch_code=20 {reduces badnesses on final pass of line-breaking}
@d dimen_pars=21 {total number of dimension parameters}
@y
@d emergency_stretch_code=20 {reduces badnesses on final pass of line-breaking}
@d page_width_code=21 {current paper page width}
@d page_height_code=22 {current paper page height}
@d dimen_pars=23 {total number of dimension parameters}
@z
@x
@d emergency_stretch==dimen_par(emergency_stretch_code)
@y
@d emergency_stretch==dimen_par(emergency_stretch_code)
@d page_width==dimen_par(page_width_code)
@d page_height==dimen_par(page_height_code)
@z
@x
emergency_stretch_code:print_esc("emergencystretch");
@y
emergency_stretch_code:print_esc("emergencystretch");
page_width_code:print_esc("pagewidth");
page_height_code:print_esc("pageheight");
@z
%---------------------------------------
@x [18] m.262 - Prefix with \primitive if original definition called
else  begin print_esc(text(p));
  print_char(" ");
  end;
@y
else  begin if p=frozen_primitive then print_esc("primitive");
  print_esc(text(p)); print_char(" ");
  end;
@z
%---------------------------------------
@x [18] m.264 - Prote: keep primitive definitions
@!l:small_number; {length of the string}
@y
@!l:small_number; {length of the string}
@!p:pointer; {pointer in |ROM|}
@z
@x
eq_level(cur_val):=level_one; eq_type(cur_val):=c; equiv(cur_val):=o;
end;
@y
eq_level(cur_val):=level_one; eq_type(cur_val):=c; equiv(cur_val):=o;
@<Add primitive definition to the |ROM| array@>@;
end;
@z
%---------------------------------------
@x [18] m.266 - Allow more expand_after cases
expand_after: if chr_code=0 then print_esc("expandafter")
  @<Cases of |expandafter| for |print_cmd_chr|@>;
@y
expand_after: case chr_code of
0: print_esc("expandafter");
@/@<Cases of |expandafter| for |print_cmd_chr|@>@/
end; {there are no other cases}
@z
%---------------------------------------
@x [22] m.309 - add counter for csname
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
 %---------------------------------------
@x [25] m.366 - add forward declarations for expanding
@t\4@>@<Declare \eTeX\ procedures for expanding@>@;@/
@y
@t\4@>@<Declare \eTeX\ procedures for expanding@>@;@/
@t\4@>@<Declare \Prote\ procedures for expanding@>@;@/
@z
%---------------------------------------
@x [25] m.367 - allow more expand_after cmd modifiers
expand_after:if cur_chr=0 then @<Expand the token after the next token@>
  else @<Negate a boolean conditional and |goto reswitch|@>;
@y
expand_after: case cur_chr of
0: @<Expand the token after the next token@>;
1: @<Negate a boolean conditional and |goto reswitch|@>;
@/@<Cases for |expandafter|@>@/
end; {there are no other cases}
@z
%---------------------------------------
@x [25] m.372 - Define the boolean incsname_bool
begin r:=get_avail; p:=r; {head of the list of characters}
@y
begin r:=get_avail; p:=r; {head of the list of characters}
incr(incsname_state);
@z
@x
if cur_cmd<>end_cs_name then @<Complain about missing \.{\\endcsname}@>;
@y
if cur_cmd<>end_cs_name then @<Complain about missing \.{\\endcsname}@>;
decr(incsname_state);
@z
%---------------------------------------
@x [26] m.409 - Prote forward declarations
@t\4\4@>@<Declare \eTeX\ procedures for scanning@>@;
@y
@t\4\4@>@<Declare \eTeX\ procedures for scanning@>@;
@t\4\4@>@<Declare \Prote\ procedures for scanning@>@;
@z
%---------------------------------------
@x [26] m.416 - Define eTeX last last_item cmd mod
@d eTeX_expr=eTeX_mu+1 {first of \eTeX\ codes for expressions}
@y
@d eTeX_expr=eTeX_mu+1 {first of \eTeX\ codes for expressions}
@d eTeX_last_last_item_cmd_mod=eTeX_expr-int_val+mu_val {\.{\\muexpr}}
@z
%---------------------------------------
@x [26] m.424 - Insert Prote last_item treatment
if m>=input_line_no_code then
@y
if m>eTeX_last_last_item_cmd_mod then
  @/@<Fetch a \Prote\ item@>@/
else if m>=input_line_no_code then
@z
%---------------------------------------
@x [27] m.468 - Don't interpolate \eTeX\ convert codes
\eTeX\ adds \.{\\eTeXrevision} such that |job_name_code| remains last.

@d number_code=0 {command code for \.{\\number}}
@y
@d number_code=0 {command code for \.{\\number}}
@z
%---------------------------------------
@x [27] m.468 - Mark last used eTeX cmd modifiers
@d etex_convert_base=5 {base for \eTeX's command codes}
@d eTeX_revision_code=etex_convert_base {command code for \.{\\eTeXrevision}}
@d etex_convert_codes=etex_convert_base+1 {end of \eTeX's command codes}
@d job_name_code=etex_convert_codes {command code for \.{\\jobname}}
@y
@d job_name_code=5 {command code for \.{\\jobname}}
@d etex_convert_base=job_name_code+1 {base for \eTeX's command codes}
@d eTeX_revision_code=etex_convert_base {command code for \.{\\eTeXrevision}}
@d etex_convert_codes=etex_convert_base+1 {end of \eTeX's command codes}
@d eTeX_last_convert_cmd_mod=etex_convert_codes
@z
%---------------------------------------
@x [27] m.469 l.9235 - Add hook for other convert cases
  eTeX_revision_code: print_esc("eTeXrevision");
  othercases print_esc("jobname")
@y
  job_name_code: print_esc("jobname");
  eTeX_revision_code: print_esc("eTeXrevision");
  @/@<Cases of |convert| for |print_cmd_chr|@>@/
@z
%---------------------------------------
@x [27] m.470 - Prote add variables for our own conversions to conv_toks
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
%---------------------------------------
@x [27] m.471 l.9260 - Add hook for other <Scan the argument...>
eTeX_revision_code: do_nothing;
job_name_code: if job_name=0 then open_log_file;
@y
job_name_code: if job_name=0 then open_log_file;
eTeX_revision_code: do_nothing;
@/@<Cases of `Scan the argument for command |c|'@>@/
@z
%---------------------------------------
@x [27] m.472  - Add hook for <Print the result of command c>
eTeX_revision_code: print(eTeX_revision);
job_name_code: print(job_name);
@y
eTeX_revision_code: print(eTeX_revision);
job_name_code: print(job_name);
@/@<Cases of `Print the result of command |c|'@>@/
@z
%---------------------------------------
@x [27] m.473 - Prote definitions after scan_toks
scan_toks:=p;
end;
@y
scan_toks:=p;
end;
@t\4@>@<Declare \Prote\ procedures for token lists@>@;@/
@z
%---------------------------------------
@x [29] m.536 - Prote advertising
if eTeX_ex then
  begin; wlog_cr; wlog('entering extended mode');
  end;
end
@y
if eTeX_ex then
  begin; wlog_cr; wlog('entering extended mode');
  end;
if Prote_ex then
  begin; wlog_cr; wlog('entering Prote mode');
  end;
end
@z
%---------------------------------------
@x [50] m.1307 - Saving Prote state
dump_int(@$);@/
@<Dump the \eTeX\ state@>@/
@y
dump_int(@$);@/
@<Dump the \eTeX\ state@>@/
@<Dump the \Prote\ state@>@/
@<Dump the |ROM| array@>@/
@z
%---------------------------------------
@x [50] m.1308 - Reloading Prote state
if x<>@$ then goto bad_fmt; {check that strings are the same}
@/@<Undump the \eTeX\ state@>@/
@y
if x<>@$ then goto bad_fmt; {check that strings are the same}
@/@<Undump the \eTeX\ state@>@/
@/@<Undump the \Prote\ state@>@/
@/@<Undump the |ROM| array@>@/
@z
%---------------------------------------
@x [51] m.1337 - switching modes if requested before loading dump
@<Enable \eTeX, if requested@>@;@/
if (format_ident=0)or(buffer[loc]="&") then
@y
@<Enable \eTeX\ and furthermore Prote, if requested@>@;@/
if (format_ident=0)or(buffer[loc]="&") then
@z
@x
if eTeX_ex then wterm_ln('entering extended mode');
@y
if eTeX_ex then wterm_ln('entering extended mode');
if Prote_ex then begin Prote_initialize;
  wterm_ln('entering prote mode');
  end;
@z
%---------------------------------------
@x [53] m.1344 --- Mark TeX_last_extension_cmd_mod
@d set_language_code=5 {command modifier for \.{\\setlanguage}}
@y
@d set_language_code=5 {command modifier for \.{\\setlanguage}}
@d TeX_last_extension_cmd_mod=set_language_code
@z
%---------------------------------------
@x [53] m.1346 --- Adding symbolic printing of extension primitives
  set_language_code:print_esc("setlanguage");
@y
  set_language_code:print_esc("setlanguage");
  @/@<Cases of |extension| for |print_cmd_chr|@>@/
@z
%---------------------------------------
@x [53] m.1348 --- Adding cases for do_extension
set_language_code:@<Implement \.{\\setlanguage}@>;
@y
set_language_code:@<Implement \.{\\setlanguage}@>;
@/@<Cases for |do_extension|@>@/
@z
%---------------------------------------
@x [53] m.1356 --- Adding cases for displaying the whatsit node
othercases print("whatsit?")
@y
@/@<Cases for displaying the |whatsit| node@>@/
othercases print("whatsit?")
@z
%---------------------------------------
@x [53] m.1357 --- Adding cases for making a partial copy of the whatsit
othercases confusion("ext2")
@y
@/@<Cases for making a partial copy of the whatsit node@>@/
othercases confusion("ext2")
@z
%---------------------------------------
@x [53] m.1358 --- Adding cases for wiping out the whatsit node
close_node,language_node: free_node(p,small_node_size);
othercases confusion("ext3")
@y
close_node,language_node: free_node(p,small_node_size);
@/@<Cases for wiping out the whatsit node@>@/
othercases confusion("ext3")
@z
%---------------------------------------
@x [53] m.1373 --- Adding cases for out_what procedure
procedure out_what(@!p:pointer);
@y
@t\4@>@<Declare procedures needed in |out_what|@>@;
procedure out_what(@!p:pointer);
@z
@x
language_node:do_nothing;
othercases confusion("ext4")
@y
language_node:do_nothing;
@/@<Cases for |out_what|@>@/
othercases confusion("ext4")
@z
%---------------------------------------
@x [53a] --- Correction of the number of modes
@* \[53a] The extended features of \eTeX.
The program has two modes of operation:  (1)~In \TeX\ compatibility mode
it fully deserves the name \TeX\ and there are neither extended features
nor additional primitive commands.  There are, however, a few
modifications that would be legitimate in any implementation of \TeX\
such as, e.g., preventing inadequate results of the glue to \.{DVI}
unit conversion during |ship_out|.  (2)~In extended mode there are
additional primitive commands and the extended features of \eTeX\ are
available.

The distinction between these two modes of operation initially takes
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
@z
@x --- Enabling \Prote\ too
@<Enable \eTeX, if requested@>=
@!init if (buffer[loc]="*")and(format_ident=" (INITEX)") then
  begin no_new_control_sequence:=false;
  @<Generate all \eTeX\ primitives@>@;
  incr(loc); eTeX_mode:=1; {enter extended mode}
  @<Initialize variables for \eTeX\ extended mode@>@;
  end;
tini@;@/
if not no_new_control_sequence then {just entered extended mode ?}
  no_new_control_sequence:=true@+else
@y
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
@z
%---------------------------------------
@x [53a] - Mark last used eTeX cmd modifiers
@d if_font_char_code=19 { `\.{\\iffontchar}' }
@y
@d if_font_char_code=19 { `\.{\\iffontchar}' }
@d eTeX_last_if_test_cmd_mod=if_font_char_code
@d eTeX_last_expand_after_cmd_mod=1
@z
%---------------------------------------
@x [53a] - Explicate the expand_after treatment to insert Prote
@ @<Cases of |expandafter| for |print_cmd_chr|@>=
else print_esc("unless")
@y
@ @<Cases of |expandafter| for |print_cmd_chr|@>=
1: print_esc("unless");
@z
%---------------------------------------
@x [54] - Prote additions
@* \[54] System-dependent changes.
@y
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
be enabled, the engine is still compatible with \TeX\ with no added
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

@<Global...@>=
@!xchg_buffer:array[1..xchg_buffer_size] of eight_bits;
  {exchange buffer for interaction with system routines}
@!xchg_buffer_length:integer; {last valid index in this buf; 0 means no data}
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

@<Global...@>=
@!data_in:byte_file; {opening here, but letting external routines handle}

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

It is here only an alias to |set_invalid_date|.

@d get_creation_date==set_invalid_date 

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

@d get_elapsed_time==infinity {a function should be implemented}

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

Standard \PASCAL\ doesn't provide related routines so our
syntactically correct but semantically useless routines are implemented
here: the |reset_timer| does nothing, while the |get_elapsed_time|
simply returns, even when |reset_timer| has been called, the invalid
value |infinity|. 

@d reset_timer==do_nothing

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

The code below is a basic working implementation; but the result
can obviously be obtained more efficiently by the system, without
reading the contents of the file. The file is opened externally
and is closed externally.
@^system dependencies@>

@<Declare \Prote\ procedures for scanning@>=
function get_file_size:integer;
var k:integer; {length to be returned}
@!i:integer; {byte returned; unused}
begin k:=0; repeat read(data_in,i);incr(k); until eof(data_in);
get_file_size:=k;
end;

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

In this basic implementation, we set the string to the empty one by
simply setting |xchg_buffer_length| to~$0$.

@d get_file_mtime==xchg_buffer_length:=0

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
standard \PASCAL\ does not provide. So we do not bother to try. The
present implementation returns nothing.
@^system dependencies@>

@ |mdfive_init| shall reinit the state to compute the hash value.
Nothing is taken from |xchg_buffer| and |xchg_buffer_length| is
unchanged.

@d mdfive_init==do_nothing

@ |mdfive_update| takes |xchg_buffer_length| bytes to contribute to the
hash. The bytes being consumed, |xchg_buffer_length| shall be reset to
$0$.

@d mdfive_update==xchg_buffer_length:=0

@ |md5_final| puts the binary $16$ bytes long hash into |xchg_buffer|
and sets |xchg_buffer_length| to $16$.

Here, by default, we do nothing except carefully set
|xchg_buffer_length| to $0$ in order to state that we have consumed
the data.

@d mdfive_final==xchg_buffer_length:=0

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

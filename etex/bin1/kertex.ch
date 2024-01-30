% Supplementary change file for system adjustements for e-TeX
% in kerTeX.
% Thierry Laronde <tlaronde@polynum.com> 2011-12-25
% Thierry Laronde <tlaronde@polynum.com> 2017-03-26
%    char arrays and strings; Pascal vs C; vstrcpy() vs vstrncpy().
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1.2] banner line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d eTeX_banner=='This is e-TeX, Version 3.141592653',eTeX_version_string
@y
@d eTeX_banner=='This is e-TeX, kerTeX C Version 3.141592653-2.6',eTeX_version_string
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1.11] Changing the pool name to not step on TeXees toes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!pool_name='tex.pool';
@!pool_name_length=8;
  {required: |name_of_file| and |name_length| have to be both defined}
@y
@!pool_name='etex.pool';
@!pool_name_length=9;
  {required: |name_of_file| and |name_length| have to be both defined}
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [29.520] default format. Correction: e-TeX now has digests !
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
Under {\mc UNIX} we don't give the area part, instead depending
on the path searching that will happen during file opening. \.{pp2rc}
adds one to the array sizes so that the indices do point inside the
array. When the array is declared in the Pascal code and used by Pascal
routines, we do not need the C trailing nul character since this is not
a C string.

@d format_default_length=9 {length of the |TEX_format_default| string}
@d format_area_length=0 {length of its area part}
@d format_ext_length=4 {length of its `\.{.fmt}' part}
@d format_extension=".fmt" {the extension, as a \.{WEB} constant}
  {not empty and distinct from ".tex", ".log", "tfm" and ".dvi"}

@y
Under {\mc UNIX} we don't give the area part, instead depending
on the path searching that will happen during file opening. \.{pp2rc}
adds one to the array sizes so that the indices do point inside the
array. When the array is declared in the Pascal code and used by Pascal
routines, we do not need the C trailing nul character since this is not
a C string.

Distinct objects shall have distinct names. \TeX\ has formats. \eTeX has
digests.

@d format_default_length=10 {length of the |TEX_format_default| string}
@d format_area_length=0 {length of its area part}
@d format_ext_length=5 {length of its `\.{.dgst}' part}
@d format_extension=".dgst" {the extension, as a \.{WEB} constant}
  {not empty and distinct from ".tex", ".log", "tfm" and ".dvi"}

@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [29.521] plain format location. See module below too.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
vstrncpy(TEX_format_default + 1, 'plain.fmt', format_default_length);
@y
vstrncpy(TEX_format_default + 1, 'plain.dgst', format_default_length);
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [51.1332] Call set_paths with correct argument.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
set_paths(TEX_PATHS_SET); {get default file paths from the Unix environment}
@y
set_paths(ETEX_PATHS_SET); {get default file paths from the Unix environment}
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [53a] \eTeX: fixing call to pointer to variables instead of variable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
cur_h:=0; link(p):=reverse(this_box,null,cur_g,cur_glue); width(p):=-cur_h;
@y
cur_h:=0; link(p):=v_reverse(this_box,null,cur_g,cur_glue); width(p):=-cur_h;
@z
@x
link(p):=reverse(this_box,new_edge(reflected,0),cur_g,cur_glue);
@y
link(p):=v_reverse(this_box,new_edge(reflected,0),cur_g,cur_glue);
@z
%---------------------------------------
@x [54] - Fixing missing expand_depth and expand_depth_count.
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

@* \[54] System-dependent changes.
@z

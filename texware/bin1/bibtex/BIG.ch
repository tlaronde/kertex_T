% Supplementary change file for BIG TeX
%
% Thierry Laronde <tlaronde@polynum.com> 2011-12-25
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compile-time constants; enlarging.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
These parameters can be changed at compile time to extend or reduce
\BibTeX's capacity.  They are set to accommodate about 750 cites when
used with the standard styles, although |pool_size| is usually the
first limitation to be a problem, often when there are 500 cites.

@<Constants in the outer block@>=
@!buf_size=1000; {maximum number of characters in an input line (or string)}
@!min_print_line=3; {minimum \.{.bbl} line length: must be |>=3|}
@!max_print_line=79; {the maximum: must be |>min_print_line| and |<buf_size|}
@!aux_stack_size=20; {maximum number of simultaneous open \.{.aux} files}
@!max_bib_files=20; {maximum number of \.{.bib} files allowed}
@!pool_size=65000; {maximum number of characters in strings}
@!max_strings=4000; {maximum number of strings, including pre-defined;
                                                        must be |<=hash_size|}
@!max_cites=750; {maximum number of distinct cite keys; must be
                                                        |<=max_strings|}
@!min_crossrefs=2; {minimum number of cross-refs required for automatic
                                                        |cite_list| inclusion}
@!wiz_fn_space=3000; {maximum amount of |wiz_defined|-function space}
@!single_fn_space=100; {maximum amount for a single |wiz_defined|-function}
@!max_ent_ints=3000; {maximum number of |int_entry_var|s
                                        (entries $\times$ |int_entry_var|s)}
@!max_ent_strs=3000; {maximum number of |str_entry_var|s
                                        (entries $\times$ |str_entry_var|s)}
@!ent_str_size=100; {maximum size of a |str_entry_var|; must be |<=buf_size|}
@!glob_str_size=1000; {maximum size of a |str_global_var|;
                                                        must be |<=buf_size|}
@!max_fields=17250; {maximum number of fields (entries $\times$ fields,
                                        about |23*max_cites| for consistency)}
@!lit_stk_size=100; {maximum number of literal functions on the stack}
@y
These parameters can be changed at compile time to extend or reduce
\BibTeX's capacity.  They are set to accommodate about 750 cites when
used with the standard styles, although |pool_size| is usually the
first limitation to be a problem, often when there are 500 cites.

@<Constants in the outer block@>=
@!buf_size=20000; {maximum number of characters in an input line (or string)}
@!min_print_line=3; {minimum \.{.bbl} line length: must be |>=3|}
@!max_print_line=79; {the maximum: must be |>min_print_line| and |<buf_size|}
@!aux_stack_size=20; {maximum number of simultaneous open \.{.aux} files}
@!max_bib_files=20; {maximum number of \.{.bib} files allowed}
@!pool_size=100000; {maximum number of characters in strings}
@!max_strings=7500; {maximum number of strings, including pre-defined;
                                                        must be |<=hash_size|}
@!max_cites=2000; {maximum number of distinct cite keys; must be
                                                        |<=max_strings|}
@!min_crossrefs=2; {minimum number of cross-refs required for automatic
                                                        |cite_list| inclusion}
@!wiz_fn_space=9000; {maximum amount of |wiz_defined|-function space}
@!single_fn_space=150; {maximum amount for a single |wiz_defined|-function}
@!max_ent_ints=4500; {maximum number of |int_entry_var|s
                                        (entries $\times$ |int_entry_var|s)}
@!max_ent_strs=4500; {maximum number of |str_entry_var|s
                                        (entries $\times$ |str_entry_var|s)}
@!ent_str_size=100; {maximum size of a |str_entry_var|; must be |<=buf_size|}
@!glob_str_size=2000; {maximum size of a |str_global_var|;
                                                        must be |<=buf_size|}
@!max_fields=46000; {maximum number of fields (entries $\times$ fields,
                                        about |23*max_cites| for consistency)}
@!lit_stk_size=200; {maximum number of literal functions on the stack}
@z

@x
These parameters can also be changed at compile time, but they're
needed to define some \.{WEB} numeric macros so they must be so
defined themselves.

@d hash_size=5000       {must be |>= max_strings| and |>= hash_prime|}
@d hash_prime=4253      {a prime number about 85\% of |hash_size| and |>= 128|
                                                and |< @t$2^{14}-2^6$@>|}
@d max_glob_strs=10     {maximum number of |str_global_var| names}
@d max_glb_str_minus_1 = max_glob_strs-1  {to avoid wasting a |str_global_var|}
@y
These parameters can also be changed at compile time, but they're
needed to define some \.{WEB} numeric macros so they must be so
defined themselves.

@d hash_size=9500       {must be |>= max_strings| and |>= hash_prime|}
@d hash_prime=7919      {a prime number about 85\% of |hash_size| and |>= 128|
                                                and |< @t$2^{14}-2^6$@>|}
@d max_glob_strs=30     {maximum number of |str_global_var| names}
@d max_glb_str_minus_1 = max_glob_strs-1  {to avoid wasting a |str_global_var|}
@z


% Supplementary change file to go from TRIP to ETRIP.
% 
% Thierry Laronde <tlaronde@polynum.com> 2011-12-25
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1.11] compile-time constants, adjusted from TRIP to ETRIP according 
% etripman  A.2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!max_strings=3000; {maximum number of strings; must not exceed |max_halfword|}
@y
@!max_strings=3200; {maximum number of strings; must not exceed |max_halfword|}
@z

@x
@!pool_size=32000; {maximum number of characters in strings, including all
  error messages and help texts, and the names of all fonts and
  control sequences; must exceed |string_vacancies| by the total
  length of \TeX's own strings, which is currently about 23000}
@y
@!pool_size=45000; {maximum number of characters in strings, including all
  error messages and help texts, and the names of all fonts and
  control sequences; must exceed |string_vacancies| by the total
  length of \TeX's own strings, which is currently about 23000}
@z


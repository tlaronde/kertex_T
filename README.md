# kerTeX distribution of D.E. Knuth's TeX typographic system.

![Quixante](http://kertex.kergis.com/img/quixante_half.png)

This is the main part of the kerTeX distribution, the bulk of what will
be installed on the Target (hence the 'T'). It uses **kertex_M** ('M'
for Matrix) in order to convert WEB to C for compilation. Both use
**risk_comp** as compilation and installation framework.

kerTeX is the **TeX kernel system**: the main part upon which
everything else relies.

**kerTeX relies only on a libc and, for
administration of extensions (packages), and slightly for MetaPost
utilities, on a reduced subset of POSIX.2 utilities that are indeed
available for any OS (MS Windows included via MSYS). And it will
stay this way.**

The installation includes all the D.E. Knuth's work and additions (John Hobby's
MetaPost, e-TeX, Oren Patashnik's BibTeX, D.E. Knuth and Sylvio Levi 
CWEB, Tomas Rokicki's dvips) as well a Prote, T. Laronde extension to
TeX and e-TeX that is the main engine, compatible with TeX, compatible
with e-TeX and providing the supplementary primitives needed by LaTeX
post 2e.

To clarify what is, here, added and what is taken from external
sources, the external sources are put aside and can be retrieved
in a bundle provided by the kerTeX web site (see the downloads section
on the site whose address is given below).

So the present code is not enough, by itself, to obtain the system: it
reaches ``out'' supplementary code.

But see COPYRIGHTS for a description of who is the author of what and
what responsability an author has in the present work. And see the
README or LISEZ.MOI---that can be found for download on the website---
for further explanations.

## Further documentation

* [kertex main site](http://kertex.kergis.com/)

* [kertex site french version](http://kertex.kergis.com/fr/index.html)

* [kertex site english version](http://kertex.kergis.com/en/index.html)


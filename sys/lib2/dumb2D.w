% This is the dumb flavour fo Online Graphic Output routine for
% METAFONT.
% $Id: dumb2D.w,v 1.1 2020/09/01 17:01:07 tlaronde Exp $

% in limbo
\lang=fr
\input lists
\datethis % dater le chef-d'oeuvre

\font\logo=logo10 % font used for the METAFONT logo
\def\MF{{\logo META}\-{\logo FONT}}

\def\author{Thierry LARONDE (tlaronde@@polynum.com)}
\def\copydate{2012, 2016}

% Numbers have to be adjusted when binding all the doc together
\skippage=1
\def\contentspagenumber{\startpage}
\pageno=\contentspagenumber \advance\pageno by \skippage

\def\topofcontents{\null\vfill
  \centerline{\titlefont Ker\TeX\ : dumb Online Graphic Output for \MF}
  \vskip 1em
  \centerline{\$Id: dumb2D.w,v 1.1 2020/09/01 17:01:07 tlaronde Exp $$}
  \vskip 20pt
  \centerline{\mainfont \author}
  \vskip 20pt

% abstract will be included on first page

\centerline{\bf Abstract}
\medskip
If the host system offers a graphical 2D service, the \.{virmf}
\MF\ incarnations can have the abibity to display a rendering of
characters.

This is described in the \MF\ program as the {\bf Outline graphic 
output} part number 27 ; hence the {\sl ogo} acronym for the library.

The use of the routines, from an user point of view, is described in
the \MF book, chapter 23.

This is the dumb flavour (i.e.: not 2D output) of the \MF\ routines.

\bigskip
Copyright \copydate\ \author. All rights reserved.

This software is provided ``as is'' without any warranty, under the
ker\TeX\ public licence.

\smallskip
\hrule
\medskip
If the host system has a 2D graphical output service, the various
\.{virmf} incarnations of \MF can display the characters being
programmed in \MF.

This is described in \MF\, 27  part : {\bf
Online graphic output} hence the acronym {\sl ogo} for the library.

From the user standpoint, the use of the routines, if there are
available (not the case in the dumb2D implementation...), are described
in the \MF book, chapter 24.

Here we will instruct \.{virmf} that we do nothing...

\bigskip
Copyright \copydate\ \author. All rights reserved.

This software is provided without any warranty, under the ker\TeX\
public license.

}

@ The exported routines instruct \.{virmf} that we do nothing.

Some variables are exported too, even if we presently don't use them.

The comments are only to explain what is the use for an implementation
that would do something...

@c
#include "kertex.h"
#include "pascal.h"	/* boolean */
#include "ogo.h"

int screenwidth;
int screendepth;
int *rowtransition; /* screencol rowtransition[screencol] */
boolean screenOK; /* is it legitimate to call |blank_rectangle|,
  |paint_row|, and |update_screen|? */

@ The first routine will initialize the screen (this is the name used in
\MF, and this matches generally the concept of a window).

@c
boolean
initscreen(void)
{
	(void)fprintf(stderr, "No Online Output Graphic compiled in.\n");
	return false;
}

@ The screen is updated at user's request.

@c
void
updatescreen(void)
{
}

@ Erasing the screen is ``blanking'' the whole screen. But one can
blank whatever rectangle.

@c
/* ARGSUSED */
void
blankrectangle(int left_col, int right_col, int top_row,
	int bot_row)
{
}

@ Obviously, one needs to be able to draw something, row by row, on the
screen.

@c
/* ARGSUSED */
void
paintrow(int r, signed char b, int *a, int n)
{
}


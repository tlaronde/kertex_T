% Une impl�mentation X11/Xt des routines OGO de METAFONT.
% $Id: x11.w,v 1.4 2016/01/31 08:29:37 tlaronde Exp $

% in limbo
\lang=fr
\input lists
\datethis % dater le chef-d'oeuvre

\font\logo=logo10 % font used for the METAFONT logo
\def\MF{{\logo META}\-{\logo FONT}}

\def\author{Thierry LARONDE (tlaronde@@polynum.com)}
\def\copydate{2015}

% Numbers have to be adjusted when binding all the doc together
\skippage=1
\def\contentspagenumber{\startpage}
\pageno=\contentspagenumber \advance\pageno by \skippage

\def\topofcontents{\null\vfill
  \centerline{\titlefont Ker\TeX\ : rendu graphique X11 pour \MF}
  \vskip 1em
  \centerline{(�bauche)}
  \centerline{\$Id: x11.w,v 1.4 2016/01/31 08:29:37 tlaronde Exp $$}
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

This is the X11 implementation of the \MF\ routines, using only
standard X11 features without using even the Xt library.

\bigskip
Copyright \copydate\ \author. All rights reserved.

This software is provided ``as is'' without any warranty, under the
ker\TeX\ public licence.

\smallskip
\hrule
\medskip
Si le syst�me h�te offre un service de rendu graphique 2D, les
diverses incarnations \.{virmf} de \MF peuvent offrir la possibilit�
d'afficher un rendu � l'�cran des caract�res programm�s.

Cela est d�crit dans le programme de \MF\ dans la partie 27 : {\bf
Online graphic output} d'o� l'acronyme {\sl ogo} pour la biblioth�que.

Du point de vue de l'utilisateur, l'emploi des routines, si elles sont
disponibles, est d�crit dans le \MF book, chapitre 24.

Ceci est l'impl�mentation des routines de \MF\ d�volues en utilisant ce
que le syst�me X11 fournit de mani�re normalis�e (X11), sans m�me
utiliser Xt. 

\bigskip
Copyright \copydate\ \author. Tous droits r�serv�s.

Ce logiciel est fourni en l'�tat sans aucune garantie, sous la licence
publique de ker\TeX.

}

% format specifications for X11 strutures

@s Display char
@s Screen char
@s Window char
@s GC char
@s Pixmap char
@s XImage char


@** Vue d'ensemble.

Le rendu graphique se b�tit � partir de deux �l�ments. Premi�rement, une
fen�tre dans laquelle dessiner quelque chose. Deuxi�mement, le dessin
effectif de ce que nous voulons rendre dans cette fen�tre d�di�e.

@ \MF\ utilise le terme |screen| pour d�signer la portion 2D dans
laquelle il affiche car cet �cran est par la suite subdivis� en fen�tres
g�r�es par le code ind�pendant du syst�me (cette biblioth�que ne g�re
donc pas ces sous-fen�tres). La remarque est d'ailleurs faite paragraphe
571.

@ Le lien entre le code \MF\ ind�pendant du syst�me et la partie
d�pendante est fait par l'interm�diaire de certaines variables globales.

Les deux premi�res sont les dimensions de l'�cran. Ces valeurs peuvent
�tre particularis�es par l'utilisateur, sur la ligne de commande ou par
des variables d'environnement.

Un bool�en indique, apr�s initialisation, si l'�cran est
OK. Cette variable est export�e car l'utilisateur, sur le terminal, peut
fermer la fen�tre. � l'interception d'un tel �v�nement, nous mettrons �
jour le bool�en pour que les routines de modification du contenu ne
soient plus appel�es (les routines de la pr�sente biblioth�que ne 
v�rifient donc pas le bool�en ; cette v�rification est faite dans
le code \MF\ ind�pendant du syst�me).

Enfin, un vecteur de transition, manipul� par \MF,  sert � d�finir
ce qui doit �tre dessin�. Il est allou� en fonction des valeurs de
|screenwidth| et |screendepth|.

@<Globals@>=
int screenwidth = MF_SCREEN_WIDTH_DEFAULT;
int screendepth = MF_SCREEN_DEPTH_DEFAULT;
boolean screenOK =  false;
int *rowtransition;

@ Parce que ker\TeX\ a l'objectif de fournir la m�me chose, par
l'interm�diaire des m�mes commandes, sur des syst�mes diff�rents,
la fen�tre graphique sera minimale, sans menu, sans autonomie, et
sa gestion d�pendra du programme \MF, par la ligne de commande et
par l'environnement. Nous n'utilisons pas les ressources propres
(facult�s d'adaptation) du syst�me h�te graphique.

@* Initialisation de l'�cran.

L'initialisation comporte une partie qui est bien entendu d�pendante du
syst�me graphique h�te, et une partie g�n�rique : l'allocation du
vecteur de transition, qui d�pend de la taille effective de l'�cran,
mais qui ne d�pend pas du syst�me 2D.

Dans ce qui suit, nous tentons de mettre � part ce qui est ind�pendant
du syst�me graphique de ce qui en est d�pendant.

@c
#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
@<Host 2D headers@>@;
#include "pascal.h"
#include "ogo.h"
@<Globals@>@;

boolean
initscreen(void)
{
	if (screenwidth <= 0 || screendepth <= 0) {
		(void)fprintf(stderr, "The size of the screen (%d,%d) is invalid!\n",
			screenwidth, screendepth);
		return false;
	}
	@<Create and allocate host 2D resources; return |false| on error@>@;
	@<Allocate |rowtransition|; return |false| on error@>@;
	updatescreen(); /* initial blanking */

	return true;
}

@ L'allocation du vecteur de transition d�pend des tailles effectives
de l'�cran (le syst�me peut ne pas allouer ce qui a �t� demand�), mais
sinon le code ne d�pend pas du syst�me.

@<Allocate |rowtransition|; return |false| on error@>=
assert(screenwidth > 0);
if ( (rowtransition = (int *)malloc(screenwidth * sizeof(int))) == NULL)
	return false;

@ En cas de fermeture de l'�cran ou de tout autre probl�me, nous
commen�ons par invalider toute mise � jour de l'�cran et lib�rons 
le vecteur de transition.

@<Free all resources allocated and invalidate screen updates@>=
screenOK = false;
free(rowtransition);
rowtransition = NULL;

@ Pour X11, la proc�dure consiste � commencer par se connecter au
serveur, condition {\it sine qua non} pour pouvoir allouer des
ressources et afficher quelque chose.

Si cela r�ussit, on cr�e notre �cran (notre fen�tre dans la terminologie
X11) et on cr�e �galement une image de sauvegarde : tous les trac�s sont
faits dans l'image, et c'est cette image qui est affich�e.

Apr�s avoir affich� l'�cran \MF\ sur l'�cran X11, on d�marre par une
fen�tre vide (remplie de la couleur d'arri�re-plan).

Une fois la fen�tre cr��e et initialis�e, nous nous occuperons du dessin
par le biais d'une |Ximage| et d'un |bitmap|.

@<Host 2D headers@>=
#include <X11/Xlib.h>
#include <X11/Xutil.h> /* |XSizeHints| and window properties */
#include <X11/Xatom.h>

@ @<Create and allocate host 2D resources; return |false| on error@>=
@<Try to connect to the X11 server; return false on error@>@;
@<Create the |mfwin| X11 window@>@;
@<Retrieve |mfwin| attributes@>@;
@<Adjust |mfwin| attributes@>@;
@<Allocate the corresponding |gc|@>@;
@<Allocate the drawing into |mfwin| resources@>@;
XMapWindow(display, mfwin);

@ La connexion au serveur se fait, pour nous --- puisque, rappelons-le,
nous voulons une m�me exp�rience utilisateur quel que soit l'h�te ---,
via l'environnement. � l'utilisateur de d�finir correctement |DISPLAY|.

@<Globals@>=
static Display *display;
static int iscreen;
static Screen *screen;

@ @<Try to connect to the X11 server; return false on error@>=
if ( (display = XOpenDisplay(NULL)) == NULL ) {
	(void)fprintf(stderr, "%s: unable to connect to X11 server.\n",
		argv[0]);
	return false;
}
iscreen = DefaultScreen(display);
screen = DefaultScreenOfDisplay(display);

@ Pour X11, |screen| est le p�riph�rique graphique en entier, et une
portion de ce p�riph�rique dans laquelle tracer est une |Window| qui
peut recouvrir l'int�gralit� de l'�cran (mais les fen�tres s'empilent,
tandis que l'�cran est toujours unique).

L'identifiant de la fen�tre correspondant au |screen| de \MF\ sera donc 
|mfwin|.

@<Globals@>=
static Window mfwin;
static unsigned long bg, fg;

@ Si la largeur de l'�cran de \MF\ porte le nom |screenwidth|, la
hauteur de la fen�tre porte le nom |screendepth|, ce qui n'est pas le
nom g�n�ralement utilis� avec X11, o� la profondeur est li�e au nombre
de couleurs. En l'occurrence, c'est une profondeur, parce que les $y$
vont croissant de haut en bas : l'origine de la fen�tre est en haut �
gauche, ce qui correspond � la convention X11.

La fen�tre n'est qu'une fen�tre de rendu. Nous n'avons pas besoin de
curseur, de boutons, de menu d'autant que la fen�tre n'est pas une
application d�di�e qui g�rerait les �v�nements, mais est d�pendante de
l'application \MF. Nous n'utiliserons donc que les routines \.{XLIB}
sans m�me utiliser \.{Xt}.

Comme nous n'utilisons que deux couleurs contrastantes (qui ne sont pas
forc�ment du noir et du blanc), nous utilisons le visuel par d�faut de
la fen�tre racine et nous utilisons donc la routine de cr�ation
simplifi�e.

Nous cr�ons l'objet, mais rien n'est affich� pour l'instant.

@<Create the |mfwin| X11 window@>=
bg = WhitePixel(display, iscreen);
fg = BlackPixel(display, iscreen);
mfwin = XCreateSimpleWindow(display, RootWindow(display, iscreen),
	0, 0, screenwidth, screendepth, 4, fg, bg);

@ La fen�tre cr��e peut avoir, ou pas, les dimensions sp�cifi�es.

On r�cup�re la dimension affect�e.

@<Retrieve |mfwin| attributes@>=
{
XWindowAttributes mfwinattr;

if (XGetWindowAttributes(display, mfwin, &mfwinattr) == 0) {
	(void)fprintf(stderr, "%s: failed to get X11 window attributes.\n",
		argv[0]);
	return false;
}
screenwidth = mfwinattr.width;
screendepth = mfwinattr.height;
}

@ Qui plus est, comme cette fen�tre n'est, r�ellement, qu'en affichage,
et qu'elle est totalement d�pendante de \MF, la mise � jour de
l'affichage ne se fait qu'explicitement par l'appel des routines
utilisateur au niveau de \MF.

Si le serveur permet le |Backing Store|, autant l'utiliser.

Sinon, nous ne nous int�ressons qu'aux �v�nements de mise au jour ({\it
exposure}) et aux �v�nements de destruction de la fen�tre.

@<Adjust |mfwin| attributes@>=
{
XSetWindowAttributes setmfwinattr;

setmfwinattr.backing_store = Always;
setmfwinattr.save_under = True;
setmfwinattr.event_mask = ExposureMask | StructureNotifyMask;
XChangeWindowAttributes(display, mfwin, 
	CWBackingStore|CWSaveUnder|CWEventMask,
	&setmfwinattr);
}

@ Dans tous les cas, |updatescreen| devra ``profiter'' de son appel pour
traiter la queue des �v�nements s�lectionn�s ci-dessus. Mais il s'agit
d'une proc�dure appel�e � la demande : le traitement des �v�nements ne
doit donc pas bloquer.

@<Process the X11 events queue, setting |screenOK| to |false| if |mfwin|
disappeared@>=
{
XEvent event;

while (XCheckWindowEvent(display, mfwin, 
	ExposureMask|StructureNotifyMask, &event) == True) {
	switch (event.type) {
		case UnmapNotify:
			XDestroyWindow(display, mfwin);
			/* FALLTHRU */
		case DestroyNotify:
			@<Free all resources allocated and invalidate screen updates@>@;
			return;
			break;
		default:
			break;
	}
}
}

@ Pour dessiner dans la fen�tre, nous allouons sur le serveur un |gc|,
dont les param�tres sont basiques.

Nous s�lectionnons une �paisseur de ligne de $1$ car $0$ entra�ne
l'utilisation d'un algorithme rapide qui peut ne pas donner des
r�sultats tr�s fins. (Bien qu'en l'occurrence, cela n'ait aujourd'hui
pas d'importance compte tenu de notre usage.)

@<Globals@>=
static GC gc;

@ @<Allocate the corresponding |gc|@>=
{
XGCValues gcvalues;

gcvalues.foreground = fg;
gcvalues.background = bg;
gcvalues.function = GXcopy; /* default */
gcvalues.line_width = 1; /* 0 is simplified rendering */
gc = XCreateGC(display, mfwin,
	(GCFunction | GCForeground | GCBackground | GCLineWidth), &gcvalues);
}

@ La mise � jour de ce qui s'affiche dans la fen�tre sera la simple
copie d'une image, mise � jour ligne par ligne par |paintrow|, et
dont des portions rectangulaires auront �ventuellement �t� blanchies
par |blankrectangle|.

Pour l'instant, c'est un ``bitmap'' puisque nous n'utilisons que deux
couleurs (rappelons qu'elles ne sont pas obligatoirement le noir et le
blanc mais deux couleurs contrastantes pour le visuel utilis�).

En l'occurrence, pour �viter la lourdeur des �changes avec le serveur
quand nous composons, pixel par pixel, le dessin, une image (donc c�t�
client) sera utilis�e, cependant qu'un |bitmap| (|pixmap| de profondeur
1) sera allou� au niveau du serveur et sera recopi�e dans la fen�tre.

@ Nous allons donc allouer le correspondant au niveau du client du
bitmap, � savoir une |XImage|. Le vecteur de donn�es n'est pas cr�� ;
par contre, si le pointeur dans la structure n'est pas nil, la
destruction entra�ne la lib�ration du vecteur de donn�es.

@<Globals@>=
XImage *img;
int bytes_per_line;

@ Le vecteur sera allou� contin�ment, mais chaque ligne est bien entendu
un nombre entiers d'octets. Il faut donc arrondir � l'entier
imm�diatement sup�rieur ou �gal.

@<Allocate the drawing into |mfwin| resources@>=
bytes_per_line = (screenwidth + 7) / 8;
if ( ( (img = XCreateImage(display, DefaultVisual(display, iscreen),
	1, XYBitmap, 0, None, screenwidth, screendepth, 8, bytes_per_line))
	== NULL ) 
	|| ( (img->data = (char *)calloc((size_t) (bytes_per_line * screendepth),
	sizeof(char))) == NULL ) ) {
	(void)fprintf(stderr, "%s: unable to allocate X11 Ximage.\n",
		argv[0]);
	@<Free all resources allocated and invalidate screen updates@>@;
	return false;
}

@ @<Free all resources allocated and invalidate screen updates@>=
if (img != NULL) XDestroyImage(img); /* release data too if not nil */

@ La routine |updatescreen| va donc traiter les �v�n�ments en attente,
remettre � z�ro l'�cran (le blanchir), mettre � jour le masque |bitmap|
et remplir la fen�tre ``au pochoir''.

@c
void
updatescreen(void)
{
	@<Process the X11 events queue...@>@;
	XPutImage(display, mfwin, gc, img, 0, 0, 0, 0,
		screenwidth, screendepth);
	XFlush(display); /* since no input so not automatically done */
}

@* Les routines de dessin.

Les routines de dessin proprement dit ne d�pendent pas de l'affichage :
on compose l'image avant d'utiliser |updatescreen| pour mettre � jour
l'�cran (la fen�tre) \MF.

Les routines sont d�j� pour l'essentiel impl�ment�es en commentaire dans
le fichier WEB de \MF, et nous ne faisons qu'adapter pour des
manipulations de bits.

@d white '\0'
@d black '\1'

@ Blanchir un rectangle, c'est simplement mettre � $0$ les bits dans le
rectangle, se rappelant que la borne sup�rieure est exclue (voir le code
comment� dans \MF).

@c
void
blankrectangle(int left_col, int right_col, int top_row, int bot_row)
{
	int r, c;
	char *row;

	for (r = top_row; r < bot_row; ++r) {
		row = img->data + r * bytes_per_line;
		for (c = left_col; c < right_col; c++)
			row[c/8] &= ~(black << (c%8));
	}
}

@ Le vecteur de transition indique des intervalles altern�s : la
premi�re colonne ayant la couleur pass�e, la derni�re colonne ayant la
couleur pass�e (derni�re colonne exclue). Forc�ment, l'intervalle
suivant n'a pas la m�me couleur, ce pourquoi on �change.

@c
void
paintrow(int r, signed char b, int *a, int n)
{
	int k, c;
	char *row;

	row = img->data + r * bytes_per_line;
	k = 0;
	c = a[0]; /* start column */
	do {
		++k;
		do {
			row[c/8] = ( row[c/8] & ~(black << (c%8)) ) | (b << (c%8));
			c++;
		} while (c != a[k]);
		b = black - b; /* swap black<->white */
	} while (k != n);
}

@** Index.

Voici une liste des identifiants utilis�s et de leurs occurrences. Les
entr�es sous-lign�es indiquent l'endroit de leur d�finition.

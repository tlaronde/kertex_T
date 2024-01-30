% Une implémentation X11/Xt des routines OGO de METAFONT.
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
  \centerline{(Ébauche)}
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
Si le système hôte offre un service de rendu graphique 2D, les
diverses incarnations \.{virmf} de \MF peuvent offrir la possibilité
d'afficher un rendu à l'écran des caractères programmés.

Cela est décrit dans le programme de \MF\ dans la partie 27 : {\bf
Online graphic output} d'où l'acronyme {\sl ogo} pour la bibliothèque.

Du point de vue de l'utilisateur, l'emploi des routines, si elles sont
disponibles, est décrit dans le \MF book, chapitre 24.

Ceci est l'implémentation des routines de \MF\ dévolues en utilisant ce
que le système X11 fournit de manière normalisée (X11), sans même
utiliser Xt. 

\bigskip
Copyright \copydate\ \author. Tous droits réservés.

Ce logiciel est fourni en l'état sans aucune garantie, sous la licence
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

Le rendu graphique se bâtit à partir de deux éléments. Premièrement, une
fenêtre dans laquelle dessiner quelque chose. Deuxièmement, le dessin
effectif de ce que nous voulons rendre dans cette fenêtre dédiée.

@ \MF\ utilise le terme |screen| pour désigner la portion 2D dans
laquelle il affiche car cet écran est par la suite subdivisé en fenêtres
gérées par le code indépendant du système (cette bibliothèque ne gère
donc pas ces sous-fenêtres). La remarque est d'ailleurs faite paragraphe
571.

@ Le lien entre le code \MF\ indépendant du système et la partie
dépendante est fait par l'intermédiaire de certaines variables globales.

Les deux premières sont les dimensions de l'écran. Ces valeurs peuvent
être particularisées par l'utilisateur, sur la ligne de commande ou par
des variables d'environnement.

Un booléen indique, après initialisation, si l'écran est
OK. Cette variable est exportée car l'utilisateur, sur le terminal, peut
fermer la fenêtre. À l'interception d'un tel événement, nous mettrons à
jour le booléen pour que les routines de modification du contenu ne
soient plus appelées (les routines de la présente bibliothèque ne 
vérifient donc pas le booléen ; cette vérification est faite dans
le code \MF\ indépendant du système).

Enfin, un vecteur de transition, manipulé par \MF,  sert à définir
ce qui doit être dessiné. Il est alloué en fonction des valeurs de
|screenwidth| et |screendepth|.

@<Globals@>=
int screenwidth = MF_SCREEN_WIDTH_DEFAULT;
int screendepth = MF_SCREEN_DEPTH_DEFAULT;
boolean screenOK =  false;
int *rowtransition;

@ Parce que ker\TeX\ a l'objectif de fournir la même chose, par
l'intermédiaire des mêmes commandes, sur des systèmes différents,
la fenêtre graphique sera minimale, sans menu, sans autonomie, et
sa gestion dépendra du programme \MF, par la ligne de commande et
par l'environnement. Nous n'utilisons pas les ressources propres
(facultés d'adaptation) du système hôte graphique.

@* Initialisation de l'écran.

L'initialisation comporte une partie qui est bien entendu dépendante du
système graphique hôte, et une partie générique : l'allocation du
vecteur de transition, qui dépend de la taille effective de l'écran,
mais qui ne dépend pas du système 2D.

Dans ce qui suit, nous tentons de mettre à part ce qui est indépendant
du système graphique de ce qui en est dépendant.

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

@ L'allocation du vecteur de transition dépend des tailles effectives
de l'écran (le système peut ne pas allouer ce qui a été demandé), mais
sinon le code ne dépend pas du système.

@<Allocate |rowtransition|; return |false| on error@>=
assert(screenwidth > 0);
if ( (rowtransition = (int *)malloc(screenwidth * sizeof(int))) == NULL)
	return false;

@ En cas de fermeture de l'écran ou de tout autre problème, nous
commençons par invalider toute mise à jour de l'écran et libérons 
le vecteur de transition.

@<Free all resources allocated and invalidate screen updates@>=
screenOK = false;
free(rowtransition);
rowtransition = NULL;

@ Pour X11, la procédure consiste à commencer par se connecter au
serveur, condition {\it sine qua non} pour pouvoir allouer des
ressources et afficher quelque chose.

Si cela réussit, on crée notre écran (notre fenêtre dans la terminologie
X11) et on crée également une image de sauvegarde : tous les tracés sont
faits dans l'image, et c'est cette image qui est affichée.

Après avoir affiché l'écran \MF\ sur l'écran X11, on démarre par une
fenêtre vide (remplie de la couleur d'arrière-plan).

Une fois la fenêtre créée et initialisée, nous nous occuperons du dessin
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
nous voulons une même expérience utilisateur quel que soit l'hôte ---,
via l'environnement. À l'utilisateur de définir correctement |DISPLAY|.

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

@ Pour X11, |screen| est le périphérique graphique en entier, et une
portion de ce périphérique dans laquelle tracer est une |Window| qui
peut recouvrir l'intégralité de l'écran (mais les fenêtres s'empilent,
tandis que l'écran est toujours unique).

L'identifiant de la fenêtre correspondant au |screen| de \MF\ sera donc 
|mfwin|.

@<Globals@>=
static Window mfwin;
static unsigned long bg, fg;

@ Si la largeur de l'écran de \MF\ porte le nom |screenwidth|, la
hauteur de la fenêtre porte le nom |screendepth|, ce qui n'est pas le
nom généralement utilisé avec X11, où la profondeur est liée au nombre
de couleurs. En l'occurrence, c'est une profondeur, parce que les $y$
vont croissant de haut en bas : l'origine de la fenêtre est en haut à
gauche, ce qui correspond à la convention X11.

La fenêtre n'est qu'une fenêtre de rendu. Nous n'avons pas besoin de
curseur, de boutons, de menu d'autant que la fenêtre n'est pas une
application dédiée qui gérerait les événements, mais est dépendante de
l'application \MF. Nous n'utiliserons donc que les routines \.{XLIB}
sans même utiliser \.{Xt}.

Comme nous n'utilisons que deux couleurs contrastantes (qui ne sont pas
forcément du noir et du blanc), nous utilisons le visuel par défaut de
la fenêtre racine et nous utilisons donc la routine de création
simplifiée.

Nous créons l'objet, mais rien n'est affiché pour l'instant.

@<Create the |mfwin| X11 window@>=
bg = WhitePixel(display, iscreen);
fg = BlackPixel(display, iscreen);
mfwin = XCreateSimpleWindow(display, RootWindow(display, iscreen),
	0, 0, screenwidth, screendepth, 4, fg, bg);

@ La fenêtre créée peut avoir, ou pas, les dimensions spécifiées.

On récupère la dimension affectée.

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

@ Qui plus est, comme cette fenêtre n'est, réellement, qu'en affichage,
et qu'elle est totalement dépendante de \MF, la mise à jour de
l'affichage ne se fait qu'explicitement par l'appel des routines
utilisateur au niveau de \MF.

Si le serveur permet le |Backing Store|, autant l'utiliser.

Sinon, nous ne nous intéressons qu'aux événements de mise au jour ({\it
exposure}) et aux événements de destruction de la fenêtre.

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
traiter la queue des événements sélectionnés ci-dessus. Mais il s'agit
d'une procédure appelée à la demande : le traitement des événements ne
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

@ Pour dessiner dans la fenêtre, nous allouons sur le serveur un |gc|,
dont les paramètres sont basiques.

Nous sélectionnons une épaisseur de ligne de $1$ car $0$ entraîne
l'utilisation d'un algorithme rapide qui peut ne pas donner des
résultats très fins. (Bien qu'en l'occurrence, cela n'ait aujourd'hui
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

@ La mise à jour de ce qui s'affiche dans la fenêtre sera la simple
copie d'une image, mise à jour ligne par ligne par |paintrow|, et
dont des portions rectangulaires auront éventuellement été blanchies
par |blankrectangle|.

Pour l'instant, c'est un ``bitmap'' puisque nous n'utilisons que deux
couleurs (rappelons qu'elles ne sont pas obligatoirement le noir et le
blanc mais deux couleurs contrastantes pour le visuel utilisé).

En l'occurrence, pour éviter la lourdeur des échanges avec le serveur
quand nous composons, pixel par pixel, le dessin, une image (donc côté
client) sera utilisée, cependant qu'un |bitmap| (|pixmap| de profondeur
1) sera alloué au niveau du serveur et sera recopiée dans la fenêtre.

@ Nous allons donc allouer le correspondant au niveau du client du
bitmap, à savoir une |XImage|. Le vecteur de données n'est pas créé ;
par contre, si le pointeur dans la structure n'est pas nil, la
destruction entraîne la libération du vecteur de données.

@<Globals@>=
XImage *img;
int bytes_per_line;

@ Le vecteur sera alloué continûment, mais chaque ligne est bien entendu
un nombre entiers d'octets. Il faut donc arrondir à l'entier
immédiatement supérieur ou égal.

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

@ La routine |updatescreen| va donc traiter les événéments en attente,
remettre à zéro l'écran (le blanchir), mettre à jour le masque |bitmap|
et remplir la fenêtre ``au pochoir''.

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

Les routines de dessin proprement dit ne dépendent pas de l'affichage :
on compose l'image avant d'utiliser |updatescreen| pour mettre à jour
l'écran (la fenêtre) \MF.

Les routines sont déjà pour l'essentiel implémentées en commentaire dans
le fichier WEB de \MF, et nous ne faisons qu'adapter pour des
manipulations de bits.

@d white '\0'
@d black '\1'

@ Blanchir un rectangle, c'est simplement mettre à $0$ les bits dans le
rectangle, se rappelant que la borne supérieure est exclue (voir le code
commenté dans \MF).

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

@ Le vecteur de transition indique des intervalles alternés : la
première colonne ayant la couleur passée, la dernière colonne ayant la
couleur passée (dernière colonne exclue). Forcément, l'intervalle
suivant n'a pas la même couleur, ce pourquoi on échange.

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

Voici une liste des identifiants utilisés et de leurs occurrences. Les
entrées sous-lignées indiquent l'endroit de leur définition.

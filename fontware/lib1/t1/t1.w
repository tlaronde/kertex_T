% $Id: t1.w,v 1.3 2013/06/02 20:25:52 tlaronde Exp $

\def\author{Thierry LARONDE (tlaronde@@polynum.com)}

% Numbers have to be adjusted when binding all the doc together
\skippage=1
\def\contentspagenumber{\startpage}
\pageno=\contentspagenumber \advance\pageno by \skippage

\def\topofcontents{\null\vfill
  \centerline{\titlefont Manipulation des fontes au format Adobe T1.}
  \vskip 1em
  \centerline{(�bauche)}
  \centerline{\$Id: t1.w,v 1.3 2013/06/02 20:25:52 tlaronde Exp $$}
  \vskip 20pt
  \centerline{\mainfont \author}
  \vskip 20pt

% abstract will be included on first page

\centerline{\bf Abstract}
\medskip
This library implements the routines necessary to deal with Adobe Type 1
font format, accessed as downloadable files encoded in the IBM PC
format.
\smallskip
\hrule
\medskip
Cette biblioth�que impl�mente les routines n�cessaires � la
manipulation des fontes au format Type 1 d'Adobe, fontes disponibles
sous forme de fichier t�l�chargeable encod�s conform�ment au format IBM
PC.
}

% COPYRIGHT

@i role.iw

@* Impl�mentation.

L'implementation vise � permettre la manipulation des fontes. Elle
comprend la manipulation des formats encod�s, la manipulation du d�tail
des fontes, et la g�n�ration du code � ins�rer dans un fichier de
commandes PostScript.

@ Les diverses �tapes font l'objet de proc�dures sp�cifiques. La s�rie
des fontes est d�finie comme une s�rie de structures de gestion,
comprenant, entre autres, les indications permettant d'acc�der aux
diff�rents segments d'une fonte entrepos�e en PFB.

@<Local declarations@>=
typedef struct PFB_seg {
  unsigned int type;
  long offset;
  unsigned long size;
} PFB_seg;
typedef struct T1_fnt {
  unsigned int flags;
  char *fname;
  FILE *fp;
  unsigned int nseg;
  PFB_seg *seg;  /* a series of seg structures */
} T1_fnt;

@ @<Local definitions@>=
static unsigned int nfnt;
static T1_fnt *fnt;

@ @c
@<C headers@>@;
#include "t1.h"
@<Local declarations@>@;
@<Local definitions@>@;
@<Local prototypes@>@;
int t1flags;

@* Le format de fichier t�l�chargeable pour IBM PC.

Une fonte est sauvegard�e sous forme d'un fichier binaire, comportant
plusieurs segments.

La lecture de la fonte doit se faire s�quentiellement, puisque la taille
de chaque segment est d�finie par un enregistrement de taille fixe.

@ Chaque segment est introduit par un enregistrement de 6 octets tant
qu'il y a des donn�es, d'au moins 2 octets pour le segment sentinelle
indiquant la fin de fichier et comportant dans l'ordre :

\beginlistn
$1$ octet comportant le nombre magique ($128$) (requis);

$1$ octet d�finissant le type de segment (requis);

$4$ octets d�finissant la taille du segment en little endian (requis
sauf pour EOF).
\endlistn

suivi par le nombre d'octets d�fini constituant les donn�es. Ce nombre
est sur $4$ octets en {\it little endian}.

@<Local definitions@>=
#define SERIAL_EOF '\004' /* ctrl-D */

/* Macintosh POST unsupported */
#define POST_TYPE_COMMENT 0U
#define POST_TYPE_ASCII 1U
#define POST_TYPE_BINARY 2U
#define POST_TYPE_SEND_EOF 3U
#define POST_TYPE_MAC_DATA_FORK 4U
#define POST_TYPE_END_FONT 5U

/* IBM PC format */
#define PFB_MAGIC 128U
#define PFB_SEGREC_SIZE 6U
#define PFB_TYPE_ASCII 1U
#define PFB_MIN_SEGTYPE PFB_TYPE_ASCII
#define PFB_TYPE_BINARY 2U
#define PFB_TYPE_EOF 3U
#define PFB_MAX_SEGTYPE PFB_TYPE_EOF

@ @<Local prototypes@>=
static int pfbRecGet(FILE *fp);

@ Comme |fseek(3)| efface le marqueur de fin de fichier, il ne faut pas
l'invoquer, m�me avec un |datasize == 0|, si la sentinelle marquant la
fin est atteinte. La condition |datasize == 0|, apr�s l'invocation de
|pfbRecGet()|,  indique donc, pour la biblioth�que, la fin du fichier.

@<Local definitions@>=
static unsigned char segrec[PFB_SEGREC_SIZE];
#define SEGMAGIC segrec[0]
#define SEGTYPE segrec[1]
static char *segtype[4] = {
	NULL,
  "ascii",
  "binary",
	"end_of_font"
};
static size_t datasize;

@ Le traitement est donc simple puisqu'il est s�quentiel : la lecture de
l'enregistrement donne le type et la taille des �l�ments de donn�es, et
donc aussi le d�calage jusqu'� l'enregistrement suivant.

|datasize| n'est d�finie que si l'en-t�te est valide. Sinon, sa valeur
est ind�finie.

@c
int
pfbRecGet(FILE *fp)
{
unsigned int nread;

if (feof(fp)) return PFB_ERR_EOF;

errno = 0;
if ((nread = fread(segrec, 1U, PFB_SEGREC_SIZE, fp)) != PFB_SEGREC_SIZE) {
  if (nread == 2 && SEGTYPE == PFB_TYPE_EOF && feof(fp)) { 
    datasize = 0;
    if (t1flags & T1_FLAG_TRACE)
    (void) fprintf(stderr, "%% t1lib: Segment EOF reached.\n");
  return T1_SUCCESS;
  } else
    return (errno != 0) ? SYSERROR : PFB_ERR_RECORD;
}
if (SEGMAGIC != PFB_MAGIC) return PFB_ERR_FORMAT;
if (SEGTYPE < PFB_MIN_SEGTYPE || SEGTYPE > PFB_MAX_SEGTYPE) return PFB_ERR_SEGTYPE;
datasize = (size_t) (segrec[2] + (segrec[3] << 8) + (segrec[4] << 16)
  + (segrec[5] << 24));
if (t1flags & T1_FLAG_TRACE)
  (void) fprintf(stderr, "%% t1lib: Segment type `%s', size %zu.\n",
    segtype[SEGTYPE], datasize);

return T1_SUCCESS;
}

@ Une v�rification de base consiste � s'assurer que le PFB est une
s�quence correcte de segments.

On se contente de lire l'en-t�te, de v�rifier ses d�finitions, puis de
sauter � l'en-t�te suivant qui correspond au d�calage de la taille du
segment annonc� dans l'en-t�te.

@c
int
pfbCk(FILE *fp)
{
  int status;

  assert(fp != NULL);  /* caller's problem */

  if (fseek(fp, 0L, SEEK_SET) != 0) {
    status = SYSERROR;
    goto failed;
  }

  while (!feof(fp)) {
    if ((status = pfbRecGet(fp)) != T1_SUCCESS) {
      if (t1flags & T1_FLAG_TRACE)
        t1perror(status);
      return (status);
    }
    if (datasize == 0) break; /* fseek() spoils feof() */
    if (fseek(fp, (long) datasize, SEEK_CUR) != 0) {
      status = SYSERROR;
      goto failed;
    }
  }

  return T1_SUCCESS;

failed:
  if (t1flags & T1_FLAG_TRACE)
    t1perror(status);
  return (status);
}

@ Le traitement des donn�es des segments --- et non seulement de leur
en-t�te --- n�cessite de lire des octets. Nous ne ferons pas de
diff�rence entre l'ASCII et le binaire.

Qui plus est, comme l'utilisateur peut d�j� avoir manipul� le flot, nous
ne pouvons invoquer \lib{setvbuf}.

Nous nous contenterons de lire des blocs de |BUFSIZ| ou du reliquat, en
ne passant pas la fin du segment de donn�es.

@<Local definitions@>=
static char pfbbuf[BUFSIZ];

@ Le programme PostScript r�sultat est envoy� sur le flot |t1fpout|, qui
peut �tre d�fini par le code utilisateur appelant.

@<Local definitions@>=
FILE *t1fpout = stdout;

@ Un segment de type |PFB_TYPE_ASCII| est compos� de code PostScript 
qui peut �tre directement transmis � l'interpr�teur.

@<Send |datasize| ps code to the interpret@>=
{
size_t size, chunk_size;

size = datasize;

while (size != 0U) {
  chunk_size = (size > BUFSIZ) ? BUFSIZ : size;
  if ( fread(pfbbuf, 1U, chunk_size, fp) != chunk_size
    || fwrite(pfbbuf, 1U, chunk_size, t1fpout) != chunk_size ) {
    status = SYSERROR;
    goto failed;
  }
  size -= chunk_size;
}
}

@ Un segment binaire est simplement envoy� sur le flot de sortie, chaque
octet transcrit en hexadecimal.

Parce que l'utilisation de |fprintf()| serait trop co�teuse, on
transcrit directement, sur des lignes de $64$ caract�res (sans
compter le nul terminal ou le fin de ligne), que l'on
envoie alors sur le flot de sortie.

On remplit au maximum le tampon, avant de traiter le contenu par
s�quence de $32$ octets au maximum.

@<Send hexadecimal encoded |datasize| binary to the interpret@>=
{
#define NHEXA 64
const char hexadigit[] = "0123456789abcdef";
char line[NHEXA+1];
size_t size, chunk_size, ioctet;
unsigned int ihexdigit;

size = datasize;
ihexdigit = 0;

while (size != 0U) {
  chunk_size = (size > BUFSIZ) ? BUFSIZ : size;
  size -= chunk_size;
  if (fread(pfbbuf, 1U, chunk_size, fp) != chunk_size) {
    status = SYSERROR;
    goto failed;
  }
	for (ioctet = 0; ioctet < chunk_size; ++ioctet) {
		line[ihexdigit++] = hexadigit[((unsigned char)pfbbuf[ioctet]) >> 4];
		line[ihexdigit++] = hexadigit[pfbbuf[ioctet] & 0x0f];
		if ( ihexdigit == NHEXA
			|| (ioctet == (chunk_size - 1) && size == 0) ) {
			line[ihexdigit++] = '\n';
  		if (fwrite(line, 1U, ihexdigit, t1fpout) != ihexdigit) {
    		status = SYSERROR;
    		goto failed;
			}
			ihexdigit = 0;
		}
	}
}
}

@ L'envoi du PFB sur |t1fpout| reprend la lecture s�quentielle de
|pfbCk|, hormis que l'on traite les segments.

|PFB_TYPE_EOF| marque la fin de la fonte, mais ne g�n�re pas
l'envoi du marqueur. Quoi qu'il en soit, on arr�te l�.

@c
int
pfbSend(FILE *fp)
{
  int status;

  assert(fp != NULL);  /* caller's problem */

  if (fseek(fp, 0L, SEEK_SET) != 0) {
    status = SYSERROR;
    goto failed;
  }

  while (!feof(fp)) {
    if ((status = pfbRecGet(fp)) != T1_SUCCESS) {
      if (t1flags & T1_FLAG_TRACE)
        t1perror(status);
      return (status);
    }
    if (datasize == 0) break; /* fseek() spoils feof() */
		switch (SEGTYPE) {
			case PFB_TYPE_ASCII:
      	@<Send |datasize| ps code to the interpret@>@;
				break;
			case PFB_TYPE_BINARY:
				@<Send hexadecimal encoded |datasize| binary to the interpret@>@;
				break;
			case PFB_TYPE_EOF:
				return T1_SUCCESS;
				break;
			default:
				status = PFB_ERR_FORMAT;
				goto failed;
		}
  }

  return T1_SUCCESS;

failed:
  if (t1flags & T1_FLAG_TRACE)
    t1perror(status);
  return (status);
}

@* Gestion des messages d'erreur.

Nous regroupons l'ensemble ici, afin de pouvoir borner la plage
d'erreurs possible.

@<Exported declarations@>=
#define PFB_ERR_EOF 1
#define PFB_ERR_RECORD 2
#define PFB_ERR_FORMAT 3
#define PFB_ERR_SEGTYPE 4
#define T1_ERR_MAX 4

@ Les erreurs syst�mes sont renvoy�es comme valeur n�gative.

@<Local declarations@>=
#define SYSERROR -errno

@ @c
static char *errmsg[] = {
	"Everything is OK! my friend...",
	"EOF already reached.",
	"Incorrect file organization: unable to retrieve record header.",
	"Wrong file format (not PFB).",
	"Wrong segment type.",
	"This error number is invalid!"
};

void
t1perror(int errnum) {
  if (errnum >= T1_ERR_MAX) errnum = T1_ERR_MAX;
  (void) fprintf(stderr, "t1lib: error %d: %s\n", errnum,
	(errnum < 0) ? strerror(-errnum) : errmsg[errnum]);
}

@* D�pendances syst�me.

La biblioth�que ne fait que du traitement de texte, et doit �tre
ind�pendante du syst�me.

@<C headers@>=
#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

@i t1ck.iw

@** Index.

Les entr�es soulign�es indiquent la place de la d�finition.

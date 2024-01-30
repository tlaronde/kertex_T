/* Header for libogo, the Online Graphic Output routines for METAFONT.
   These are the 4 system dependent primitives that have to be
   implemented, perhaps by doing strictly nothing as in the dumb 2D
   type. See "METAFONT: The Program", part 27.

   C) 2012, 2016 Thierry Laronde <tlaronde@polynum.com>
   kerTeX licence.
   No guarantees.
 */
#ifndef OGO_H
#define OGO_H

extern int screenwidth;
#define MF_SCREEN_WIDTH_DEFAULT 500 /* mf plain screen_cols value */
extern int screendepth;
#define MF_SCREEN_DEPTH_DEFAULT 400 /* mf plain screen_rows value */

typedef int screenrow; /* originally bounded by screendepth */
typedef int screencol; /* originally bounded by screenwidth */
typedef signed char pixelcolor; /* originally only 0 or 1 */
extern int *rowtransition; /* screencol rowtransition[screencol] */

extern boolean initscreen(void);	/* to have or not to have */

extern boolean screenOK; /* is it legitimate to call |blank_rectangle|,
  |paint_row|, and |update_screen|? */

extern void updatescreen(void);
extern void blankrectangle(int left_col, int right_col, int top_row,
	int bot_row);
extern void paintrow(int r, signed char b, int *a, int n);

#endif /* OGO_H */


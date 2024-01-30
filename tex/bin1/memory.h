/*
 * Global data structures too hard to translate automatically from
 * Pascal.  This file is included from the change file in the change for
 * section 8.113.
 */

typedef union {
    struct {
	halfword rh, lh;
    } v;
    struct {
	halfword junk_space;	/* Make B0,B1 overlap LH in memory */
	quarterword B0, B1;
    } u;
} twohalves;
#define	b0field	u.B0
#define	b1field	u.B1
#define	b2field	u.B2
#define	b3field	u.B3
#define rhfield v.rh
#define lhfield v.lh

typedef struct {
    struct {
	quarterword B0;
	quarterword B1;
	quarterword B2;
	quarterword B3;
    } u;
} fourquarters;

typedef union {
    integer intfield;
    glueratio grfield;
    twohalves hhfield;
    fourquarters qqqqfield;
} memoryword;

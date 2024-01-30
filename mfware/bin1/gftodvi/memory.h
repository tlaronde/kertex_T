/* pp2rc(1) doesn't translate automatically structures; and doesn't
   handle an identifier as a triplet (name, type, scope). Hence, the
   structure is described in a header, and the members' names are
   redefined to some uniq identifiers (by uniqids(1)).
   Thierry Laronde, 2010-04-10.
 */
#define	b0field	u.B0
#define	b1field	u.B1
#define	b2field	u.B2
#define	b3field	u.B3
typedef struct {
    struct {
	quarterword B0;
	quarterword B1;
	quarterword B2;
	quarterword B3;
    } u;
} fourquarters;

typedef union {
   scaled scfield;
   fourquarters qqqqfield;
} memoryword;

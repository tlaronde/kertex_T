% This is the change file for kerTeX.
% 2011-12-25 Thierry Laronde <tlaronde@polynum.com>
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1] Change banner message
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
The ``banner line'' defined here should be changed whenever \.{CWEAVE}
is modified.

@d banner "This is CWEAVE (Version 3.65)\n"
@y
The ``banner line'' defined here should be changed whenever \.{CWEAVE}
is modified.

@d banner "This is CWEAVE (kerTeX C version 3.65)\n"
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [2] We impose standard C, so just use the standard C string routines
% header.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ We predeclare several standard system functions here instead of including
their system header files, because the names of the header files are not as
standard as the names of the functions. (For example, some \CEE/ environments
have \.{<string.h>} where others have \.{<strings.h>}.)

@<Predecl...@>=
extern int strlen(); /* length of string */
extern int strcmp(); /* compare strings lexicographically */
extern char* strcpy(); /* copy one string to another */
extern int strncmp(); /* compare up to $n$ string characters */
extern char* strncpy(); /* copy up to $n$ string characters */
@y
@ We use the standard C string routines.

@<Include...@>=
#include <string.h> /* |strlen|, |strcmp| and so on */
#define vstrcpy(a,b) (void)strcpy((char *)(a),(char *)(b))
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [3] Changing size of max filename according to stdio.h:FILENAME_MAX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@d max_file_name_length 60
@y
@d max_file_name_length FILENAME_MAX + 1
@z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [236] collate[] is declared as eigh_bits [] i.e. unsigned char; this
% shocks some compilers expecting signed char.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
We initialize |collate| by copying a few characters at a time, because
some \CEE/ compilers choke on long strings.

@<Set init...@>=
collate[0]=0;
strcpy(collate+1," \1\2\3\4\5\6\7\10\11\12\13\14\15\16\17");
/* 16 characters + 1 = 17 */
strcpy(collate+17,"\20\21\22\23\24\25\26\27\30\31\32\33\34\35\36\37");
/* 16 characters + 17 = 33 */
strcpy(collate+33,"!\42#$%&'()*+,-./:;<=>?@@[\\]^`{|}~_");
/* 32 characters + 33 = 65 */
strcpy(collate+65,"abcdefghijklmnopqrstuvwxyz0123456789");
/* (26 + 10) characters + 65 = 101 */
strcpy(collate+101,"\200\201\202\203\204\205\206\207\210\211\212\213\214\215\216\217");
/* 16 characters + 101 = 117 */
strcpy(collate+117,"\220\221\222\223\224\225\226\227\230\231\232\233\234\235\236\237");
/* 16 characters + 117 = 133 */
strcpy(collate+133,"\240\241\242\243\244\245\246\247\250\251\252\253\254\255\256\257");
/* 16 characters + 133 = 149 */
strcpy(collate+149,"\260\261\262\263\264\265\266\267\270\271\272\273\274\275\276\277");
/* 16 characters + 149 = 165 */
strcpy(collate+165,"\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316\317");
/* 16 characters + 165 = 181 */
strcpy(collate+181,"\320\321\322\323\324\325\326\327\330\331\332\333\334\335\336\337");
/* 16 characters + 181 = 197 */
strcpy(collate+197,"\340\341\342\343\344\345\346\347\350\351\352\353\354\355\356\357");
/* 16 characters + 197 = 213 */
strcpy(collate+213,"\360\361\362\363\364\365\366\367\370\371\372\373\374\375\376\377");
/* 16 characters + 213 = 229 */
@y
We initialize |collate| by copying a few characters at a time, because
some \CEE/ compilers choke on long strings.

@<Set init...@>=
collate[0]=0;
vstrcpy(collate+1," \1\2\3\4\5\6\7\10\11\12\13\14\15\16\17");
/* 16 characters + 1 = 17 */
vstrcpy(collate+17,"\20\21\22\23\24\25\26\27\30\31\32\33\34\35\36\37");
/* 16 characters + 17 = 33 */
vstrcpy(collate+33,"!\42#$%&'()*+,-./:;<=>?@@[\\]^`{|}~_");
/* 32 characters + 33 = 65 */
vstrcpy(collate+65,"abcdefghijklmnopqrstuvwxyz0123456789");
/* (26 + 10) characters + 65 = 101 */
vstrcpy(collate+101,"\200\201\202\203\204\205\206\207\210\211\212\213\214\215\216\217");
/* 16 characters + 101 = 117 */
vstrcpy(collate+117,"\220\221\222\223\224\225\226\227\230\231\232\233\234\235\236\237");
/* 16 characters + 117 = 133 */
vstrcpy(collate+133,"\240\241\242\243\244\245\246\247\250\251\252\253\254\255\256\257");
/* 16 characters + 133 = 149 */
vstrcpy(collate+149,"\260\261\262\263\264\265\266\267\270\271\272\273\274\275\276\277");
/* 16 characters + 149 = 165 */
vstrcpy(collate+165,"\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316\317");
/* 16 characters + 165 = 181 */
vstrcpy(collate+181,"\320\321\322\323\324\325\326\327\330\331\332\333\334\335\336\337");
/* 16 characters + 181 = 197 */
vstrcpy(collate+197,"\340\341\342\343\344\345\346\347\350\351\352\353\354\355\356\357");
/* 16 characters + 197 = 213 */
vstrcpy(collate+213,"\360\361\362\363\364\365\366\367\370\371\372\373\374\375\376\377");
/* 16 characters + 213 = 229 */
@z

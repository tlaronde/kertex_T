%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1.11] Screen compile-time constants. screen_width and screen_depth
% are now settable as arguments to virmf(1).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@!screen_width=1664; {number of pixels in each row of screen display}
@!screen_depth=1200; {number of pixels in each column of screen display}
@y
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [27.564] Screen (2D) support: this is implemented as a C external
% library, depending on the OS facilities (there may be none).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p function init_screen:boolean;
begin init_screen:=false;
end;
@#
procedure update_screen; {will be called only if |init_screen| returns |true|}
begin @!init wlog_ln('Calling UPDATESCREEN');@+tini {for testing only}
end;
@y
|init_screen| and |update_screen| are implemented in a system dependent
C external library.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [27.565] Since screen_depth and screen_width are variables, they can
% not be used as constant bounds. To be typedef'ed in supplementary 
% code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@<Types...@>=
@!screen_row=0..screen_depth; {a row number on the screen}
@!screen_col=0..screen_width; {a column number on the screen}
@!trans_spec=array[screen_col] of screen_col; {a transition spec, see below}
@!pixel_color=white..black; {specifies one of the two pixel values}
@y
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [27.567] blank_rectangle implemented in external C library.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p procedure blank_rectangle(@!left_col,@!right_col:screen_col;
  @!top_row,@!bot_row:screen_row);
var @!r:screen_row;
@!c:screen_col;
begin @{@+for r:=top_row to bot_row-1 do
  for c:=left_col to right_col-1 do
    screen_pixel[r,c]:=white;@+@}@/
@!init wlog_cr; {this will be done only after |init_screen=true|}
wlog_ln('Calling BLANKRECTANGLE(',left_col:1,',',
  right_col:1,',',top_row:1,',',bot_row:1,')');@+tini
end;
@y
|blank_rectangle| is implemented in a system dependent C external library.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [27.568] paint_row implemented in external C library.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@p procedure paint_row(@!r:screen_row;@!b:pixel_color;var @!a:trans_spec;
  @!n:screen_col);
var @!k:screen_col; {an index into |a|}
@!c:screen_col; {an index into |screen_pixel|}
begin @{@+k:=0; c:=a[0];
repeat incr(k);
  repeat screen_pixel[r,c]:=b; incr(c);
  until c=a[k];
  b:=black-b; {$|black|\swap|white|$}
  until k=n;@+@}@/
@!init wlog('Calling PAINTROW(',r:1,',',b:1,';');
  {this is done only after |init_screen=true|}
for k:=0 to n do
  begin wlog(a[k]:1); if k<>n then wlog(',');
  end;
wlog_ln(')');@+tini
end;
@y
|paint_row| is implemented in a system dependent C external library.
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [27.569] screen_OK.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ The remainder of \MF's screen routines are system-independent calls
on the four primitives just defined.

First we have a global boolean variable that tells if |init_screen|
has been called, and another one that tells if |init_screen| has
given a |true| response.

@<Glob...@>=
@!screen_started:boolean; {have the screen primitives been initialized?}
@!screen_OK:boolean; {is it legitimate to call |blank_rectangle|,
  |paint_row|, and |update_screen|?}
@y
@ The remainder of \MF's screen routines are system-independent calls
on the four primitives just defined.

First we have a global boolean variable that tells if |init_screen|
has been called, and another one that tells if |init_screen| has
given a |true| response.

But to be able to intercept a change (close) on the screen, |screen_OK|
is external (in C code).

@<Glob...@>=
@!screen_started:boolean; {have the screen primitives been initialized?}
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [27.579] Since the screen is of variable size, the transition array
% is variable and has to be allocated.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x
@ The transition-specification parameter to |paint_row| is always the same
array.

@<Glob...@>=
@!row_transition:trans_spec; {an array of |black|/|white| transitions}
@y
@ The transition-specification parameter to |paint_row| is always the same
array.

|row_transition| is defined externally and, since its size can be
customized by user, has to be dynamically allocated.
@z


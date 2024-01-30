%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [6.86] Adding an end-of-line (and the ellipsis) to batch_mode term
% logging too.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x [6] m.86 - normalize batch_mode output to term
print("OK, entering ");
case c of
"Q":begin print_esc("batchmode"); decr(selector);
  end;
"R":print_esc("nonstopmode");
"S":print_esc("scrollmode");
end; {there are no other cases}
print("..."); print_ln; update_terminal; return;
@y
print("OK, entering ");
case c of
"Q":print_esc("batchmode");
"R":print_esc("nonstopmode");
"S":print_esc("scrollmode");
end; {there are no other cases}
print("..."); print_ln;
if c="Q" then decr(selector);
update_terminal; return;
@z


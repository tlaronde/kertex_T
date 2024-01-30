% $Id: samplePlain.mp,v 1.1 2020/11/11 11:53:12 tlaronde Exp $

% This is a post-processing kerTeX mp2ps trick.
special "%\special{psfile=quixante.eps hoffset=111 voffset=90 hscale=25 vscale=25 }";

picture pix[];
pix0:=nullpicture;
pix1:=nullpicture;
pix2:=nullpicture;
u:=1bp;

% Example of TeX with graphics. From John Hobby's manual.
numeric ux, uy;
120ux=1.2in; 4uy=2.4in;
addto pix0 doublepath (0,4uy)--(0,0)--(120ux,0);
pickup pencircle scaled 1pt;
addto pix0 doublepath (0,uy){right}
	for ix=1 upto 8:
		..(15ix*ux, uy*2/(1+cosd 15ix))
	endfor;
addto pix0 also thelabel.bot(btex $x$ axis etex, (60ux,0));
addto pix0 also thelabel.lft(btex $y$ axis etex rotated 90, (0,2uy));
addto pix0 also thelabel.lft(btex $\displaystyle y={2\over1+\cos x}$ etex,
	(120ux,4uy));

% An example with color. Taken for John Hobby's manual.
h=2in; w=2.7in;
path p[], q[], pp;
for i=2 upto 4: ii:=i**2;
	p[i] = (w/ii,h){1,-ii}...(w/i,h/i)...(w,h/ii){ii,-1};
endfor
q0.5 = (0,0)--(w,0.5h);
q1.5 = (0,0)--(w/1.5,h);
pp = buildcycle(q0.5, p2, q1.5, p4);
addto pix1 contour pp withcolor (.6,.6,1.);
z0=center pp;
pix2:=thelabel(btex $f>0$ etex, z0);
addto pix1 contour bbox pix2 withcolor white;
addto pix1 also pix2;
addto pix1 doublepath q0.5;
addto pix1 doublepath p2;
addto pix1 doublepath q1.5;
addto pix1 doublepath p4;
linecap:=rounded;
pix2:=nullpicture;
pix2:=thelabel.top(btex $P$ etex, p2 intersectionpoint q0.5);
addto pix1 also pix2 withcolor red;
addto pix1 doublepath p2 intersectionpoint q0.5 withpen pencircle
	scaled 4;
pix2:=nullpicture;
pix2:=thelabel.rt(btex $Q$ etex, p2 intersectionpoint q1.5);
addto pix1 also pix2 withcolor red;
addto pix1 doublepath p2 intersectionpoint q1.5 withpen pencircle
	scaled 4;
pix2:=nullpicture;
pix2:=thelabel.lft(btex $R$ etex, p4 intersectionpoint q1.5);
addto pix1 also pix2 withcolor red;
addto pix1 doublepath p4 intersectionpoint q1.5 withpen pencircle
	scaled 4;
pix2:=nullpicture;
pix2:=thelabel.bot(btex $S$ etex, p4 intersectionpoint q0.5);
addto pix1 also pix2 withcolor red;
addto pix1 doublepath p4 intersectionpoint q0.5 withpen pencircle
	scaled 4;

% Also a John Hobby's example of boxes.
input boxes
vardef cuta(suffix a, b) expr p =
	drawarrow p cutbefore bpath.a cutafter bpath.b;
	point .5*length p of p
enddef;

vardef self@# expr p =
	cuta(@#,@#) @#.c{curl0}..@#.c+p..{curl0}@#.c enddef;


beginfig(1);
verbatimtex \def\stk#1#2{$\displaystyle{\matrix{#1\cr#2\cr}}$} etex
circleit.aa(btex\strut Start etex); aa.dx=aa.dy;
circleit.bb(btex \stk B{(a|b)^*a} etex);
circleit.cc(btex \stk C{b^*} etex);
circleit.dd(btex \stk D{(a|b)^*ab} etex);
circleit.ee(btex\strut Stop etex); ee.dx=ee.dy;
numeric hsep;
bb.c-aa.c = dd.c-bb.c = ee.c-dd.c = (hsep,0);
cc.c-bb.c = (0,.8hsep);
xpart(ee.e - aa.w) = 3.8in;
drawboxed(aa,bb,cc,dd,ee);
label.ulft(btex$b$etex, cuta(aa,cc) aa.c{dir50}..cc.c);
label.top(btex$b$etex, self.cc(0,30pt));
label.rt(btex$a$etex, cuta(cc,bb) cc.c..bb.c);
label.top(btex$a$etex, cuta(aa,bb) aa.c..bb.c);
label.llft(btex$a$etex, self.bb(-20pt,-35pt));
label.top(btex$b$etex, cuta(bb,dd) bb.c..dd.c);
label.top(btex$a$etex, cuta(dd,ee) dd.c..ee.c);
label.lrt(btex$a$etex, cuta(dd,bb) dd.c..{dir140}bb.c);
label.bot(btex$a$etex, cuta(ee,bb) ee.c..tension1.3 ..{dir115}bb.c);
label.urt(btex$b$etex, cuta(ee,cc) ee.c{(cc.c-ee.c)rotated-15}..cc.c);
draw pix0 scaled 0.7 shifted (170u,150u);
draw pix1 scaled 0.5 shifted (10u,170u);
endfig;

end

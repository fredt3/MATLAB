%%By: Fred Tidwell and Chima Uwazie
%%Anchors Aweigh

%Defining notes
cq = note10(40,.25);
ch = note10(40,.5);
cw = note10(40,1);
cdw = note10(40,2);
c3 = note10(40,.75);
uc3 = note10(52,.75);
ucw = note10(52,1);
ucdw = note10(52,2);
uch = note10(52,.5);
ucq = note10(52,.25);
lcw = note10(28,1);
lcdw = note10(28,2);
lch = note10(28,.5);

llbh = note10(27,.5);
bh = note10(51,.5);
lbq = note10(39,.25);
lbh = note10(39,.5);

gq = note10(47,.25);
ge = note10(47,.15);
gh = note10(47,.5);
gw = note10(47,1);
lgw = note10(35,1);
lge = note10(35,.15);
lgh = note10(35,.5);
lgq = note10(35,.25);
lgdw = note10(35,2);
lgsh = note10(36,.5);

aq = note10(49,.25);
ah = note10(49,.5);
aw = note10(49,1);
a3 = note10(49,.75);
lla3 = note10(37,.75);
llaq = note10(37,.25);
llaw = note10(37,1);


lllf3 = note10(21,.75);
lllfq = note10(21,.25);
lllfh = note10(21,.5);
lllfw = note10(21,1);
lfsh = note10(34,.5);
lfsq = note10(34,.25);
lfw = note10(33,1);
lfh = note10(33,.5);
llfh = note10(21,.5); 
fq = note10(45,.25);
fe = note10(45,.15);
fh = note10(45,.5);
fsh = note10(46,.5);
fsq = note10(46,.25);
fw = note10(45,1);
ufh = note10(57,.5);

eq = note10(44,.25);
ueq = note10(56,.25);
ueh = note10(56,.5);
ee = note10(44,.15);
e3 = note10(44,.75);
eh = note10(44,.5);
uew = note10(56,1);
uedw = note10(56,2);
ew = note10(44,1);
lew = note10(32,1);
leh = note10(32,.5);
le3 = note10(32,.75);
ledw = note10(32,2);

aw = note10(49,1);
lah = note10(37,.5);
llah = note10(25,.5);

de = note10(42,.15);
dq = note10(42,.25);
dh = note10(42,.5);
udh = note10(54,.5);
dw = note10(42,1);
ldh = note10(29,.5);


%Bass and Treble
b1 = [lew lgh leh le3 lbq lew le3 lgq ch ch lgdw lfw lfh lfh lfh lfh lgsh lah lah lfsh lah lah lgh lgh lfh ldh lew lgh leh le3 lbq lew lgw ch ch lgdw lfw lfh lfh lfh lfh lgsh lah ch lge lfsq lgq lbh lge lfsq lgq ledw];
b2 = [lcw lch llbh lla3 llaq llaw lllf3 lllfq lllfh lllfh lcw ldh leh lfh lch llah llfh lch lch lbh lah ldh ldh ldh lfsh lgh lgh lfh ldh lcw lch llbh lla3 llaq llaw lllfw lllfh lllfh lcw ldh leh lfh lch llah llfh lch lch lbh lah lch lge lfsq lgq lllfh lge lfsq lgq lcdw];
t2 = [lgw ch ch c3 cq cw e3 eq fh fh ew fh gh cw ch ch eh eh eh eh dh dh fsh dh dh gh fh dh cw ch ch c3 cq cw ew fh fh ew fh gh cw ch ch eh eh eh eh eh ge fsq gq lbh ge fsq gq cdw];
t1 = [cw eh gh a3 eq aw uc3 ucq ufh gh ucdw aw uch ah gh ah bh uch fsh ah udh uch bh gh fh dh cw eh gh a3 eq aw ucw ufh gh ucdw aw uch ah gh ah bh uch ueh ge fsq gq udh ge fsq gq ucdw]; 
noise = t1 + t2+ b1 + b2; %Combine
soundsc(noise,19200); %Play
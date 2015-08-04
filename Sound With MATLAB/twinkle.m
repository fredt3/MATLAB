function y = twinkle 

FS = 19200;

HALF = 1;
QUARTER = HALF/2;
EIGHTH = QUARTER/2;

a1 = note10(40,QUARTER); 
a2 = note10(40,QUARTER);
a3 = note10(47,QUARTER);
a4 = note10(47,QUARTER);
a5 = note10(49,QUARTER);
a6 = note10(49,QUARTER);
a7 = note10(47,HALF);
a8 = note10(45,QUARTER);
a9 = note10(45,QUARTER);
a10 = note10(44,QUARTER);
a11 = note10(44,QUARTER);

a12 = note10(42,QUARTER);
a13 = note10(42,QUARTER);
a14 = note10(40,HALF);
a15 = note10(47,QUARTER);
a16 = note10(47,QUARTER);
a17 = note10(45,QUARTER);
a18 = note10(45,QUARTER);
a19 = note10(44,QUARTER);
a20 = note10(44,QUARTER);
a21 = note10(42,HALF);

a22 = note10(47,QUARTER);
a23 = note10(47,QUARTER);
a24 = note10(45,QUARTER);
a25 = note10(45,QUARTER);
a26 = note10(44,QUARTER);
a27 = note10(44,EIGHTH);
a28 = note10(45,EIGHTH);
a29 = note10(44,QUARTER);
a30 = note10(42,QUARTER);
a31 = note10(40,QUARTER);
a32 = note10(40,QUARTER);
a33 = note10(47,QUARTER);
a34 = note10(47,QUARTER);

a35 = note10(49,QUARTER);
a36 = note10(49,QUARTER);
a37 = note10(47,HALF);
a38 = note10(45,QUARTER);
a39 = note10(45,QUARTER);
a40 = note10(44,QUARTER);
a41 = note10(44,QUARTER);
a42 = note10(42,QUARTER);
a43 = note10(42,EIGHTH);
a44 = note10(44,EIGHTH);
a45 = note10(40,HALF);

x = [a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16 a17 a18 a19 ...
    a20 a21 a22 a23 a24 a25 a26 a27 a28 a29 a30 a31 a32 a33 a34 a35 a36 ...
    a37 a38 a39 a40 a41 a42 a43 a44 a45];
y = [];
soundsc(x, FS);


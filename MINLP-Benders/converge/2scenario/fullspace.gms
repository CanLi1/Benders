Positive variables
qu,qv,u,v,up,vp;
Binary variables
y1,y2,z1,z2;
variables
obj;
Equations
e1,e2,e3,e4,e5, e6, e7, e8,e9,e12;
e1 .. qu =l= 2 * y1;
e2 .. qv =l= 3 * y2;
e3 .. up =l= qu;
e4 .. vp =l= qv;
e5 .. -log(1+u) + up =l=0;
e6 .. -log(1+v) + vp =l= 0;
e7 .. u =l= 10 * z1;
e8 .. v =l= 12 * z2;
e9 .. obj =e=  10 * y1 +14 * y2 + 15 * z1 + 12 * z1 +  2* (qu+qv) + 3* ( u + v) - 50 * (up + vp );
e12 .. u + v =l= 20;
model toy /all/;
toy.optfile=1;
solve toy using minlp minimizing obj;
display y1.l, y2.l, z1.l,z2.l, qu.l, qv.l, vp.l, up.l, u.l, v.l;

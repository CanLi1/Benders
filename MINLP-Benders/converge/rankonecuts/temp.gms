binary variables
x1,x2;
set
djc /1*2/;
binary variables
vx1(djc), vx2(djc), lambda(djc);
variables
dnorm;
equations
e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13;
e1(djc) .. 7*vx1(djc) + 8*vx2(djc) =l= 9 * lambda(djc);
e2(djc) .. 8 * vx1(djc) + 7 * vx2(djc) =l= 9 * lambda(djc);
e3(djc) .. vx1(djc) =l= lambda(djc);
e4(djc) .. vx2(djc) =l= lambda(djc);
e5 .. x1 =e= sum(djc, vx1(djc)) ;
e6 .. x2 =e= sum(djc, vx2(djc));
e7 .. vx1('1') =e= lambda('1');
e8 .. vx1('2') =e= 0;
e9 .. sum(djc, lambda(djc)) =e= 1;
e10 .. dnorm =g= x1 - 0.6;
e11 .. dnorm =g= 0.6 - x1;
e12 .. dnorm =g= x2 - 0.6;
e13 .. dnorm =g= 0.6 - x2;
model dis /e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13/;
option mip=gurobi;
solve dis using rmip minimizing dnorm;

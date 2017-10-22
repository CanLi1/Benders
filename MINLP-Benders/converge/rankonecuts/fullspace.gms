sets
w /w1*w2/;
Positive variables
qu,qv,u(w),v(w),up(w),vp(w);
Binary variables
y1,y2,z1,z2;
variables
obj, bobj;
sets
iter /1*10/
aiter(iter), citer(iter);
aiter(iter) = no;
citer(iter) = no;
parameters
qubar, qvbar,y1bar, y2bar, prob(w);
prob('w1') = 0.7;
prob('w2') = 0.3;
set 
freeze(w);
parameters
v1(iter,w), v2(iter,w),g(iter,w), qubar_record(iter), qvbar_record(iter), y1bar_record(iter), y2bar_record(iter), ub_record(iter), lb_record(iter), ub, lb;
alias (iter, iiter);
v1(iter,w) = 0;
v2(iter,w) = 0;
g(iter,w) = 0;

scalar
epsilon /1e-5/;
*uncertainty in the model 
parameters
d(w);
d('w1') = 20;
d('w2') = 15;

variables
yita(w), bsubobj;
Equations
e1,e2, bbound, b1,b2,t1,t2,t3,t4,oe3,oe4,oe5,oe6,oe7,oe8,oe12,oe13;
e1 .. qu =l= 2 * y1;
e2 .. qv =l= 3 * y2;
bbound .. bobj =g= 10 * y1 +14 * y2 - 500;
b1(w,iiter)$(aiter(iiter)) .. yita(w) =g=prob(w) *( 10 * y1 +14 * y2 )+ v1(iiter,w) * qu + v2(iiter,w) * qv + g(iiter,w);
b2 .. bobj =g= sum(w, yita(w));

model bendersmaster /e1,e2,bbound,b1,b2/;
set 
int /1*20/;
parameters
intu(int)
intv(int);
loop(int,
	intu(int) = power(1.15, ord(int) - 1) -1;
	intv(int) = power(1.15, ord(int) - 1) -1;
	);
*define benders subproblem
t1 .. qu =e= qubar;
t2 .. qv =e= qvbar;
t3 .. y1 =e= y1bar;
t4 .. y2 =e= y2bar;
oe3(w)$freeze(w) .. up(w) =l= qu;
oe4(w)$freeze(w) .. vp(w) =l= qv;
*oe5(w)$freeze(w) .. -log(1+u(w)) + up(w) =l=0;
oe5(w,int)$freeze(w) .. -log(1+intu(int)) - 1/(1+intu(int)) * ( u(w) - intu(int)) + up(w) =l=0;
*oe6(w)$freeze(w) .. -log(1+v(w)) + vp(w) =l= 0;
oe6(w,int)$freeze(w) .. -log(1+intv(int)) - 1/(1+intv(int)) * ( v(w) - intv(int)) + vp(w) =l=0;
oe7(w)$freeze(w) .. u(w) =l= 10 * z1(w);
oe8(w)$freeze(w) .. v(w) =l= 12 * z2(w);
oe12(w)$freeze(w) .. u(w) + v(w) =l= d(w);
oe13 .. bsubobj =e=sum(w, prob(w) * (15 * z1(w) + 12 * z1(w) +  2* (qu+qv) + 10 * y1 +14 * y2 + 3* ( u(w) + v(w)) - 50 * (up(w) + vp(w) )));
freeze(w) = yes;
model fullspace /e1,e2,oe3,oe4,oe5, oe6,oe7,oe8,oe12,oe13/;
option optcr = 0;
option optca=0;
option decimals=8;
solve fullspace using mip minimizing bsubobj;
display y1.l,y2.l,qu.l,qv.l,up.l,vp.l,u.l,v.l,z1.l,z2.l;










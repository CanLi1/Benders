Positive variables
qu,qv,u,v,up,vp;
Binary variables
y1,y2,z1,z2;
variables
obj, bobj;
sets
iter /1*10/
aiter(iter);
aiter(iter) = no;
parameters
qubar, qvbar,y1bar, y2bar;
parameters
v1(iter), v2(iter),g(iter), qubar_record(iter), qvbar_record(iter), y1bar_record(iter), y2bar_record(iter), ub_record(iter), lb_record(iter), ub, lb;
alias (iter, iiter);
v1(iter) = 0;
v2(iter) = 0;
g(iter) = 0;
sets
djc /1*4/;
scalar
epsilon /1e-5/;
Positive variables
lambda(djc), vqu(djc), vqv(djc), vy1(djc), vy2(djc), vz1(djc), vz2(djc), vu(djc), vv(djc), vup(djc), vvp(djc);
Equations
e1,e2,e3,e4,e5, e6, e7, e8,e9,e12, bbound, b1,t1,t2,t3,t4,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,ub1,ub2,ub3,ub4,ub5,ub6,ub7,ub8,ub9,ub10, set1,set2,set3,set4,set5,set6,set7,set8,oe3,oe4,oe5,oe6,oe7,oe8,oe12;
e1 .. qu =l= 2 * y1;
e2 .. qv =l= 3 * y2;
bbound .. bobj =g= 10 * y1 +14 * y2 - 500;
b1(iiter)$(aiter(iiter)) .. bobj =g= 10 * y1 +14 * y2 + v1(iiter) * qu + v2(iiter) * qv + g(iiter);
t1 .. qu =e= qubar;
t2 .. qv =e= qvbar;
t3 .. y1 =e= y1bar;
t4 .. y2 =e= y2bar;
oe3 .. up =l= qu;
oe4 .. vp =l= qv;
oe5 .. -log(1+u) + up =l=0;
oe6 .. -log(1+v) + vp =l= 0;
oe7 .. u =l= 10 * z1;
oe8 .. v =l= 12 * z2;
oe12 .. u + v =l= 20;
e3(djc) .. vup(djc) =l= vqu(djc);
e4(djc) .. vvp(djc) =l= vqv(djc);
e5(djc) .. -((1-epsilon) * lambda(djc) + epsilon) * log(1+vu(djc) / (( 1- epsilon)* lambda(djc) + epsilon)) + vup(djc) =l=0;
e6(djc) .. -((1-epsilon) * lambda(djc) + epsilon) * log(1+vv(djc) / (( 1- epsilon)* lambda(djc) + epsilon)) + vvp(djc) =l= 0;
e7(djc) .. vu(djc) =l= 10 * vz1(djc);
e8(djc) .. vv(djc) =l= 12 * vz2(djc);

e12(djc) .. vu(djc) + vv(djc) =l= 20 * lambda(djc);
s1 .. sum(djc, vqu(djc)) =e= qu;
s2 .. sum(djc, vqv(djc)) =e= qv;
s3 .. sum(djc, vy1(djc)) =e= y1;
s4 .. sum(djc, vy2(djc)) =e= y2;
s5 .. sum(djc, vup(djc)) =e= up;
s6 .. sum(djc, vvp(djc)) =e= vp;
s7 .. sum(djc, vv(djc)) =e= v;
s8 .. sum(djc, vu(djc)) =e= u;
s9 .. sum(djc, vz1(djc)) =e= z1;
s10 .. sum(djc, vz2(djc)) =e= z2;
s11 .. sum(djc, lambda(djc)) =e= 1;

ub1(djc) .. vqu(djc) =l= lambda(djc) * 2;
ub2(djc) .. vqv(djc) =l= lambda(djc) * 3;
ub3(djc) .. vy1(djc) =l= lambda(djc);
ub4(djc) .. vy2(djc) =l= lambda(djc);
ub5(djc) .. vup(djc) =l= lambda(djc) * 3;
ub6(djc) .. vvp(djc) =l= lambda(djc) * 3;
ub7(djc) .. vv(djc) =l= lambda(djc) * 12;
ub8(djc) .. vu(djc) =l= lambda(djc) * 10;
ub9(djc) .. vz1(djc) =l= lambda(djc);
ub10(djc) .. vz2(djc) =l= lambda(djc);
e9 .. obj =e=  10 * y1 +14 * y2 + 15 * z1 + 12 * z1 +  2* (qu+qv) + 3* ( u + v) - 50 * (up + vp );

set1 .. vz1('1') =e= lambda('1');
set2 .. vz1('2') =e= lambda('2');
set3 .. vz1('3') =e= 0;
set4 .. vz1('4') =e= 0;
set5 .. vz2('1') =e= lambda('1');
set6 .. vz2('2') =e= 0;
set7 .. vz2('3') =e= 0;
set8 .. vz2('4') =e= lambda('4');
option optcr = 0;
option optca =0;
  OPTION LIMROW = 0;
OPTION LIMCOL = 0;
model bendersmaster /e1,e2,b1, bbound/;
model ubsub /t1,t2,t3,t4,oe3,oe4,oe5,oe6,oe7,oe8,e9,oe12/;
model sub /t1,t2,t3,t4,e3,e4,e5,e6,e7,e8,e9,e12, s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,ub1,ub2,ub3,ub4,ub5,ub6,ub7,ub8,ub9,ub10,set1,set2,set3,set4,set5,set6,set7,set8 /;
ubsub.optfile=1;
ub = 0.1;
lb = -500;
qubar = 0;
qvbar = 0;
y1bar =0;
y2bar = 0;
	solve ubsub using minlp minimizing obj;
loop(iter,
	solve bendersmaster using mip minimizing bobj;
	lb_record(iter) = bobj.l;
	if(bobj.l gt lb,
		lb = bobj.l;
		);
	qubar = qu.l;
	qvbar = qv.l;
	y1bar = y1.l;
	y2bar = y2.l;
	qubar_record(iter) = qubar;
	qvbar_record(iter) = qvbar;
	y1bar_record(iter) = y1bar;
	y2bar_record(iter) = y2bar;

	solve ubsub using minlp minimizing obj;
	ub_record(iter) = obj.l;
	if(obj.l lt ub,
		ub = obj.l;
		);
	solve sub using rminlp minimizing obj;
	v1(iter) = t1.m;
	v2(iter) = t2.m;
	g(iter) = obj.l - y1bar * 10 - y2bar * 14 - t1.m * qubar - t2.m * qvbar;
	display t1.m,t2.m,t3.m,t4.m;
	if(lb gt ub * 1.0001,
	break;);
	aiter(iter) = yes;
	);
display qubar_record, qvbar_record, y1bar_record,y2bar_record, ub_record, lb_record;













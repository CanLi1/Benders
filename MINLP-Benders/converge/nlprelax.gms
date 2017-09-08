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
Equations
e1,e2,e3,e4,e5, e6, e7, e8,e9,e12, bbound, b1,t1,t2,t3,t4;
e1 .. qu =l= 2 * y1;
e2 .. qv =l= 3 * y2;
bbound .. bobj =g= 10 * y1 +14 * y2 - 500;
b1(iiter)$(aiter(iiter)) .. bobj =g= 10 * y1 +14 * y2 + v1(iiter) * qu + v2(iiter) * qv + g(iiter);
t1 .. qu =e= qubar;
t2 .. qv =e= qvbar;
t3 .. y1 =e= y1bar;
t4 .. y2 =e= y2bar;
e3 .. up =l= qu;
e4 .. vp =l= qv;
e5 .. -log(1+u) + up =l=0;
e6 .. -log(1+v) + vp =l= 0;
e7 .. u =l= 10 * z1;
e8 .. v =l= 12 * z2;
e9 .. obj =e=  10 * y1 +14 * y2 + 15 * z1 + 12 * z1 +  2* (qu+qv) + 3* ( u + v) - 50 * (up + vp );
e12 .. u + v =l= 20;
model bendersmaster /e1,e2,b1, bbound/;
model sub /t1,t2,t3,t4,e3,e4,e5,e6,e7,e8,e9,e12/;
sub.optfile=1;
ub = 0.1;
lb = -500;
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

	solve sub using minlp minimizing obj;
	ub_record(iter) = obj.l;
	if(obj.l lt ub,
		ub = obj.l;
		);
	solve sub using rminlp minimizing obj;
	v1(iter) = t1.m;
	v2(iter) = t2.m;
	g(iter) = obj.l - y1bar * 10 - y2bar * 14 - t1.m * qubar - t2.m * qvbar;
	display t1.m,t2.m,t3.m,t4.m;
	if(lb gt ub * 1.01,
	break;);
	aiter(iter) = yes;
	);
display qubar_record, qvbar_record, y1bar_record,y2bar_record, ub_record, lb_record;













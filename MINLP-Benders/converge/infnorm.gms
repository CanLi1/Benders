Positive variables
qu,qv,u,v,up,vp;
Binary variables
y1,y2,z1,z2;
variables
obj, bobj;
sets
iter /1*30/
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
djc /1*2/;
scalar
epsilon /1e-5/;
variables
alpha;
parameters
uhat, vhat, uphat, vphat, z1hat, z2hat,z1hat_record(iter), z2hat_record(iter);
Positive variables
lambda(djc), vqu(djc), vqv(djc), vy1(djc), vy2(djc), vz1(djc), vz2(djc), vu(djc), vv(djc), vup(djc), vvp(djc);
Equations
e1,e2,e3,e4,e5, e6, e7, e8,e9,e12, bbound, b1,t1,t2,t3,t4,s5,s6,s7,s8,s9,s10,s11,ub1,ub2,ub3,ub4,ub5,ub6,ub7,ub8,ub9,ub10, set1,set2,set3,set4,oe3,oe4,oe5,oe6,oe7,oe8,oe12;
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
e3(djc) .. vup(djc) =l= lambda(djc) * qubar;
e4(djc) .. vvp(djc) =l= lambda(djc) * qvbar;
e5(djc) .. -((1-epsilon) * lambda(djc) + epsilon) * log(1+vu(djc) / (( 1- epsilon)* lambda(djc) + epsilon)) + vup(djc) =l=0;
e6(djc) .. -((1-epsilon) * lambda(djc) + epsilon) * log(1+vv(djc) / (( 1- epsilon)* lambda(djc) + epsilon)) + vvp(djc) =l= 0;
e7(djc) .. vu(djc) =l= 10 * vz1(djc);
e8(djc) .. vv(djc) =l= 12 * vz2(djc);

e12(djc) .. vu(djc) + vv(djc) =l= 20 * lambda(djc);
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

set1 .. vz1('1') =e= 0;
set2 .. vz1('2') =e= lambda('2');
set3 .. vz2('1') =e= 0;
set4 .. vz2('2') =e= lambda('2');
Equations n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11, n12;
n1 .. alpha =g= z1hat - z1;
n2 .. alpha =g= z1 - z1hat;
n3 .. alpha =g= z2hat - z2;
n4 .. alpha =g= z2 - z2hat;
n5 .. alpha =g= (uhat - u ) / 10;
n6 .. alpha =g= (u-uhat) /10;
n7 .. alpha =g= (vhat - v) /12;
n8 .. alpha =g= (v - vhat) /12;
n9 .. alpha =g= (vp - vphat) / 3;
n10 .. alpha =g= (vphat - vp ) /3;
n11 .. alpha =g= (up - uphat) /3;
n12 .. alpha =g= (uphat - up ) /3;
parameters 
sign1z1, sign1z2,sign1u, sign1v, sign1u, sign1up, sign1vp, sign2z1, sign2z2,sign2u, sign2v, sign2u, sign2up, sign2vp,result1z1, result1z2,result1u, result1v, result1u, result1up, result1vp, result2z1, result2z2,result2u, result2v, result2u, result2up, result2vp, active_found;
Equations 
lp1, lp2;
lp1 .. sign1z1 * (z1 - result1z1) + sign1z2 * ( z2 - result1z2) + sign1u * ( u - result1u) + sign1v * ( u - result1v) + sign1up * (up - result1up) + sign1vp * (vp - result1vp) =g= 0;
lp2 .. sign2z1 * (z1 - result2z1) + sign2z2 * ( z2 - result2z2) + sign2u * ( u - result2u) + sign2v * ( u - result2v) + sign2up * (up - result2up) + sign2vp * (vp - result2vp) =g= 0;
option optcr = 0;
option optca =0;
  OPTION LIMROW = 0;
OPTION LIMCOL = 0;
option    solprint = on;
option sysout = off; 
model bendersmaster /e1,e2,b1, bbound/;
model ubsub /t1,t2,t3,t4,oe3,oe4,oe5,oe6,oe7,oe8,e9,oe12/;
model sep1 /e3,e4,e5,e6,e7,e8,e12, s5,s6,s7,s8,s9,s10,s11,ub1,ub2,ub3,ub4,ub5,ub6,ub7,ub8,ub9,ub10,set1,set2,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11, n12 /;
model sep2 /e3,e4,e5,e6,e7,e8,e12, s5,s6,s7,s8,s9,s10,s11,ub1,ub2,ub3,ub4,ub5,ub6,ub7,ub8,ub9,ub10,set3,set4,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11, n12 /;
model lpsub /t1,t2,t3,t4,oe3,oe4,oe5,oe6,oe7,oe8,e9,oe12, lp1, lp2/;
ubsub.optfile=1;
ub = 0.1;
lb = -500;
qubar = 0;
qvbar = 0;
y1bar =0;
y2bar = 0;
parameters
gap_closed(iter), sub_obj(iter), lpsub_obj(iter), sep1_stat_record(iter), sep2_stat_record(iter), sep1_alpha_record(iter), sep2_alpha_record(iter);
gap_closed(iter) = 0;
loop(iter,
	sign1z1=0 ;
	sign1z2 = 0;
	sign1u=0; 
	sign1v=0;
	sign1u=0;
	sign1up=0;
	sign1vp=0;
	sign2z1=0;
	sign2z2=0;
	sign2u=0;
	sign2v=0;
	sign2u=0;
	sign2up=0;
	sign2vp=0;
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
	solve ubsub using rminlp minimizing obj;
	sub_obj(iter) = obj.l;
	z1hat = z1.l;
	z2hat = z2.l;
	uhat = u.l;
	vhat = v.l;
	vphat = vp.l;
	uphat = up.l;
	z1hat_record(iter) = z1hat;
	z2hat_record(iter) = z2hat;
	solve sep1 using rminlp minimizing alpha;
	sep1_stat_record(iter) = sep1.modelstat;
	sep1_alpha_record(iter) = alpha.l;
	result1z1 = z1.l;
	result1z2 = z2.l;
	result1u = u.l;
	result1v = v.l;
	result1u = u.l;
	result1up = up.l;
	result1vp = vp.l;
	active_found = 0;
		display result1z1, result1z2, result1u, result1v, result1up, result1vp;
	display z1hat, z2hat, uhat, vhat, uphat, vphat;
	if(active_found eq 0,
	if(alpha.l eq z1.l - z1hat or alpha.l eq z1hat - z1.l,
		active_found = 1;
		sign1z1 = sign(z1.l - z1hat);

		);
	);

	if(active_found eq 0,
	if(alpha.l eq z2.l - z2hat or alpha.l eq z2hat - z2.l,
		active_found = 1;
		sign1z2 = sign(z2.l - z2hat);

		);
	);

	if(active_found eq 0,
		if(alpha.l eq (u.l - uhat)/10 or alpha.l eq (uhat - u.l)/10,
			active_found = 1;
			sign1u = sign(u.l - uhat);
			);
		);
	if(active_found eq 0,
		if(alpha.l eq (v.l - vhat)/12 or alpha.l eq (vhat - v.l)/12, 
			active_found = 1;
			sign1v = sign(v.l - vhat);
			);
		);
	if(active_found eq 0,
		if(alpha.l eq (up.l - uphat)/3 or alpha.l eq (uphat - up.l)/3,
			active_found = 1;
			sign1up = sign(up.l - uphat);
			);
		);
	if( active_found eq 0,
		if(alpha.l eq (vp.l - vphat)/3 or alpha.l eq (vphat - vp.l)/3,
			active_found = 1;
			sign1vp = sign(vp.l - vphat);
			);
		);

	solve sep2 using rminlp minimizing alpha;
	sep2_stat_record(iter) = sep2.modelstat;
	sep2_alpha_record(iter) = alpha.l;
	result2z1 = z1.l;
	result2z2 = z2.l;
	result2u = u.l;
	result2v = v.l;
	result2u = u.l;
	result2up = up.l;
	result2vp = vp.l;
	active_found = 0;
	display result2z1, result2z2, result2u, result2v, result2up, result2vp;
	display z1hat, z2hat, uhat, vhat, uphat, vphat;
	if(active_found eq 0,
	if(alpha.l eq z1.l - z1hat or alpha.l eq z1hat - z1.l,
		active_found = 1;
		sign2z1 = sign(z1.l - z1hat);

		);
	);

	if(active_found eq 0,
	if(alpha.l eq z2.l - z2hat or alpha.l eq z2hat - z2.l,
		active_found = 1;
		sign2z2 = sign(z2.l - z2hat);

		);
	);

	if(active_found eq 0,
		if(alpha.l eq (u.l - uhat)/10 or alpha.l eq (uhat - u.l)/10,
			active_found = 1;
			sign2u = sign(u.l - uhat);
			);
		);
	if(active_found eq 0,
		if(alpha.l eq (v.l - vhat)/12 or alpha.l eq (vhat - v.l)/12, 
			active_found = 1;
			sign2v = sign(v.l - vhat);
			);
		);
	if(active_found eq 0,
		if(alpha.l eq (up.l - uphat)/3 or alpha.l eq (uphat - up.l)/3,
			active_found = 1;
			sign2up = sign(up.l - uphat);
			);
		);
	if( active_found eq 0,
		if(alpha.l eq (vp.l - vphat)/3 or alpha.l eq (vphat - vp.l)/3,
			active_found = 1;
			sign2vp = sign(vp.l - vphat);
			);
		);
	solve lpsub using rminlp minimizing obj;
	lpsub_obj(iter) = obj.l;
	v1(iter) = t1.m;
	v2(iter) = t2.m;
	g(iter) = obj.l - y1bar * 10 - y2bar * 14 - t1.m * qubar - t2.m * qvbar;
	display t1.m,t2.m,t3.m,t4.m;
	if((ub_record(iter) - sub_obj(iter)) ne 0,
	gap_closed(iter) = 1- (ub_record(iter)-lpsub_obj(iter)) / (ub_record(iter) - sub_obj(iter)); 
	);
	if(lb gt ub * 1.0001,
	break;);
	aiter(iter) = yes;
	);
display qubar_record, qvbar_record, y1bar_record,y2bar_record, ub_record, lb_record, sub_obj, lpsub_obj, gap_closed, z1hat_record, z2hat_record, alpha.l, sep1_stat_record, sep2_stat_record;

display sep1_alpha_record, sep2_alpha_record;











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
v1(iter,w), v2(iter,w),muy1(iter,w), muy2(iter, w), g(iter,w), qubar_record(iter), qvbar_record(iter), y1bar_record(iter), y2bar_record(iter), ub_record(iter), lb_record(iter), ub, lb;
alias (iter, iiter);
v1(iter,w) = 0;
v2(iter,w) = 0;
muy1(iter,w) = 0;
muy2(iter,w) = 0;
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
b1(w,iiter)$(aiter(iiter)) .. yita(w) =g=muy1(iiter,w)*y1 + muy2(iiter,w)*y2+ v1(iiter,w) * qu + v2(iiter,w) * qv + g(iiter,w);
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
oe13(w)$freeze(w) .. bsubobj =e= prob(w) * (15 * z1(w) + 12 * z1(w) + 10 * y1 +14 * y2+ 2* (qu+qv) + 3* ( u(w) + v(w)) - 50 * (up(w) + vp(w) ));
model bendersub /t1,t2,t3,t4,oe3,oe4,oe5, oe6,oe7,oe8,oe12,oe13/;

*define cut generating linear program 
sets
djc /1*2/;
Positive variables
lambda(djc), vqu(djc), vqv(djc), vy1(djc), vy2(djc), vz1(djc,w), vz2(djc,w), vu(djc,w), vv(djc,w), vup(djc,w), vvp(djc,w);

Equations
s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,ub1,ub2,ub3,ub4,ub5,ub6,ub7,ub8,ub9,ub10, de1, de2,de3,de4,de5,de6,de7,de8,de12,set1,set2,set3,set4;
s1 .. sum(djc, vqu(djc)) =e= qu;
s2 .. sum(djc, vqv(djc)) =e= qv;
s3 .. sum(djc, vy1(djc)) =e= y1;
s4 .. sum(djc, vy2(djc)) =e= y2;
s5(w)$freeze(w) .. sum(djc, vup(djc,w)) =e= up(w);
s6(w)$freeze(w) .. sum(djc, vvp(djc,w)) =e= vp(w);
s7(w)$freeze(w) .. sum(djc, vv(djc,w)) =e= v(w);
s8(w)$freeze(w) .. sum(djc, vu(djc,w)) =e= u(w);
s9(w)$freeze(w) .. sum(djc, vz1(djc,w)) =e= z1(w);
s10(w)$freeze(w) .. sum(djc, vz2(djc,w)) =e= z2(w);
s11 .. sum(djc, lambda(djc)) =e= 1;

ub1(djc) .. vqu(djc) =l= lambda(djc) * 2;
ub2(djc) .. vqv(djc) =l= lambda(djc) * 3;
ub3(djc) .. vy1(djc) =l= lambda(djc);
ub4(djc) .. vy2(djc) =l= lambda(djc);
ub5(djc,w)$freeze(w) .. vup(djc,w) =l= lambda(djc) * 3;
ub6(djc,w)$freeze(w) .. vvp(djc,w) =l= lambda(djc) * 3;
ub7(djc,w)$freeze(w) .. vv(djc,w) =l= lambda(djc) * 12;
ub8(djc,w)$freeze(w) .. vu(djc,w) =l= lambda(djc) * 10;
ub9(djc,w)$freeze(w) .. vz1(djc,w) =l= lambda(djc);
ub10(djc,w)$freeze(w) .. vz2(djc,w) =l= lambda(djc);

de1(djc) .. vqu(djc) =l= 2 * vy1(djc);
de2(djc) .. vqv(djc) =l= 3 * vy2(djc);
de3(djc,w)$freeze(w) .. vup(djc,w) =l= vqu(djc);
de4(djc,w)$freeze(w) .. vvp(djc,w) =l= vqv(djc);
*de5(djc,w)$freeze(w) .. -((1-epsilon) * lambda(djc) + epsilon) * log(1+vu(djc,w) / (( 1- epsilon)* lambda(djc) + epsilon)) + vup(djc,w) =l=0;
de5(djc,w,int)$freeze(w) .. -log(1+intu(int)) * lambda(djc) - 1/(1+intu(int)) * ( vu(djc,w) - intu(int) * lambda(djc)) + vup(djc,w) =l=0;
*de6(djc,w)$freeze(w) .. -((1-epsilon) * lambda(djc) + epsilon) * log(1+vv(djc,w) / (( 1- epsilon)* lambda(djc) + epsilon)) + vvp(djc,w) =l= 0;
de6(djc,w,int)$freeze(w) .. -log(1+intv(int)) * lambda(djc) - 1/(1+intv(int)) * ( vv(djc,w) - intv(int) * lambda(djc)) + vvp(djc,w) =l=0;
de7(djc,w)$freeze(w) .. vu(djc,w) =l= 10 * vz1(djc,w);
de8(djc,w)$freeze(w) .. vv(djc,w) =l= 12 * vz2(djc,w);
de12(djc,w)$freeze(w) .. vu(djc, w) + vv(djc, w) =l= d(w) * lambda(djc);

set1(w)$freeze(w) .. vz1('1',w) =e= lambda('1');
set2(w)$freeze(w) .. vz1('2',w) =e= 0;
set3(w)$freeze(w) .. vz2('1',w) =e= lambda('1');
set4(w)$freeze(w) .. vz2('2',w) =e= 0;

*define fractional variables
parameters
y1hat(iter)
y2hat(iter)
quhat(iter)
qvhat(iter)
vhat(iter, w)
uhat(iter, w)
vphat(iter,w)
uphat(iter,w)
z1hat(iter,w)
z2hat(iter,w)
;
y1hat(iter)	=0;
y2hat(iter)	=0;
quhat(iter)	=0;
qvhat(iter)	=0;
vhat(iter, w)	=0;
uhat(iter, w)	=0;
vphat(iter,w)	=0;
uphat(iter,w)	=0;
z1hat(iter,w)	=0;
z2hat(iter,w)	=0;
Positive variables
ay1,ay2,aqu,aqv,av(w),au(w),avp(w),aup(w),az1(w),az2(w);
variables
dnorm;
*define equations for 1-norm
equations
n1p,n1m,n2p,n2m,n3p,n3m,n4p,n4m,n5p,n5m,n6p,n6m,n7p,n7m,n8p,n8m,n9p,n9m,n10p,n10m,dobj;

n1p(iiter)$citer(iiter) .. ay1 =g= y1 - y1hat(iiter);
n1m(iiter)$citer(iiter) .. ay1 =g= y1hat(iiter) - y1;
n2p(iiter)$citer(iiter) .. ay2 =g= y2 - y2hat(iiter);
n2m(iiter)$citer(iiter) .. ay2 =g= y2hat(iiter) - y2;
n3p(iiter)$citer(iiter) .. aqu =g= (qu - quhat(iiter))/2;
n3m(iiter)$citer(iiter) .. aqu =g= (quhat(iiter) - qu)/2;
n4p(iiter)$citer(iiter) .. aqv =g= (qv - qvhat(iiter))/3;
n4m(iiter)$citer(iiter) .. aqv =g= (qvhat(iiter) - qv)/3;
n5p(iiter,w)$(citer(iiter) and freeze(w)) .. av(w) =g= (v(w) - vhat(iiter, w))/12;
n5m(iiter,w)$(citer(iiter) and freeze(w)) .. av(w) =g= (vhat(iiter,w) - v(w))/12;
n6p(iiter,w)$(citer(iiter) and freeze(w)) .. au(w) =g= (u(w) - uhat(iiter,w))/10;
n6m(iiter,w)$(citer(iiter) and freeze(w)) .. au(w) =g= (uhat(iiter,w) - u(w))/10;
n7p(iiter,w)$(citer(iiter) and freeze(w)) .. avp(w) =g= (vp(w) - vphat(iiter,w))/3;
n7m(iiter,w)$(citer(iiter) and freeze(w)) .. avp(w) =g= (vphat(iiter, w) - vp(w))/3;
n8p(iiter,w)$(citer(iiter) and freeze(w)) .. aup(w) =g= (up(w) - uphat(iiter,w))/3;
n8m(iiter,w)$(citer(iiter) and freeze(w)) .. aup(w) =g= (uphat(iiter,w) - up(w))/3;
n9p(iiter,w)$(citer(iiter) and freeze(w)) .. az1(w) =g= z1(w) - z1hat(iiter,w);
n9m(iiter,w)$(citer(iiter) and freeze(w)) .. az1(w) =g= z1hat(iiter,w) - z1(w);
n10p(iiter,w)$(citer(iiter) and freeze(w)) .. az2(w) =g= z2(w) - z2hat(iiter,w);
n10m(iiter,w)$(citer(iiter) and freeze(w)) .. az2(w) =g= z2hat(iiter,w) - z2(w);
dobj(w)$freeze(w) .. dnorm =e= ay1+ay2+aqu+aqv+av(w)+au(w)+avp(w)+aup(w)+az1(w)+az2(w);
model sep1 /s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,ub1,ub2,ub3,ub4,ub5,ub6,ub7,ub8,ub9,ub10,de1, de2,de3,de4,de5,de6, de7,de8,de12,set1,set2,n1p,n1m,n2p,n2m,n3p,n3m,n4p,n4m,n5p,n5m,n6p,n6m,n7p,n7m,n8p,n8m,n9p,n9m,n10p,n10m,dobj/;
model sep2 /s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,ub1,ub2,ub3,ub4,ub5,ub6,ub7,ub8,ub9,ub10, de1, de2,de3,de4,de5,de6,de7,de8,de12,set3,set4,n1p,n1m,n2p,n2m,n3p,n3m,n4p,n4m,n5p,n5m,n6p,n6m,n7p,n7m,n8p,n8m,n9p,n9m,n10p,n10m,dobj/;


sets 
as1(iter,w)
as2(iter,w);
as1(iter,w) = no;
as2(iter,w) = no;

equations 
lp1,lp2,clp1,clp2,clp3;
variables
stat1(iter,w), stat2(iter,w), stat3;
parameters
dy1s1(iter,w), dy2s1(iter,w), dqus1(iter,w), dqvs1(iter,w), dvs1(iter,w), dus1(iter,w), dups1(iter,w), dvps1(iter,w),dz1s1(iter,w),dz2s1(iter,w), dconsts1(iter,w);
parameters
dy1s2(iter,w), dy2s2(iter,w), dqus2(iter,w), dqvs2(iter,w), dvs2(iter,w), dus2(iter,w), dups2(iter,w), dvps2(iter,w),dz1s2(iter,w),dz2s2(iter,w), dconsts2(iter,w);
dy1s1(iter,w)=0;
dy2s1(iter,w)=0;
dqus1(iter,w)=0;
dqvs1(iter,w)=0;
dvs1(iter,w)=0;
dus1(iter,w)=0;
dups1(iter,w)=0;
dvps1(iter,w)=0;
dz1s1(iter,w)=0;
dz2s1(iter,w)=0;
dconsts1(iter,w)=0;
dy1s2(iter,w)=0;
dy2s2(iter,w)=0;
dqus2(iter,w)=0;
dqvs2(iter,w)=0;
dvs2(iter,w)=0;
dus2(iter,w)=0;
dups2(iter,w)=0;
dvps2(iter,w)=0;
dz1s2(iter,w)=0;
dz2s2(iter,w)=0;
dconsts2(iter,w)=0;
parameters
oy1,oy2,oqu,oqv,oz1(w),oz2(w),ou(w),ov(w),oup(w), ovp(w);
oy1=1;
oy2=1;
oqu=2;
oqv= 2.56618151;
oz1(w)=1;
oz2(w)=1;
ou('w1')=6.38231595;
ou('w2')=6.38231595;
ov('w1')=12.00000000;
ov('w2')=8.61768405;
oup(w)=2;
ovp('w1')=2.56618151;
ovp('w2')=2.26398267;
lp1(iiter,w)$(freeze(w) and as1(iiter,w)) .. dy1s1(iiter,w) * y1 + dy2s1(iiter,w)  * y2 + dqus1(iiter,w) * qu + dqvs1(iiter,w) * qv + dus1(iiter,w) * u(w) + dvs1(iiter,w) * v(w) + dups1(iiter,w) * up(w) + dvps1(iiter,w) * vp(w) + dz1s1(iiter,w) * z1(w) + dz2s1(iiter,w) * z2(w) + dconsts1(iiter,w) =l= 0;
lp2(iiter,w)$(freeze(w) and as2(iiter,w)) .. dy1s2(iiter,w) * y1 + dy2s2(iiter,w)  * y2 + dqus2(iiter,w) * qu + dqvs2(iiter,w) * qv + dus2(iiter,w) * u(w) + dvs2(iiter,w) * v(w) + dups2(iiter,w) * up(w) + dvps2(iiter,w) * vp(w) + dz1s2(iiter,w) * z1(w) + dz2s2(iiter,w) * z2(w) + dconsts2(iiter,w) =l= 0;
clp1(iiter,w)$(freeze(w) and as1(iiter,w)) .. dy1s1(iiter,w) * oy1 + dy2s1(iiter,w)  * oy2 + dqus1(iiter,w) * oqu + dqvs1(iiter,w) * oqv + dus1(iiter,w) * ou(w) + dvs1(iiter,w) * ov(w) + dups1(iiter,w) * oup(w) + dvps1(iiter,w) * ovp(w) + dz1s1(iiter,w) * oz1(w) + dz2s1(iiter,w) * oz2(w) + dconsts1(iiter,w) =e= stat1(iiter,w);
clp2(iiter,w)$(freeze(w) and as2(iiter,w)) .. dy1s2(iiter,w) * oy1 + dy2s2(iiter,w)  * oy2 + dqus2(iiter,w) * oqu + dqvs2(iiter,w) * oqv + dus2(iiter,w) * ou(w) + dvs2(iiter,w) * ov(w) + dups2(iiter,w) * oup(w) + dvps2(iiter,w) * ovp(w) + dz1s2(iiter,w) * oz1(w) + dz2s2(iiter,w) * oz2(w) + dconsts2(iiter,w) =e= stat2(iiter,w);
clp3 .. stat3 =g= 1;
model lpsub /t1,t2,t3,t4,oe3,oe4,oe5, oe6,oe7,oe8,oe12,lp1,lp2,oe13/;
model checkstat /clp1,clp2, clp3/;
alias(w,w3);

*the record for all objectives
parameters
bendersub_obj(iter,w)
lpsub_obj(iter,w)
ub_obj(iter,w)
beforelp_obj(iter, w)
bendermaster_obj(iter)
bendersub_stat(iter, w)
lpsub_stat(iter, w)
ub_stat(iter,w)
bendersmaster_stat(iter);
option threads = 12;
option optca = 0;
option optcr = 0;
loop(iter,
citer(iiter) = no;
citer(iter) = yes;

*solve bedners master problem to obtain first stage decisions
solve bendersmaster using mip minimizing bobj;
bendersmaster_stat(iter) = bendersmaster.modelstat;
bendermaster_obj(iter) = bobj.l;
y1hat(iter) = y1.l;
y2hat(iter) = y2.l;
quhat(iter) = qu.l;
qvhat(iter) = qv.l;
y1bar = y1.l;
y2bar = y2.l;
qubar = qu.l;
qvbar = qv.l;

*solve upper bound subproblem
loop(w3,
	freeze(w) = no;
	freeze(w3) = yes;
	solve bendersub using mip minimizing bsubobj;
	ub_stat(iter,w3) = bendersub.modelstat;
	ub_obj(iter, w3) = bsubobj.l;
	);

*solve the relaxed NLP
loop(w3,
	freeze(w) = no;
	freeze(w3) = yes;
	solve lpsub using rmip minimizing bsubobj;
	bendersub_stat(iter,w3) = lpsub.modelstat;
	bendersub_obj(iter, w3) = bsubobj.l;
	vhat(iter, w3) = v.l(w3);
	uhat(iter,w3) = u.l(w3);
	vphat(iter,w3) = vp.l(w3);
	uphat(iter,w3) = up.l(w3);
	z1hat(iter,w3) = z1.l(w3);
	z2hat(iter,w3) = z2.l(w3);
	);


*solve CGLP
loop(w3,
	freeze(w) = no;
	freeze(w3) = yes;
	solve sep1 using rmip minimizing dnorm;
	if(dnorm.l gt 1e-2,
		dqus1(iiter,w3) = s1.m;
		dqvs1(iiter,w3) = s2.m;
		dy1s1(iiter,w3) = s3.m;
		dy2s1(iiter,w3) = s4.m;
		dups1(iiter,w3) = s5.m(w3);
		dvps1(iiter,w3) = s6.m(w3);
		dvs1(iiter,w3) = s7.m(w3);
		dus1(iiter,w3) = s8.m(w3);
		dz1s1(iiter,w3) = s9.m(w3);
		dz2s1(iiter,w3) = s10.m(w3);
		dconsts1(iiter,w3) = s11.m;
		as1(iter,w3) = yes;
		);
	solve sep2 using rmip minimizing dnorm;	
	if(dnorm.l gt 1e-2,
		as2(iter,w3) = yes;
		dqus2(iiter,w3) = s1.m;
		dqvs2(iiter,w3) = s2.m;
		dy1s2(iiter,w3) = s3.m;
		dy2s2(iiter,w3) = s4.m;
		dups2(iiter,w3) = s5.m(w3);
		dvps2(iiter,w3) = s6.m(w3);
		dvs2(iiter,w3) = s7.m(w3);
		dus2(iiter,w3) = s8.m(w3);
		dz1s2(iiter,w3) = s9.m(w3);
		dz2s2(iiter,w3) = s10.m(w3);
		dconsts2(iiter,w3) = s11.m;
		);
	);

*solve the strengthened benders
loop(w3,
	freeze(w) = no;
	freeze(w3) = yes;
	solve lpsub using rmip minimizing bsubobj;
	lpsub_stat(iter,w3) = lpsub.modelstat;
	lpsub_obj(iter,w3) = bsubobj.l;
	v1(iter,w3) = t1.m;
	v2(iter,w3) = t2.m;
	muy1(iter,w3) = t3.m;
	muy2(iter,w3) = t4.m;
	g(iter,w3) = bsubobj.l - t1.m * qubar - t2.m * qvbar - t3.m * y1bar - t4.m * y2bar;
	);
aiter(iter) = yes;
	);

freeze(w)=yes;
solve checkstat using mip minimizing stat3;

display ub_stat,bendersmaster_stat, bendersub_stat,lpsub_stat,ub_obj,bendermaster_obj,bendersub_obj,lpsub_obj, as1,as2, z1hat,z2hat,stat1.l,stat2.l, quhat,qvhat;




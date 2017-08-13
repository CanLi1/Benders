Sets
i /i1*i5/
j /j1*j6/
k /k1*k4/
w /w1*w81/
freeze(w)
;
alias (k, kk), (w,w3,w2);

parameters
alpha(j)
beta(j)
delta /230/
lambda(j)
VL /300/
VU /2300/
H /5000/
baseQ(i) /i1 250000, i2 150000, i3 180000, i4 160000, i5 120000/
Q(i,w)
prob(w)
;
alpha(j) = 250;
beta(j) = 0.6;
lambda(j) = 2000;

*generatre scenarios---------------------------------
set
sub0 /1*3/;
parameters
num
baseprob(sub0) /1 0.3, 2 0.4, 3 0.3/;
alias (sub0,sub1,sub2,sub3,sub4);
loop(sub0,
 loop(sub1,
  loop(sub2,
   loop(sub3,
        num = 1*(ord(sub0)-1)+3*(ord(sub1)-1)+9*(ord(sub2)-1)+27*(ord(sub3)-1)+1;
        loop(w3$(ord(w3) eq num),
                 Q('i1', w3 )= baseQ('i1')*(1 + (ord(sub0)-2)/10);
                Q('i2', w3 )= baseQ('i2')*(1 + (ord(sub1)-2)/10);
                Q('i3', w3 )= baseQ('i3')*(1 + (ord(sub2)-2)/10);
                Q('i4', w3 )= baseQ('i4')*(1 + (ord(sub3)-2)/10);
                Q('i5', w3 )= baseQ('i5')*(1 + (ord(sub3)-2)/10);
                prob(w3) = baseprob(sub0)* baseprob(sub1) * baseprob(sub2) * baseprob(sub3) ;
            );

   );
  );
 );
);
Table S(i,j)
      j1      j2       j3      j4        j5        j6
i1   7.9     2.0      5.2     4.9       6.1       4.2
i2   0.7     0.8      0.9     3.4       2.1       2.5
i3   0.7     2.6      1.6     3.6       3.2       2.9
i4   4.7     2.3      1.6     2.7       1.2       2.5
i5   1.2     3.6      2.4     4.5       1.6       2.1;

Table t(i,j)
      j1      j2      j3       j4      j5      j6
i1   6.4     4.7     8.3      3.9     2.1     1.2
i2   6.8     6.4     6.5      4.4     2.3     3.2
i3     1     6.3     5.4     11.9     5.7     6.2
i4   3.2       3     3.5      3.3     2.8     3.4
i5   2.1     2.5     4.2      3.6     3.7     2.2;

Binary Variables
yf(k,j)
ys(k,j,w);

Variables
n(j)
v(j)
ns(j,w)
tl(i,w)
b(i,w)
cost;

Positive Variables
L(w);


*Lagrangean subproblem----------------------------------------------------
parameters
piyf(k,j,w)
pin(j,w)
piv(j,w)
;
piyf(k,j,w) = 0;
pin(j,w)=0;
piv(j,w)=0;

Equations
e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,eobj;
*first stage
e1(j) .. sum(k, yf(k,j)) =e= 1;
e2(j) .. n(j) =e= sum(k, log(ord(k)) * yf(k,j));
e3(j) .. v(j) =l= log(VU);
e4(j) .. v(j) =g= log(VL);

*second stage
e5(i,j,w)$freeze(w) .. v(j) =g= log(S(i,j)) + b(i,w);
e6(j,w)$freeze(w) .. ns(j,w) =e= sum(k, log(ord(k)) * ys(k,j,w));
*e7(k,j,w)$freeze(w) .. ys(k,j,w) =l= sum(kk$(ord(kk) ge ord(k)), yf(kk,j));
e7(j,w)$freeze(w) .. ns(j,w) =l= n(j);
e8(i,j,w)$freeze(w) .. ns(j,w) + tl(i,w) =g= log(t(i,j));
e9(w)$freeze(w) .. sum(i, Q(i,w) * exp(tl(i,w) - b(i,w))) =l= H + L(w);
e10(j,w)$freeze(w) .. sum(k, ys(k,j,w)) =e= 1;
eobj .. cost =e= sum(w$freeze(w), prob(w)*sum(j, alpha(j) * exp(n(j) + beta(j) * v(j)))) + sum(w$freeze(w), prob(w) * (sum(j, lambda(j) * exp(ns(j,w))) + delta*L(w)))+sum(w$freeze(w), sum(j, piv(j,w) * v(j) + pin(j,w) * n(j) + sum(k, piyf(k,j,w) * yf(k,j))));

model sub /e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,eobj/;
sub.optfile=1;
set iter /1*60/
aiter(iter)
biter(iter);


*lagrangean parameters
Sets
ltheta / 1/
lstep /1/;
parameters
yf_record_lag(iter, k,j,w)
n_record_lag(iter, j, w)
v_record_lag(iter, j, w)
obj_record(iter, w)
total_obj_record(iter)
muyf(iter, k,j,w)
mun(iter, j,w)
muv(iter, j,w)
piyf_all(iter, k,j,w)
pin_all(iter,j,w)
piv_all(iter, j, w)
cpu_lag/0/
den(iter)
stepsize
theta0 /1.5/
theta00(ltheta) /1 2/
half00(lstep) /1 0.5/
*theta00(ltheta)/1 0.2,2 0.6, 3 1, 4 1.5, 5 2/
half0 /0.5/
*half00(lstep) / 1 0.5,2 0.8, 3 0.9/
change;
muyf('1', k,j,w) = 0;
mun('1', j,w)=0;
muv('1', j,w) = 0;
piyf_all(iter, k,j,w)=0;
pin_all(iter,j,w)=0;
piv_all(iter, j, w)=0;
alias (iiiter, iiter, iter);

*Benders master problems--------------------------------
******************
*define Benders master problem
parameters
v1(iter, w)
g1(iter, k, j, w)
g2(iter, j, w)
g3(iter, j, w)
yf_record(iter, k,j)
n_record(iter, j)
v_record(iter, j)
BenderOBJ_record(iter)
;
Positive Variables
yita(w);

Variables
BenderOBJ;
Equations
bobj ,b2;

bobj .. BenderOBJ =e= sum(w, yita(w));
b2(w, iiiter)$biter(iiiter) .. yita(w) =g= v1(iiiter, w) + sum(j, sum(k, g1(iiiter, k , j, w)* yf(k,j)) +g2(iiiter, j, w) * n(j) + g3(iiiter, j, w) * v(j));
model bendersmaster /bobj,  b2, e1, e2,e3,e4/;
bendersmaster.threads=12;

*----------------------------DEFINE Benders subproblem---------------------------
parameters
yfbar(k,j), nbar(j), vbar(j), UB_Bender(iter), cpu_bender_sub/0/, cpu_bender_master /0/, cpu_ub/0/ ;
equations
Tyf, Tn,Tv,  Beobj;
Tyf(k,j) .. yf(k,j) =e= yfbar(k,j);
Tn(j) .. n(j) =e= nbar(j);
Tv(j) .. v(j) =e= vbar(j);
Beobj .. cost =e= sum(w$freeze(w), prob(w)*sum(j, alpha(j) * exp(n(j) + beta(j) * v(j)))) + sum(w$freeze(w), prob(w) * (sum(j, lambda(j) * exp(ns(j,w)) )+ delta*L(w)));
model Bendersub /Tyf, Tn, Tv,e5,e6,e7,e8,e9,e10,Beobj/;
BenderSub.optfile=1;


*-------------------solve model -----------------------------------
option optcr = 0;
option optca =0;
option reslim = 1e9;
  OPTION LIMROW = 0;
OPTION LIMCOL = 0;
option MINLP = dicopt;
option nlp = conopt;
option iterlim = 2e9;
BenderSub.solvelink =3;
sub.solvelink =3;
*parallel------------------
parameters
Bendersub_handle(w3)
lag_sub_handle(w3)
lag_sub_modelstat(iter,w)
bender_sub_modelstat(iter, w)
upper_sub_modelstat(iter,w)
master_modelstat(iter)
;
bender_sub_modelstat(iter,w)=0;
upper_sub_modelstat(iter,w)=0;
master_modelstat(iter)=0;
lag_sub_modelstat(iter,w)=0;

parameters
LB(ltheta, lstep)
UB(ltheta, lstep)
;
LB(ltheta,lstep) =  250843.7050;
UB(ltheta,lstep) = 1e6  ;
aiter(iiiter) = yes;
loop(ltheta,
loop(lstep,
 theta0 = theta00(ltheta);
  half0 = half00(lstep);
  g1(iter,k,j,w) =0;
g2(iter,j,w)=0;
g3(iter, j, w) = 0;
v1(iter,w) =0;
muyf('1', k,j,w) = 0;
mun('1', j,w)=0;
muv('1', j,w) = 0;
piyf_all(iter, k,j,w)=0;
pin_all(iter,j,w)=0;
piv_all(iter, j, w)=0;
piyf(k,j,w) = 0;
pin(j,w)=0;
piv(j,w)=0;
loop(iter,





*solve benders master problem----------------
    aiter(iiiter) = no;
    biter(iiiter)=no;
  loop(iiter,
    if(ord(iiter) le ord(iter),
      biter(iiter)= yes;
      );
      
    );
  solve bendersmaster using mip minimizing BenderOBJ;
  cpu_bender_master = cpu_bender_master + bendersmaster.resusd;
  BenderOBJ_record(iter) = BenderOBJ.l;
  master_modelstat(iter) = bendersmaster.modelStat;
*  abort$(bendersmaster.modelStat ne 1 or bendersmaster.solveStat ne 1) 'abort due to error solve benders master';
  if(LB(ltheta, lstep) lt BenderOBJ.l,
    LB(ltheta, lstep) = BenderOBJ.l;
    );

  yf_record(iter, k,j) = yf.l(k,j);
  n_record(iter,j) = n.l(j);
  v_record(iter, j) = v.l(j);

*solve benders subproblem--------------------

*update fisrt stage decision
  yfbar(k,j) = yf.l(k,j);
  nbar(j) = n.l(j);
  vbar(j) = v.l(j);
  UB_Bender(iter) = 0;
*solve upper bound each subproblem
  loop(w3,
      freeze(w2) = no;
  freeze(w3) = yes;
  n.l(j) = log(3);
  v.l(j) = log(2300);
  ns.l(j,w3) = log(3);
  tl.l(i,w3) = log(2);
  b.l(i,w3) = log(400);
  yf.l(k,j) = 0;
  yf.l('k3',j) =1;
  ys.l(k,j,w3)= 0;
  ys.l('k3',j,w3)= 1;
  L.l(w3) = 1e3;
    freeze(w2) = no;
    freeze(w3) = yes;
    solve BenderSub using MINLP minimizing COST;
    Bendersub_handle(w3) = Bendersub.handle;

    );
  Repeat
    loop(w3$handlecollect(Bendersub_handle(w3)),
        cpu_ub = cpu_ub + BenderSub.resusd;
        UB_Bender(iter) = UB_Bender(iter) + cost.l;
        upper_sub_modelstat(iter,w3) = bendersub.modelStat;
        if((bendersub.modelStat ne 8 and bendersub.modelStat ne 2 and bendersub.modelStat ne 1),
          display bendersub.modelStat;
          UB(ltheta, lstep) = 0;
          );
        abort$((bendersub.modelStat ne 8 and bendersub.modelStat ne 2 and bendersub.modelStat ne 1)  or bendersub.solveStat ne 1) 'abort due to errors solve upper bound sub';
        display$handledelete(Bendersub_handle(w3)) 'trouble deleting handles';
        Bendersub_handle(w3)=0;
      );
  until card(Bendersub_handle) =0;


*add benders cuts, solve each benders subproblem--------------
  loop(w3,
    freeze(w2) = no;
    freeze(w3) = yes;
    solve Bendersub using rMINLP minimizing COST;
    Bendersub_handle(w3)= Bendersub.handle;

    );

  Repeat
    loop(w3$handlecollect(Bendersub_handle(w3)),
      cpu_bender_sub = cpu_bender_sub + Bendersub.resusd;
      v1(iter, w3) = COST.l - sum(j, sum(k, yfbar(k,j)*Tyf.m(k,j)) + nbar(j) * Tn.m(j) + vbar(j) * Tv.m(j));
      g1(iter, k,j, w3) = Tyf.m(k,j);
      g2(iter, j, w3) = Tn.m(j);

      g3(iter, j, w3) = Tv.m(j);
      bender_sub_modelstat(iter,w3) = bendersub.modelStat;
      if((bendersub.modelStat ne 2 and bendersub.modelStat ne 1)or bendersub.solveStat ne 1,
        display bendersub.modelStat;
        UB(ltheta, lstep) = 0;
        );
      abort$((bendersub.modelStat ne 2 and bendersub.modelStat ne 1) or bendersub.solveStat ne 1) 'abort due to errors solve Bender subproblem';
      display$handledelete(Bendersub_handle(w3)) 'trouble deleting handles';
      Bendersub_handle(w3)=0;
      );
 until card(Bendersub_handle) =0;

  if(UB_Bender(iter) lt UB(ltheta, lstep),
    UB(ltheta, lstep) = UB_Bender(iter);
);
    );



);
);

parameter
WallTime;
WallTime=TimeElapsed;
parameters
dn(iter,j)
dv(iter,j)
;
dn(iter, j) = exp(n_record(iter, j));
dv(iter, j) = exp(v_record(iter,j));
display bender_sub_modelstat, upper_sub_modelstat,cpu_ub,cpu_bender_sub, cpu_bender_master,walltime;
display UB, LB, BenderOBJ_record, UB_Bender ;

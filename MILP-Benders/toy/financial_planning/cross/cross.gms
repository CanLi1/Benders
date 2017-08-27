sets
i /1*4/
s /1*2/
freeze(s)
;
alias(s,ss);
Table r(s,i)
        1         2          3       4
1     1.5      1.35       1.23    1.16
2     0.9         1        1.1    1.12;

Positive Variables
x1(i)
x2(i,s)
su(s,ss)
d(s,ss);

Binary variables
y2(i,s)
y1(i);

variables
cost;
parameters
pix(i,s)
piy(i,s);
pix(i,s)=0;
piy(i,s)=0;
Equations
e1,e2,e3,e4,e5,e6,e7,eobj;
e1 .. sum(i, x1(i)) =e= 1;
e2 .. sum(i, y1(i)) =e= 1;
e3(i) .. x1(i) =l= 1 * y1(i);
e4(s)$freeze(s) .. sum(i, x2(i,s)) =e= sum(i, x1(i) * r(s,i));
e5(s)$freeze(s) .. sum(i, y2(i,s)) =e= 1;
e6(i,s)$freeze(s) .. x2(i,s) =l= 2 * y2(i,s);
e7(s,ss)$freeze(s) .. sum(i, x2(i,s) * r(ss,i)) - su(s,ss) + d(s,ss) =e= 1.2;
eobj .. -sum((s,ss)$freeze(s), 0.25 * (su(s,ss) - 3*d(s,ss)))+sum((i,s)$freeze(s), pix(i,s) *x1(i) + piy(i,s) * y1(i)) =e= cost;
model sub /e1,e2,e3,e4,e5,e6,e7,eobj/;

sets
iter /1*30/
aiter(iter)
biter(iter);
*lagrangean decomposition parameters
parameters
x_record_lag(iter,i,s)
y_record_lag(iter,i,s)
obj_record(iter,s)
total_obj_record(iter)
mux(iter,i,s)
muy(iter,i,s)
pix_all(iter,i,s)
piy_all(iter,i,s)
cpu_lag/0/ 
den(iter)
stepsize
theta0 /2/
change;
mux('1',i,s) = 0;
muy('1',i,s)=0;
pix_all(iter,i,s) =0;
piy_all(iter,i,s) =0;
alias (s,s2,s3);
alias (iiiter, iiter, iter);


*Benders master problems--------------------------------
******************
*define Benders master problem
Binary Variables
yf(i);
positive variables
xf(i);
Variables 
BenderOBJ,yita(s);
parameters
BenderOBJ_record(iter)
xf_record(iter, i)
yf_record(iter, i)
v(iter,s)
g1(iter, i,s)
g2(iter,i,s)
;
g1(iter,i,s) =0;
g2(iter,i,s)=0;
v(iter,s) =0;

equations
bobj, b1,b2,b4,b5,b3;
bobj .. BenderOBJ =e= sum(s,  yita(s))  ;
b1(s, iiiter)$aiter(iiiter) .. yita(s) =g= obj_record(iiiter,s ) - sum((i), pix_all(iiiter,i,s) * xf(i)+ piy_all(iiiter,i,s)*yf(i));
b2 .. sum(i,xf(i))=e= 1;
b4 .. sum(i,yf(i)) =e= 1;
b5(i) .. xf(i) =l= 1 * yf(i);
b3(s, iiiter)$biter(iiiter)  .. yita(s) =g= v(iiiter, s) + sum((i), g1(iiiter, i,s) * xf(i) + g2(iiiter, i, s) * yf(i) ) ;
model bendersmaster /bobj, b1,b2, b3,b4,b5/;

*----------------------------DEFINE Benders subproblem---------------------------
parameters
xbar(i), ybar(i), UB_Bender(iter), cpu_bender_sub/0/, cpu_bender_master /0/, cpu_ub/0/ ;


equations
TX, Ty,  Beobj;
TX(i) .. x1(i) =e= xbar(i);
Ty(i) .. y1(i) =e= ybar(i);
Beobj .. cost =e= -sum((s,ss)$freeze(s), 0.25 * (su(s,ss) - 3*d(s,ss)));
model Bendersub /TX, Ty,e4,e5,e6,e7,Beobj/;


*-------------------solve model -----------------------------------
option optcr = 0;
option optca =0;
  OPTION LIMROW = 0;
OPTION LIMCOL = 0;
option decimals=5;



parameters
LB /-0.17365/
UB /-0.130/
;
aiter(iiiter) = yes;
loop(iter,


*solve each lagrangean subproblem
loop(s3, 
  freeze(s2) = no;
  freeze(s3) = yes;

  solve sub using MIP minimizing COST;
       x_record_lag(iter,i,s3 ) = x1.l(i);
      y_record_lag(iter,i,s3)=y1.l(i);
      obj_record(iter, s3) = cost.l;
      cpu_lag = cpu_lag + sub.resusd;
  
);


  total_obj_record(iter) = sum(s, obj_record(iter,s));

*solve benders master problem----------------
*update multiplier
  pix_all(iter,i,s) = pix(i,s);
  piy_all(iter,i,s) = piy(i,s);
    aiter(iiiter) = no;
    biter(iiiter) = no;
  loop(iiter,
    if(ord(iiter) le ord(iter),
      aiter(iiter)= yes;
      );
      if(ord(iiter) lt ord(iter),
      biter(iiter)= yes;
      );
    );
  solve bendersmaster using mip minimizing BenderOBJ;
  cpu_bender_master = cpu_bender_master + bendersmaster.resusd;
  BenderOBJ_record(iter) = BenderOBJ.l;
*  abort$(bendersmaster.modelStat ne 1 or bendersmaster.solveStat ne 1) 'abort due to error solve benders master';
  if(LB lt BenderOBJ.l,
    LB = BenderOBJ.l;
    );
  xf_record(iter,i) = xf.l(i);
  yf_record(iter,i) = yf.l(i);

*solve benders subproblem--------------------

*update fisrt stage decision
  xbar(i) = xf.l(i);
  ybar(i) = yf.l(i);
  UB_Bender(iter) = 0;
*solve upper bound each subproblem
  loop(s3,
    freeze(s2) = no;
    freeze(s3) = yes;
    solve BenderSub using MIP minimizing COST;
            cpu_ub = cpu_ub + BenderSub.resusd;
        UB_Bender(iter) = UB_Bender(iter) + cost.l;
    );



*add benders cuts, solve each benders subproblem--------------
  loop(s3,
    freeze(s2) = no;
    freeze(s3) = yes;
    solve Bendersub using rMIP minimizing COST;
          cpu_bender_sub = cpu_bender_sub + Bendersub.resusd;
      v(iter, s3) = COST.l - sum((i), xbar(i) * TX.m(i) + ybar(i) * Ty.m(i) ) ;
      g1(iter, i, s3) = TX.m(i);
      g2(iter, i, s3) = Ty.m(i);
    );



  if(UB_Bender(iter) lt UB,
    UB = UB_Bender(iter);
    );
*finish benders-------------------

*update lagrangean multiplier
  den(iter) = sum((i,s), power(x_record_lag(iter,i,s) -x_record_lag(iter,i,'1'), 2 ) + power(y_record_lag(iter,i,s)-y_record_lag(iter,i,'1'), 2) );
  stepsize = theta0 * (UB-LB)/den(iter);
  loop(s,
    if(ord(s) gt 1,
      mux(iter+1,i,s) = mux(iter,i,s) + (x_record_lag(iter,i,s)-x_record_lag(iter,i,'1')) * stepsize;
      muy(iter+1,i,s) = muy(iter,i,s) + (y_record_lag(iter,i,s)-y_record_lag(iter,i,'1')) * stepsize;
      );
    );
  loop(s,
    if(ord(s) gt 1,
      pix(i,s) =  mux(iter+1,i,s);
      piy(i,s) = muy(iter+1,i,s);

      );
    pix(i,'1') = -sum((s2)$( ord(s2) gt 1), mux(iter+1,i,s2));
    piy(i,'1') = -sum((s2)$( ord(s2) gt 1 ), muy(iter+1,i,s2));
    );
  if (ord(iter) gt 1,
    change = -(total_obj_record(iter-1) - total_obj_record(iter)) / total_obj_record(iter-1);
    if (change lt 0, 
      theta0 = theta0 * 0.85;
      );
    );
  if(LB lt total_obj_record(iter),
    LB = total_obj_record(iter);
    );
  if(LB * 0.99 gt UB,
  break; );
  );
parameter
WallTime;
WallTime=TimeElapsed;
display x_record_lag,y_record_lag,mux, muy, obj_record, pix_all, piy_all,g2,v,xf_record, yf_record;

display total_obj_record, BenderOBJ_record, UB_Bender,UB, LB, WallTime,cpu_ub,cpu_lag, cpu_bender_sub, cpu_bender_master ;
























sets
i /i1*i4/
j /j1*j6/
s /s1*s4/
r /r1*r4/
p /p1*p3/
c /c1*c4/
w /w1*w3/
freeze(w)
;

alias(j,jj),(s,ss);
Table
IJ(i,j) "index set of process that consume chemical j"
      j1    j2    j3    j4    j5    j6
i1     1                             1
i2     1                             1
i3     1     1
i4                 1     1
;
Table
OJ(i,j) "index set of process that produce chemical j"
      j1    j2    j3    j4    j5    j6
i1                 1
i2                 1     1
i3                 1     1
i4                             1     1
;
Table
PS(i,s) "index set of production scheme for process i"
        s1     s2      s3      s4
i1       1
i2       1      1
i3       1      1       1       1
i4       1      1
;
Table
JM(i,s,j) "index set of main products for production scheme s"
        j1    j2     j3     j4     j5    j6
i1.s1                 1
i2.s1                 1
i2.s2                        1
i3.s1                 1
i3.s2                        1
i3.s3                 1
i3.s4                        1
i4.s1                               1
i4.s2                               1
;

Table
L(i,s,j)
        j1    j2     j3     j4     j5    j6
i1.s1    1                                1
i2.s1    1
i2.s2    1                                1
i3.s1    1
i3.s2    1
i3.s3          1
i3.s4          1
i4.s1                                     1
i4.s2                                     1
;
Table
Lbar(i,s,j)
        j1    j2     j3     j4     j5    j6
i1.s1
i2.s1
i2.s2
i3.s1
i3.s2
i3.s3
i3.s4
i4.s1                 1
i4.s2                        1
;
Table
RJ(r,j)
        j1       j2        j3         j4         j5          j6
r1                1                    1                      1
r2       1                             1                      1
r3       1        1                                           1
r4       1        1                    1                      1
;

Parameters
Q0(p,i)
rho(i,j,s)
H(i)
betaC(i)/ i1 0.1, i2 0.09, i3 0.11, i4 0.8/
alphaC(i) /i1 20, i2 10, i3 15, i4 30/
delta(i,s) "operating cost coefficient"
phi(c,j) "penalty cost for not satisfying demand from customer c for chemical j"
QEU(p,i)
PUU /100/
FUU /150/
;
betaC(i)=betaC(i)*10;

Q0(p,i) = 0;
rho(i,j,s) =1;
H(i) = 1;
phi(c,'j3') = 3;
phi(c,'j5') = 300;
QEU(p,i) = 1.50;
delta(i,s) = 0.1;
delta('i4', s) = 3;
Table
mu(i,s,j)
           j1     j2      j3       j4       j5       j6
i1.s1    1.05             -1                       0.03
i2.s1    1.02             -1
i2.s2    1.10                      -1              0.09
i3.s1    1.10             -1
i3.s2    1.20                      -1
i3.s3           1.08      -1
i3.s4           1.05               -1
i4.s1                    1.2                -1        1
i4.s2                             1.1       -1     0.85;

Table
baseD(c,j) "demand base"
        j1       j2        j3         j4         j5          j6
c1                        100                     5
c2                         50                     3
c3                        150                   2.5
c4                         80                     2
;
Table
betaS(r,j) "price for purchase chemical j from supplier r"
        j1       j2        j3         j4         j5          j6
r1              0.5                    2                   0.25
r2    0.65                           1.8                   0.30
r3    0.90        1                                        0.25
r4    0.75     0.75                  1.9                   0.30
;
Parameters
D(c,j,w)
prob(w)
;

*generate scenarios
Set
subw/1*3/;
Parameters
num
baseprob(subw)/1 0.25, 2 0.5, 3 0.25/;
alias (sub0,sub1,sub2,sub3,sub4,sub5,sub6,sub7,sub8,sub9,sub10,sub11,subw);
loop(sub0,
            num = 0;

            num = 1*(ord(sub0)-1);
            loop(w,
              if(ord(w) eq num + 1,
D(c,j,w)= baseD(c, j)*(1+(ord(sub0)-2)*0.3);
prob(w)=baseprob(sub0);
            );
              );
              );
Table
alphaRP(r,p) "fixed cost for transporting chemical from supplier r to plant p"
      p1       p2       p3
r1    20       10       15
r2    25       30       20
r3    30       15       20
r4    15       20       25
;

Table
betaRP(r,p) "variable cost for transporting chemical from supplier r to plant p"
          p1          p2         p3
r1      0.15         0.1       0.15
r2      0.12         0.2       0.05
r3      0.08        0.15       0.10
r4      0.13        0.08       0.20
;

Table
alphaPC(p,c) "fixed cost for transporting chemical from plant p to customer c"
           c1          c2        c3        c4
p1         20          15        25        10
p2         15          25        30        35
p3         10          15        20        40
;

Table
betaPC(p,c) "variable cost for transporting chemical from plant p to customer c"
           c1          c2        c3        c4
p1       0.03         0.1      0.15      0.05
p2       0.20        0.15      0.05      0.20
p3       0.25        0.10      0.15      0.30
;
Positive Variables
PU(r,p,j,w)
F(p,c,j,w)
QE(p,i)
theta(p,i,j,s,w)
Q(p,i)
WW(p,i,j,s,w)
Slack(c,j,w)
;

Binary Variables
x(p,i)
y(r,p,w)
z(p,c,w)
;

Variables
cost;

*Lagrangean subproblems----------------------------------------------
Parameters
pix(p,i,w)
piQ(p,i,w)
avg_x(p,i)
avg_Q(p,i)
penalty_x(i)
penalty_Q(p,i);
pix(p,i,w) = 0;
piQ(p,i,w) = 0;
avg_x(p,i) = 0;
avg_Q(p,i) =0;
Equations
e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,eobj;

e1(p,i) .. QE(p,i) =l= QEU(p,i) * x(p,i);
e2(p,i) .. Q(p,i) =e= Q0(p,i) + QE(p,i);
e3(p,j,w)$freeze(w) .. sum(r$RJ(r,j), PU(r,p,j,w)) + sum((i,s)$(OJ(i,j) and PS(i,s)), WW(p,i,j,s,w)) =e= sum(c, F(p,c,j,w)) + sum((i,s)$(IJ(i,j) and PS(i,s)), WW(p,i,j,s,w));
e4(p,i,w)$freeze(w) .. sum((j,s)$(JM(i,s,j) and PS(i,s)), theta(p,i,j,s,w)) =l= H(i) * Q(p,i)*100;
e5(p,i,j,s,w)$(freeze(w) and PS(i,s) and JM(i,s,j)) .. WW(p,i,j,s,w) =e= rho(i,j,s) * theta(p,i,j,s,w);
e6(p,i,j,w,s)$(freeze(w) and (not (PS(i,s) and JM(i,s,j)))) .. theta(p,i,j,s,w) =e= 0;
e7(p,i,j,jj,w,s)$(freeze(w) and L(i,s,j) and PS(i,s) and JM(i,s,jj)) .. WW(p,i,j,s,w) =e= mu(i,s,j) * WW(p,i,jj,s,w);
e8(p,i,j,jj,w,s)$(freeze(w) and Lbar(i,s,j) and PS(i,s) and JM(i,s,jj)) .. log(1+WW(p,i,j,s,w)) =g= mu(i,s,j) * WW(p,i,jj,s,w);
e9(r,p,w,j)$(RJ(r,j) and freeze(w)) .. PU(r,p,j,w) =l= PUU * y(r,p,w);
e10(p,c,j,w)$freeze(w) .. F(p,c,j,w) =l= FUU * z(p,c,w);
e11(c,j,w)$freeze(w) .. sum(p, F(p,c,j,w)) + Slack(c,j,w) =e= D(c,j,w);
e12(p,i,j,s,w)$(freeze(w) and (not(JM(i,s,j) or L(i,s,j) or Lbar(i,s,j)))) .. WW(p,i,j,s,w) =e= 0;
eobj .. cost =e= sum(w$freeze(w), prob(w) * sum(p, sum(i, betaC(i) * QE(p,i)*100 + alphaC(i) * x(p,i)))) + sum(w$freeze(w), prob(w) * (sum((p,i,s,j)$(PS(i,s) and JM(i,s,j)), delta(i,s)*rho(i,j,s) * theta(p,i,j,s,w)) + sum((p,j,r)$RJ(r,j), (betaS(r,j) + betaRP(r,p)) * PU(r,p,j,w)) + sum((r,p), alphaRP(r,p) * y(r,p,w)) + sum((p,c), alphaPC(p,c) * z(p,c,w)) + sum((p,c,j), betaPC(p,c) * F(p,c,j,w)) + sum((c,j), phi(c,j) * Slack(c,j,w)) )) +  sum((p,i,w)$freeze(w), prob(w) * (pix(p,i,w) * x(p,i) + piQ(p,i,w) * Q(p,i)))+   sum((p,i,w)$freeze(w), prob(w) * penalty_x(i)/2*power((x(p,i)-avg_x(p,i)), 2) +prob(w) *  penalty_Q(p,i)/2*power((Q(p,i)-avg_Q(p,i)), 2)) ;

set iter /1*30/
aiter(iter)
biter(iter);


*lagrangean decomposition parameters
parameters
x_record_ph(iter,p,i,w)
Q_record_ph(iter,p,i,w)
xf_record(iter, p,i)
Qf_record(iter, p,i)
obj_record(iter,w)
total_obj_record(iter)
mux(iter,p,i,w)
muQ(iter,p,i,w)
pix_all(iter,p,i,w)
piQ_all(iter,p,i,w)
cpu_lag/0/
den(iter)
stepsize
theta0 /2/
*theta00(ltheta)/1 0.2,2 0.6, 3 1, 4 1.5, 5 2/
half0 /0.6/
*half00(lstep) / 1 0.5, 2 0.6,3 0.7,4 0.8/
change;
mux('1',p,i,w) = 0;
muQ('1',p,i,w)=0;
pix_all(iter,p,i,w) =0;
piQ_all(iter,p,i,w) =0;
alias (w2,w,w3);
alias (iiiter, iiter, iter);
model sub/e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,eobj/;
sub.optfile=1;


*----------------------------DEFINE Benders subproblem---------------------------
parameters
xbar(p,i), Qbar(p,i), UB_Bender(iter), cpu_bender_sub/0/, cpu_bender_master /0/, cpu_ph/0/,cpu_ub/0/ , UB_Bender(iter);

UB_Bender(iter) = 0;
equations
TX, TQ,  Beobj;
TX(p,i) .. x(p,i) =e= xbar(p,i);
TQ(p,i) .. Q(p,i) =e= Qbar(p,i);
Beobj .. cost =e= sum(w$freeze(w), prob(w) * sum(p, sum(i, betaC(i) * QE(p,i)*100 + alphaC(i) * x(p,i)))) + sum(w$freeze(w), prob(w) * (sum((p,i,s,j)$(PS(i,s) and JM(i,s,j)), delta(i,s)*rho(i,j,s) * theta(p,i,j,s,w)) + sum((p,j,r)$RJ(r,j), (betaS(r,j) + betaRP(r,p)) * PU(r,p,j,w)) + sum((r,p), alphaRP(r,p) * y(r,p,w)) + sum((p,c), alphaPC(p,c) * z(p,c,w)) + sum((p,c,j), betaPC(p,c) * F(p,c,j,w)) + sum((c,j), phi(c,j) * Slack(c,j,w)) )) ;
model Bendersub /TX, TQ,e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,Beobj/;
BenderSub.optfile=1;

*-------------------solve model -----------------------------------
option optcr = 0;
option optca =0;
  OPTION LIMROW = 0;
OPTION LIMCOL = 0;
option MINLP = dicopt;
option iterlim = 2e9;
*parallel------------------
BenderSub.solvelink =3;
sub.solvelink =3;
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
LB
UB;
LB = 700;
UB =1703.074  ;
aiter(iiiter) = yes;
parameters
distance
temp_distance
distance_record(iter)
;

loop(iter,
if(ord(iter) eq 1,
	penalty_x(i) = 0;
	penalty_Q(p,i) =0;
	);


*solve each progressive hedging subproblem
loop(w3,
  freeze(w2) = no;
  freeze(w3) = yes;
  solve sub using MINLP minimizing COST;
  lag_sub_handle(w3) = sub.handle;

);
Repeat
  loop(w3$handlecollect(lag_sub_handle(w3)),
      x_record_ph(iter,p,i,w3 ) = x.l(p,i);
      Q_record_ph(iter,p,i,w3)=Q.l(p,i);
      cpu_ph = cpu_ph + sub.resusd;
      lag_sub_modelstat(iter,w3) = sub.modelStat;
*      abort$(sub.modelStat ne 8 or sub.solveStat ne 1) 'abort due to error solve lag sub';
      display$handledelete(lag_sub_handle(w3)) 'trouble deleting handles';
      lag_sub_handle(w3)=0;
    );
until card(lag_sub_handle) =0;



*obtain an lower bound at each iteration by setting penalty =0
penalty_x(i) = 0;
penalty_Q(p,i) =0;
loop(w3,
  freeze(w2) = no;
  freeze(w3) = yes;
  solve sub using MINLP minimizing COST;
  lag_sub_handle(w3) = sub.handle;

);
Repeat
  loop(w3$handlecollect(lag_sub_handle(w3)),
      obj_record(iter, w3) = cost.l;
      cpu_lag = cpu_lag + sub.resusd;
      lag_sub_modelstat(iter,w3) = sub.modelStat;
*      abort$(sub.modelStat ne 8 or sub.solveStat ne 1) 'abort due to error solve lag sub';
      display$handledelete(lag_sub_handle(w3)) 'trouble deleting handles';
      lag_sub_handle(w3)=0;
    );
until card(lag_sub_handle) =0;
*obtain a lower bound 
total_obj_record(iter) = sum(w, obj_record(iter,w));
*update lower bound
if(LB lt total_obj_record(iter),
	LB = total_obj_record(iter);
	);


*calculate the weighted average the first stage decisions
avg_x(p,i) = sum(w3, prob(w3) * x_record_ph(iter, p,i, w3));
avg_Q(p,i) = sum(w3, prob(w3) * Q_record_ph(iter, p,i,w3));
distance = 1e6;
loop(w3,
  temp_distance = sqrt(sum((p,i), power((avg_x(p,i)- x_record_ph(iter, p,i, w3)), 2) + power((avg_Q(p,i) - Q_record_ph(iter,p,i, w3)), 2)));
  if(temp_distance lt distance,
    xbar(p,i) = x_record_ph(iter, p,i, w3);
    Qbar(p,i) = Q_record_ph(iter, p,i, w3);
    distance = temp_distance;
    );
  );
xf_record(iter,p,i) = xbar(p,i);
Qf_record(iter,p,i) = Qbar(p,i);

*solve upper bound each subproblem
  loop(w3,
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
        display bendersub.modelStat;
        abort$((bendersub.modelStat ne 8 and bendersub.modelStat ne 2 and bendersub.modelStat ne 1)  or bendersub.solveStat ne 1) 'abort due to errors solve upper bound sub';
        display$handledelete(Bendersub_handle(w3)) 'trouble deleting handles';
        Bendersub_handle(w3)=0;
      );
  until card(Bendersub_handle) =0;

  if(UB_Bender(iter) lt UB,
    UB = UB_Bender(iter);

    );

*upate the multipliers
penalty_x(i) = alphaC(i) /2;
penalty_Q(p,i) = betaC(i) *100 / (max(sum(w3, prob(w3) * abs(Q_record_ph(iter, p,i,w3) - avg_Q(p,i))), 1)); 
loop(w3,
pix(p,i, w3) = pix(p,i,w3) + penalty_x(i) * (x_record_ph(iter,p,i,w3) - avg_x(p,i));
piQ(p,i,w3) = piQ(p,i,w3) + penalty_Q(p,i) * (Q_record_ph(iter,p,i,w3) - avg_Q(p,i));
);
*break if nac is satisfied
distance_record(iter) = distance;
if(distance le 1e-3,
	break;
	);
  );



parameter
WallTime;
WallTime=TimeElapsed;
display x_record_ph,Q_record_ph,  xf_record, Qf_record;

display total_obj_record, UB_Bender,UB, LB, WallTime,cpu_ub,cpu_lag, cpu_ph, distance_record ;

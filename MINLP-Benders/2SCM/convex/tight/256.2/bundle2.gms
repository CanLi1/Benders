Sets
i /i1*i4/
j /j1*j6/
s /s1*s4/
r /r1*r4/
p /p1*p3/
c /c1*c4/
w /w1*w256/
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
betaC(i)/ i1 0.1, i2 0.09, i3 0.11, i4 0.08/
alphaC(i) /i1 20, i2 10, i3 15, i4 30/
delta(i,s) "operating cost coefficient" 
phi(c,j) "penalty cost for not satisfying demand from customer c for chemical j"
QEU(p,i)
PUU /100/
FUU /150/
prob(w);
prob(w) = 1/256;
Q0(p,i) = 0;
rho(i,j,s) =1;
H(i) = 1;
phi(c,'j3') = 10;
phi(c,'j5') = 100;
QEU(p,i) = 150;
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



Parameters
D(c,j,w);
*generate scenarios
Set 
subw/1*2/;
Parameters
num;
alias (sub0,sub1,sub2,sub3,sub4,sub5,sub6,sub7,sub8,sub9,sub10,sub11,subw);
loop(sub0,
 loop(sub1,
  loop(sub2,
   loop(sub3,
    loop(sub4,
     loop(sub5,
      loop(sub6,
        loop(sub7,

            num = 0;
             
            num = 1*(ord(sub0)-1)+2*(ord(sub1)-1)+4*(ord(sub2)-1)+8*(ord(sub3)-1)+16*(ord(sub4)-1)+32*(ord(sub5)-1)+64*(ord(sub6)-1)+128*(ord(sub7)-1);
            loop(w, 
              if(ord(w) eq num + 1,
D('c1','j3',w)= baseD('c1', 'j3')*(1 + (ord(sub0)-1.5)*0.6);
D('c1','j5',w)= baseD('c1', 'j5')*(1 + (ord(sub1)-1.5)*0.6);
D('c2','j3',w)= baseD('c2', 'j3')*(1 + (ord(sub2)-1.5)*0.6);
D('c2','j5',w)= baseD('c2', 'j5')*(1 + (ord(sub3)-1.5)*0.6);
D('c3','j3',w)= baseD('c3', 'j3')*(1 + (ord(sub4)-1.5)*0.6);
D('c3','j5',w)= baseD('c3', 'j5')*(1 + (ord(sub5)-1.5)*0.6);
D('c4','j3',w)= baseD('c4', 'j3')*(1 + (ord(sub6)-1.5)*0.6);
D('c4','j5',w)= baseD('c4', 'j5')*(1 + (ord(sub7)-1.5)*0.6);

            );
              );
              );

           );
          );
         );
        );
       );
      );
     );

Table
betaS(r,j) "price for purchase chemical j from supplier r"
        j1       j2        j3         j4         j5          j6
r1              0.5                    2                   0.25  
r2    0.65                           1.8                   0.30
r3    0.90        1                                        0.25
r4    0.75     0.75                  1.9                   0.30
;
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
alphaRP(r,p) = alphaRP(r,p) * 10;
alphaPC(p,c) = alphaPC(p,c) * 10;
alphac(i) = alphaC(i) * 10;
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
piQ(p,i,w);
pix(p,i,w) = 0;
piQ(p,i,w) = 0;
Equations
e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,eobj;

e1(p,i) .. QE(p,i) =l= QEU(p,i) * x(p,i);
e2(p,i) .. Q(p,i) =e= Q0(p,i) + QE(p,i);
e3(p,j,w)$freeze(w) .. sum(r$RJ(r,j), PU(r,p,j,w)) + sum((i,s)$(OJ(i,j) and PS(i,s)), WW(p,i,j,s,w)) =e= sum(c, F(p,c,j,w)) + sum((i,s)$(IJ(i,j) and PS(i,s)), WW(p,i,j,s,w));
e4(p,i,w)$freeze(w) .. sum((j,s)$(JM(i,s,j) and PS(i,s)), theta(p,i,j,s,w)) =l= H(i) * Q(p,i);
e5(p,i,j,s,w)$(freeze(w) and PS(i,s) and JM(i,s,j)) .. WW(p,i,j,s,w) =e= rho(i,j,s) * theta(p,i,j,s,w);
e6(p,i,j,w,s)$(freeze(w) and (not (PS(i,s) and JM(i,s,j)))) .. theta(p,i,j,s,w) =e= 0;
e7(p,i,j,jj,w,s)$(freeze(w) and L(i,s,j) and PS(i,s) and JM(i,s,jj)) .. WW(p,i,j,s,w) =e= mu(i,s,j) * WW(p,i,jj,s,w);
e8(p,i,j,jj,w,s)$(freeze(w) and Lbar(i,s,j) and PS(i,s) and JM(i,s,jj)) .. log(1+WW(p,i,j,s,w)) =g= mu(i,s,j) * WW(p,i,jj,s,w);
e9(r,p,w,j)$(RJ(r,j) and freeze(w)) .. PU(r,p,j,w) =l= PUU * y(r,p,w);
e10(p,c,j,w)$freeze(w) .. F(p,c,j,w) =l= FUU * z(p,c,w);
e11(c,j,w)$freeze(w) .. sum(p, F(p,c,j,w)) + Slack(c,j,w) =e= D(c,j,w);
e12(p,i,j,s,w)$(freeze(w) and (not(JM(i,s,j) or L(i,s,j) or Lbar(i,s,j)))) .. WW(p,i,j,s,w) =e= 0;
eobj .. cost =e= sum(w$freeze(w), prob(w) * sum(p, sum(i, betaC(i) * QE(p,i) + alphaC(i) * x(p,i)))) + sum(w$freeze(w), prob(w) * (sum((p,i,s,j)$(PS(i,s) and JM(i,s,j)), delta(i,s)*rho(i,j,s) * theta(p,i,j,s,w)) + sum((p,j,r)$RJ(r,j), (betaS(r,j) + betaRP(r,p)) * PU(r,p,j,w)) + sum((r,p), alphaRP(r,p) * y(r,p,w)) + sum((p,c), alphaPC(p,c) * z(p,c,w)) + sum((p,c,j), betaPC(p,c) * F(p,c,j,w)) + sum((c,j), phi(c,j) * Slack(c,j,w)) )) +  sum((p,i,w)$freeze(w), pix(p,i,w) * x(p,i) + piQ(p,i,w) * Q(p,i));

set iter /1*50/
aiter(iter)
fiter(iter)
biter(iter);


*lagrangean decomposition parameters
parameters
x_record_lag(iter,p,i,w)
Q_record_lag(iter,p,i,w)
obj_record(iter,w)
mux(iter,p,i,w)
muQ(iter,p,i,w)
pix_all(iter,p,i,w)
piQ_all(iter,p,i,w)
cpu_lag/0/ ;
mux('1',p,i,w) = 0;
muQ('1',p,i,w)=0;
pix_all(iter,p,i,w) =0;
piQ_all(iter,p,i,w) =0;
alias (w2,w,w3);
alias (iiiter, iiter, iter);
model sub/e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,eobj/;
sub.optfile=1;




*Benders master problems--------------------------------
******************
*define Benders master problem
Binary Variables
xf(p,i);
positive variables
QEf(p,i),Qf(p,i),yita(w);
Variables 
BenderOBJ;
parameters
BenderOBJ_record(iter)
xf_record(iter, p,i)
Qf_record(iter, p,i)
QEf_record(iter,p,i)
v(iter,w)
g1(iter, p,i,w)
g2(iter,p,i,w)
;
g1(iter,p,i,w) =0;
g2(iter,p,i,w)=0;
v(iter,w) =0;

equations
bobj, b1,b2,b4,b3;
bobj .. BenderOBJ =e= sum(w,  yita(w))  ;
b1(w, iiiter)$aiter(iiiter) .. yita(w) =g= obj_record(iiiter,w ) - sum((p,i), pix_all(iiiter,p,i,w) * xf(p,i)+ piQ_all(iiiter,p,i,w)*Qf(p,i));
b2(p,i) .. xf(p,i)*QEU(p,i)=g= QEf(p,i);
b4(p,i) .. Qf(p,i) =e= Q0(p,i) + QEf(p,i);
b3(w, iiiter)$biter(iiiter)  .. yita(w) =g= v(iiiter, w) + sum((p,i), g1(iiiter, p,i,w) * xf(p,i) + g2(iiiter, p,i, w) * Qf(p,i) ) ;
model bendersmaster /bobj, b1,b2, b3,b4/;

*----------------------------DEFINE Benders subproblem---------------------------
parameters
xbar(p,i), Qbar(p,i), UB_Bender(iter),  cpu_bender_sub/0/, cpu_bender_master /0/, cpu_ub/0/ ;


equations
TX, TQ,  Beobj;
TX(p,i) .. x(p,i) =e= xbar(p,i);
TQ(p,i) .. Q(p,i) =e= Qbar(p,i);
Beobj .. cost =e= sum(w$freeze(w), prob(w) * sum(p, sum(i, betaC(i) * QE(p,i) + alphaC(i) * x(p,i)))) + sum(w$freeze(w), prob(w) * (sum((p,i,s,j)$(PS(i,s) and JM(i,s,j)), delta(i,s)*rho(i,j,s) * theta(p,i,j,s,w)) + sum((p,j,r)$RJ(r,j), (betaS(r,j) + betaRP(r,p)) * PU(r,p,j,w)) + sum((r,p), alphaRP(r,p) * y(r,p,w)) + sum((p,c), alphaPC(p,c) * z(p,c,w)) + sum((p,c,j), betaPC(p,c) * F(p,c,j,w)) + sum((c,j), phi(c,j) * Slack(c,j,w)) )) ;
model Bendersub /TX, TQ,e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,Beobj/;
BenderSub.optfile=1;

*Lagrangean master problem----------------------------------
Variables
kappa(w)
zML
muxV(p,i,w)
muQV(p,i,w)
;
Sets
para /d1/;
Parameters
*multpenalty(para) / d1 1e5, d2 5e5, d3 1e6/
multpenalty(para) / d1 0.8e5/
multpenalty0
zSB(iter, w)
total_obj_record(para, iter)
mux_record(para, iter, p,i,w)
muQ_record(para, iter, p,i,w)
center_mux(p,i,w)
center_muQ(p,i,w)
last_best_LB
;

center_mux(p,i,w) = 0;
center_mux(p,i,w) = 0;
parameters
LB 
UB;

Equations
mle1,mle2,mle3,mle4,mle5;
mle1 .. zML =l= sum(w, kappa(w)) - multpenalty0*sum((p,i,w), power((muxV(p,i,w)-center_mux(p,i,w))/alphaC(i), 2) + power((muQV(p,i,w)-center_muQ(p,i,w))/betaC(i), 2));
mle2(iiiter)$aiter(iiiter) .. kappa('w1') =l= obj_record(iiiter,'w1') + sum((p,i), sum(w$(ord(w) gt 1), -muxV(p,i,w) + mux(iiiter,p,i,w)) * x_record_lag(iiiter,p,i,'w1') ) + sum((p,i), sum(w$(ord(w) gt 1), -muQV(p,i,w) + muQ(iiiter,p,i,w)) * Q_record_lag(iiiter,p,i,'w1') );
mle3(iiiter, w)$(aiter(iiiter) and ord(w) gt 1) .. kappa(w) =l= obj_record(iiiter, w) + sum((p,i), (muxV(p,i,w)-mux(iiiter,p,i,w))*x_record_lag(iiiter,p,i,w) +(muQV(p,i,w) - muQ(iiiter,p,i,w))*Q_record_lag(iiiter,p,i,w) ); 
mle4(iiiter)$aiter(iiiter) .. kappa('w1') =l= zSB(iiiter, 'w1') + sum((p,i),sum(w$(ord(w) gt 1 ),  -muxV(p,i,w) ) * xf_record(iiiter, p,i) + sum(w$(ord(w) gt 1), -muQV(p,i,w)) * Qf_record(iiiter,p,i));
mle5(iiiter, w)$(aiter(iiiter) and ord(w) gt 1) .. kappa(w) =l= zSB(iiiter, w) + sum((p,i), muxV(p,i,w) * xf_record(iiiter, p,i) + muQV(p,i,w) * Qf_record(iiiter, p,i));
model ml /mle1,mle2,mle3,mle4, mle5/;
*
*finish defining Lagrangean master problem--------------------------



*-------------------solve model -----------------------------------
option optcr = 0;
option optca =0;
  OPTION LIMROW = 0;
OPTION LIMCOL = 0;
option NLP=CONOPT4;
OPTION rMINLP=CONOPT4;
option QCP = CPLEX;
option iterlim = 2e9;
option decimals = 8;
*parallel------------------
BenderSub.solvelink =3;
sub.solvelink =3;
bendersmaster.threads = 3;
ml.threads = 3;
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
LB_record(para)
UB_record(para);

aiter(iiiter) = yes;
loop(para,

  g1(iter,p,i,w) =0;
g2(iter,p,i,w)=0;
v(iter,w) =0;
mux(iter,p,i,w) = 0;
muQ(iter,p,i,w)=0;
center_mux(p,i,w) = 0;
center_muQ(p,i,w)=0;
pix_all(iter,p,i,w) =0;
piQ_all(iter,p,i,w) =0;
pix(p,i,w) = 0;
piQ(p,i,w) = 0;
LB = 0;
UB = 3466;
 multpenalty0 = multpenalty(para);
loop(iter,


*solve each lagrangean subproblem
loop(w3, 
  freeze(w2) = no;
  freeze(w3) = yes;
  solve sub using MINLP minimizing COST;
  lag_sub_handle(w3) = sub.handle;
  
);
Repeat
  loop(w3$handlecollect(lag_sub_handle(w3)),
      x_record_lag(iter,p,i,w3 ) = x.l(p,i);
      Q_record_lag(iter,p,i,w3)=Q.l(p,i);
      obj_record(iter, w3) = cost.l;
      cpu_lag = cpu_lag + sub.resusd;
      lag_sub_modelstat(iter,w3) = sub.modelStat;
      if(sub.modelStat ne 8 or sub.solveStat ne 1,
        UB=0;
        );
*      abort$(sub.modelStat ne 8 or sub.solveStat ne 1) 'abort due to error solve lag sub';
      display$handledelete(lag_sub_handle(w3)) 'trouble deleting handles';
      lag_sub_handle(w3)=0;
    );
until card(lag_sub_handle) =0;

  total_obj_record(para,iter) = sum(w, obj_record(iter,w));
  if(ord(iter) eq 1,
    last_best_LB = total_obj_record(para, iter);
    );
  if(total_obj_record(para, iter) - last_best_LB > 2,
    center_mux(p,i,w) = mux(iter, p,i,w);
    center_muQ(p,i,w) = muQ(iter, p,i,w);
    last_best_LB = total_obj_record(para, iter);
    );

*update multiplier in Benders master
    pix_all(iter,p,i,w) = pix(p,i,w);
    piQ_all(iter,p,i,w) = piQ(p,i,w);


*solve benders master problem----------------
    aiter(iiiter) = no;
    biter(iiiter)=no;
  loop(iiter,
    if(ord(iiter) le ord(iter),
       aiter(iiter)= yes;
      biter(iiter)= yes;
      );

    );
  solve bendersmaster using mip minimizing BenderOBJ;
  cpu_bender_master = cpu_bender_master + bendersmaster.resusd;
  BenderOBJ_record(iter) = BenderOBJ.l;
  master_modelstat(iter) = bendersmaster.modelStat;
  abort$(bendersmaster.modelStat ne 1 or bendersmaster.solveStat ne 1) 'abort due to error solve benders master';
  if(LB lt BenderOBJ.l,
    LB = BenderOBJ.l;
    );
  xf_record(iter,p,i) = xf.l(p,i);
  Qf_record(iter,p,i) = Qf.l(p,i);

*solve benders subproblem--------------------

*update fisrt stage decision
  xbar(p,i) = xf.l(p,i);
  Qbar(p,i) = Qf.l(p,i);
  UB_Bender(iter) = 0;
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
        zSB(iter, w3) = cost.l;
        UB_Bender(iter) = UB_Bender(iter) + cost.l;
        upper_sub_modelstat(iter,w3) = bendersub.modelStat;
        if((bendersub.modelStat ne 8 and bendersub.modelStat ne 2 and bendersub.modelStat ne 1)  or bendersub.solveStat ne 1,
          UB = 0;
          );
*        abort$((bendersub.modelStat ne 8 and bendersub.modelStat ne 2 and bendersub.modelStat ne 1)  or bendersub.solveStat ne 1) 'abort due to errors solve upper bound sub';
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
      v(iter, w3) = COST.l - sum((p,i), xbar(p,i) * TX.m(p,i) + Qbar(p,i) * TQ.m(p,i) ) ;
      g1(iter, p,i, w3) = TX.m(p,i);
      g2(iter, p,i, w3) = TQ.m(p,i);
      bender_sub_modelstat(iter,w3) = bendersub.modelStat;
        if ((bendersub.modelStat ne 2 and bendersub.modelStat ne 1) or bendersub.solveStat ne 1,
        UB=0;
        );
*      abort$((bendersub.modelStat ne 2 and bendersub.modelStat ne 1) or bendersub.solveStat ne 1) 'abort due to errors solve Bender subproblem';
      display$handledelete(Bendersub_handle(w3)) 'trouble deleting handles';
      Bendersub_handle(w3)=0;
      );

  until card(Bendersub_handle) =0;

  if(UB_Bender(iter) lt UB,
    UB = UB_Bender(iter);

    );
*finish benders-------------------

*lagrangean master problem----------------  
  solve ml using QCP maximizing zML;
  mux(iter+1, p,i,w) = muxV.l(p,i,w);
  muQ(iter+1, p,i,w) = muQV.l(p,i,w);
  loop(w,
    if(ord(w) gt 1,
      pix(p,i,w) =  mux(iter+1,p,i,w);
      piQ(p,i,w) = muQ(iter+1,p,i,w);

      );
    pix(p,i,'w1') = -sum((w2)$( ord(w2) gt 1), mux(iter+1,p,i,w2));
    piQ(p,i,'w1') = -sum((w2)$( ord(w2) gt 1 ), muQ(iter+1,p,i,w2));
    );

  if(LB * 1.01 gt UB,
    LB_record(para) = LB;
    UB_record(para) = UB;
    display LB, UB, total_obj_record, UB_Bender, BenderOBJ_record;
  break; );
  if ( ord(iter) eq card(iter),
        LB_record(para) = LB;
        UB_record(para) = UB;
        mux_record(para, iiter, p,i,w) = mux(iiter, p,i,w);
        muQ_record(para, iiter, p,i,w) = muQ(iiter, p,i,w);
        display LB, UB, total_obj_record, UB_Bender, BenderOBJ_record;

    );
  );

);
parameter
WallTime;
WallTime=TimeElapsed;
display x_record_lag,Q_record_lag,mux, muQ, pix, piQ,obj_record, pix_all, piQ_all,g2,v,xf_record, Qf_record;

display lag_sub_modelstat,bender_sub_modelstat,upper_sub_modelstat,master_modelstat,total_obj_record, BenderOBJ_record, UB_Bender,UB, LB, WallTime,cpu_ub,cpu_lag, cpu_bender_sub, cpu_bender_master;







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
piQ(p,i,w);
pix(p,i,w) = 0;
piQ(p,i,w) = 0;
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
eobj .. cost =e= sum(w$freeze(w), prob(w) * sum(p, sum(i, betaC(i) * QE(p,i)*100 + alphaC(i) * x(p,i)))) + sum(w$freeze(w), prob(w) * (sum((p,i,s,j)$(PS(i,s) and JM(i,s,j)), delta(i,s)*rho(i,j,s) * theta(p,i,j,s,w)) + sum((p,j,r)$RJ(r,j), (betaS(r,j) + betaRP(r,p)) * PU(r,p,j,w)) + sum((r,p), alphaRP(r,p) * y(r,p,w)) + sum((p,c), alphaPC(p,c) * z(p,c,w)) + sum((p,c,j), betaPC(p,c) * F(p,c,j,w)) + sum((c,j), phi(c,j) * Slack(c,j,w)) )) +  sum((p,i,w)$freeze(w), pix(p,i,w) * x(p,i) + piQ(p,i,w) * Q(p,i));

set iter /1*100/
aiter(iter)
biter(iter);


*lagrangean decomposition parameters
parameters
x_record_lag(iter,p,i,w)
Q_record_lag(iter,p,i,w)
obj_record(iter,w)
total_obj_record(iter)
mux(iter,p,i,w)
muQ(iter,p,i,w)
pix_all(iter,p,i,w)
piQ_all(iter,p,i,w)
cpu_lag/0/
den(iter)
stepsize
theta0 /1/
*theta00(ltheta)/1 0.2,2 0.6, 3 1, 4 1.5, 5 2/
half0 /0.5/
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
xbar(p,i), Qbar(p,i), UB_Bender(iter), cpu_bender_sub/0/, cpu_bender_master /0/, cpu_ub/0/ ;


equations
TX, TQ,  Beobj;
TX(p,i) .. x(p,i) =e= xbar(p,i);
TQ(p,i) .. Q(p,i) =e= Qbar(p,i);
Beobj .. cost =e= sum(w$freeze(w), prob(w) * sum(p, sum(i, betaC(i) * QE(p,i)*100 + alphaC(i) * x(p,i)))) + sum(w$freeze(w), prob(w) * (sum((p,i,s,j)$(PS(i,s) and JM(i,s,j)), delta(i,s)*rho(i,j,s) * theta(p,i,j,s,w)) + sum((p,j,r)$RJ(r,j), (betaS(r,j) + betaRP(r,p)) * PU(r,p,j,w)) + sum((r,p), alphaRP(r,p) * y(r,p,w)) + sum((p,c), alphaPC(p,c) * z(p,c,w)) + sum((p,c,j), betaPC(p,c) * F(p,c,j,w)) + sum((c,j), phi(c,j) * Slack(c,j,w)) )) ;
model Bendersub /TX, TQ,e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,Beobj/;
BenderSub.optfile=1;
*------------------------DEFINE cut generating linear program------------------
*define variables for the disjunction
Sets
djc/1*2/;
Positive variables
lpPU(r,p,j,w)
lpF(p,c,j,w)
lptheta(p,i,j,s,w)
lpWW(p,i,j,s,w)
lpSlack(c,j,w)
vPU(r,p,j,djc,w)
vF(p,c,j,djc,w)
vtheta(p,i,j,s,djc,w)
vQ(p,i, djc)
vWW(p,i,j,s,djc,w)
vSlack(c,j,djc,w)
lambda(djc);

Binary variables
vy(r,p,djc,w)
vz(p,c,djc,w)
lpy(r,p,w)
lpz(p,c,w)
;

variables
dnorm;

*define the optimal solution of Benders subproblems
Parameters
PUhat(r,p,j,w)
Fhat(p,c,j,w)
thetahat(p,i,j,s,w)
WWhat(p,i,j,s,w)
Slackhat(c,j,w)
yhat(r,p,w)
zhat(p,c,w)
epsilon /1e-4/;

*define superset
Sets
RP(r,p)
PC(p,c);

*set for interpolation of WW
sets
int /1*20/;

*parameter for interpolation points of WW
parameter
intWW(int);

loop(int,
intWW(int) = power(1.3, ord(int)) -1;
  );
*DEFINE equations for CGNLP
equations
d1, d2,d3,d5,d6,d7,d8,d9,d10,d11,d12,d12p,d14p,d14,d15,d16,d17,de3,de5,de6,de7,de8,de9,de10,de11,de12,ds1,ds2,ds3,ds4,dobj;
*todo check the domain of each variable, delete the redundant constraints
d1(r,p,j,w)$freeze(w) .. lpPU(r,p,j,w)=e=sum(djc,vPU(r,p,j,djc,w));
d2(p,c,j,w)$freeze(w) .. lpF(p,c,j,w) =e= sum(djc,vF(p,c,j,djc,w));
d3(p,i,j,s,w)$freeze(w) .. lptheta(p,i,j,s,w)=e= sum(djc, vtheta(p,i,j,s,djc,w));
d5(p,i,j,s,w)$freeze(w) .. lpWW(p,i,j,s,w) =e= sum(djc, vWW(p,i,j,s,djc,w));
d6(c,j,w)$freeze(w) .. lpSlack(c,j,w) =e= sum(djc, vSlack(c,j,djc,w));
d7(r,p,w)$freeze(w) .. lpy(r,p,w) =e= sum(djc, vy(r,p,djc,w));
d8(p,c,w)$freeze(w) .. lpz(p,c,w) =e= sum(djc, vz(p,c,djc,w));

d9 .. sum(djc,lambda(djc)) =e= 1;

*upper and lower bound of variables
d10(r,p,j,djc,w)$freeze(w) .. vPU(r,p,j,djc,w) =l= PUU * lambda(djc);
d11(p,c,j,djc,w )$freeze(w) .. vF(p,c,j,djc,w) =l= FUU* lambda(djc);
d12(p,i,j,s,djc, w)$freeze(w) .. vtheta(p,i,j,s,djc,w) =l=  QEU(p,i) * lambda(djc)*100;
d14(p,i,j,s,djc, w)$freeze(w) .. vWW(p,i,j,s,djc,w) =l= 1.2 * QEU(p,i) * lambda(djc)*100;
d12p(p,'i4','j5',s,djc, w)$freeze(w) .. vtheta(p,'i4','j5',s,djc,w) =l=  QEU(p,'i4') * lambda(djc)*5;
d14p(p,'i4','j5',s,djc, w)$freeze(w) .. vWW(p,'i4','j5',s,djc,w) =l= 1.2 * QEU(p,'i4') * lambda(djc)*5;
d15(c,j,djc,w)$freeze(w) .. vSlack(c,j,djc,w) =l= D(c,j,w) * lambda(djc);
d16(r,p,djc,w)$freeze(w) .. vy(r,p,djc,w) =l= lambda(djc);
d17(p,c,djc,w)$freeze(w) .. vz(p,c,djc,w) =l= lambda(djc);

*Constraints for second stage variables

de3(p,j,djc,w)$freeze(w) .. sum(r$RJ(r,j), vPU(r,p,j,djc,w)) + sum((i,s)$(OJ(i,j) and PS(i,s)), vWW(p,i,j,s,djc,w)) =e= sum(c, vF(p,c,j,djc,w)) + sum((i,s)$(IJ(i,j) and PS(i,s)), vWW(p,i,j,s,djc,w));
*de4(p,i,djc,w)$freeze(w) .. sum((j,s)$(JM(i,s,j) and PS(i,s)), vtheta(p,i,j,s,djc,w)) =l= H(i) * Qbar(p,i)*100 *lambda(djc);
de5(p,i,j,s,djc,w)$(freeze(w) and PS(i,s) and JM(i,s,j)) .. vWW(p,i,j,s,djc,w) =e= rho(i,j,s) * vtheta(p,i,j,s,djc,w);
de6(p,i,j,djc,w,s)$(freeze(w) and (not (PS(i,s) and JM(i,s,j)))) .. vtheta(p,i,j,s,djc,w) =e= 0;
de7(p,i,j,jj,djc,w,s)$(freeze(w) and L(i,s,j) and PS(i,s) and JM(i,s,jj)) .. vWW(p,i,j,s,djc,w) =e= mu(i,s,j) * vWW(p,i,jj,s,djc,w);
*de8(p,i,j,jj,djc,w,s)$(freeze(w) and Lbar(i,s,j) and PS(i,s) and JM(i,s,jj)) .. (lambda(djc)*(1-epsilon)+epsilon)*log(1+vWW(p,i,j,s,djc,w)/(lambda(djc)*(1-epsilon)+epsilon)) =g= mu(i,s,j) * vWW(p,i,jj,s,djc,w);
de8(p,i,j,jj,djc,w,s, int )$(freeze(w) and Lbar(i,s,j) and PS(i,s) and JM(i,s,jj)) .. lambda(djc)*(-log(1+intWW(int))) + (-1/(1+intWW(int))) * (vWW(p,i,j,s,djc,w) - intWW(int) * lambda(djc))  + mu(i,s,j) * vWW(p,i,jj,s,djc,w) =l= 0;

de9(r,p,djc,w,j)$(RJ(r,j) and freeze(w)) .. vPU(r,p,j,djc,w) =l= PUU * vy(r,p,djc,w);
de10(p,c,j,djc,w)$freeze(w) .. vF(p,c,j,djc,w) =l= FUU * vz(p,c,djc,w);
de11(c,j,djc,w)$freeze(w) .. sum(p, vF(p,c,j,djc,w)) + vSlack(c,j,djc,w) =e= D(c,j,w)*lambda(djc);
de12(p,i,j,s,djc,w)$(freeze(w) and (not(JM(i,s,j) or L(i,s,j) or Lbar(i,s,j)))) .. vWW(p,i,j,s,djc,w) =e= 0;

*set 0-1 variables
ds1(r,p,w)$(freeze(w) and RP(r,p)) .. vy(r,p,'1',w) =e= 0;
ds2(r,p,w)$(freeze(w) and RP(r,p)) .. vy(r,p,'2', w) =e= lambda('2');
ds3(p,c,w)$(freeze(w) and PC(p,c)) .. vz(p,c,'1',w) =e= 0;
ds4(p,c,w)$(freeze(w) and PC(p,c)) .. vz(p,c, '2',w) =e= lambda('2');


*define variables to represent the absolute value of variables
Positive variables
aPU(r,p,j,w)
aF(p,c,j,w)
atheta(p,i,j,s,w)
aWW(p,i,j,s,w)
aSlack(c,j,w)
ay(r,p,w)
az(p,c,w)
;


*define equations for calculating 1-norm
equations
n1p,n1m,n2p,n2m,n3p,n3m,n4p,n4m,n5p,n5m,n6p,n6m,n7p,n7m,n8p,n8m;
n1p(r,p,j,w)$freeze(w) .. aPU(r,p,j,w) =g= (lpPU(r,p,j,w) - PUhat(r,p,j,w))/PUU;
n1m(r,p,j,w)$freeze(w) .. aPU(r,p,j,w) =g= -(lpPU(r,p,j,w) - PUhat(r,p,j,w))/PUU;
n2p(p,c,j,w)$freeze(w) .. aF(p,c,j,w) =g= (lpF(p,c,j,w)-Fhat(p,c,j,w))/FUU;
n2m(p,c,j,w)$freeze(w) .. aF(p,c,j,w) =g= -(lpF(p,c,j,w)-Fhat(p,c,j,w))/FUU;
n3p(p,i,j,s,w)$(freeze(w) and JM(i,s,j) and PS(i,s) and (ord(i) ne 4 or ord(j) ne 5 )) .. atheta(p,i,j,s,w)=g= (lptheta(p,i,j,s,w) - thetahat(p,i,j,s,w))/QEU(p,i)/100;
n3m(p,i,j,s,w)$(freeze(w) and JM(i,s,j) and PS(i,s) and (ord(i) ne 4 or ord(j) ne 5 )) .. atheta(p,i,j,s,w)=g= -(lptheta(p,i,j,s,w) - thetahat(p,i,j,s,w))/QEU(p,i)/100;
n4p(p,i,j,s,w)$(freeze(w) and JM(i,s,j) and PS(i,s) and (ord(i) eq 4 and ord(j) eq 5 )) .. atheta(p,i,j,s,w)=g= (lptheta(p,i,j,s,w) - thetahat(p,i,j,s,w))/QEU(p,i)/5;
n4m(p,i,j,s,w)$(freeze(w) and JM(i,s,j) and PS(i,s) and (ord(i) eq 4 and ord(j) eq 5 )) .. atheta(p,i,j,s,w)=g= -(lptheta(p,i,j,s,w) - thetahat(p,i,j,s,w))/QEU(p,i)/5;
n5p(p,i,j,s,w)$(freeze(w) and (L(i,s,j) or Lbar(i,s,j)) and PS(i,s)) .. aWW(p,i,j,s,w) =g= (lpWW(p,i,j,s,w)-WWhat(p,i,j,s,w))/QEU(p,i)/100;
n5m(p,i,j,s,w)$(freeze(w) and (L(i,s,j) or Lbar(i,s,j)) and PS(i,s)) .. aWW(p,i,j,s,w) =g= -(lpWW(p,i,j,s,w)-WWhat(p,i,j,s,w))/QEU(p,i)/100;
n6p(c,j,w)$(freeze(w) and (ord(j)=3 or ord(j)=5)) .. aSlack(c,j,w) =g= (Slack(c,j,w) - Slackhat(c,j,w))/D(c,j,w);
n6m(c,j,w)$(freeze(w) and (ord(j)=3 or ord(j)=5)) .. aSlack(c,j,w) =g= -(Slack(c,j,w) - Slackhat(c,j,w))/D(c,j,w);
n7p(r,p,w)$freeze(w) .. ay(r,p,w) =g= lpy(r,p,w)-yhat(r,p,w);
n7m(r,p,w)$freeze(w) .. ay(r,p,w) =g= -lpy(r,p,w)+yhat(r,p,w);
n8p(p,c,w)$freeze(w) .. az(p,c,w) =g= (lpz(p,c,w)-zhat(p,c,w));
n8m(p,c,w)$freeze(w) .. az(p,c,w) =g= -(lpz(p,c,w)-zhat(p,c,w));
*define seperation problem obj
dobj(w)$(freeze(w)) .. dnorm =e= sum((r,p,j)$RJ(r,j), aPU(r,p,j,w)) + sum((p,c,j), aF(p,c,j,w)) + sum((p,i,j,s)$(JM(i,s,j) and PS(i,s) and (ord(i) ne 4 or ord(j) ne 5 )), atheta(p,i,j,s,w) )+ sum((p,i,j,s)$(JM(i,s,j) and PS(i,s) and (ord(i) eq 4 and ord(j) eq 5 )), atheta(p,i,j,s,w) ) + sum((p,i,j,s)$((L(i,s,j) or Lbar(i,s,j)) and PS(i,s)), aWW(p,i,j,s,w)) + sum((c,j)$(ord(j)=3 or ord(j)=5), aSlack(c,j,w) ) + sum((r,p), ay(r,p,w)) +sum((p,c), az(p,c,w));

model sep /d1, d2,d3,d5,d6,d7,d8,d9,d10,d11,d12,d12p,d14p,d14,d15,d16,d17,de3,de5,de6,de7,de8,de9,de10,de11,de12,ds1,ds2,ds3,ds4,dobj,n1p,n1m,n2p,n2m,n3p,n3m,n4p,n4m,n5p,n5m,n6p,n6m,n7p,n7m,n8p,n8m/;
*--------------DEFINE subproblem with lift and project cuts---------------------
alias (r,rr,r3), (p,pp,p3),(c,cc, c3);

*the parameters that record the optimal solutions of the CGNLP
parameters
PUrp(r,p,j,w,rr,pp)
Frp(p,c,j,w,rr,pp)
thetarp(p,i,j,s,w,rr,pp)
WWrp(p,i,j,s,w,rr,pp)
Slackrp(c,j,w,rr,pp)
yrp(r,p,w,rr,pp)
zrp(p,c,w,rr,pp)
PUpc(r,p,j,w,pp,cc)
Fpc(p,c,j,w,pp,cc)
thetapc(p,i,j,s,w,pp,cc)
WWpc(p,i,j,s,w,pp,cc)
Slackpc(c,j,w,pp,cc)
ypc(r,p,w,pp,cc)
zpc(p,c,w,pp,cc)
;

*sets define which constraints is active in the subproblem(some does not generate cuts)
Sets
aRP(rr,pp,w)
aPC(pp,cc,w);

equations
lp1, lp2;
lp1(rr,pp,w)$(freeze(w) and aRP(rr,pp,w)) .. sum((r,p,j)$RJ(r,j), sign((PUrp(r,p,j,w,rr,pp)-PUhat(r,p,j,w))/PUU)*(PU(r,p,j,w) - PUrp(r,p,j,w,rr,pp))/PUU) + sum((p,c,j), sign((Frp(p,c,j,w,rr,pp)-Fhat(p,c,j,w))/FUU)*(F(p,c,j,w)-Frp(p,c,j,w,rr,pp))/FUU) + sum((p,i,j,s)$(JM(i,s,j) and PS(i,s)and (ord(i) ne 4 or ord(j) ne 5 )), sign((thetarp(p,i,j,s,w,rr,pp)-thetahat(p,i,j,s,w))/QEU(p,i)/100)*(theta(p,i,j,s,w) - thetarp(p,i,j,s,w,rr,pp))/QEU(p,i)/100) + sum((p,i,j,s)$(JM(i,s,j) and PS(i,s)and (ord(i) eq 4 and ord(j) eq 5 )), sign((thetarp(p,i,j,s,w,rr,pp)-thetahat(p,i,j,s,w))/QEU(p,i)/5)*(theta(p,i,j,s,w) - thetarp(p,i,j,s,w,rr,pp))/QEU(p,i)/5)+ sum((p,i,j,s)$((L(i,s,j) or Lbar(i,s,j)) and PS(i,s)), sign((WWrp(p,i,j,s,w,rr,pp)-WWhat(p,i,j,s,w))/QEU(p,i)/100)*(WW(p,i,j,s,w)-WWrp(p,i,j,s,w,rr,pp))/QEU(p,i)/100) + sum((c,j)$(ord(j)=3 or ord(j)=5), sign((Slackrp(c,j,w,rr,pp)-Slackhat(c,j,w))/D(c,j,w))*(Slack(c,j,w) - Slackrp(c,j,w,rr,pp))/D(c,j,w)) + sum((r,p), sign((yrp(r,p,w,rr,pp)-yhat(r,p,w)))*(y(r,p,w)-yrp(r,p,w,rr,pp))) +sum((p,c), sign((zrp(p,c,w,rr,pp)-zhat(p,c,w)))*(z(p,c,w)-zrp(p,c,w,rr,pp))) =g= 0;
lp2(pp,cc,w)$(freeze(w) and aPC(pp,cc,w)) .. sum((r,p,j)$RJ(r,j), sign((PUpc(r,p,j,w,pp,cc)-PUhat(r,p,j,w))/PUU)*(PU(r,p,j,w) - PUpc(r,p,j,w,pp,cc))/PUU) + sum((p,c,j), sign((Fpc(p,c,j,w,pp,cc)-Fhat(p,c,j,w))/FUU)*(F(p,c,j,w)-Fpc(p,c,j,w,pp,cc))/FUU) + sum((p,i,j,s)$(JM(i,s,j) and PS(i,s)and (ord(i) ne 4 or ord(j) ne 5 )), sign((thetapc(p,i,j,s,w,pp,cc)-thetahat(p,i,j,s,w))/QEU(p,i)/100)*(theta(p,i,j,s,w) - thetapc(p,i,j,s,w,pp,cc))/QEU(p,i)/100)+ sum((p,i,j,s)$(JM(i,s,j) and PS(i,s)and (ord(i) eq 4 and ord(j) eq 5 )), sign((thetapc(p,i,j,s,w,pp,cc)-thetahat(p,i,j,s,w))/QEU(p,i)/5)*(theta(p,i,j,s,w) - thetapc(p,i,j,s,w,pp,cc))/QEU(p,i)/5)+ sum((p,i,j,s)$((L(i,s,j) or Lbar(i,s,j)) and PS(i,s)), sign((WWpc(p,i,j,s,w,pp,cc)-WWhat(p,i,j,s,w))/QEU(p,i)/100)*(WW(p,i,j,s,w)-WWpc(p,i,j,s,w,pp,cc))/QEU(p,i)/100) + sum((c,j)$(ord(j)=3 or ord(j)=5), sign((Slackpc(c,j,w,pp,cc)-Slackhat(c,j,w))/D(c,j,w))*(Slack(c,j,w) - Slackpc(c,j,w,pp,cc))/D(c,j,w)) + sum((r,p), sign((ypc(r,p,w,pp,cc)-yhat(r,p,w)))*(y(r,p,w)-ypc(r,p,w,pp,cc))) +sum((p,c), sign((zpc(p,c,w,pp,cc)-zhat(p,c,w)))*(z(p,c,w)-zpc(p,c,w,pp,cc))) =g= 0;
model lpsub /TX, TQ,e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,Beobj, lp1,lp2/;

*-------------------solve model -----------------------------------
option optcr = 0;
option optca =0;
  OPTION LIMROW = 0;
OPTION LIMCOL = 0;
option MINLP = dicopt;
option nlp = conopt;
option rMINLP = conopt;
option iterlim = 2e9;
option reslim = 1e3;
*parallel------------------
BenderSub.solvelink =3;
sub.solvelink =3;
sep.solvelink=3;
lpsub.solvelink=3;
bendersmaster.threads = 12;
parameters
cpu_sep /0/
cpu_lpsub /0/
Bendersub_handle(w3)
sep_handle(w3)
lpsub_handle(w3)
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
lpsub_obj(iter, w)
bender_sub_obj(iter,w);
set
baditer(iter);
baditer(iter) = no;
parameters
LB
UB;
LB = 700;
UB =1703.074  ;
aiter(iiiter) = yes;
loop(iter,


*solve each lagrangean subproblem
if(ord(iter) le 30,
loop(w3,
  freeze(w2) = no;
  freeze(w3) = yes;
  Slack.l(c,'j3', w3) = 50;
  Slack.l(c,'j5',w3) = 2;
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
      abort$(sub.modelStat ne 8 and sub.modelStat ne 1 and sub.modelStat ne 2) 'abort due to error solve lag sub';
      display$handledelete(lag_sub_handle(w3)) 'trouble deleting handles';
      lag_sub_handle(w3)=0;
    );
until card(lag_sub_handle) =0;

  total_obj_record(iter) = sum(w, obj_record(iter,w));
*update multiplier
    pix_all(iter,p,i,w) = pix(p,i,w);
    piQ_all(iter,p,i,w) = piQ(p,i,w);
);

*solve benders master problem----------------
    aiter(iiiter) = no;
    biter(iiiter)=no;
  loop(iiter,
    if(ord(iiter) le ord(iter),
      biter(iiter)= yes;
      );
      if(ord(iiter) le ord(iter) and ord(iiter) le 30,
      aiter(iiter)= yes;
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
        UB_Bender(iter) = UB_Bender(iter) + cost.l;
        upper_sub_modelstat(iter,w3) = bendersub.modelStat;
        abort$((bendersub.modelStat ne 8 and bendersub.modelStat ne 2 and bendersub.modelStat ne 1)  or bendersub.solveStat ne 1) 'abort due to errors solve upper bound sub';
        display$handledelete(Bendersub_handle(w3)) 'trouble deleting handles';
        Bendersub_handle(w3)=0;
      );
  until card(Bendersub_handle) =0;
*update upper bound
  if(UB_Bender(iter) lt UB,
    UB = UB_Bender(iter);

    );

*solve NLP relaxation--------------
  loop(w3,
    freeze(w2) = no;
    freeze(w3) = yes;
    Slack.l(c,'j3', w3) = 50;
    Slack.l(c,'j5',w3) = 2;
    solve Bendersub using rMINLP minimizing COST;
    Bendersub_handle(w3)= Bendersub.handle;

    );

  Repeat
    loop(w3$handlecollect(Bendersub_handle(w3)),
      cpu_bender_sub = cpu_bender_sub + Bendersub.resusd;
      bender_sub_obj(iter, w3) = cost.l;
*update parameters
      PUhat(r,p,j,w3) = PU.l(r,p,j,w3);
    Fhat(p,c,j,w3) = F.l(p,c,j,w3);
    thetahat(p,i,j,s,w3) = theta.l(p,i,j,s,w3);
    WWhat(p,i,j,s,w3) = WW.l(p,i,j,s,w3);
    Slackhat(c,j,w3) = Slack.l(c,j,w3);
    yhat(r,p,w3) = y.l(r,p,w3);
    zhat(p,c,w3) = z.l(p,c, w3);
      bender_sub_modelstat(iter,w3) = bendersub.modelStat;
      abort$((bendersub.modelStat ne 2 and bendersub.modelStat ne 1) or bendersub.solveStat ne 1) 'abort due to errors solve Bender subproblem';
      display$handledelete(Bendersub_handle(w3)) 'trouble deleting handles';
      Bendersub_handle(w3)=0;
      );

  until card(Bendersub_handle) =0;


*solve SEP problems-------------------
PC(p,c) = no;
RP(r,p) = no;
aRP(r,p,w) = no;
loop(r3,
  loop(p3,
    RP(r,p) = no;
    RP(r3,p3) =yes;
    loop(w3,
      freeze(w2) = no;
      freeze(w3) = yes;
      if(yhat(r3,p3,w3) gt 1e-1 and yhat(r3,p3,w3) lt (1 -1e-1),
        aRP(r3,p3,w3) = yes;
        solve sep using rMIP minimizing dnorm;
        sep_handle(w3) = sep.handle;
        );
      );
    Repeat
      loop(w3$handlecollect(sep_handle(w3)),
        cpu_sep = cpu_sep + sep.resusd;
*update parameters
          PUrp(r,p,j,w3,r3,p3) = lpPU.l(r,p,j,w3);
        Frp(p,c,j,w3,r3,p3) = lpF.l(p,c,j,w3);
        thetarp(p,i,j,s,w3,r3,p3) = lptheta.l(p,i,j,s,w3);
        WWrp(p,i,j,s,w3,r3,p3) = lpWW.l(p,i,j,s,w3);
        Slackrp(c,j,w3,r3,p3) = lpSlack.l(c,j,w3);
        yrp(r,p,w3,r3,p3) = lpy.l(r,p,w3);
        zrp(p,c,w3,r3,p3) = lpz.l(p,c, w3);
        display sep.modelStat;
*       abort$(sep.modelStat ne 2 and sep.modelStat ne 1 and sep.modelStat ne 7) "abort due to errors solving sep problem";
       display$handledelete(sep_handle(w3)) 'trouble deleting handles';
        if(dnorm.l lt 1e-6 or (sep.modelStat ne 2 and sep.modelStat ne 1),
          aRP(r3,p3,w3) = no;
          );

        sep_handle(w3) = 0;
        );
    until card(sep_handle) =0;
  );
);

RP(r,p) = no;
PC(p,c) = no;
aPC(p,c,w) = no;
ypc(r,p,w3,p3,c3) = 0;
zpc(p,c,w3,p3,c3) = 0;
loop(p3,
  loop(c3,
    PC(p,c) = no;
    PC(p3,c3) =yes;
    loop(w3,
      freeze(w2) = no;
      freeze(w3) = yes;
      if(zhat(p3,c3,w3) gt 1e-1 and zhat(p3,c3,w3) lt (1 -1e-1),
        aPC(p3,c3,w3) = yes;
        solve sep using rMIP minimizing dnorm;
        sep_handle(w3) = sep.handle;
        );
      );
    Repeat
      loop(w3$handlecollect(sep_handle(w3)),
        cpu_sep = cpu_sep + sep.resusd;
*update parameters
          PUpc(r,p,j,w3,p3,c3) = lpPU.l(r,p,j,w3);
        Fpc(p,c,j,w3,p3,c3) = lpF.l(p,c,j,w3);
        thetapc(p,i,j,s,w3,p3,c3) = lptheta.l(p,i,j,s,w3);
        WWpc(p,i,j,s,w3,p3,c3) = lpWW.l(p,i,j,s,w3);
        Slackpc(c,j,w3,p3,c3) = lpSlack.l(c,j,w3);
        ypc(r,p,w3,p3,c3) = lpy.l(r,p,w3);
        zpc(p,c,w3,p3,c3) = lpz.l(p,c, w3);
        display sep.modelStat;
        if(dnorm.l lt 1e-6 or (sep.modelStat ne 2 and sep.modelStat ne 1),
          aPC(p3,c3,w3) = no;
          );
*       abort$(sep.modelStat ne 2 and sep.modelStat ne 1 and sep.modelStat ne 7) "abort due to errors solving sep problem";
       display$handledelete(sep_handle(w3)) 'trouble deleting handles';
        sep_handle(w3) = 0;
        );
    until card(sep_handle) =0;
  );
);

*--------------------solve subproblems with lift-and-project cuts
display yhat, zhat;
display ypc,zpc;
display aPC, aRP;
loop(w3,
  freeze(w2) = no;
  freeze(w3) = yes;
  solve lpsub using rMINLP minimizing cost;
  lpsub_handle(w3) = lpsub.handle;
  );
Repeat
  loop(w3$handlecollect(lpsub_handle(w3)),
    cpu_lpsub = cpu_lpsub + lpsub.resusd;
    lpsub_obj(iter, w3) = cost.l;
    if(lpsub.modelStat eq 1 or lpsub.modelStat eq 2 ,
    v(iter, w3) = COST.l - sum((p,i), xbar(p,i) * TX.m(p,i) + Qbar(p,i) * TQ.m(p,i) ) ;
    g1(iter, p,i, w3) = TX.m(p,i);
    g2(iter, p,i, w3) = TQ.m(p,i);
    else
    baditer(iter) = yes;
    );
    display lpsub.modelStat;
*   abort$(lpsub.modelStat ne 1 and lpsub.modelStat ne 2 and lpsub.modelStat ne 7) 'abort due to errors solving lpsub';
    display$handledelete(lpsub_handle(w3)) 'trouble deleting handles';
    lpsub_handle(w3) =0;
    );
until card(lpsub_handle) = 0;

*update lagrangean multiplier
if(ord(iter) le 30,
  den(iter) = sum((p,i,w), power(x_record_lag(iter,p,i,w) -x_record_lag(iter,p,i,'w1'), 2 ) + power(Q_record_lag(iter,p,i,w)-Q_record_lag(iter,p,i,'w1'), 2) );
  stepsize = theta0 * (UB-LB)/den(iter);
  loop(w,
    if(ord(w) gt 1,
      mux(iter+1,p,i,w) = mux(iter,p,i,w) + (x_record_lag(iter,p,i,w)-x_record_lag(iter,p,i,'w1')) * stepsize;
      muQ(iter+1,p,i,w) = muQ(iter,p,i,w) + (Q_record_lag(iter,p,i,w)-Q_record_lag(iter,p,i,'w1')) * stepsize;
      );
    );
  loop(w,
    if(ord(w) gt 1,
      pix(p,i,w) =  mux(iter+1,p,i,w);
      piQ(p,i,w) = muQ(iter+1,p,i,w);

      );
    pix(p,i,'w1') = -sum((w2)$( ord(w2) gt 1), mux(iter+1,p,i,w2));
    piQ(p,i,'w1') = -sum((w2)$( ord(w2) gt 1 ), muQ(iter+1,p,i,w2));
    );
  if (ord(iter) gt 1,
    change = -(total_obj_record(iter-1) - total_obj_record(iter)) / total_obj_record(iter-1);
    if (change lt 0,
      theta0 = theta0 * half0;
      );
    );
  );
  if(LB lt total_obj_record(iter),
    LB = total_obj_record(iter);
    );
  if(LB * 1.01 gt UB,
  break; );
  );

parameter
gap_closed(iter);
gap_closed(iter) = (sum(w, lpsub_obj(iter,w))-sum(w,bender_sub_obj(iter,w)))/(UB_Bender(iter)-sum(w,bender_sub_obj(iter,w)));
parameter
WallTime;
WallTime=TimeElapsed;
display x_record_lag,Q_record_lag,mux, muQ, obj_record, pix_all, piQ_all,g2,v,xf_record, Qf_record;

display lag_sub_modelstat,bender_sub_modelstat,upper_sub_modelstat,master_modelstat,bender_sub_obj, aRP, aPC, lpsub_obj,gap_closed,total_obj_record, BenderOBJ_record, UB_Bender,UB, LB, WallTime,cpu_ub,cpu_lag, cpu_bender_sub, cpu_bender_master, cpu_sep, cpu_lpsub ;
display baditer;

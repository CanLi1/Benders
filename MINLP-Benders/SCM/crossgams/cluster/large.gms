
*in order to change this file to solve problem with different number of scenarios
*you have to change set w, parameter D(j,c,w), set clus, parameter prob
sets
  i 'raw materials'        / I1*I3 /
  j 'products'             / J1*J4 /
  s 'suppliers'            / S1*S3 /
  p 'plants'               / P1*P5 /
  c 'customers'            / C1*C12 /
  w 'scenarios'           /1*128/
  clus 'scenario cluster' /1*32/
  freeze(w)
  CLUSW(clus, w)
;
parameter size;
size = card(w) / card(clus);
alias(clus, cluss, clusss);
alias (ww,w,www);
loop(cluss,
  loop(www,
    if(ord(www) gt size * (ord(cluss)-1) and ord(www) le size * ord(cluss), 
      CLUSW(cluss, www) = yes;
      else
      CLUSW(cluss, www) = no;
      );
    );
  );



table IS(i,s) '1 if supplier s supplies raw material i'
        S1      S2      S3
  I1    1       1       1
  I2    1               1
  I3            1       1
;

table IP(i,p) '1 if plant p requires raw material i'
        P1      P2      P3      P4      P5
  I1    1       1       1       1       1
  I2    1       1       1       1
  I3            1       1               1
;

table JP(j,p) '1 if plant produces product j'
        P1      P2      P3      P4      P5
  J1    1                       1
  J2    1       1       1       1
  J3            1       1               1
  J4                    1               1
;

table U(i,s) 'maximum amount of raw material i that can be purchased from supplier s [tonne/yr]'
        S1      S2      S3
  I1    10000   20000   20000
  I2    20000           30000
  I3            20000   20000
;

table CAP(j,p) 'maximum amount of product j that can be produced at plant p [tonne/yr]'
        P1      P2      P3      P4      P5
  J1    3000                    4000
  J2    3000    1500    2500    4000
  J3            1500    2500            1500
  J4                    2500            1500
;

table M(j,p) 'upper bound for capacity expansion for producing product j at plant p [tonne/yr]'
        P1      P2      P3      P4      P5
  J1    10000                   10000
  J2    10000   10000   10000   10000
  J3            10000   10000           10000
  J4                    10000           10000
;

table rho(i,j,p) 'conversion factor for converting raw material i into product j at plant p'
            P1      P2      P3      P4      P5
  I1.J1     1.2                     1.2
  I1.J2     0.6     0.6             0.6
  I1.J3                     1.5             1.5
  I1.J4                     0.8             0.7
  I2.J1
  I2.J2     0.8     0.8     1.3     0.8
  I2.J3
  I2.J4
  I3.J1
  I3.J2
  I3.J3             1.1
  I3.J4                     0.8             0.7
;

table tempD(j,c,w) 'amount of product j requested by customer c in year t [tonne]'
            1        2        3
J1.C1    1300     1000      700
J1.C2 
J1.C3    2600     2000     1400
J1.C4    1560     1200      840
J1.C5 
J1.C6    3120     2400     1680
J1.C7 
J1.C8 
J1.C9    1300     1000      700
J1.C10  
J1.C11   1300     1000      700
J1.C12   1560     1200      840
J2.C1    1300     1000      700
J2.C2 
J2.C3    1950     1500     1050
J2.C4    1950     1500     1050
J2.C5    2600     2000     1400
J2.C6     650      500      350
J2.C7 
J2.C8    1300     1000      700
J2.C9    1950     1500     1050
J2.C10   1300     1000      700
J2.C11   1300     1000      700
J2.C12   2600     2000     1400
J3.C1 
J3.C2    1300     1000      700
J3.C3    1040      800      560
J3.C4    1040      800      560
J3.C5 
J3.C6     650      500      350
J3.C7    2600     2000     1400
J3.C8    1300     1000      700
J3.C9 
J3.C10  
J3.C11   1300     1000      700
J3.C12   1950     1500     1050
J4.C1 
J4.C2     650      500      350
J4.C3    1040      800      560
J4.C4     650      500      350
J4.C5    1300     1000      700
J4.C6 
J4.C7 
J4.C8 
J4.C9    1040      800      560
J4.C10   1040      800      560
J4.C11    650      500      350
J4.C12   1300     1000      700;
*generate scenario 
parameters
D(j,c,w), num;
D(j,'C8', w) = tempD(j,'C8', '2');
D(j,'C9', w) = tempD(j,'C9', '2');
D(j,'C10', w) = tempD(j,'C10', '2');
D(j,'C11', w) = tempD(j,'C11', '2');
D(j,'C12', w) = tempD(j,'C12', '2');
Set 
subb/1*2/;
alias (sub0,sub1,sub2,sub3,sub4,sub5,sub6,subb);
loop(sub0,
 loop(sub1,
  loop(sub2,
   loop(sub3,
    loop(sub4,
     loop(sub5,
      loop(sub6,

            num = 0;
             
            num = 1*(ord(sub0)-1)+2*(ord(sub1)-1)+4*(ord(sub2)-1)+8*(ord(sub3)-1)+16*(ord(sub4)-1)+32*(ord(sub5)-1)+64*(ord(sub6)-1);
            loop(w, 
              if(ord(w) eq num + 1,
            D(j,'C1', w )= tempD(j,'C1','2')*(1 + (ord(sub0)-1.5)/2);
            D(j,'C2', w )= tempD(j,'C2','2')*(1 + (ord(sub1)-1.5)/2);
            D(j,'C3', w )= tempD(j,'C3','2')*(1 + (ord(sub2)-1.5)/2);
            D(j,'C4', w )= tempD(j,'C4','2')*(1 + (ord(sub3)-1.5)/2);
            D(j,'C5', w )= tempD(j,'C5','2')*(1 + (ord(sub4)-1.5)/2);
            D(j,'C6', w )= tempD(j,'C6','2')*(1 + (ord(sub5)-1.5)/2);
            D(j,'C7', w )= tempD(j,'C7','2')*(1 + (ord(sub6)-1.5)/2);

            );
              );

           );
          );
         );
        );
       );
      );
     );
table betaS(i,s) 'variable cost for purchasing raw material j from supplier s [$/tonne]'
        S1      S2      S3
  I1    200     250     150
  I2    300             200
  I3            250     150
;

table betaP(j,p) 'variable cost for producing product j at plant p [$/tonne]'
        P1      P2      P3      P4      P5
  J1    100                     150
  J2    150     70      100     100
  J3            100     150             80
  J4                    80              50
;

table alphaSP(s,p) 'yearly fixed cost for transporting one chemical from supplier s to plant p [$]'
        P1      P2      P3      P4      P5
  S1    5000    5000    5000    5000    10000
  S2    5000    5000    5000    5000    10000
  S3    10000   5000    5000    10000   5000
;

table betaSP(s,p) 'variable cost for transporting one chemical from supplier s to plant p [$/tonne]'
        P1    P2    P3    P4    P5
  S1    20    20    30    50    70
  S2    20    30    20    20    60
  S3    90    50    50    55    20
;

table alphaPC(p,c) 'yearly fixed cost for transporting one chemical from plant p to customer c [$]'
        C1      C2      C3      C4      C5      C6      C7      C8      C9      C10     C11     C12
  P1    4000    4000    4000    8000    8000    8000    8000    8000    4000    4000    4000    4000
  P2    4000    4000    4000    4000    4000    4000    8000    8000    8000    8000    4000    4000
  P3    10000   5000    5000    5000    5000    5000    5000    5000    5000    5000    5000    5000
  P4    10000   10000   10000   10000   5000    5000    5000    5000    5000    5000    5000    5000
  P5    6000    6000    6000    3000    3000    3000    3000    3000    3000    6000    6000    3000
;

table betaPC(p,c) 'variable cost for transporting one chemical from plant p to customer c [$/tonne]'
        C1    C2    C3    C4    C5    C6    C7    C8    C9    C10   C11   C12
  P1    20    20    40    60    60    60    90    70    40    20    20    40
  P2    50    40    20    20    35    45    70    60    60    60    30    15
  P3    60    50    50    40    25    25    50    30    30    45    15    15
  P4    60    60    70    60    50    30    45    20    10    40    35    40
  P5    95    85    75    50    30    25    20    30    50    85    65    50
;

table alphaC(j,p) 'fixed cost for expanding capacity of producing product j at plant p [$]'
        P1      P2      P3      P4      P5
  J1    1.5E6                   1.5E6
  J2    1E6     1.2E6   1.2E6   1E6
  J3            1E6     1E6             1E6
  J4                    1.2E6           1E6
;

table betaC(j,p) 'variable cost for expanding capacity of producing product j at plant p [$/tonne]'
        P1      P2      P3      P4      P5
  J1    30                      30
  J2    40      40      40      40
  J3            30      30              30
  J4                    35              30
;






*dual variables
parameters
pix(j,p,w)
piCAP(j,p,w)
prob/7.8125E-3/;
pix(j,p,w) = 0;
piCAP(j,p,w)=0;

* -------------------- Model Formulation -------------------------------------

variables
  ZC  'total cost [$]'
  CS(w)  'purchasing cost [$]'
  CP(w)  'production cost [$]'
  CSP(w) 'supplier-plant transportation cost [$]'
  CPC(w) 'plant-customer transportation cost [$]'
  CC(w)  'capacity expansion cost [$]'
  CDUAL(w) 'dual cost '
  
;

positive variables
 
   CAP_(j,p,w)   'expanded capacity for producing product j at plant p [tonne]'
  F(i,s,p,w)  'amount of raw material i transported from supplier s to plant p in time period t [tonne]'
  F_(j,p,c,w) 'amount of product j transported from plant p to customer c in time period t [tonne]'
  Q(j,p,w)    'amount of product j produced at plant p in time period t [tonne]'
  R(i,s,w)    'amount of raw material i purchased from supplier s in time period t [tonne]'
    Slack(j,c,w) 'slack variable for not satisfying the demand'
;

binary variables
  X(j,p,w)      '1 if capacity for product j expanded at plant p'
  Y(i,s,p,w)  '1 if raw material i transported from supplier s to plant p in time period t'
  Y_(j,p,c,w) '1 if product j transported from plant p to customer c in time period t'

;

equations
  ObjC, ObjC1, ObjC2, ObjC3, ObjC4, ObjC5,
  Con1, Con2, Con3, Con4, Con5, Con6, Con7, Con8, Con9 , NLP, DUAL;

* Objective functions:
  DUAL(w)$(freeze(w)) .. CDUAL(w) =e= sum((j,p)$JP(j,p), pix(j,p,w) * x(j,p,w)+piCAP(j,p,w)* CAP_(j,p,w)) ;
  ObjC..  ZC =e= sum(w$freeze(w), prob *( CS(w) + CP(w) + CSP(w) + CPC(w) + CC(w) + 900 * sum((j,c), Slack(j,c,w)))+CDUAL(w)) ;
  ObjC1(w)$(freeze(w)).. CS(w) =e= sum( (i,s)$IS(i,s) , betaS(i,s)*R(i,s,w) ) ;
  ObjC2(w)$(freeze(w)).. CP(w) =e= sum( (j,p)$JP(j,p) , betaP(j,p)*Q(j,p,w) ) ;
  ObjC3(w)$(freeze(w)).. CSP(w) =e= sum( (i,s,p)$(IS(i,s) and IP(i,p)) , (alphaSP(s,p)*Y(i,s,p,w)+betaSP(s,p)*F(i,s,p,w)) ) ;
  ObjC4(w)$(freeze(w)).. CPC(w) =e= sum( (j,p,c)$JP(j,p) , (alphaPC(p,c)*Y_(j,p,c,w)+betaPC(p,c)*F_(j,p,c,w)) ) ;
  ObjC5(w)$(freeze(w)).. CC(w) =e= sum( (j,p)$JP(j,p) , alphaC(j,p)*X(j,p,w) + betaC(j,p)*CAP_(j,p,w) ) ;
  

* Mass balance at supplier:
  Con1(i,s,w)$(IS(i,s) and freeze(w)).. R(i,s,w) =l= U(i,s) ;
  Con2(i,s,w)$(IS(i,s) and freeze(w)).. R(i,s,w) =e= sum(p$IP(i,p),F(i,s,p,w)) ;

* Mass balance at plant:
  Con3(i,p,w)$(IP(i,p)and freeze(w)).. sum(s$IS(i,s),F(i,s,p,w)) =e= sum(j$JP(j,p),rho(i,j,p)*Q(j,p,w)) ;
  Con4(j,p,w)$(JP(j,p)and freeze(w)).. Q(j,p,w) =l= CAP(j,p) + CAP_(j,p,w) ;
  Con5(j,p,w)$(JP(j,p) and freeze(w))..   CAP_(j,p,w) =l= M(j,p)*X(j,p,w) ;

  Con6(j,p,w)$(JP(j,p) and freeze(w)).. Q(j,p,w) =e= sum(c,F_(j,p,c,w)) ;

* Mass balance at customer:
  Con7(j,c,w)$freeze(w).. sum(p$JP(j,p),F_(j,p,c,w)) + Slack(j,c,w) =e= D(j,c,w) ;

* Distributino capacities:
  Con8(i,s,p,w)$(IS(i,s) and IP(i,p) and freeze(w)).. F(i,s,p,w) =l= 1E4*Y(i,s,p,w) ;
  Con9(j,p,c,w)$(JP(j,p)and freeze(w))..               F_(j,p,c,w) =l=3000*Y_(j,p,c,w) ;

  NLP(w)$(freeze(w)) .. SQRT( sum( (i,s)$IS(i,s) , R(i,s,w)**2 ) + sum( (j,p)$JP(j,p) , Q(j,p,w)**2 ) + sum( (i,s,p)$(IS(i,s) and IP(i,p)) , F(i,s,p,w)**2 )  +sum( (j,p,c)$JP(j,p) , F_(j,p,c,w)**2) + sum((j,c), Slack(j,c,w) ** 2 ) ) * 2 + ( sum( (i,s)$IS(i,s) , R(i,s,w)*5 ) + sum( (j,p)$JP(j,p) , Q(j,p,w)*5 ) + sum( (i,s,p )$(IS(i,s) and IP(i,p)) , F(i,s,p,w)*5 ) +sum( (j,p,c)$JP(j,p) , F_(j,p,c,w)*5) + sum((j,c), Slack(j,c,w) *6 ) ) =l= 1.1e6 ;

set iter /1*30/
aiter(iter);


*lagrangean decomposition parameters
parameters
x_record_lag(iter,j,p,w)
CAP_record_lag(iter,j,p,w)
obj_record(iter,clus)
total_obj_record(iter)
mux(iter,j,p,w)
muCAP(iter,j,p,w)
pix_all(iter,j,p,w)
piCAP_all(iter,j,p,w)
cpu_lag/0/ 
den(iter)
stepsize
theta /0.2/
change;
mux('1',j,p,w) = 0;
muCAP('1',j,p,w)=0;
pix_all(iter,j,p,w) =0;
piCAP_all(iter,j,p,w) =0;

alias (iiiter, iiter, iter);
model sub /  ObjC, ObjC1, ObjC2, ObjC3, ObjC4, ObjC5,Con1, Con2, Con3, Con4, Con5, Con6, Con7, Con8, Con9 , NLP, DUAL/;
*--------------------benders master  equations--------------------------------------
******************
*define Benders master problem
Binary Variables
xf(j,p);
positive variables
capf(j,p),yita(clus);
Variables 
BenderOBJ;
parameters
BenderOBJ_record(iter)
xf_record(iter, j,p)
capf_record(iter, j,p)
v(iter,w)
g1(iter, j,p,w)
g2(iter,j,p,w)
x_record_b(iter, j,p)
CAP_record_b(iter,j,p);
g1(iter,j,p,w) =0;
g2(iter,j,p,w)=0;
v(iter,w) =0;
equations
bobj, b1,b2,b3;
bobj .. BenderOBJ =e= sum(clus,  yita(clus))  ;
b1(clus, iiiter) .. yita(clus) =g= obj_record(iiiter,clus) + sum(w$CLUSW(clus,w), - sum((j,p)$JP(j,p), pix_all(iiiter,j,p,w) * xf(j,p)+ piCAP_all(iiiter,j,p,w)*capf(j,p)) );
b2(j,p)$JP(j,p) .. xf(j,p)*M(j,p)=g= capf(j,p);
b3(clus, iiiter)  .. yita(clus) =g= sum(w$CLUSW(clus, w), v(iiiter, w) + sum((j,p)$JP(j,p), g1(iiiter, j, p,w) * xf(j,p) + g2(iiiter, j,p, w) * capf(j,p) ) ) + sum((j,p)$JP(j,p), alphaC(j,p)*xf(j,p) + betaC(j,p)*capf(j,p) )  * prob * size;
model bendersmaster /bobj, b1,b2, b3/;

*****finish defining benders master problem

*----------------------------DEFINE Benders subproblem---------------------------
parameters
xbar(j,p), capbar(j,p), UB_Bender(iter), cpu_bender_sub/0/, cpu_bender_master /0/, cpu_ub/0/ ;
Positive Variables 
BX(j,p,w)
BSY(i,s,p,w)  '1 if raw material i transported from supplier s to plant p in time period t'
BSY_(j,p,c,w) '1 if product j transported from plant p to customer c in time period t'
;
BX.up(j,p,w) =1;
BSY.up(i,s,p,w) = 1;
BSY_.up(j,p,c,w) = 1;
equations
  BSObjC, BSObjC1, BSObjC2, BSObjC3, BSObjC4, BSObjC5,
  BSCon1, BSCon2, BSCon3, BSCon4, BSCon5, BSCon6, BSCon7, BSCon8, BSCon9 , BSNLP, TX, TCAP;

*transfer equation
  TX(j,p,w)$(freeze(w) and  JP(j,p)) .. BX(j,p,w) =e= xbar(j,p);
  TCAP(j,p,w)$(freeze(w) and JP(j,p) ).. CAP_(j,p,w) =e= capbar(j,p);
* Objective functions:
  BSObjC..  ZC =e= sum(w$freeze(w), prob *( CS(w) + CP(w) + CSP(w) + CPC(w)  + 900 * sum((j,c), Slack(j,c,w)))) ;
  BSObjC1(w)$(freeze(w)).. CS(w) =e= sum( (i,s)$IS(i,s) , betaS(i,s)*R(i,s,w) ) ;
  BSObjC2(w)$(freeze(w)).. CP(w) =e= sum( (j,p)$JP(j,p) , betaP(j,p)*Q(j,p,w) ) ;
  BSObjC3(w)$(freeze(w)).. CSP(w) =e= sum( (i,s,p)$(IS(i,s) and IP(i,p)) , (alphaSP(s,p)*BSY(i,s,p,w)+betaSP(s,p)*F(i,s,p,w)) ) ;
  BSObjC4(w)$(freeze(w)).. CPC(w) =e= sum( (j,p,c)$JP(j,p) , (alphaPC(p,c)*BSY_(j,p,c,w)+betaPC(p,c)*F_(j,p,c,w)) ) ;
  
  

* Mass balance at supplier:
  BSCon1(i,s,w)$(IS(i,s) and freeze(w)).. R(i,s,w) =l= U(i,s) ;
  BSCon2(i,s,w)$(IS(i,s) and freeze(w)).. R(i,s,w) =e= sum(p$IP(i,p),F(i,s,p,w)) ;

* Mass balance at plant:
  BSCon3(i,p,w)$(IP(i,p)and freeze(w)).. sum(s$IS(i,s),F(i,s,p,w)) =e= sum(j$JP(j,p),rho(i,j,p)*Q(j,p,w)) ;
  BSCon4(j,p,w)$(JP(j,p)and freeze(w)).. Q(j,p,w) =l= CAP(j,p) + CAP_(j,p,w) ;
  
  BSCon6(j,p,w)$(JP(j,p) and freeze(w)).. Q(j,p,w) =e= sum(c,F_(j,p,c,w)) ;

* Mass balance at customer:
  BSCon7(j,c,w)$freeze(w).. sum(p$JP(j,p),F_(j,p,c,w)) + Slack(j,c,w) =e= D(j,c,w) ;

* Distributino capacities:
  BSCon8(i,s,p,w)$(IS(i,s) and IP(i,p) and freeze(w)).. F(i,s,p,w) =l= 1E4*BSY(i,s,p,w) ;
  BSCon9(j,p,c,w)$(JP(j,p)and freeze(w))..               F_(j,p,c,w) =l=3000*BSY_(j,p,c,w) ;

  BSNLP(w)$(freeze(w)) .. SQRT( sum( (i,s)$IS(i,s) , R(i,s,w)**2 ) + sum( (j,p)$JP(j,p) , Q(j,p,w)**2 ) + sum( (i,s,p)$(IS(i,s) and IP(i,p)) , F(i,s,p,w)**2 )  +sum( (j,p,c)$JP(j,p) , F_(j,p,c,w)**2) + sum((j,c), Slack(j,c,w) ** 2 ) ) * 2 + ( sum( (i,s)$IS(i,s) , R(i,s,w)*5 ) + sum( (j,p)$JP(j,p) , Q(j,p,w)*5 ) + sum( (i,s,p )$(IS(i,s) and IP(i,p)) , F(i,s,p,w)*5 ) +sum( (j,p,c)$JP(j,p) , F_(j,p,c,w)*5) + sum((j,c), Slack(j,c,w) *6 ) ) =l= 1.1e6 ;

  model Bendersub /BSObjC, BSObjC1, BSObjC2, BSObjC3, BSObjC4,  BSCon1, BSCon2, BSCon3, BSCon4, BSCon6, BSCon7, BSCon8, BSCon9 , BSNLP, TX, TCAP/;
  model BenderBinarySub/BSObjC, BSObjC1, BSObjC2, ObjC3, ObjC4,  BSCon1, BSCon2, BSCon3, BSCon4, BSCon6, BSCon7, Con8, Con9 , NLP, TX, TCAP/;

* -------------------- Solving Model -----------------------------------------



* Options:
  option MINLP = DICOPT ;
  option optCA = 0 ;
  option optCR = 0 ;
  OPTION LIMROW = 0;
OPTION LIMCOL = 0;
  OPTION RESLIM = 1E10;
   OPTION ITERLIM = 1E9;

parameters
LB /17500000/
UB /20500000/
best_solution;
loop(iter,


*solve each lagrangean cluster
loop(cluss,
  freeze(ww) = no;
loop(www, 
  if(ord(www) gt size * (ord(cluss) -1) and ord(www) le size *ord(cluss), 
  freeze(www) = yes;
  );
  );
  solve sub using MINLP minimizing ZC;
  loop(www, 
    if(ord(www) gt size * (ord(cluss) -1) and ord(www) le size *ord(cluss), 
    x_record_lag(iter,j,p,www ) = x.l(j,p,www);
  CAP_record_lag(iter,j,p,www)=CAP_.l(j,p,www);
  );
  );
  obj_record(iter, cluss) = ZC.l;
  cpu_lag = cpu_lag + sub.resusd;

);
  total_obj_record(iter) = sum(clus, obj_record(iter,clus));

*solve benders master problem----------------
*update multiplier
  pix_all(iter,j,p,w) = pix(j,p,w);
  piCAP_all(iter,j,p,w) = piCAP(j,p,w);
  solve bendersmaster using mip minimizing BenderOBJ;
  cpu_bender_master = cpu_bender_master + bendersmaster.resusd;
  BenderOBJ_record(iter) = BenderOBJ.l;
  if(LB lt BenderOBJ.l,
    LB = BenderOBJ.l;
    );
  xf_record(iter,j,p) = xf.l(j,p);
  capf_record(iter,j,p) = capf.l(j,p);

*solve benders subproblem--------------------

*update fisrt stage decision
  xbar(j,p) = xf.l(j,p);
  capbar(j,p) = capf.l(j,p);
  UB_Bender(iter) = sum((j,p)$JP(j,p), alphaC(j,p) * xbar(j,p) + betaC(j,p) * capbar(j,p));
*solve each subproblem
  loop(cluss,
    freeze(ww) = no;
  loop(www,
    if(ord(www) gt size * (ord(cluss) -1) and ord(www) le size *ord(cluss), 
    freeze(www) = yes;
    );
    );
    solve BenderBinarySub using MINLP minimizing ZC;
    cpu_ub = cpu_ub + BenderBinarySub.resusd;
    UB_Bender(iter) = UB_Bender(iter) + ZC.l;
*add benders cuts--------------
*initialize
    Slack.l(j,c,w) = 1000;
    solve Bendersub using nlp minimizing ZC;
    cpu_bender_sub = cpu_bender_sub + Bendersub.resusd;
      loop(www,
    if(ord(www) gt size * (ord(cluss) -1) and ord(www) le size *ord(cluss), 
        v(iter, www) = ZC.l - sum((j,p)$JP(j,p), xbar(j,p) * TX.m(j,p,www) + capbar(j,p) * TCAP.m(j,p,www) ) ;
      g1(iter, j,p, www) = TX.m(j,p, www);
      g2(iter, j,p, www) = TCAP.m(j,p,www);
    );
    );

    
    );

  if(UB_Bender(iter) lt UB,
    UB = UB_Bender(iter);
    best_solution = ord(iter);
    );
*finish benders-------------------

*update lagrangean multiplier
  den(iter) = sum((j,p,w)$JP(j,p), power(x_record_lag(iter,j,p,w) -x_record_lag(iter,j,p,'1'), 2 ) + power(CAP_record_lag(iter,j,p,w)-CAP_record_lag(iter,j,p,'1'), 2) );
  stepsize = theta * (UB-LB)/den(iter);
  loop(w,
    if(ord(w) gt 1,
      mux(iter+1,j,p,w) = mux(iter,j,p,w) + (x_record_lag(iter,j,p,w)-x_record_lag(iter,j,p,'1')) * stepsize;
      muCAP(iter+1,j,p,w) = muCAP(iter,j,p,w) + (CAP_record_lag(iter,j,p,w)-CAP_record_lag(iter,j,p,'1')) * stepsize;
      );
    );
  loop(w,
    if(ord(w) gt 1,
      pix(j,p,w) =  mux(iter+1,j,p,w);
      piCAP(j,p,w) = muCAP(iter+1,j,p,w);

      );
    pix(j,p,'1') = -sum((ww)$( ord(ww) gt 1), mux(iter+1,j,p,ww));
    piCAP(j,p,'1') = -sum((ww)$( ord(ww) gt 1 ), muCAP(iter+1,j,p,ww));
    );
  if (ord(iter) gt 1,
    change = -(total_obj_record(iter-1) - total_obj_record(iter)) / total_obj_record(iter-1);
    if (change lt 0.1, 
      theta = theta * 0.85;
      );
    );
  if(LB lt total_obj_record(iter),
    LB = total_obj_record(iter);
    );
  if(LB * 1.01 gt UB,
  break; );

  );

display x_record_lag,CAP_record_lag,mux, muCAP, obj_record, pix_all, piCAP_all,g2,v,xf_record, capf_record;

display total_obj_record, BenderOBJ_record, UB_Bender,UB, LB, cpu_ub,cpu_lag, cpu_bender_sub, cpu_bender_master ;


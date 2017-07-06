Sets
i /i1*i4/
j /j1*j6/
s /s1*s4/
r /r1*r4/
p /p1*p3/
c /c1*c4/
w /w1*w256/
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

Equations
e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,eobj;

e1(p,i) .. QE(p,i) =l= QEU(p,i) * x(p,i);
e2(p,i) .. Q(p,i) =e= Q0(p,i) + QE(p,i);
e3(p,j,w) .. sum(r$RJ(r,j), PU(r,p,j,w)) + sum((i,s)$(OJ(i,j) and PS(i,s)), WW(p,i,j,s,w)) =e= sum(c, F(p,c,j,w)) + sum((i,s)$(IJ(i,j) and PS(i,s)), WW(p,i,j,s,w));
e4(p,i,w) .. sum((j,s)$(JM(i,s,j) and PS(i,s)), theta(p,i,j,s,w)) =l= H(i) * Q(p,i);
e5(p,i,j,s,w)$(PS(i,s) and JM(i,s,j)) .. WW(p,i,j,s,w) =e= rho(i,j,s) * theta(p,i,j,s,w);
e6(p,i,j,w,s)$(not (PS(i,s) and JM(i,s,j))) .. theta(p,i,j,s,w) =e= 0;
e7(p,i,j,jj,w,s)$(L(i,s,j) and PS(i,s) and JM(i,s,jj)) .. WW(p,i,j,s,w) =e= mu(i,s,j) * WW(p,i,jj,s,w);
e8(p,i,j,jj,w,s)$(Lbar(i,s,j) and PS(i,s) and JM(i,s,jj)) .. log(1+WW(p,i,j,s,w)) =g= mu(i,s,j) * WW(p,i,jj,s,w);
e9(r,p,w,j)$RJ(r,j) .. PU(r,p,j,w) =l= PUU * y(r,p,w);
e10(p,c,j,w) .. F(p,c,j,w) =l= FUU * z(p,c,w);
e11(c,j,w) .. sum(p, F(p,c,j,w)) + Slack(c,j,w) =e= D(c,j,w);
e12(p,i,j,s,w)$(not(JM(i,s,j) or L(i,s,j) or Lbar(i,s,j))) .. WW(p,i,j,s,w) =e= 0;
eobj .. cost =e= sum(p, sum(i, betaC(i) * QE(p,i) + alphaC(i) * x(p,i))) + sum(w, prob(w) * (sum((p,i,s,j)$(PS(i,s) and JM(i,s,j)), delta(i,s)*rho(i,j,s) * theta(p,i,j,s,w)) + sum((p,j,r)$RJ(r,j), (betaS(r,j) + betaRP(r,p)) * PU(r,p,j,w)) + sum((r,p), alphaRP(r,p) * y(r,p,w)) + sum((p,c), alphaPC(p,c) * z(p,c,w)) + sum((p,c,j), betaPC(p,c) * F(p,c,j,w)) + sum((c,j), phi(c,j) * Slack(c,j,w)) ));

model scm /all/;
option MINLP = DICOPT;
option optcr = 0;
option optca =0;
  OPTION LIMROW = 0;
OPTION LIMCOL = 0;
option threads=1;
scm.optfile=1;
option rMINLP = conopt4;
 OPTION RESLIM = 10000;
solve scm using rMINLP minimizing cost;

parameters
cpu
Walltime;
cpu = scm.resusd;
Walltime = TimeElapsed;
display x.l,y.l,z.l,PU.l, F.l, QE.l,theta.l,Q.l,WW.l,Slack.l, cpu, Walltime;










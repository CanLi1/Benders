Sets
i /i1*i5/
j /j1*j6/
k /k1*k4/
w /w1*w3/
freeze(w)
;
alias (k, kk), (w,ww);

parameters
alpha(j)
beta(j)
delta /220/
lambda(j) 
VL /300/
VU /2500/
H /5000/
baseQ(i) /i1 250000, i2 150000, i3 180000, i4 160000, i5 120000/
Q(i,w)
prob(w)
;
alpha(j) = 250;
beta(j) = 0.6;
lambda(j) = 2000;
Q(i, 'w1') = baseQ(i)*1.2;
Q(i, 'w2') = baseQ(i)*1;
Q(i, 'w3') = baseQ(i) *0.8;
prob('w1') = 0.25;
prob('w2') = 0.5;
prob('w3') = 0.25;
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
yf(k,j,w)
ys(k,j,w);

Variables
n(j,w)
v(j,w)
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
e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,eobj, b1,b2,b3;
*first stage
e1(j,w) .. sum(k, yf(k,j,w)) =e= 1;
e2(j,w) .. n(j,w) =e= sum(k, log(ord(k)) * yf(k,j,w));
e3(j,w) .. v(j,w) =l= log(VU);
e4(j,w) .. v(j,w) =g= log(VL);
b1(k,j,w) .. yf(k,j,w) =e= yf(k,j,'w1');
b2(j,w) .. v(j, w) =e= v(j, 'w1');
b3(j,w) .. n(j, w) =e= n(j, 'w1');
*second stage
e5(i,j,w)$freeze(w) .. v(j,w) =g= log(S(i,j)) + b(i,w);
e6(j,w)$freeze(w) .. ns(j,w) =e= sum(k, log(ord(k)) * ys(k,j,w));
e7(k,j,w)$freeze(w) .. ys(k,j,w) =l= sum(kk$(ord(kk) ge ord(k)), yf(kk,j,w));
e8(i,j,w)$freeze(w) .. ns(j,w) + tl(i,w) =g= log(t(i,j));
e9(w)$freeze(w) .. sum(i, Q(i,w) * exp(tl(i,w) - b(i,w))) =l= H + L(w);
e10(j,w)$freeze(w) .. sum(k, ys(k,j,w)) =e= 1;
eobj .. cost =e= sum(w$freeze(w), prob(w)*sum(j, alpha(j) * exp(n(j,w) + beta(j) * v(j,w)))) + sum(w$freeze(w), prob(w) * (sum(j, lambda(j) * exp(ns(j,w)) )+ delta*L(w)));
freeze(w) = yes;
model mult /all/;
solve mult using rminlp minimizing cost;
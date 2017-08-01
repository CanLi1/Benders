Sets
i /i1*i5/
j /j1*j6/
k /k1*k4/
w /w1*w81/
;
alias (k, kk), (w,w3);

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

*done generating scenarios-------------------------------
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

Equations
e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,eobj;
*first stage
e1(j) .. sum(k, yf(k,j)) =e= 1;
e2(j) .. n(j) =e= sum(k, log(ord(k)) * yf(k,j));
e3(j) .. v(j) =l= log(VU);
e4(j) .. v(j) =g= log(VL);

*second stage
e5(i,j,w) .. v(j) =g= log(S(i,j)) + b(i,w);
e6(j,w) .. ns(j,w) =e= sum(k, log(ord(k)) * ys(k,j,w));
*e7(k,j,w) .. ys(k,j,w) =l= sum(kk$(ord(kk) ge ord(k)), yf(kk,j));
e7(j,w) .. ns(j,w) =l= n(j);
e8(i,j,w) .. ns(j,w) + tl(i,w) =g= log(t(i,j));
e9(w) .. sum(i, Q(i,w) * exp(tl(i,w) - b(i,w))) =l= H + L(w);
e10(j,w) .. sum(k, ys(k,j,w)) =e= 1;
eobj .. cost =e= sum(j, alpha(j) * exp(n(j) + beta(j) * v(j))) + sum(w, prob(w) * (sum(j, lambda(j) * exp(ns(j,w))) + delta*L(w)));

model batch /all/;
batch.optfile=1;
option rminlp = CONOPT4;
option minlp=AlphaECP;
option threads=12;
option optcr = 0;
option reslim=5e5;
option iterlim=2e9;
option optca =0;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
solve batch using rminlp minimizing cost;
parameters
dn(j)
dv(j)
dns(j,w)
dtl(i,w)
db(i,w);
dn(j) = exp(n.l(j));
dv(j) = exp(v.l(j));
dns(j,w) = exp(ns.l(j,w));
dtl(i,w) = exp(tl.l(i,w));
db(i,w) = exp(b.l(i,w));
parameters
walltime;
walltime=TimeElapsed;
display yf.l, ys.l, dn, dv, dns, dtl, db, L.l;
display walltime,batch.resusd;














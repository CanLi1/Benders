********************************************************************************
********************************************************************************
** Linear Multisite multiperiod production planning and distribution ***********
** Model taken from: ***********************************************************
** Ind.Eng.Chem.Res (2003), 42, 3045-3055 **************************************
** Written by: Sebastian Terrazas Moreno ***************************************
** Carnegie Mellon University , May 2008 ***************************************
** In this file the model is written for Example 1******************************
********************************************************************************
********************************************************************************

variable

profit;

positive variables

p(i,s,t)
f(i,m,s,t)
sl(i,m,t)
pen(i,s,t)
tp(i,s,t)
inv(i,s,t);

equations

feq4a(i,s,t)
feq5a(i,s,t)
feq4b(i,s,t)
feq5b(i,s,t)
feq6(i,m,t)
feq7(i,m,t)
feq16a(i,s,t)
feq16b(i,s,t)
feq16c(i,s,t)
feq18(i,s,t)
feq19(s,t)
fobj;

feq4a(i,s,t)$(ord(t) lt nt)..
pen(i,s,t) =g= quota(i,s) - invpar(i,s,t);

feq5a(i,s,t)$(ord(t) lt nt)..
pen(i,s,t) =g= invpar(i,s,t) - quota(i,s);

feq4b(i,s,t)$(ord(t) eq nt)..
pen(i,s,t) =g= quota(i,s) - inv(i,s,t);

feq5b(i,s,t)$(ord(t) eq nt)..
pen(i,s,t) =g= inv(i,s,t) - quota(i,s);

feq6(i,m,t)..
sl(i,m,t) =e= sum((s),f(i,m,s,t)) ;

feq7(i,m,t)..
sl(i,m,t) =l= fcast(i,m,t);

feq16a(i,s,t)$((ord(t) eq 1))..
p(i,s,t) + quota(i,s) =e= invpar(i,s,t) + sum(m,f(i,m,s,t));

feq16b(i,s,t)$((ord(t) gt 1) and ord(t) lt nt)..
p(i,s,t) + invpar(i,s,t-1) =e= invpar(i,s,t) + sum(m,f(i,m,s,t));

feq16c(i,s,t)$(ord(t) eq nt)..
p(i,s,t) + invpar(i,s,t-1) =e= inv(i,s,t) + sum(m,f(i,m,s,t));

feq18(i,s,t)..
p(i,s,t) =l= cap(i,s)*tp(i,s,t);

feq19(s,t)..
sum(i,tp(i,s,t)) =e= 1;


fobj..
profit =e= sum((t),
                 sum((i,m),bb(i,m)*sl(i,m,t)) -
                 sum((i,s),aa(i,s)*(p(i,s,t) + 0.2*pen(i,s,t))) -
                 sum((i,s,m),gg(i,s,m)*f(i,m,s,t))
           )

;

OPTION LIMROW = 0;
OPTION LIMCOL = 0;
OPTION OPTCR = 0;
OPTION MIP = CPLEX;

model LP_feas_temp /feq4a,feq5a,feq4b,feq5b,feq6,feq7,feq16a,feq16b,feq16c,feq18,feq19,fobj/;
LP_feas_temp.optfile = 1;







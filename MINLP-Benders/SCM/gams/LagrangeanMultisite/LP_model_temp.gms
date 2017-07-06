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

inv(i,s,t)
invp(i,s,t)
p(i,s,t)
f(i,m,s,t)
sl(i,m,t)
pen(i,s,t)
tp(i,s,t);

equations

eq4(i,s,t)
eq5(i,s,t)
eq6(i,m,t)
eq7(i,m,t)
eq15(i,s,t)
eq16a(i,s,t)
eq16b(i,s,t)
eq18(i,s,t)
eq19(s,t)
obj;

eq4(i,s,t)$(freeze(t))..
pen(i,s,t) =g= quota(i,s) - inv(i,s,t);

eq5(i,s,t)$(freeze(t))..
pen(i,s,t) =g= inv(i,s,t) - quota(i,s);

eq6(i,m,t)$(freeze(t))..
sl(i,m,t) =e= sum((s),f(i,m,s,t)) ;

eq7(i,m,t)$(freeze(t))..
sl(i,m,t) =l= fcast(i,m,t);

eq15(i,s,t)$(freeze(t) and (ord(t) lt nt))..
inv(i,s,t) =e= invp(i,s,t);

eq16a(i,s,t)$(freeze(t) and (ord(t) eq 1))..
p(i,s,t) + quota(i,s) =e= inv(i,s,t) + sum(m,f(i,m,s,t));

eq16b(i,s,t)$(freeze(t) and (ord(t) gt 1))..
p(i,s,t) + invp(i,s,t-1) =e= inv(i,s,t) + sum(m,f(i,m,s,t));

eq18(i,s,t)$(freeze(t))..
p(i,s,t) =l= cap(i,s)*tp(i,s,t);

eq19(s,t)$(freeze(t))..
sum(i,tp(i,s,t)) =e= 1;


obj..
profit =e= sum((t)$freeze(t),
                 sum((i,m),bb(i,m)*sl(i,m,t)) -
                 sum((i,s),aa(i,s)*(p(i,s,t) + 0.2*pen(i,s,t))) -
                 sum((i,s,m),gg(i,s,m)*f(i,m,s,t))
           )


           +
           sum((i,s,t)$(freeze(t) and (ord(t) lt nt)),ut(i,s,t)*(inv(i,s,t)))
           -
           sum((i,s,t)$(freeze(t) and (ord(t) gt 1)),ut(i,s,t-1)*(invp(i,s,t-1)))
;



inv.up(i,s,t) = cap(i,s);
invp.up(i,s,t) = cap(i,s);

OPTION LIMROW = 0;
OPTION LIMCOL = 0;
OPTION OPTCR = 0;
OPTION MIP = CPLEX;

model LP_model_temp /eq4,eq5,eq6,eq7,eq16a,eq16b,eq18,eq19,obj/;
LP_model_temp.optfile = 1;






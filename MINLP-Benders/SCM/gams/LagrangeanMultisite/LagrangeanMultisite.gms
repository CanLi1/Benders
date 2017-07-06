********************************************************************************
********************************************************************************
** Linear Multisite multiperiod production planning and distribution ***********
** Model taken from: ***********************************************************
** Ind.Eng.Chem.Res (2003), 42, 3045-3055 **************************************
** Written by: Sebastian Terrazas Moreno ***************************************
** Carnegie Mellon University , May 2008 ***************************************
** This file runs temportal decompositions using subgradient *******************
********************************************************************************
********************************************************************************

$set ntp 3
scalar nt /%ntp%/;

set i products           /A,B,C/;
set m markets            /1*3/;
set s prodcution sites   /1*3/;
set t time periods       /1*%ntp%/;

set freeze(t)


table cap(i,s)
                 1       2       3
         A      50     350      50
         B     500     250     450
         C     800     600     100 ;



table quota(i,s)
                 1       2       3
         A      10      70      10
         B     100      50      90
         C     160     120      20 ;

table aa(i,s)
                 1       2       3
         A     0.010   0.012   0.008
         B     0.008   0.010   0.010
         C     0.015   0.012   0.014 ;

table fcast(i,m,t)
                 1       2       3
         A.1    100     350     500
         A.2     45     300     200
         A.3    200     200     200
         B.1      0       0       0
         B.2    200     250     300
         B.3    350     450     200
         C.1    600     200     300
         C.2      0       0       0
         C.3     50      50     100;

table gg(i,s,m)
                 1       2       3
         A.1    0.2     0.1     0.3
         A.2    0.1     0.2     0.2
         A.3    0.2     0.3     0.1
         B.1    0.2     0.1     0.3
         B.2    0.1     0.2     0.2
         B.3    0.2     0.3     0.1
         C.1    0.2     0.1     0.3
         C.2    0.1     0.2     0.2
         C.3    0.2     0.3     0.1;

table bb(i,m)
                 1       2       3
         A     1.00    0.85    1.20
         B     1.25    1.00    1.00
         C     0.80    0.90    1.00 ;

table invi(i,s)
                 1       2       3
         A       0       0       0
         B       0       0       0
         C       0       0       0  ;

parameter ut(i,s,t);
ut(i,s,t) = 0;

set iter /1*100/;

parameter zrsg(iter),den(iter),pk(iter),cpu(iter),feasol(iter),cpu_time,zo;
zo=0;
parameter profit1,profit2,profit3,profit4,cpu0,cpu1,cpu2,cpu3,cpu4;
scalar stps /2/;
parameter invpar(i,s,t);
invpar(i,s,t) = 0;

parameter change,inv_k(iter,i,s,t),invp_k(iter,i,s,t);

$Include LP_model_temp.gms
$Include LP_feas_temp.gms

*freeze(t) = yes;
*solve LP_model_temp maximizing profit using LP;
*ut(i,s,t) = eq15.m(i,s,t);

loop((iter),



         freeze(t) = no;
         freeze('1') = yes;
         solve LP_model_temp maximizing profit using LP;
         inv_k(iter,i,s,t)=inv.l(i,s,t);
         invp_k(iter,i,s,t)=invp.l(i,s,t);
         profit1=profit.l;
         cpu1=LP_model_temp.resusd;

         freeze(t) = no;
         freeze('2') = yes;
         solve LP_model_temp maximizing profit using LP;
         inv_k(iter,i,s,t)=inv.l(i,s,t);
         invp_k(iter,i,s,t)=invp.l(i,s,t);
         profit2=profit.l;
         cpu2=LP_model_temp.resusd;

         freeze(t) = no;
         freeze('3') = yes;
         solve LP_model_temp maximizing profit using LP;
         inv_k(iter,i,s,t)=inv.l(i,s,t);
         invp_k(iter,i,s,t)=invp.l(i,s,t);
         profit3=profit.l;
         cpu3=LP_model_temp.resusd;



         invpar(i,s,t)= inv.l(i,s,t);

         solve LP_feas_temp maximizing profit using LP;
         feasol(iter) = profit.l;
         if(((profit.l > zo) and (LP_feas_temp.modelstat = 1)),
                 zo = profit.l;
         );
         cpu0=LP_feas_temp.resusd;


         cpu(iter)=cpu0 + cpu1 + cpu2 + cpu3;
         zrsg(iter) = profit1 + profit2 + profit3;


         den(iter) = sum((i,s,t),power(inv_k(iter,i,s,t) - invp_k(iter,i,s,t),2));


         pk(iter)=stps*(zrsg(iter)-zo)/den(iter);

         loop((i,t),
                  ut(i,s,t) = ut(i,s,t)
                  - pk(iter)*(inv_k(iter,i,s,t) - invp_k(iter,i,s,t));
         );



        IF (ord(iter) gt 1,
                        change = (zrsg(iter-1)-zrsg(iter))/zrsg(iter-1);
                         IF (change LT 0.1,
                                 stps = 0.85*stps;
                         );
         );


);

cpu_time=sum(iter,cpu(iter));


display feasol,zrsg,zo,cpu_time;



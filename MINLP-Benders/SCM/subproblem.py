#write the extensive form of the SCM model
# Imports
#
from pyomo.environ import *
from pyomo.opt import *

sub=AbstractModel()

sub.I = RangeSet(3, ordered=True)
sub.J = RangeSet(4, ordered=True)
sub.S = RangeSet(3, ordered=True)
sub.P = RangeSet(5, ordered=True)
sub.C = RangeSet(12, ordered=True)
sub.IS = Set(within=sub.I*sub.S)
sub.IP = Set(within=sub.I*sub.P)
sub.ISP = Set(within=sub.I*sub.S*sub.P)
sub.JP = Set(within=sub.J*sub.P,ordered=True)

sub.U = Param(sub.IS, default=0)
sub.CAP = Param(sub.J, sub.P, default=0)
sub.rho = Param(sub.I, sub.J, sub.P, default=0)
sub.D= Param(sub.J, sub.C,  default=0,mutable=True)
sub.betaS = Param(sub.I, sub.S, default=0)
sub.betaP = Param(sub.J, sub.P, default=0)
sub.alphaSP = Param(sub.S, sub.P, default=0)
sub.betaSP = Param(sub.S,sub.P, default=0)
sub.alphaPC = Param(sub.P, sub.C)
sub.betaPC = Param(sub.P, sub.C)
sub.delta = Param(sub.J, sub.C, default=900)
sub.p = Param(mutable=True)
#first stage variable value
sub.x = Param(sub.JP, mutable=True,default=0)
sub.EX=Param(sub.JP, mutable=True,default=0)
sub.alphaC = Param(sub.JP)
sub.betaC = Param(sub.JP)
#local copy of first stage variables
sub.xbar = Var(sub.JP)
sub.EXbar = Var(sub.JP)

#second stage variables
sub.y = Var(sub.ISP, bounds=(0,1))
sub.z = Var(sub.JP, sub.C, bounds=(0,1))
sub.F = Var(sub.ISP,  within=NonNegativeReals, initialize=1000)
sub.B = Var(sub.JP, sub.C,  within=NonNegativeReals)
sub.Q = Var(sub.JP,  within=NonNegativeReals)
sub.R = Var(sub.IS,  within=NonNegativeReals)
sub.s = Var(sub.J, sub.C,  within=NonNegativeReals, initialize=1000)
sub.obj = Var()
sub.Cost =  Var(within=NonNegativeReals)

#define parmaters for eco constraints
#standard deviations all equal to one
sub.sigmaR = Param(sub.IS, default =1)
sub.sigmaQ = Param(sub.JP, default =1)
sub.sigmaF = Param(sub.ISP, default=1)
sub.sigmaB = Param(sub.JP, sub.C, default =1)
sub.sigmas = Param(sub.J, sub.C , default =1)
#average all equal to 5
sub.muR = Param(sub.IS, default =5)
sub.muQ = Param(sub.JP, default =5)
sub.muF = Param(sub.ISP, default=5)
sub.muB = Param(sub.JP, sub.C, default =5)
sub.mus = Param(sub.J, sub.C , default =6)
#Omega
sub.Omega = Param(default =1.1e6)

def c01(sub, j, p):
	return sub.xbar[j,p] - sub.x[j,p] == 0
sub.c01C = Constraint(sub.JP, rule=c01)

def c02(sub, j, p):
	return sub.EXbar[j,p] - sub.EX[j,p] == 0
sub.c02C = Constraint(sub.JP, rule=c02)

def c2(sub,j,p):
	return sub.Q[j,p] - sum(sub.B[j,p,c] for c in sub.C) == 0
sub.c2C = Constraint(sub.JP,  rule=c2)

def c3(sub,i,s):
	return sub.R[i,s] - sub.U[i,s] <= 0
sub.c3C = Constraint(sub.IS,  rule=c3)

def c10(sub,i,s):
	return sub.R[i,s] - sum(sub.F[i,s,p] for p in sub.P if (i,p) in sub.IP) ==0
sub.c10C = Constraint(sub.IS,  rule=c10)

def c4(sub,i,p):
	return sum(sub.F[i,s,p] for s in sub.S if (i,s) in sub.IS) - sum(sub.rho[i,j,p] * sub.Q[j,p] for j in sub.J if (j,p) in sub.JP) ==0
sub.c4C = Constraint(sub.IP,  rule=c4)

def c5(sub,j,p):
	return sub.Q[j,p] - sub.CAP[j,p] - sub.EXbar[j,p] <= 0
sub.c5C = Constraint(sub.JP,  rule=c5)

def c6(sub,j,c):
	return sum(sub.B[j,p,c] for p in sub.P if (j,p) in sub.JP) + sub.s[j,c]  ==sub.D[j,c]
sub.c6C = Constraint(sub.J, sub.C,  rule=c6)

def c7(sub,i,s,p):
	return sub.F[i,s,p] - 10000 * sub.y[i,s,p] <=0
sub.c7C = Constraint(sub.ISP,  rule=c7)

def c8(sub,j,p,c):
	return sub.B[j,p,c] -3000 * sub.z[j,p,c] <=0
sub.c8C = Constraint(sub.JP, sub.C,  rule=c8)

def nlp(sub):
	return sqrt( sum( (sub.sigmaR[i,s] * sub.R[i,s] )**2 for i in sub.I for s in sub.S if (i,s) in sub.IS)\
		+ sum((sub.sigmaQ[j,p] * sub.Q[j,p] )**2 for j in sub.J for p in sub.P if(j,p) in sub.JP )\
		+sum((sub.sigmaF[i,s,p] * sub.F[i,s,p])**2 for i in sub.I for s in sub.S if (i,s) in sub.IS for p in sub.P  if (i,p) in sub.IP)\
		+sum((sub.sigmaB[j,p,c] * sub.B[j,p,c])**2 for j in sub.J for p in sub.P if (j,p) in sub.JP for c in sub.C)\
		+sum((sub.sigmas[j,c]*sub.s[j,c])**2 for j in sub.J for c in sub.C )  ) * 2 \
		+sum( (sub.muR[i,s] * sub.R[i,s] ) for i in sub.I for s in sub.S if (i,s) in sub.IS)\
		+ sum((sub.muQ[j,p] * sub.Q[j,p] ) for j in sub.J for p in sub.P if(j,p) in sub.JP )\
		+sum((sub.muF[i,s,p] * sub.F[i,s,p]) for i in sub.I for s in sub.S if (i,s) in sub.IS for p in sub.P  if (i,p) in sub.IP)\
		+sum((sub.muB[j,p,c] * sub.B[j,p,c]) for j in sub.J for p in sub.P if (j,p) in sub.JP for c in sub.C)\
		+sum((sub.mus[j,c]*sub.s[j,c]) for j in sub.J for c in sub.C ) <= sub.Omega
sub.nlpC = Constraint( rule=nlp)

def c9(sub):
	return sum(sub.betaS[i,s] * sub.R[i,s] for i in sub.I for s in sub.S if (i,s) in sub.IS) \
	+sum(sub.betaP[j,p]*sub.Q[j,p] for j in sub.J for p in sub.P if (j,p) in sub.JP )\
	+sum(sub.alphaSP[s,p] * sub.y[i,s,p]+sub.betaSP[s,p]*sub.F[i,s,p] for i in sub.I for s in sub.S for p in sub.P if( (i,s) in sub.IS and (i,p) in sub.IP ))\
	+sum(sub.alphaPC[p,c]*sub.z[j,p,c]+sub.betaPC[p,c]*sub.B[j,p,c] for j in sub.J for p in sub.P for c in sub.C if (j,p) in sub.JP)\
	+sum(sub.delta[j,c] * sub.s[j,c] for j in sub.J for c in sub.C ) - sub.Cost == 0
sub.c9C = Constraint( rule=c9)

def c11(sub):
	return sub.obj == sub.p * sub.Cost 
sub.c11C = Constraint(rule=c11)

def oobj(sub):
	return sub.obj
sub.oobjO = Objective(rule=oobj, sense=minimize)


















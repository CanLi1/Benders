#write the extensive form of the SCM model
# Imports
#
from pyomo.environ import *
from pyomo.opt import *

subb=AbstractModel()

subb.I = RangeSet(3, ordered=True)
subb.J = RangeSet(4, ordered=True)
subb.S = RangeSet(3, ordered=True)
subb.P = RangeSet(5, ordered=True)
subb.C = RangeSet(12, ordered=True)
subb.IS = Set(within=subb.I*subb.S)
subb.IP = Set(within=subb.I*subb.P)
subb.ISP = Set(within=subb.I*subb.S*subb.P)
subb.JP = Set(within=subb.J*subb.P,ordered=True)

subb.U = Param(subb.IS, default=0)
subb.CAP = Param(subb.J, subb.P, default=0)
subb.rho = Param(subb.I, subb.J, subb.P, default=0)
subb.D= Param(subb.J, subb.C,  default=0,mutable=True)
subb.betaS = Param(subb.I, subb.S, default=0)
subb.betaP = Param(subb.J, subb.P, default=0)
subb.alphaSP = Param(subb.S, subb.P, default=0)
subb.betaSP = Param(subb.S,subb.P, default=0)
subb.alphaPC = Param(subb.P, subb.C)
subb.betaPC = Param(subb.P, subb.C)
subb.delta = Param(subb.J, subb.C, default=900)
subb.p = Param(mutable=True)
subb.alphaC = Param(subb.JP)
subb.betaC = Param(subb.JP)
#first stage variable value
subb.x = Param(subb.JP, mutable=True,default=0)
subb.EX=Param(subb.JP, mutable=True,default=0)

#local copy of first stage variables
subb.xbar = Var(subb.JP)
subb.EXbar = Var(subb.JP)

#second stage variables
subb.y = Var(subb.ISP, within=Binary)
subb.z = Var(subb.JP, subb.C, within=Binary)
subb.F = Var(subb.ISP,  within=NonNegativeReals,initialize=1000)
subb.B = Var(subb.JP, subb.C,  within=NonNegativeReals)
subb.Q = Var(subb.JP,  within=NonNegativeReals)
subb.R = Var(subb.IS,  within=NonNegativeReals)
subb.s = Var(subb.J, subb.C,  within=NonNegativeReals)
subb.obj = Var()
subb.Cost =  Var(within=NonNegativeReals)

#define parmaters for eco constraints
#standard deviations all equal to one
subb.sigmaR = Param(subb.IS, default =1)
subb.sigmaQ = Param(subb.JP, default =1)
subb.sigmaF = Param(subb.ISP, default=1)
subb.sigmaB = Param(subb.JP, subb.C, default =1)
subb.sigmas = Param(subb.J, subb.C , default =1)
#average all equal to 5
subb.muR = Param(subb.IS, default =5)
subb.muQ = Param(subb.JP, default =5)
subb.muF = Param(subb.ISP, default=5)
subb.muB = Param(subb.JP, subb.C, default =5)
subb.mus = Param(subb.J, subb.C , default =6)
#Omega
subb.Omega = Param(default =1.1e6)

def c01(subb, j, p):
	return subb.xbar[j,p]  ==  subb.x[j,p]
subb.c01C = Constraint(subb.JP, rule=c01)

def c02(subb, j, p):
	return subb.EXbar[j,p]   == subb.EX[j,p]
subb.c02C = Constraint(subb.JP, rule=c02)

def c2(subb,j,p):
	return subb.Q[j,p] - sum(subb.B[j,p,c] for c in subb.C) == 0
subb.c2C = Constraint(subb.JP,  rule=c2)

def c3(subb,i,s):
	return subb.R[i,s] - subb.U[i,s] <= 0
subb.c3C = Constraint(subb.IS,  rule=c3)

def c10(subb,i,s):
	return subb.R[i,s] - sum(subb.F[i,s,p] for p in subb.P if (i,p) in subb.IP) ==0
subb.c10C = Constraint(subb.IS,  rule=c10)

def c4(subb,i,p):
	return sum(subb.F[i,s,p] for s in subb.S if (i,s) in subb.IS) - sum(subb.rho[i,j,p] * subb.Q[j,p] for j in subb.J if (j,p) in subb.JP) ==0
subb.c4C = Constraint(subb.IP,  rule=c4)

def c5(subb,j,p):
	return subb.Q[j,p] - subb.CAP[j,p]   <= subb.EXbar[j,p]
subb.c5C = Constraint(subb.JP,  rule=c5)

def c6(subb,j,c):
	return sum(subb.B[j,p,c] for p in subb.P if (j,p) in subb.JP) + subb.s[j,c]  == subb.D[j,c]
subb.c6C = Constraint(subb.J, subb.C,  rule=c6)

def c7(subb,i,s,p):
	return subb.F[i,s,p] - 10000 * subb.y[i,s,p] <=0
subb.c7C = Constraint(subb.ISP,  rule=c7)

def c8(subb,j,p,c):
	return subb.B[j,p,c] -3000 * subb.z[j,p,c] <=0
subb.c8C = Constraint(subb.JP, subb.C,  rule=c8)

def nlp(subb):
	return ( sum( (subb.sigmaR[i,s] * subb.R[i,s] )**2 for i in subb.I for s in subb.S if (i,s) in subb.IS)\
		+ sum((subb.sigmaQ[j,p] * subb.Q[j,p] )**2 for j in subb.J for p in subb.P if(j,p) in subb.JP )\
		+sum((subb.sigmaF[i,s,p] * subb.F[i,s,p])**2 for i in subb.I for s in subb.S if (i,s) in subb.IS for p in subb.P  if (i,p) in subb.IP)\
		+sum((subb.sigmaB[j,p,c] * subb.B[j,p,c])**2 for j in subb.J for p in subb.P if (j,p) in subb.JP for c in subb.C)\
		+sum((subb.sigmas[j,c]*subb.s[j,c])**2 for j in subb.J for c in subb.C )  )**0.5 * 2 \
		+sum( (subb.muR[i,s] * subb.R[i,s] ) for i in subb.I for s in subb.S if (i,s) in subb.IS)\
		+ sum((subb.muQ[j,p] * subb.Q[j,p] ) for j in subb.J for p in subb.P if(j,p) in subb.JP )\
		+sum((subb.muF[i,s,p] * subb.F[i,s,p]) for i in subb.I for s in subb.S if (i,s) in subb.IS for p in subb.P  if (i,p) in subb.IP)\
		+sum((subb.muB[j,p,c] * subb.B[j,p,c]) for j in subb.J for p in subb.P if (j,p) in subb.JP for c in subb.C)\
		+sum((subb.mus[j,c]*subb.s[j,c]) for j in subb.J for c in subb.C ) <= subb.Omega
subb.nlpC = Constraint( rule=nlp)


def c9(subb):
	return sum(subb.betaS[i,s] * subb.R[i,s] for i in subb.I for s in subb.S if (i,s) in subb.IS) \
	+sum(subb.betaP[j,p]*subb.Q[j,p] for j in subb.J for p in subb.P if (j,p) in subb.JP )\
	+sum(subb.alphaSP[s,p] * subb.y[i,s,p]+subb.betaSP[s,p]*subb.F[i,s,p] for i in subb.I for s in subb.S for p in subb.P if( (i,s) in subb.IS and (i,p) in subb.IP ))\
	+sum(subb.alphaPC[p,c]*subb.z[j,p,c]+subb.betaPC[p,c]*subb.B[j,p,c] for j in subb.J for p in subb.P for c in subb.C if (j,p) in subb.JP)\
	+sum(subb.delta[j,c] * subb.s[j,c] for j in subb.J for c in subb.C ) - subb.Cost == 0
subb.c9C = Constraint( rule=c9)

def c11(subb):
	return subb.obj == subb.p * subb.Cost 
subb.c11C = Constraint(rule=c11)

def oobj(subb):
	return subb.obj
subb.oobjO = Objective(rule=oobj, sense=minimize)


















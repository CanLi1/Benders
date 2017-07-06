#write the extensive form of the SCM model
# Imports
#
from pyomo.environ import *
from pyomo.opt import *

sl=AbstractModel()

sl.I = RangeSet(3, ordered=True)
sl.J = RangeSet(4, ordered=True)
sl.S = RangeSet(3, ordered=True)
sl.P = RangeSet(5, ordered=True)
sl.C = RangeSet(12, ordered=True)
sl.IS = Set(within=sl.I*sl.S)
sl.IP = Set(within=sl.I*sl.P)
sl.ISP = Set(within=sl.I*sl.S*sl.P)
sl.JP = Set(within=sl.J*sl.P,ordered=True)

sl.M = Param(sl.JP, default =10000 )
sl.U = Param(sl.IS, default=0)
sl.CAP = Param(sl.J, sl.P, default=0)
sl.rho = Param(sl.I, sl.J, sl.P, default=0)
sl.D= Param(sl.J, sl.C,  default=0,mutable=True)
sl.betaS = Param(sl.I, sl.S, default=0)
sl.betaP = Param(sl.J, sl.P, default=0)
sl.alphaSP = Param(sl.S, sl.P, default=0)
sl.betaSP = Param(sl.S,sl.P, default=0)
sl.alphaPC = Param(sl.P, sl.C)
sl.betaPC = Param(sl.P, sl.C)
sl.delta = Param(sl.J, sl.C, default=900)
sl.p = Param(mutable=True, default=0.25)
sl.alphaC = Param(sl.JP)
sl.betaC = Param(sl.JP)

#lagrangean multiplier
sl.pix = Param(sl.JP, default=0)
sl.piEX = Param(sl.JP, default=0) 

# first stage variables
sl.x = Var(sl.JP,within=Binary)
sl.EX = Var(sl.JP, within=NonNegativeReals)

#second stage variables
sl.y = Var(sl.ISP, within=Binary)
sl.z = Var(sl.JP, sl.C, within=Binary)
sl.F = Var(sl.ISP,  within=NonNegativeReals, initialize=1000)
sl.B = Var(sl.JP, sl.C,  within=NonNegativeReals)
sl.Q = Var(sl.JP,  within=NonNegativeReals)
sl.R = Var(sl.IS,  within=NonNegativeReals)
sl.s = Var(sl.J, sl.C,  within=NonNegativeReals)
sl.obj = Var()
sl.dual= Var(sl.JP)
sl.Cost =  Var(within=NonNegativeReals)

#define parmaters for eco constraints
#standard deviations all equal to one
sl.sigmaR = Param(sl.IS, default =1)
sl.sigmaQ = Param(sl.JP, default =1)
sl.sigmaF = Param(sl.ISP, default=1)
sl.sigmaB = Param(sl.JP, sl.C, default =1)
sl.sigmas = Param(sl.J, sl.C , default =1)
#average all equal to 5
sl.muR = Param(sl.IS, default =5)
sl.muQ = Param(sl.JP, default =5)
sl.muF = Param(sl.ISP, default=5)
sl.muB = Param(sl.JP, sl.C, default =5)
sl.mus = Param(sl.J, sl.C , default =6)
#Omega
sl.Omega = Param(default =1.1e6)

def c1(sl,j,p):
	return sl.EX[j,p] - sl.M[j,p]*sl.x[j,p] <= 0.0
sl.c1C = Constraint(sl.JP, rule=c1)

def c2(sl,j,p):
	return sl.Q[j,p] - sum(sl.B[j,p,c] for c in sl.C) == 0
sl.c2C = Constraint(sl.JP,  rule=c2)

def c3(sl,i,s):
	return sl.R[i,s]  - sl.U[i,s] <=0
sl.c3C = Constraint(sl.IS,  rule=c3)

def c10(sl,i,s):
	return sl.R[i,s] - sum(sl.F[i,s,p] for p in sl.P if (i,p) in sl.IP) ==0
sl.c10C = Constraint(sl.IS,  rule=c10)

def c4(sl,i,p):
	return sum(sl.F[i,s,p] for s in sl.S if (i,s) in sl.IS) - sum(sl.rho[i,j,p] * sl.Q[j,p] for j in sl.J if (j,p) in sl.JP) ==0
sl.c4C = Constraint(sl.IP,  rule=c4)

def c5(sl,j,p):
	return sl.Q[j,p] - sl.CAP[j,p] - sl.EX[j,p] <= 0
sl.c5C = Constraint(sl.JP,  rule=c5)

def c6(sl,j,c):
	return sum(sl.B[j,p,c] for p in sl.P if (j,p) in sl.JP) + sl.s[j,c]  == sl.D[j,c]
sl.c6C = Constraint(sl.J, sl.C,  rule=c6)

def c7(sl,i,s,p):
	return sl.F[i,s,p] - 10000 * sl.y[i,s,p] <=0
sl.c7C = Constraint(sl.ISP,  rule=c7)

def c8(sl,j,p,c):
	return sl.B[j,p,c] -3000 * sl.z[j,p,c] <=0
sl.c8C = Constraint(sl.JP, sl.C,  rule=c8)

def nlp(sl):
	return ( sum( (sl.sigmaR[i,s] * sl.R[i,s] )**2 for i in sl.I for s in sl.S if (i,s) in sl.IS)\
		+ sum((sl.sigmaQ[j,p] * sl.Q[j,p] )**2 for j in sl.J for p in sl.P if(j,p) in sl.JP )\
		+sum((sl.sigmaF[i,s,p] * sl.F[i,s,p])**2 for i in sl.I for s in sl.S if (i,s) in sl.IS for p in sl.P  if (i,p) in sl.IP)\
		+sum((sl.sigmaB[j,p,c] * sl.B[j,p,c])**2 for j in sl.J for p in sl.P if (j,p) in sl.JP for c in sl.C)\
		+sum((sl.sigmas[j,c]*sl.s[j,c])**2 for j in sl.J for c in sl.C )  )**0.5 * 2 \
		+sum( (sl.muR[i,s] * sl.R[i,s] ) for i in sl.I for s in sl.S if (i,s) in sl.IS)\
		+ sum((sl.muQ[j,p] * sl.Q[j,p] ) for j in sl.J for p in sl.P if(j,p) in sl.JP )\
		+sum((sl.muF[i,s,p] * sl.F[i,s,p]) for i in sl.I for s in sl.S if (i,s) in sl.IS for p in sl.P  if (i,p) in sl.IP)\
		+sum((sl.muB[j,p,c] * sl.B[j,p,c]) for j in sl.J for p in sl.P if (j,p) in sl.JP for c in sl.C)\
		+sum((sl.mus[j,c]*sl.s[j,c]) for j in sl.J for c in sl.C ) <= sl.Omega
sl.nlpC = Constraint( rule=nlp)

def c9(sl):
	return sum(sl.betaS[i,s] * sl.R[i,s] for i in sl.I for s in sl.S if (i,s) in sl.IS) \
	+sum(sl.betaP[j,p]*sl.Q[j,p] for j in sl.J for p in sl.P if (j,p) in sl.JP )\
	+sum(sl.alphaSP[s,p] * sl.y[i,s,p]+sl.betaSP[s,p]*sl.F[i,s,p] for i in sl.I for s in sl.S for p in sl.P if( (i,s) in sl.IS and (i,p) in sl.IP ))\
	+sum(sl.alphaPC[p,c]*sl.z[j,p,c]+sl.betaPC[p,c]*sl.B[j,p,c] for j in sl.J for p in sl.P for c in sl.C if (j,p) in sl.JP)\
	+sum(sl.delta[j,c] * sl.s[j,c] for j in sl.J for c in sl.C ) - sl.Cost == 0
sl.c9C = Constraint( rule=c9)

def c11(sl):
	return -sl.obj + sl.p * (sl.Cost + sum(sl.x[j,p] * sl.alphaC[j,p] + sl.EX[j,p]*sl.betaC[j,p] for j in sl.J for p in sl.P if (j,p) in sl.JP ))+ sum(sl.dual[j,p] for j in sl.J for p in sl.P if(j,p) in sl.JP)  == 0
sl.c11C = Constraint(rule=c11)

def c12(sl, j,p):
	return sl.dual[j,p] == sl.x[j,p] * sl.pix[j,p]+sl.EX[j,p]*sl.piEX[j,p]
sl.c12C = Constraint(sl.JP, rule=c12)

def oobj(sl):
	return sl.obj
sl.oobjO = Objective(rule=oobj, sense=minimize)


















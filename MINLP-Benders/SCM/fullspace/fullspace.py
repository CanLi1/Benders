#write the extensive form of the SCM model
# Imports
#
from pyomo.environ import *
from pyomo.opt import *

m=AbstractModel()

m.I = RangeSet(3, ordered=True)
m.J = RangeSet(4, ordered=True)
m.S = RangeSet(3, ordered=True)
m.P = RangeSet(5, ordered=True)
m.C = RangeSet(12, ordered=True)
m.W = RangeSet(3, ordered=True)
m.IS = Set(within=m.I*m.S)
m.IP = Set(within=m.I*m.P)
m.JP = Set(within=m.J*m.P, ordered=True)
m.ISP = Set(within=m.I*m.S*m.P)
m.U = Param(m.IS, default=0)
m.CAP = Param(m.J, m.P, default=0)
m.M = Param(m.J, m.P, default=0)
m.rho = Param(m.I, m.J, m.P, default=0)
m.Demand= Param(m.J, m.C, m.W, default=0, mutable=True)
m.betaS = Param(m.I, m.S, default=0)
m.betaP = Param(m.J, m.P, default=0)
m.alphaSP = Param(m.S, m.P, default=0)
m.betaSP = Param(m.S,m.P, default=0)
m.alphaPC = Param(m.P, m.C)
m.betaPC = Param(m.P, m.C)
m.alphaC = Param(m.J, m.P, default=0)
m.betaC = Param(m.J, m.P, default=0)
m.delta = Param(m.J, m.C, m.W, default=900)
m.p = Param(m.W)
#first stage variables
m.x = Var(m.JP, within=Binary)
m.EX = Var(m.JP, within=NonNegativeReals)

#second stage variables
m.y = Var(m.ISP, m.W, within=Binary)
m.z = Var(m.JP, m.C, m.W, within=Binary)
# m.y = Var(m.ISP, m.W, bounds=(0,1))
# m.z = Var(m.JP, m.C, m.W, bounds=(0,1))
m.F = Var(m.ISP, m.W, within=NonNegativeReals, initialize = 1000)
m.B = Var(m.JP, m.C, m.W, within=NonNegativeReals)
m.Q = Var(m.JP, m.W, within=NonNegativeReals)
m.R = Var(m.IS, m.W, within=NonNegativeReals)
m.s = Var(m.J, m.C, m.W, within=NonNegativeReals)
m.Cost = Var(m.W, within=NonNegativeReals)

m.obj = Var()


#define parmaters for eco constraints
#standard deviations all equal to one
m.sigmaR = Param(m.IS, default =1)
m.sigmaQ = Param(m.JP, default =1)
m.sigmaF = Param(m.ISP, default=1)
m.sigmaB = Param(m.JP, m.C, default =1)
m.sigmas = Param(m.J, m.C , default =1)
#average all equal to 5
m.muR = Param(m.IS, default =5)
m.muQ = Param(m.JP, default =5)
m.muF = Param(m.ISP, default=5)
m.muB = Param(m.JP, m.C, default =5)
m.mus = Param(m.J, m.C , default =6)
#Omega
m.Omega = Param(default =1.1e6)
def c1(m,j,p):
	return m.EX[j,p] - m.M[j,p]*m.x[j,p] <= 0
m.c1C = Constraint(m.JP, rule=c1)

def c2(m,j,p,w):
	return m.Q[j,p,w] - sum(m.B[j,p,c,w] for c in m.C) == 0
m.c2C = Constraint(m.JP, m.W, rule=c2)

def c3(m,i,s,w):
	return m.R[i,s,w] - m.U[i,s] <= 0
m.c3C = Constraint(m.IS, m.W, rule=c3)

def c10(m,i,s,w):
	return m.R[i,s,w] - sum(m.F[i,s,p,w] for p in m.P if (i,p) in m.IP) ==0
m.c10C = Constraint(m.IS, m.W, rule=c10)

def c4(m,i,p,w):
	return sum(m.F[i,s,p,w] for s in m.S if (i,s) in m.IS) - sum(m.rho[i,j,p] * m.Q[j,p,w] for j in m.J if (j,p) in m.JP) ==0
m.c4C = Constraint(m.IP, m.W, rule=c4)

def c5(m,j,p,w):
	return m.Q[j,p,w] - m.CAP[j,p] - m.EX[j,p] <= 0
m.c5C = Constraint(m.JP, m.W, rule=c5)

def c6(m,j,c,w):
	return sum(m.B[j,p,c,w] for p in m.P if (j,p) in m.JP ) + m.s[j,c,w]  == m.Demand[j,c,w]
m.c6C = Constraint(m.J, m.C, m.W, rule=c6)

def c7(m,i,s,p,w):
	return m.F[i,s,p,w] - 10000* m.y[i,s,p,w] <=0
m.c7C = Constraint(m.ISP, m.W, rule=c7)

def c8(m,j,p,c,w):
	return m.B[j,p,c,w] -3000 * m.z[j,p,c,w] <=0
m.c8C = Constraint(m.JP, m.C, m.W, rule=c8)

#nonlinear constraints
def nlp(m,w):
	return ( sum( (m.sigmaR[i,s] * m.R[i,s,w] )**2 for i in m.I for s in m.S if (i,s) in m.IS)\
		+ sum((m.sigmaQ[j,p] * m.Q[j,p,w] )**2 for j in m.J for p in m.P if(j,p) in m.JP )\
		+sum((m.sigmaF[i,s,p] * m.F[i,s,p,w])**2 for i in m.I for s in m.S if (i,s) in m.IS for p in m.P  if (i,p) in m.IP)\
		+sum((m.sigmaB[j,p,c] * m.B[j,p,c,w])**2 for j in m.J for p in m.P if (j,p) in m.JP for c in m.C)\
		+sum((m.sigmas[j,c]*m.s[j,c,w])**2 for j in m.J for c in m.C )  )**0.5 * 2 \
		+sum( (m.muR[i,s] * m.R[i,s,w] ) for i in m.I for s in m.S if (i,s) in m.IS)\
		+ sum((m.muQ[j,p] * m.Q[j,p,w] ) for j in m.J for p in m.P if(j,p) in m.JP )\
		+sum((m.muF[i,s,p] * m.F[i,s,p,w]) for i in m.I for s in m.S if (i,s) in m.IS for p in m.P  if (i,p) in m.IP)\
		+sum((m.muB[j,p,c] * m.B[j,p,c,w]) for j in m.J for p in m.P if (j,p) in m.JP for c in m.C)\
		+sum((m.mus[j,c]*m.s[j,c,w]) for j in m.J for c in m.C ) <= m.Omega
m.nlpC = Constraint(m.W, rule=nlp)

def c9(m,w):
	return sum(m.betaS[i,s] * m.R[i,s,w] for i in m.I for s in m.S if (i,s) in m.IS) \
	+sum(m.betaP[j,p]*m.Q[j,p,w] for j in m.J for p in m.P if (j,p) in m.JP )\
	+sum(m.alphaSP[s,p] * m.y[i,s,p,w]+m.betaSP[s,p]*m.F[i,s,p,w] for i in m.I for s in m.S for p in m.P if( (i,s) in m.IS and (i,p) in m.IP ))\
	+sum(m.alphaPC[p,c]*m.z[j,p,c,w]+m.betaPC[p,c]*m.B[j,p,c,w] for j in m.J for p in m.P for c in m.C if (j,p) in m.JP)\
	+sum(m.delta[j,c,w] * m.s[j,c,w] for j in m.J for c in m.C ) - m.Cost[w]/ m.p[w] == 0
m.c9C = Constraint(m.W, rule=c9)

def cobj(m):
	return m.obj - sum(m.alphaC[j,p] * m.x[j,p]+ m.betaC[j,p] * m.EX[j,p]for j in m.J for p in m.P if (j,p) in m.JP ) - \
	sum(m.Cost[w] for w in m.W) ==  0
m.cobjC = Constraint(rule=cobj)

# def cobj(m):
# 	return m.obj == sum(m.Cost[w] for w in m.W)
# m.cobj = Constraint(rule=cobj)
def oobj(m):
	return m.obj
m.oobjO = Objective(rule=oobj, sense=minimize)


















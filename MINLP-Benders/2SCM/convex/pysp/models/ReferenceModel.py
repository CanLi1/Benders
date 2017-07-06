#write the reference model of the SCM 
# Imports
#
from pyomo.core import *

model = AbstractModel()

model.I = RangeSet(4)
model.J = RangeSet(6)
model.S = RangeSet(4)
model.R = RangeSet(4)
model.P = RangeSet(3)
model.C = RangeSet(4)

model.IJ = Set(within=model.I * model.J)
model.OJ = Set(within = model.I*model.J)
model.PS = Set(within=model.I*model.S)
model.JM = Set(within=model.I*model.S*model.J)
model.L = Set(within=model.I*model.S * model.J)
model.Lbar = Set(within=model.I*model.S*model.J)
model.RJ = Set(within=model.R*model.J)

#parameters
model.Q0 = Param(model.P, model.I, default=0)
model.rho = Param(model.I, model.J, model.S, default=1)
model.H = Param(model.I, default=1)
model.betaC = Param(model.I)
model.alphaC = Param(model.I)
model.delta = Param(model.I, model.S, default=0.1)
model.phi = Param(model.C, model.J, default=0)
model.QEU = Param(model.P, model.I, default=150)
model.PUU = Param(default=100)
model.FUU = Param(default=150)
model.mu = Param(model.I, model.S, model.J, default=0)
model.D = Param(model.C, model.J, default=0)
model.betaS =Param(model.RJ)
model.alphaRP = Param(model.R, model.P)
model.betaRP = Param(model.R, model.P)
model.alphaPC = Param(model.P, model.C)
model.betaPC = Param(model.P, model.C)

#variables
model.PU = Var(model.R, model.P, model.J, within=NonNegativeReals)
model.F = Var(model.P, model.C, model.J, within=NonNegativeReals)
model.QE = Var(model.P, model.I, within=NonNegativeReals, bounds=(0,150))
model.theta = Var(model.P, model.JM, within=NonNegativeReals)
model.Q = Var(model.P, model.I, within=NonNegativeReals, bounds=(0,150))
model.WW = Var(model.P, model.I, model.J, model.S, within=NonNegativeReals)
model.Slack = Var(model.C, model.J, within=NonNegativeReals)
model.x = Var(model.P, model.I, within=Binary)
model.y = Var(model.R, model.P, within=Binary)
model.z = Var(model.P, model.C, within=Binary)
model.FirstStageCost = Var()
model.SecondStageCost = Var()


def c1(model, p,i):
	return model.QE[p,i] <= model.QEU[p,i] * model.x[p,i]
model.c1C = Constraint(model.P, model.I, rule=c1)

def c2(model, p,i):
	return model.Q[p,i] == model.Q0[p,i] + model.QE[p,i]
model.c2C = Constraint(model.P, model.I, rule=c2)

def c3(model,p,j):
	return sum(model.PU[r,p,j] for r in model.R if (r,j) in model.RJ) + sum(model.WW[p,i,j,s] for i in model.I for s in model.S if (i,j) in model.OJ if (i,s) in model.PS) == sum(model.F[p,c,j] for c in model.C) + sum(model.WW[p,i,j,s] for i in model.I for s in model.S if (i,j) in model.IJ if (i,s) in model.PS)
model.c3C = Constraint(model.P, model.J, rule=c3)

def c4(model,p,i):
	return sum(model.theta[p,i,s,j] for j in model.J for s in model.S if  (i,s,j) in model.JM if (i,s) in model.PS ) <= model.H[i] * model.Q[p,i]
model.c4C = Constraint(model.P, model.I, rule=c4)

def c5(model,p,i,s,j):
	return  model.WW[p,i,j,s] == model.rho[i,j,s] * model.theta[p,i,s,j]
model.c5C = Constraint(model.P, model.JM, rule=c5)

def c6(model,p,i,j,jj,s):
	if (i,s,j) in model.L and (i,s,jj) in model.JM:
		return model.WW[p,i,j,s] == model.mu[i,s,j] * model.WW[p,i,jj, s]
	else:
		return Constraint.Skip
model.c6C = Constraint(model.P, model.I,model.J, model.J, model.S, rule=c6)

def c7(model,p,i,j,jj,s):
	if (i,s,j) in model.Lbar and (i,s,jj) in model.JM:
		return log(1+model.WW[p,i,j,s]) >= model.mu[i,s,j] * model.WW[p,i,jj,s]
	else:
		return Constraint.Skip
model.c7C = Constraint(model.P, model.I, model.J, model.J, model.S, rule=c7)

def c8(model,r,p,j):
	if (r,j) in model.RJ:
		return model.PU[r,p,j] <= model.PUU * model.y[r,p]
	else:
		return Constraint.Skip
model.c8C = Constraint(model.R, model.P, model.J, rule=c8)

def c9(model,p,c,j):
	return model.F[p,c,j] <= model.FUU * model.z[p,c]
model.c9C = Constraint(model.P, model.C, model.J, rule=c9)

def c10(model,c,j):
	return sum(model.F[p,c,j] for p in model.P) + model.Slack[c,j] == model.D[c,j]
model.c10C =  Constraint(model.C, model.J, rule=c10)

def c11(model,p,i,j,s):
	if (i,s,j) not in (model.JM|model.L|model.Lbar):
		return model.WW[p,i,j,s] == 0
	else:
		return Constraint.Skip
model.c11C = Constraint(model.P, model.I, model.J, model.S, rule=c11)

def cobj1(model):
	return  model.FirstStageCost == sum(model.betaC[i] * model.QE[p,i] + model.alphaC[i] * model.x[p,i] for i in model.I for p in model.P)
model.cobj1C = Constraint(rule=cobj1)

def cobj2(model):
	return model.SecondStageCost == sum(model.delta[i,s] * model.rho[i,j,s] * model.theta[p,i,s,j] for p in model.P for i in model.I for s in model.S for j in model.J if (i,s,j) in model.JM) + sum((model.betaS[r,j] + model.betaRP[r,p]) * model.PU[r,p,j] for p in model.P for j in model.J for r in model.R if (r,j) in model.RJ) + sum(model.alphaRP[r,p]*model.y[r,p] for r in model.R for p in model.P) + sum(model.alphaPC[p,c] * model.z[p,c] for p in model.P for c in model.C ) + sum(model.betaPC[p,c] * model.F[p,c,j] for p in model.P for c in model.C for j in model.J ) + sum(model.Slack[c,j] * model.phi[c,j] for c in model.C for j in model.J)
model.cobj2C = Constraint(rule=cobj2)

def oobj(model):
	return model.FirstStageCost + model.SecondStageCost
model.oobjO = Objective(rule=oobj, sense=minimize)
























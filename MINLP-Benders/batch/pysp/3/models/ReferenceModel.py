#write the reference model of the batch 
# Imports
#
from pyomo.core import *

model = AbstractModel()

#sets
model.I = RangeSet(5)
model.J = RangeSet(6)
model.K = RangeSet(4)

#Parameters
model.alpha = Param(model.J, default=250)
model.beta = Param(model.J, default=0.6)
model.delta = Param(default=230)
model.lamda = Param(default=2000)
model.VL = Param(default=300)
model.VU = Param(default=2300)
model.H = Param(default=5000)
model.Q = Param(model.I)
model.S = Param(model.I, model.J)
model.t = Param(model.I, model.J)

#variables
model.yf = Var(model.K, model.J, within=Binary)
model.ys = Var(model.K, model.J, within=Binary)
model.n = Var(model.J, bounds=(0,1.4))
model.v = Var(model.J, bounds=(5.5,7.8))
model.ns = Var(model.J)
model.tl = Var(model.I)
model.b = Var(model.I)
model.StageoneCost = Var(model.J, bounds=(0,105000))
model.StagetwoCost = Var(model.J)
model.FirstStageCost = Var()
model.SecondStageCost = Var()
model.L = Var(within=NonNegativeReals)

def c1(model, j):
	return sum(model.yf[k,j] for k in model.K ) == 1
model.c1C = Constraint(model.J, rule=c1)

def c2(model, j):
	return model.n[j] == sum(log(k)*model.yf[k,j] for k in model.K)
model.c2C = Constraint(model.J, rule=c2)

def c3(model, j):
	return model.v[j] <= log(model.VU)
model.c3C = Constraint(model.J, rule=c3)

def c4(model, j):
	return model.v[j] >= log(model.VL)
model.c4C = Constraint(model.J, rule=c4)

#second stage
def c5(model, i,j):
	return model.v[j] >= log(model.S[i,j]) + model.b[i]
model.c5C = Constraint(model.I, model.J, rule=c5)

def c6(model, j):
	return model.ns[j] == sum(log(k)* model.ys[k,j] for k in model.K)
model.c6C = Constraint(model.J, rule=c6)

def c7(model, j):
	return model.ns[j] <= model.n[j]
model.c7C = Constraint(model.J, rule=c7)

def c8(model,i,j):
	return model.ns[j] + model.tl[i] >= log(model.t[i,j])
model.c8C = Constraint(model.I, model.J, rule=c8)

def c9(model):
	return sum(model.Q[i] * exp(model.tl[i] -model.b[i]) for i in model.I) <= model.H + model.L
model.c9C = Constraint(rule=c9)

def cl1(model, j):
	return model.StageoneCost[j] >= exp(model.n[j] + model.beta[j] * model.v[j])
model.cl1C = Constraint(model.J, rule=cl1)

def cl2(model, j):
	return model.StagetwoCost[j] >= exp(model.ns[j])
model.cl2C = Constraint(model.J, rule=cl2)

def c10(model):
	return model.FirstStageCost == sum(model.alpha[j] * model.StageoneCost[j] for j in model.J)
model.c10C = Constraint(rule=c10)

def c11(model):
	return model.SecondStageCost == sum(model.lamda * model.StagetwoCost[j] + model.delta * model.L for j in model.J)
model.c11C = Constraint(rule=c11)

def oobj(model):
	return model.FirstStageCost + model.SecondStageCost
model.oobjO = Objective(rule=oobj, sense = minimize)

















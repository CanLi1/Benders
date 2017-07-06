from pyomo.environ import *
from pyomo.opt import *

model=AbstractModel()

model.J = RangeSet(4, ordered=True)
model.P = RangeSet(5, ordered=True)
model.JP = Set(within=model.J*model.P,ordered=True)
model.W = RangeSet(3, ordered=True)
model.M = Param(model.JP)
model.alphaC = Param(model.JP)
model.betaC = Param(model.JP)
model.p = Param(model.W)

model.x = Var(model.JP, within=Binary)
model.EX = Var(model.JP, within=NonNegativeReals)
model.f1 = Var()
model.obj = Var()
model.Cost = Var(model.W, within=NonNegativeReals)
model.theta = Var(model.W, within=NonNegativeReals)

def c1(model,j,p):
	return -model.EX[j,p] + model.M[j,p]*model.x[j,p] >= 0
model.c1C = Constraint(model.JP, rule=c1)

def c2(model):
	return model.f1 == sum(model.alphaC[j,p] * model.x[j,p]+ model.betaC[j,p] * model.EX[j,p]for j in model.J for p in model.P if (j,p) in model.JP ) 
model.c2C = Constraint(rule=c2)

def c3(model):
	return model.obj == sum(model.Cost[w] for w in model.W) + model.f1
model.c3C = Constraint(rule=c3)

def c4(model):
	return model.obj == sum(model.theta[w] for w in model.W )
model.c4C = Constraint(rule=c4)

def c5(model, w):
	return model.theta[w] == model.p[w] * sum(model.alphaC[j,p] * model.x[j,p]+ model.betaC[j,p] * model.EX[j,p] for j in model.J for p in model.P if (j,p) in model.JP ) + model.Cost[w]
model.c5C = Constraint(model.W, rule=c5)

def cobj(model):
	return model.obj
model.oobjO = Objective(rule=cobj, sense = minimize)
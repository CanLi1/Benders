#write master problem of Benders decomposition
# Imports
#
from pyomo.environ import *
from pyomo.opt import *


#
# master problem
#

model = AbstractModel()

#
# sets
model.Investments = Set(ordered=True)
model.Scenario = Set(ordered=True)

model.r = Param(model.Investments, model.Scenario)
#variables
model.y = Var(model.Investments,within=Binary)
model.y2 = Var(model.Investments,model.Scenario, within=Binary)
model.x2 = Var(model.Investments, model.Scenario, within=NonNegativeReals)
model.x = Var(model.Investments, within=NonNegativeReals)
model.f = Var( model.Scenario, bounds=(-2000, 1000))
model.d = Var(model.Scenario, model.Scenario, within=NonNegativeReals)
model.su = Var(model.Scenario, model.Scenario,within=NonNegativeReals)
model.obj = Var()
def c1(model):
	return sum(model.x[i] for i in model.Investments ) == 1000
model.c1C = Constraint(rule=c1)

def c2(model):
	return sum(model.y[i] for i in model.Investments) == 1;
model.c2C = Constraint(rule=c2)

def c3(model, i):
	return model.x[i] <= model.y[i] * 1000
model.c3C = Constraint(model.Investments,rule=c3)

def c5(model,s):
	return sum(model.x2[i,s]**2 for i in model.Investments) <= sum(model.x[i] * model.r[i,s] for i in model.Investments)
model.c5C = Constraint(model.Scenario, rule=c5)

def c6(model,s):
	return sum(model.y2[i,s] for i in model.Investments) == 1
model.c6C = Constraint(model.Scenario, rule=c6)

def c4(model,s,ss):
	return sum(model.x2[i,s] * model.r[i,ss] for i in model.Investments ) - model.su[s,ss] + model.d[s,ss] == 35
model.c4C = Constraint(model.Scenario, model.Scenario, rule=c4)

def c7(model,s):
	return model.f[s] == 0.5*sum(-3*model.d[s,ss] + model.su[s,ss] for ss in model.Scenario)
model.c7C = Constraint(model.Scenario,rule=c7)

def c8(model,s,i):
	return model.x2[i,s] <= 1000 * model.y2[i,s]
model.c8C = Constraint(model.Scenario, model.Investments, rule= c8)

def cobj(model):
	return model.obj == 0.5*sum(model.f[i] for i in model.Scenario)
model.cobjC = Constraint(rule=cobj)

def oobj(model):
	return model.obj
model.oobjO = Objective(rule = oobj, sense=maximize)

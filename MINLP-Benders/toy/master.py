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
#variables
model.y = Var(model.Investments,within=Binary)
model.x = Var(model.Investments, within=NonNegativeReals)
model.f1 = Var( bounds=(-50, 50))
model.f2 = Var( bounds=(-50, 50))
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

def cobj(model):
	return model.obj == 0.5*(model.f1 + model.f2)
model.cobjC = Constraint(rule=cobj)

def oobj(model):
	return model.obj
model.oobjO = Objective(rule = oobj, sense=maximize)














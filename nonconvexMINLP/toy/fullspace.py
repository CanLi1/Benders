#write the extensive form of the toy nonconvex model
# Imports
#
from pyomo.environ import *
from pyomo.opt import *

model=AbstractModel()

model.s = RangeSet(3)

#parameters
model.h1 = Param(model.s)
model.h2 = Param(model.s)
model.p = Param(model.s)

#variables
model.x = Var(bounds=(0,5)) 
model.y = Var(within=Binary)
model.z1 = Var(model.s,within=Binary)
model.z2 = Var(model.s,within=Binary)
model.u1 =Var(model.s, within=NonNegativeReals)
model.u2 = Var(model.s, within=NonNegativeReals)
model.obj = Var()
model.theta = Var(model.s)

def c1(model):
	return model.x <= 5 * model.y
model.c1C = Constraint(rule=c1)

def c2(model):
	return model.x >= 3 * model.y
model.c2C = Constraint(rule=c2)

def c3(model, s):
	return model.u1[s] <= model.h1[s] * model.z1[s]
model.c3C = Constraint(model.s, rule=c3)

def c4(model, s):
	return model.u2[s] <= model.h2[s] * model.z2[s]
model.c4C = Constraint(model.s, rule=c4)

def c5(model, s):
	return model.u1[s] * model.u2[s]  <= 3 * model.x
model.c5C = Constraint(model.s, rule=c5)

def c6(model, s):
	return model.u1[s] - model.u2[s] <=1
model.c6C = Constraint(model.s, rule=c6)

def c7(model, s):
	return model.u2[s] - model.u1[s] <=1 
model.c7C = Constraint(model.s, rule=c7)

def c8(model, s):
	return model.theta[s] == model.p[s] * (5 * model.x + 7 * model.y ) + model.p[s] * (-15*model.u1[s] - 10 * model.u2[s] + 3 * model.z1[s] + 3 * model.z2[s]) 
model.c8C = Constraint(model.s, rule=c8)

def cobj(model):
	return model.obj == 5 * model.x + 7 * model.y + sum(model.p[s] * (-15*model.u1[s] - 10 * model.u2[s] + 3 * model.z1[s] + 3 * model.z2[s]) for s in model.s)
model.cobjC = Constraint(rule=cobj)

def oobj(model):
	return model.obj
model.oobjC = Objective(rule=oobj, sense=minimize)





















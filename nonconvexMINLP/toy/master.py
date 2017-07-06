#
from pyomo.environ import *
from pyomo.opt import *

model=AbstractModel()

model.s = RangeSet(3)



#variables
model.x = Var(bounds=(0,5)) 
model.y = Var(within=Binary)
model.theta = Var(model.s, bounds =(-50, 100))
model.f1 = Var()
model.obj = Var()

def c1(model):
	return model.x <= 5 * model.y
model.c1C = Constraint(rule=c1)

def c2(model):
	return model.x >= 3 * model.y
model.c2C = Constraint(rule=c2)

def c3(model):
	return model.obj == sum(model.theta[s] for s in model.s )
model.c3C = Constraint(rule=c3)

def c4(model):
	return model.f1 == 5 * model.x + 7 * model.y
model.c4C = Constraint(rule=c4)

def cobj(model):
	return model.obj 
model.oobjO = Objective(rule=cobj, sense=minimize)


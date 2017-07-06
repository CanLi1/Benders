from pyomo.environ import *
from pyomo.opt import *

model=AbstractModel()

model.I = RangeSet(2)
model.b = Param(mutable=True, default=1)
model.A = Param(model.I,mutable=True ,default=1)

model.x = Var(model.I, within=NonNegativeReals)

#If use mutable parameter inside of sum() baron will regard 
#the mutable parameter A[i] as illegal variable
#if just write model.A = Param(model.I,default=1)
#then it will work
def c(model):
	return sum(model.A[i] * model.x[i] for i in model.I)  == model.b
model.C = Constraint(rule=c)

def obj(model):
	return sum(model.x[i] for i in model.I)
model.Obj = Objective(rule=obj, sense=maximize)
#lagrangean subproblem
# Imports
#
from pyomo.environ import *
from pyomo.opt import *

sl=AbstractModel()


#parameters
sl.h1 = Param(mutable=True, default=0)
sl.h2 = Param(mutable=True, default=0)
sl.p = Param(mutable=True, default=0)

#variables
sl.x = Var(bounds=(0,5)) 
sl.y = Var(within=Binary)
sl.z1 = Var(within=Binary)
sl.z2 = Var(within=Binary)
sl.u1 =Var(within=NonNegativeReals)
sl.u2 = Var(within=NonNegativeReals)
sl.obj = Var()

#lagrangean multiplier
sl.pix = Param(mutable=True, default=0)
sl.piy = Param(mutable=True, default=0)

def c1(sl):
	return sl.x <= 5 * sl.y
sl.c1C = Constraint(rule=c1)

def c2(sl):
	return sl.x >= 3 * sl.y
sl.c2C = Constraint(rule=c2)

def c3(sl):
	return sl.u1 <= sl.h1 * sl.z1
sl.c3C = Constraint(rule=c3)

def c4(sl):
	return sl.u2 <= sl.h2 * sl.z2
sl.c4C = Constraint(rule=c4)

def c5(sl):
	return sl.u1 * sl.u2  <= 3 * sl.x
sl.c5C = Constraint(rule=c5)

def c6(sl):
	return sl.u1 - sl.u2 <=1
sl.c6C = Constraint(rule=c6)

def c7(sl):
	return sl.u2 - sl.u1 <=1 
sl.c7C = Constraint(rule=c7)

def cobj(sl):
	return sl.obj == sl.p * (5 * sl.x + 7 * sl.y -15*sl.u1 - 10 * sl.u2 + 3 * sl.z1 + 3 * sl.z2) + sl.pix * sl.x + sl.piy * sl.y
sl.cobjC = Constraint(rule=cobj)

def oobj(sl):
	return sl.obj
sl.oobjC = Objective(rule=oobj, sense=minimize)





















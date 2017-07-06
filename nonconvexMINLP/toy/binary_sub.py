#subproblem to get upper bound
# Imports
#
from pyomo.environ import *
from pyomo.opt import *

subb=AbstractModel()


#parameters
subb.h1 = Param(mutable=True, default=0)
subb.h2 = Param(mutable=True, default=0)
subb.p = Param(mutable=True, default=0)
subb.x = Param(mutable=True, default=0)
subb.y = Param(mutable=True, default=0)

#variables
subb.xbar = Var() 
subb.ybar = Var()
subb.z1 = Var(within=Binary)
subb.z2 = Var(within=Binary)
subb.u1 =Var(within=NonNegativeReals)
subb.u2 = Var(within=NonNegativeReals)
subb.obj = Var()


def c01(subb):
	return subb.xbar == subb.x 
subb.c01C = Constraint(rule=c01)

def c02(subb):
	return subb.ybar == subb.y 
subb.c02C = Constraint(rule=c02)

def c3(subb):
	return subb.u1 <= subb.h1 * subb.z1
subb.c3C = Constraint(rule=c3)

def c4(subb):
	return subb.u2 <= subb.h2 * subb.z2
subb.c4C = Constraint(rule=c4)

def c5(subb):
	return subb.u1 * subb.u2  <= 3 * subb.x
subb.c5C = Constraint(rule=c5)

def c6(subb):
	return subb.u1 - subb.u2 <=1
subb.c6C = Constraint(rule=c6)

def c7(subb):
	return subb.u2 - subb.u1 <=1 
subb.c7C = Constraint(rule=c7)


def cobj(subb):
	return subb.obj == subb.p * (-15*subb.u1 - 10 * subb.u2 + 3 * subb.z1 + 3 * subb.z2)
subb.cobjC = Constraint(rule=cobj)

def oobj(subb):
	return subb.obj
subb.oobjC = Objective(rule=oobj, sense=minimize)





















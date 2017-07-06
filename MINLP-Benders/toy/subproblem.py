from pyomo.environ import *
from pyomo.opt import *


#
# subproblem
#

sub = AbstractModel()

#
# Sets
#

sub.Investments = Set(ordered=True)
sub.Scenarios = Set(ordered=True)
# 
# 
#Parameters
# 
#return of each scenario
sub.r = Param(sub.Investments, sub.Scenarios)
#return of the first stage in a specific subproblem
sub.r0 = Param(sub.Investments)
#first stage decision
sub.x1 = Param(sub.Investments, mutable=True)

#Variables

#local copy of the first stage var
sub.xbar = Var(sub.Investments)
#second stage decision
sub.y2 = Var(sub.Investments,within=NonNegativeReals)
sub.x2 = Var(sub.Investments, within=NonNegativeReals)
sub.d = Var(sub.Scenarios, within = NonNegativeReals)
sub.su = Var(sub.Scenarios, within=NonNegativeReals)
sub.obj = Var()
#constraints
def c0(sub, i):
	return sub.xbar[i] == sub.x1[i] 
sub.c0C = Constraint(sub.Investments, rule=c0)

def c1(sub):
	return sum(sub.x2[i]**2 for i in sub.Investments ) <= sum(sub.xbar[i]*sub.r0[i] for i in sub.Investments)
sub.c1C = Constraint(rule=c1)

def c2(sub):
	return sum(sub.y2[i] for i in sub.Investments) == 1;
sub.c2C = Constraint(rule=c2)

def c3(sub, i):
	return sub.x2[i] <= 50 * sub.y2[i]
sub.c3C = Constraint(sub.Investments, rule=c3)

def c4(sub,s):
	return sum(sub.x2[i] * sub.r[i,s] for i in sub.Investments) + sub.d[s]-sub.su[s] == 35
sub.c4C = Constraint(sub.Scenarios, rule=c4)

def bound(sub,i):
	return sub.y2[i] <= 1
sub.boundC = Constraint(sub.Investments, rule=bound)

def cobj(sub):
	return sub.obj == 0.5 * sum(sub.su[s] - 3 * sub.d[s] for s in sub.Scenarios )
sub.cobjC = Constraint(rule=cobj)

def oobj(sub):
	return sub.obj
sub.oobjO = Objective(rule=oobj, sense=maximize)
















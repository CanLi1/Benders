from pyomo.environ import *
from pyomo.opt import *


#
# cglp
#

cg = AbstractModel()
#number index for sets
cg.ncolumn = Param(default=1, mutable=True)
cg.nnodes = Param(default=1, mutable=True)
cg.nrow = Param(default=1, mutable=True)
cg.nrow1 = Param(default=1, mutable=True)

#Sets
cg.nodes = RangeSet(cg.nnodes, ordered=True)
cg.row = RangeSet(cg.nrow, ordered=True) #for Ax <=b
cg.row1 = RangeSet(cg.nrow1, ordered=True) #for Cx = d
cg.column = RangeSet(cg.ncolumn, ordered=True)

#Parameters

cg.x = Param(cg.column, mutable=True, default=0)

cg.v = Param(cg.nodes, mutable=True, default=0)
cg.gamma = Param(cg.nodes, cg.column, mutable=True, default=0)
cg.A = Param(cg.row, cg.column, default=0, mutable=True)
cg.C = Param(cg.row1, cg.column, default=0, mutable=True)
cg.b = Param(cg.row, default=0, mutable=True)
cg.d = Param(cg.row1, default=0, mutable=True)
cg.mu = Param(default=0, mutable=True)
#Variables
cg.sigma0 = Var()
cg.sigma = Var(cg.column)
cg.tau = Var(cg.row, cg.nodes, within=NonNegativeReals)
cg.tau1 = Var(cg.row1, cg.nodes)
cg.tau0 = Var(cg.nodes, within=NonNegativeReals)
cg.zeta = Var()
cg.obj = Var()

def c1(cg, q):
	return (cg.sigma0 - cg.tau0[q] >= 0.0)
cg.c1C = Constraint(cg.nodes, rule=c1)

def c2(cg,q,j):
	return cg.sigma[j] >=sum( cg.tau[i,q] * cg.A[i,j] for i in cg.row ) + cg.tau0[q] * cg.gamma[q,j] + sum(cg.tau1[i,q] * cg.C[i,j] for i in cg.row1) 
cg.c2C = Constraint(cg.nodes, cg.column, rule=c2)

def c3(cg,q):
	return cg.zeta <= sum(cg.tau[i,q] * cg.b[i] for i in cg.row) + cg.tau0[q] * cg.v[q] + sum(cg.tau1[i,q] * cg.d[i] for i in cg.row1)
cg.c3C = Constraint(cg.nodes, rule=c3) 

def c4(cg):
	return sum(cg.tau0[q] for q in cg.nodes) == 1
cg.c4C = Constraint(rule=c4)

def cobj(cg):
	return cg.obj == -sum(cg.sigma[j] * cg.x[j] for j in cg.column) - cg.sigma0 * cg.mu + cg.zeta
cg.cobjC = Constraint(rule=cobj)

def oobj(cg):
	return cg.obj 
cg.oobjO = Objective(rule=oobj,sense=maximize)







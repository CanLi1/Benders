from pyomo.environ import *
from pyomo.opt import *
from fullspace import *
import time
from copy import deepcopy
a = time.time()
# opt = SolverFactory('scip')
opt = SolverFactory('baron')
opt.options['CplexLibName'] = "/opt/ibm/ILOG/CPLEX_Studio127/cplex/bin/x86-64_linux/libcplex1270.so"
instance = m.create_instance('fullspace.dat')
ins = time.time()
# for index in instance.JP:
# 	instance.x[index].fixed = True
# 	instance.EX[index].fixed=True
#  	instance.x[index].value =0
#  	instance.EX[index].value =0
# instance.x[2,2].value = 1
# instance.x[3,2].value = 1
# instance.x[4,5].value = 1
# instance.EX[2,2].value = 6100
# instance.EX[3,2].value = 6040
# instance.EX[4,5].value = 4400
results = opt.solve(instance,tee=True)
instance.display()
b = time.time()
# instance.c1C[1,1].deactivate()
# instance.c1C[1,1].activate()
# var_list = []
# var_list.append(instance.z[1,1,1,1])
# c = time.time()
# results =opt.solve(instance,tee=True)
# print results
# instance.display()
# print "solve status ", results.solver.status
# print "solve status",results.solver.termination_condition
# for index in instance.JP:
# 	for i in instance.C:
# 		print index, i, instance.B[index,i,1].value

# print "R"
# for index in instance.IS:
# 	print str(instance.R[index,1]), instance.R[index,1].value
# print "Q"
# for index in instance.JP:
# 	print str(instance.Q[index,1]), instance.Q[index,1].value
# print "s"
# for index in instance.J:
# 	for j in instance.C:
# 		print str(instance.s[index, j,1]), instance.s[index,j,1].value
print "solution time ", b-a 

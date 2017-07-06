from pyomo.environ import *
from pyomo.opt import *
from fullspace import *
opt = SolverFactory('baron')
opt.options['CplexLibName'] = "/opt/ibm/ILOG/CPLEX_Studio127/cplex/bin/x86-64_linux/libcplex1270.so"
instance = model.create_instance('fullspace.dat')
opt.solve(instance,tee=True)
instance.display()
from pyomo.environ import *
from pyomo.opt import *
from SL import *
from scenario_generator import *
opt = SolverFactory('baron')
opt.options['CplexLibName'] = "/opt/ibm/ILOG/CPLEX_Studio127/cplex/bin/x86-64_linux/libcplex1270.so"
instance = generate_scenario(sl)
opt.solve(instance[0],tee=True, keepfiles=True)
instance[0].display()
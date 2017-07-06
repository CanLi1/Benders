from pyomo.environ import *
from pyomo.opt import *
from fullspace import *
opt = SolverFactory('cplex')
instance = model.create_instance('fullspace.dat')
opt.solve(instance,tee=True)
instance.display()

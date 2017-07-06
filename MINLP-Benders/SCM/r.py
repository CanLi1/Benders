from temp import *
from pyomo.environ import *
from pyomo.opt import *

opt = SolverFactory('baron')
instance = model.create_instance()
opt.solve(instance,tee=True, keepfiles=True)
instance.display()
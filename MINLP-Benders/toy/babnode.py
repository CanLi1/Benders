from pyomo.core import Constraint
from pyomo.opt import *
from pyomo.environ import *


def is_fractional(var):
	if var.value < 1-1e-6 and var.value > 1e-6:
		return True 
	else:
		return False

class babnode:

	opt = SolverFactory('cplex') 

	def __init__(self,args):
		#objective of this node
		self.value = 0
		#status can be O: "optimal" F: "fractional" I: "infeasible"
		self.status = "O" 
		self.ode_instance = 0
		#record all the binary variables that has not been branched on 
		self.vars_not_branched = [] 
		#record all the binary variables that has been branched 
		self.vars_branched = [] 
		#vars that has fractional value after solving the LP relexation at this node
		self.frac_vars = [] 
		self.dual_function_coefficent = [] 
		self.leftchild = None 
		self.rightchild = None
		self.results = []

		#babnode can be initialized by a badnode or by an instance
		#we need to use [instance, 0] to initialize by an instance
		if len(args) == 2:
			self.node_instance = args[0]
			self.node_instance.dual = Suffix(direction=Suffix.IMPORT)
			#todo
			#find all the binary variables
			self.vars_not_branched = [self.node_instance.y2['A'],self.node_instance.y2['B'],self.node_instance.y2['C'],self.node_instance.y2['D'] ]
	

		else:
			self.node_instance = args[0].node_instance
			self.vars_branched = args[0].vars_branched
			self.vars_not_branched = args[0].vars_not_branched
			
			#todo
			#update dual function coeff

		#import dual

		self.results = self.opt.solve(self.node_instance,tee=True)	
		# self.node_instance.display()
		#check status of the current node
		if (self.results.solver.status == SolverStatus.ok) and (self.results.solver.termination_condition == TerminationCondition.optimal):			#find all fractional vars
			self.value = self.node_instance.obj.value
			for var in self.vars_not_branched:
				if is_fractional(var):
					self.frac_vars.append(var)
			if len(self.frac_vars) == 0:
				self.status ="O"
			else:
				self.status = "F"
		elif (self.results.solver.termination_condition == TerminationCondition.infeasible):
			self.status ="I"
		else:
			print "Solver Status: ",  result.solver.status

	#get dual function for current node		
	def get_dual(self):
		#note that the get dual only works when we write all the
		# constraints as Ax <= b Cx=d xbar=x1. varaible bounds are written explicitly
		# as constraints
		self.gamma = []
		self.v = 0
		for i in self.node_instance.Investments:
			self.v -= self.node_instance.dual[self.node_instance.c0C[i]] * self.node_instance.x1[i].value
			self.gamma.append(-self.node_instance.dual[self.node_instance.c0C[i]])
		self.v += self.node_instance.obj.value
		print self.v, self.gamma, self.value




class babtree:
	def __init__(self, root_instance):
		self.rootnode = 0
		self.leafnode = []
		self.active_leaf_node = []
		self.UB = 1e6
		self.LB = -1e6

		#initialize
		self.rootnode = babnode([root_instance,0])
		self.leafnode=[self.rootnode]


from pyomo.core import Constraint
from pyomo.opt import *
from pyomo.environ import *
import operator


def is_fractional(var):
	if var.value < 1-1e-6 and var.value > 1e-6:
		return True 
	else:
		return False

class babnode:

	opt = SolverFactory('ipopt') 

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
			self.vars_not_branched = []
			for var in self.node_instance.component_objects(Var):
				vobject = getattr(self.node_instance, str(var))
				for index in vobject:
					if vobject[index].bounds[0] == 0 and vobject[index].bounds[1] ==1:
						self.vars_not_branched.append(vobject[index])
			# self.opt.solve(self.node_instance)
			# self.node_instance.display()
	

		else:
			self.node_instance = args[0].node_instance
			self.vars_branched = args[0].vars_branched
			self.vars_not_branched = args[0].vars_not_branched
			
	

		#import dual

		self.results = self.opt.solve(self.node_instance,tee=True)	
		# self.node_instance.display()
		# print "display fractional variables of node with value ", self.node_instance.obj.value
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

		#sort fractional variables i.e. specify branching rules
		if self.status == "F":
			self.temp_dict = {}
			for i in range(len(self.frac_vars)):
				self.temp_dict[i] = abs(self.frac_vars[i].value -0.5)
			self.temp_dict2 = sorted(self.temp_dict.items(), key=operator.itemgetter(1))
			self.sorted_var = range(len(self.frac_vars))
			for i in range(len(self.frac_vars)):
				self.sorted_var[i] = self.frac_vars[self.temp_dict2[i][0]]
			self.frac_vars = self.sorted_var


	#get dual function for current node		
	def get_dual(self):
		#note that the get dual only works when we write all the
		# constraints as Ax <= b Cx=d xbar=x1. varaible bounds are written explicitly
		# as constraints
		#if the problem is infeasible solve the feasibility subproblem
		if self.status == "I":
			print "one leafnode is infeasible"
		self.gamma = []
		self.v = 0
		for i in self.node_instance.JP:
			self.v -= self.node_instance.dual[self.node_instance.c01C[i]] * self.node_instance.x[i].value
			self.gamma.append(-self.node_instance.dual[self.node_instance.c01C[i]])
		for i in self.node_instance.JP:
			self.v -= self.node_instance.dual[self.node_instance.c02C[i]]*self.node_instance.EX[i].value
			self.gamma.append(-self.node_instance.dual[self.node_instance.c02C[i]])
		self.v += self.node_instance.obj.value
		# print self.v, self.gamma, self.value




class babtree:
	def __init__(self, root_instance):
		self.rootnode = 0
		self.leafnode = []
		self.active_leaf_node = []
		self.UB = 1e20
		self.LB = 1E20

		#initialize
		self.rootnode = babnode([root_instance,0])
		self.leafnode=[self.rootnode]


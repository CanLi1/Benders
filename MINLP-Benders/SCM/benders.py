#this file is designed for minimization problem
#all the constraint in the master problem should be written as Ax >= b 
from pyomo.environ import *
from pyomo.opt import *
from pyomo.core import Constraint
from pyomo.core.base.expr_coopr3 import *
from copy import deepcopy
from subproblem import *
from master import *
from binary_sub import *
from babnode import *
import os
from pyomo.repn.canonical_repn import generate_canonical_repn
from scenario_generator import *
from link import *
import time 
total_time = 0
copy_time = 0
master_solve_time = 0
cglp_solve_time = 0
scip_solve_time = 0
nlp_solve_time = 0
start = time.time()

opt = SolverFactory('cplex')
nopt = SolverFactory('baron')
model.disjuntivecuts = ConstraintList()
m = model.create_instance('master.dat')
opt.solve(m)
sub.babcut = ConstraintList()

#preprocess the cglp
from cglp import *

var_list = []
for var in m.component_objects(Var):
	if str(var) != "obj" and "Cost" not in str(var) and str(var) != "f1":
		vobject = getattr(m, str(var))
		for index in vobject:
			var_list.append(str(vobject[index]))
cg.ncolumn.value = len(var_list)
nrow = 0
nrow1 = 0

for c in m.component_objects(Constraint):
	if str(c) == "c1C":
		cobject = getattr(m, str(c))
		for index in cobject:
			if cobject[index].equality:
				nrow1 += 1
			else:
				nrow += 1
nrow += len(var_list)*2
cg.nrow.value = nrow
cg.nrow1.value = nrow1
A = []
b = []
C =[]
d = []

for i in range(nrow):
	A.append([])
	b.append(0)
	for j in range(cg.ncolumn.value):
		A[i].append(0)
for i in range(nrow1):
	C.append([])
	d.append(0)
	for j in range(cg.ncolumn.value):
		C[i].append(0)



#access the coeffcient of each varaible in one constraint
iter_row = 0
iter_row1 = 0
for c in m.component_objects(Constraint):
	if str(c)== "c1C":
		cobject = getattr(m, str(c))
		for index in cobject:
			expression = cobject[index].body
			repn = generate_canonical_repn(expression)
			if cobject[index].equality:
				d[iter_row1] = cobject[index].lower()
				for i in range(len(repn.variables)):
					C[iter_row1][var_list.index(str(repn.variables[i]))] = repn.linear[i]
				iter_row1 += 1
			else:
				b[iter_row] = cobject[index].lower()
				for i in range(len(repn.variables)):
					A[iter_row][var_list.index(str(repn.variables[i]))] = repn.linear[i]

				iter_row += 1
#write upper and lower bound for vars x>= 0 x<=U
for i in range(len(var_list)):
	A[iter_row][i] = 1
	iter_row+= 1
for i in range(len(var_list)):
	A[iter_row][i] = -1
	if "EX" in var_list[i]:
		b[iter_row] = -10000
	else:
		b[iter_row] = -1
	iter_row += 1

cglp_param = open("cglp.dat", "w")
def write_matrix(file, matrix, name):
	if matrix ==[]:
		return 0
	file.write("param " + name + ":=\n")
	for i in range(len(matrix)):
		if isinstance(matrix[i], list):
			for j in range(len(matrix[i])):
				file.write(str(i+1) + " " + str(j+1) + " " + str(matrix[i][j])+"\n")
		else:
			file.write(str(i+1) + " " + str(matrix[i])+"\n")
	file.write(";\n")

write_matrix(cglp_param, A, "A")
write_matrix(cglp_param, b, "b")
write_matrix(cglp_param, C, "C")
write_matrix(cglp_param, d, "d")
cglp_param.close()

#scenario generation
num_scenarios = len(m.W)
scenario_instances = generate_scenario(sub)
binary_scenario_instances = generate_scenario(subb)
yita = generate_sub_obj(m)


MUB = 1e10
MLB = -1e6
previous_MUB= 1e10
previous_MLB = -1e6

niter = 0
max_branch = 10
while MUB > MLB:
	previous_MLB = MLB 
	previous_MUB = MUB
	ta = time.time()
	opt.solve(m,tee=True)
	m.display()
	tb = time.time()
	master_solve_time += tb - ta
	MLB = m.obj.value
	if MUB < MLB + 1e-3 or niter >=30:
		# m.display()
		# print "terminate normally in " + str(niter) + " iterations"
		break
	temp_UB = m.f1.value 
	print "f1 ", m.f1.value
	for s in range(num_scenarios):
		#solve the binary subproblem using cplex to get upper bound
		get_master_value(binary_scenario_instances[s], m)
		ta = time.time()
		nopt.solve(binary_scenario_instances[s], tee=True)
		tb = time.time()
		scip_solve_time += tb - ta 
		temp_UB += binary_scenario_instances[s].obj.value 
		print "scecond stage scenario ", str(s+1), binary_scenario_instances[s].obj.value 
		ta = time.time()
		root_instance = deepcopy(scenario_instances[s])
		tb = time.time()
		copy_time += tb - ta 
		#initialize first stage vars in subproblem
		get_master_value(root_instance, m)
		tree = babtree(root_instance)

		if tree.rootnode.status == "F":
			tree.active_leaf_node.append(tree.rootnode)
			iter= 0
		while len(tree.active_leaf_node) > 0:
			
			cur_node = tree.active_leaf_node[0]
			# print "cur node" ,cur_node.value, "tree.LB", tree.LB, "tree.UB", tree.UB
			tree.active_leaf_node.remove(cur_node)
			if cur_node.value > tree.UB:
				continue
			else:
				tree.leafnode.remove(cur_node)
				ta = time.time()
				newleftnode = deepcopy(cur_node)
				newrightnode = deepcopy(cur_node)
				tb = time.time()
				copy_time += tb - ta

				ta = time.time()
				#branching
				branch_var = newleftnode.frac_vars[0]
				newleftnode.node_instance.babcut.add(branch_var <=0)
				newleftnode.vars_not_branched.remove(branch_var)
				newleftnode.vars_branched.append(branch_var)
				branch_var = newrightnode.frac_vars[0]
				newrightnode.node_instance.babcut.add(-branch_var <=- 1)
				newrightnode.vars_not_branched.remove(branch_var)
				newrightnode.vars_branched.append(branch_var)
				#solve new node and attach to the current node
				cur_node.leftchild = babnode([newleftnode])
				cur_node.rightchild = babnode([newrightnode])
				#update leafnode
				tree.leafnode.append(cur_node.leftchild)
				tree.leafnode.append(cur_node.rightchild)
				#update active leafnode and LB
				if cur_node.leftchild.status == "F" and cur_node.leftchild.value < tree.UB:
					tree.active_leaf_node.append(cur_node.leftchild)
				elif cur_node.leftchild.status == "O":
					print "optimal solution found"
					if cur_node.leftchild.value < tree.UB:
						tree.UB = cur_node.leftchild.value
				if cur_node.rightchild.status == "F" and cur_node.rightchild.value < tree.UB:
					tree.active_leaf_node.append(cur_node.rightchild)
				elif cur_node.rightchild.status == "O":
					if cur_node.rightchild.value < tree.UB:
						tree.UB = cur_node.rightchild.value	

				#update UB
				tree.LB = 1e20
				for node in tree.leafnode:
					if node.value < tree.LB:
						tree.LB = node.value

				tb = time.time()
				nlp_solve_time += tb - ta
			iter += 1
			if tree.UB == tree.LB or iter >= max_branch:
				print "tree.LB ", tree.LB
				break

		#get dual function in each leaf node
		for leaf in range(len(tree.leafnode)):
			tree.leafnode[leaf].get_dual()

		#solve cglp
		ta = time.time()
		cg.nnodes.value = len(tree.leafnode)
		cur_cglp = cg.create_instance("cglp.dat")

		#update dual function
		for q in range(len(tree.leafnode)):
			for j in range(len(m.JP)*2):
				cur_cglp.gamma[q+1,j+1].value = tree.leafnode[q].gamma[j]
			cur_cglp.v[q+1].value = tree.leafnode[q].v 
		
		#previous iteration information
		cur_cglp.mu.value = yita[s].value 
		temp = []
		for i in m.JP:
			temp.append(m.x[i].value)
		for i in m.JP:
			temp.append(m.EX[i].value)
		for i in range(len(m.JP)*2):
			cur_cglp.x[i+1].value = temp[i]
		
		opt.solve(cur_cglp)
		tb = time.time()
		cglp_solve_time += tb - ta
		# if niter > 8:
		# 	cur_cglp.display()
		#add cuts to master problem
		cut = 0
		cut += yita[s] * cur_cglp.sigma0.value
		ii = 1
		for i in m.JP:
			cut = cut + m.x[i] * cur_cglp.sigma[ii].value + m.EX[i] * cur_cglp.sigma[ii+len(m.JP)].value
			ii +=1
		cut = cut - cur_cglp.zeta.value
		print cut.to_string()
		m.disjuntivecuts.add(cut>= 0)
	
	#update UB
	if temp_UB < MUB:
		MUB = temp_UB

	#update iter
	niter += 1
	print "upper bound", MUB, " lower bound ", MLB
	# if MLB <= previous_MLB + 100:
	# 	max_branch += 100 

end = time.time()
print "total solution time ", end-start
print "cglp time ", cglp_solve_time
print "master_solve_time ", master_solve_time
print "scip_solve_time ", scip_solve_time
print "nlp_solve_time ", nlp_solve_time
print " copy time ", copy_time




from pyomo.environ import *
from pyomo.opt import *
from pyomo.core import Constraint
from pyomo.core.base.expr_coopr3 import *
from copy import deepcopy
from subproblem import *
from master import *
from babnode import *
import os

opt = SolverFactory('cplex')
model.disjuntivecuts = ConstraintList()
m = model.create_instance('master.dat')
opt.solve(m)
sub.babcut = ConstraintList()

#preprocess the cglp
from cglp import *

#todo
#this way doesn't work, see cglp-abstract.py
var_list = []
for var in m.component_objects(Var):
	if str(var) != "obj" and "f" not in str(var):
		vobject = getattr(m, str(var))
		for index in vobject:
			var_list.append(vobject[index])
cg.ncolumn.value = len(var_list)
nrow = 0
nrow1 = 0
constraint_list = []
for c in m.component_objects(Constraint):
	if str(c) != "cobjC":
		cobject = getattr(m, str(c))
		for index in cobject:
			constraint_list.append(cobject[index])
			if cobject[index].equality:
				nrow1 += 1
			else:
				nrow += 1
cg.nrow.value = nrow +8
cg.nrow1.value = nrow1

#todo
#how to access the coeffcient of each varaible in one constraint




scenarios = [1, 2]
#lower bound of each scenario
yitaL = [-50, -50]
yita = [m.f1, m.f2]
MUB = 1e6
MLB = -1e6
niter = 0
while MUB > MLB:
	opt.solve(m,tee=True)
	m.display()
	MUB = m.obj.value
	if MUB < MLB + 1e-5:
		# m.display()
		print "terminate normally in " + str(niter) + " iterations"
		break
	temp_LB = 0 
	for s in scenarios:
		root_instance = sub.create_instance('s' + str(s) + '.dat')
		#initialize first stage vars in subproblem
		for i in root_instance.Investments:
			root_instance.x1[i] = m.x[i].value
		tree = babtree(root_instance)
		if tree.rootnode.status == "F":
			tree.active_leaf_node.append(tree.rootnode)
			iter= 0
		while len(tree.active_leaf_node) > 0:
			
			cur_node = tree.active_leaf_node[0]
			# print "cur node" ,cur_node.value, "tree.LB", tree.LB, "tree.UB", tree.UB
			tree.active_leaf_node.remove(cur_node)
			if cur_node.value < tree.LB:
				continue
			else:
				tree.leafnode.remove(cur_node)
				
				newleftnode = deepcopy(cur_node)
				newrightnode = deepcopy(cur_node)
				#branching
				branch_var = newleftnode.vars_not_branched[0]
				newleftnode.node_instance.babcut.add(branch_var <=0)
				newleftnode.vars_not_branched.remove(branch_var)
				newleftnode.vars_branched.append(branch_var)
				branch_var = newrightnode.vars_not_branched[0]
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
				if cur_node.leftchild.status == "F" and cur_node.leftchild.value > tree.LB:
					tree.active_leaf_node.append(cur_node.leftchild)
				elif cur_node.leftchild.status == "O":
					if cur_node.leftchild.value > tree.LB:
						tree.LB = cur_node.leftchild.value
				if cur_node.rightchild.status == "F" and cur_node.rightchild.value > tree.LB:
					tree.active_leaf_node.append(cur_node.rightchild)
				elif cur_node.rightchild.status == "O":
					if cur_node.rightchild.value > tree.LB:
						tree.LB = cur_node.rightchild.value					
				#update UB
				tree.UB = -1e6
				for node in tree.leafnode:
					if node.value > tree.UB:
						tree.UB = node.value

			if tree.UB == tree.LB:
				temp_LB += tree.UB
				break

		#get dual function in each leaf node
		for leaf in range(len(tree.leafnode)):
			tree.leafnode[leaf].get_dual()

		#solve cglp
		cg.nnodes.value = len(tree.leafnode)
		cur_cglp = cg.create_instance('cglp.dat')

		#update dual function
		for q in range(len(tree.leafnode)):
			for j in range(4):
				cur_cglp.gamma[q+1,j+1].value = tree.leafnode[q].gamma[j]
			cur_cglp.v[q+1].value = tree.leafnode[q].v - yitaL[s-1]
		
		#previous iteration information
		cur_cglp.mu.value = yita[s-1].value - yitaL[s-1] 
		temp = []
		for i in m.Investments:
			temp.append(m.x[i].value)
		for i in m.Investments:
			temp.append(m.y[i].value)
		for i in range(8):
			cur_cglp.x[i+1].value = temp[i]
		
		opt.solve(cur_cglp)



		#add cuts to master problem
		cut = 0
		cut += (yita[s-1] - yitaL[s-1]) * cur_cglp.sigma0.value
		ii = 1
		for i in m.Investments:
			cut = cut + m.x[i] * cur_cglp.sigma[ii].value + m.y[i] * cur_cglp.sigma[ii+4].value
			ii +=1
		cut = cut - cur_cglp.zeta.value
		m.disjuntivecuts.add(cut<= 0)
	#update LB
	temp_LB = temp_LB * 0.5
	if temp_LB > MLB:
		MLB = temp_LB

	#update iter
	niter += 1












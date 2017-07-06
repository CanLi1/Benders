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
from SL import *

total_time = 0
copy_time = 0
master_solve_time = 0
cglp_solve_time = 0
benders_UB_time = 0
nlp_solve_time = 0
lagrangean_sub_time = 0
start = time.time()

opt = SolverFactory('cplex')
nopt = SolverFactory('baron')
nlpopt = SolverFactory('ipopt')
nopt.options['CplexLibName'] = "/opt/ibm/ILOG/CPLEX_Studio127/cplex/bin/x86-64_linux/libcplex1270.so"
model.disjuntivecuts = ConstraintList()
model.lagrangeancuts = ConstraintList()
m = model.create_instance('master.dat')
opt.solve(m)
sub.babcut = ConstraintList()



#scenario generation
num_scenarios = len(m.W)
scenario_instances = generate_scenario(sub)
binary_scenario_instances = generate_scenario(subb)
yita = generate_sub_obj(m)
#if using nlp relaxation of benders------------------------------------------
for s in range(num_scenarios):
	scenario_instances[s].dual= Suffix(direction=Suffix.IMPORT)
#if using nlp relaxation of benders------------------------------------------

#initialize the multiplier of the NAC 
#the NAC is this problem is written as x1=x2, x1=x3, x1=x4 ...
num_scenarios = len(m.W)
mu_x = []
mu_EX = []


for i in range(num_scenarios-1):
	mu_x.append({})
	mu_EX.append({})
	for index in m.JP:
		mu_x[i][index] = 0
		mu_EX[i][index] = 0


#Lagrangean loops
MUB = 1e10
MLB = 17500000
BenderLB = []
BenderUB = []
LagrangeanLB = []
theta = 0.2
niter = 1 
max_branch = 10

while MUB > MLB:
	ta = time.time()
	opt.solve(m)
	m.display()
	tb = time.time()
	master_solve_time += tb - ta
	BenderLB.append(m.obj.value)
	if MLB < m.obj.value:
		MLB = m.obj.value 
	if MUB < MLB + 1e-3 or niter >=30:
		# m.display()
		# print "terminate normally in " + str(niter) + " iterations"
		break
	temp_UB = m.f1.value

	#Benders subproblem get UB and Benders cut 
	for s in range(num_scenarios):
		#solve the binary subproblem using cplex to get upper bound
		get_master_value(binary_scenario_instances[s], m)
		ta = time.time()
		nopt.solve(binary_scenario_instances[s],tee=True)
		tb = time.time()
		benders_UB_time += tb - ta 
		temp_UB += binary_scenario_instances[s].obj.value 
		#get benders cut by solving nlp relaxation-------------------
		ta = time.time()
		get_master_value(scenario_instances[s], m)
		nlpopt.solve(scenario_instances[s], tee=True)
		tb = time.time()
		nlp_solve_time += tb - ta 
		cut = m.Cost[s+1]
		for index in m.JP:
			cut += scenario_instances[s].dual[scenario_instances[s].c01C[index]] * scenario_instances[s].x[index].value
			cut += scenario_instances[s].dual[scenario_instances[s].c02C[index]] * scenario_instances[s].EX[index].value
			cut -= scenario_instances[s].dual[scenario_instances[s].c01C[index]] * m.x[index]
			cut -= scenario_instances[s].dual[scenario_instances[s].c02C[index]] * m.EX[index]
		cut -= scenario_instances[s].obj.value 
		print cut.to_string()
		m.disjuntivecuts.add(cut >=0 )
		#done geting benders cut by solving nlp relaxation------------------




		
	
	#update UB
	BenderUB.append(temp_UB)
	if temp_UB < MUB:
		MUB = temp_UB


	#start updating Lagrangean----------------------------------------------------------
	#temp_LB accumulate the objective value of Lagrangean subproblem
	temp_LB = 0
	#solve lagrangean subproblem
	lagrangean_sub = []
	for s in range(num_scenarios):
		#set multiplier value
		pix_s = {}
		piEX_s = {}
		if s == 0:
			for index in m.JP:
				pix_s[index] = 0
				piEX_s[index] =0
				for ss in range(num_scenarios-1):
					pix_s[index] += mu_x[ss][index]
					piEX_s[index] += mu_EX[ss][index]

		else:
			for index in m.JP:
				pix_s[index] = -mu_x[ss-1][index]
				piEX_s[index] = -mu_EX[ss-1][index]

		#generate Lagrangean subproblem
		lagrangean_sub.append(generate_scenario_lag(sl, s, pix_s, piEX_s))

		#solve
		ta = time.time()
		nopt.solve(lagrangean_sub[s])
		tb = time.time()
		lagrangean_sub_time += tb - ta

		lagrangean_sub[s].display()
		#update temp_LB
		temp_LB += lagrangean_sub[s].obj.value 

		#add lagrangean cut to Benders master problem
		cut = lagrangean_sub[s].obj.value 
		for index in m.JP:
			cut -= m.x[index] * pix_s[index]
			cut -= m.EX[index] * piEX_s[index]
		cut -= m.theta[s+1]
		print cut.to_string()
		m.lagrangeancuts.add(cut <= 0)


	#update lower bound using Lagrangean subproblem
	LagrangeanLB.append(temp_LB)
	if temp_LB > MLB:
		MLB = temp_LB

	#update lagrangean multiplier using subgradient method
	denominator = 0
	for s in range(num_scenarios-1):
		for index in m.JP:
			denominator += (lagrangean_sub[0].x[index].value-lagrangean_sub[s+1].x[index].value)**2 \
			+(lagrangean_sub[0].EX[index].value - lagrangean_sub[s+1].EX[index].value)**2

	step_size = theta * (MUB - MLB)/ denominator
	for s in range(num_scenarios-1):
		for index in m.JP:
			mu_x[s][index] += step_size * (lagrangean_sub[0].x[index].value - lagrangean_sub[s+1].x[index].value)
			mu_EX[s][index] += step_size *(lagrangean_sub[0].EX[index].value - lagrangean_sub[s+1].EX[index].value)

	#update theta
	if niter > 1:
		change = (LagrangeanLB[niter-1] - LagrangeanLB[niter-2]) / LagrangeanLB[niter-2]
		if change < 0.1:
			theta = 0.85 * theta
	#update iter
	niter += 1
	print "upper bound", MUB, " lower bound ", MLB


end = time.time()
print "total_solution_time ", end-start
print "cglp_time ", cglp_solve_time
print "master_solve_time ", master_solve_time
print "baron_solve_time ", benders_UB_time
print "nlp_solve_time ", nlp_solve_time
print "copy_time ", copy_time
print "lagrangean_sub_time", lagrangean_sub_time
print "BenderLB"
for item in BenderLB:
	print item
print "BenderUB"
for item in BenderUB:
	print item
print "LagrangeanLB"
for item in LagrangeanLB:
	print item 



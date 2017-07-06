#this file is designed for minimization problem
#all the constraint in the master problem should be written as Ax >= b 
from pyomo.environ import *
from pyomo.opt import *
from pyomo.core import Constraint
from subproblem import *
from master import *
from binary_sub import *
import time 
from SL import *
from scenario_generator import * 
from link import *
from copy import deepcopy

total_time = 0
master_solve_time = 0
benders_UB_time = 0
lp_solve_time = 0
lagrangean_sub_time = 0
start = time.time()

opt = SolverFactory('cplex')
nopt = SolverFactory('baron')
nopt.options['CplexLibName'] = "/opt/ibm/ILOG/CPLy_Studio127/cplex/bin/x86-64_linux/libcplex1270.so"
model.benderscuts = ConstraintList()
model.lagrangeancuts = ConstraintList()
m = model.create_instance()





#scenario generation
num_scenarios = len(m.s)
scenario_instances = generate_scenario(sub)
binary_scenario_instances = generate_scenario(subb)
lagrangean_sub = generate_scenario(sl)
theta = generate_sub_obj(m)
prob = [0.25, 0.5, 0.25]
#if using nlp relaxation of benders------------------------------------------
for s in range(num_scenarios):
	scenario_instances[s].dual= Suffix(direction=Suffix.IMPORT)
#if using nlp relaxation of benders------------------------------------------

#initialize the multiplier of the NAC 
#the NAC is this problem is written as x1=x2, x1=x3, x1=x4 ...
mu_x = []
mu_y = []
#multiplier in the previos iteration
prev_mux = []
prev_muy = []


for i in range(num_scenarios-1):
	mu_x.append(0)
	mu_y.append(0)



#Lagrangean loops
MUB = -10
MLB = -1e5
BenderLB = []
BenderUB = []
LagrangeanLB = []
theta = 2
niter = 1 


while MUB > MLB:
	#start updating Lagrangean----------------------------------------------------------
	#temp_LB accumulate the objective value of Lagrangean subproblem
	temp_LB = 0
	#solve lagrangean subproblem
	for s in range(num_scenarios):
		#set multiplier value
		if s == 0:
			lagrangean_sub[s].pix.value = 0
			lagrangean_sub[s].piy.value =0
			for ss in range(num_scenarios-1):
				lagrangean_sub[s].pix.value += mu_x[ss]
				lagrangean_sub[s].piy.value += mu_y[ss]

		else:
			lagrangean_sub[s].pix.value = -mu_x[s-1]
			lagrangean_sub[s].piy.value = -mu_y[s-1]
		

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
		cut -= m.x * lagrangean_sub[s].pix.value
		cut -= m.y * lagrangean_sub[s].piy.value 
		cut -= m.theta[s+1]
		print "lagrangean cuts", cut.to_string()
		m.lagrangeancuts.add(cut <= 0)


	#update lower bound using Lagrangean subproblem
	LagrangeanLB.append(temp_LB)
	if temp_LB > MLB:
		MLB = temp_LB

	#update theta
	if niter > 1:
		change = (LagrangeanLB[niter-1] - LagrangeanLB[niter-2]) / LagrangeanLB[niter-2]
		if change < 0:
			theta = 0.5 * theta


	#update lagrangean multiplier using subgradient method
	denominator = 0
	for s in range(num_scenarios-1):
		denominator += (lagrangean_sub[0].x.value-lagrangean_sub[s+1].x.value)**2 \
			+(lagrangean_sub[0].y.value - lagrangean_sub[s+1].y.value)**2

	step_size = theta * (MUB - MLB)/ denominator
	for s in range(num_scenarios-1):
		mu_x[s] += step_size * (lagrangean_sub[0].x.value - lagrangean_sub[s+1].x.value)
		mu_y[s] += step_size *(lagrangean_sub[0].y.value - lagrangean_sub[s+1].y.value)


	ta = time.time()
	opt.solve(m)
	m.display()
	tb = time.time()
	master_solve_time += tb - ta
	BenderLB.append(m.obj.value)
	if MLB < m.obj.value:
		MLB = m.obj.value 
	if abs(MUB-MLB)/abs(MLB) < 0.01 or niter >=30:
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
		opt.solve(scenario_instances[s], tee=True)
		scenario_instances[s].display()
		tb = time.time()
		lp_solve_time += tb - ta 
		cut = m.theta[s+1]
		cut += scenario_instances[s].dual[scenario_instances[s].c01C] * scenario_instances[s].x.value
		cut += scenario_instances[s].dual[scenario_instances[s].c02C] * scenario_instances[s].y.value
		cut -= scenario_instances[s].dual[scenario_instances[s].c01C] * m.x
		cut -= scenario_instances[s].dual[scenario_instances[s].c02C] * m.y
		cut -= scenario_instances[s].obj.value 
		cut -= prob[s] * (5 * m.x + 7 * m.y)
		print "Benders cuts", cut.to_string()
		m.benderscuts.add(cut >=0 )
		#done geting benders cut by solving nlp relaxation------------------




		
	
	#update UB
	BenderUB.append(temp_UB)
	if temp_UB < MUB:
		MUB = temp_UB


	
	#update iter
	niter += 1
	print "upper bound", MUB, " lower bound ", MLB


end = time.time()
print "total_solution_time ", end-start
print "master_solve_time ", master_solve_time
print "baron_solve_time ", benders_UB_time
print "lp_solve_time ", lp_solve_time
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



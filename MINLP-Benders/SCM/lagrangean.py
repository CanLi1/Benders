#this file implement the cross decomposition algorithm
from pyomo.environ import *
from pyomo.opt import *
from pyomo.core import Constraint
from master import *
from SL import *
from scenario_generator import *
from binary_sub import *
from link import *

opt = SolverFactory("baron")
opt.options['CplexLibName'] = "/opt/ibm/ILOG/CPLEX_Studio127/cplex/bin/x86-64_linux/libcplex1270.so"
mipopt = SolverFactory("cplex")
nlpopt = SolverFactory("ipopt")

#initialize benders master problem 
model.lagrangeancuts = ConstraintList()
m = model.create_instance('master.dat')

#generate Benders subproblem
binary_scenario_instances = generate_scenario(subb)

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
while MLB < MUB:
	#solve Benders master problem again
	mipopt.solve(m,tee=True)
	m.display()

	#get upper bound by fixing the first stage variables
	temp_UB = m.f1.value
	for s in range(num_scenarios):
		get_master_value(binary_scenario_instances[s], m)
		opt.solve(binary_scenario_instances[s],tee=True)
		temp_UB += binary_scenario_instances[s].obj.value 
	#update UB
	BenderUB.append(temp_UB)
	if temp_UB < MUB:
		MUB = temp_UB

	#update LB with Benders master problem 
	BenderLB.append(m.obj.value)
	if m.obj.value > MLB:
		MLB = m.obj.value 

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
		opt.solve(lagrangean_sub[s],tee=True)
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
	if niter >=30:
		break
	niter += 1


print "BenderLB"
for item in BenderLB:
	print item
print "LagrangeanLB"
for item in LagrangeanLB:
	print item
print "BenderUB"
for item in BenderUB:
	print item 














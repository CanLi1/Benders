#generate scenarios 
def generate_scenario(sub):
	scenario_instances = []
	cus = 12
	prod = 4
	prod_cus = []
	for i in range(prod):
		prod_cus.append([]) 
		for j in range(cus):
			prod_cus[i].append(0)
	prod_cus[0][0]=1000
	prod_cus[0][2]=2000
	prod_cus[0][3]=1200
	prod_cus[0][5]=2400
	prod_cus[0][8]=1000
	prod_cus[0][10]=1000
	prod_cus[0][11]=1200
	prod_cus[1][0]=1000
	prod_cus[1][2]=1500
	prod_cus[1][3]=1500
	prod_cus[1][4]=2000
	prod_cus[1][5]=500
	prod_cus[1][7]=1000
	prod_cus[1][8]=1500
	prod_cus[1][9]=1000
	prod_cus[1][10]=1000
	prod_cus[1][11]=2000
	prod_cus[2][1]=1000
	prod_cus[2][2]=800
	prod_cus[2][3]=800
	prod_cus[2][5]=500
	prod_cus[2][6]=2000
	prod_cus[2][7]=1000
	prod_cus[2][10]=1000
	prod_cus[2][11]=1500
	prod_cus[3][1]=500
	prod_cus[3][2]=800
	prod_cus[3][3]=500
	prod_cus[3][4]=1000
	prod_cus[3][8]=800
	prod_cus[3][9]=800
	prod_cus[3][10]=500
	prod_cus[3][11]=1000

	ratio = [0.3, 0, -0.3]
	p = [0.25, 0.5, 0.25 ]
	for s in range(3):
		new_instance = sub.create_instance('sub.dat')
		for c in range(12):
			for j in range(4):
				d = prod_cus[j][c] + prod_cus[j][c] * ratio[s]
				new_instance.D[j+1,c+1].value = d 
		new_instance.p.value = p[s]

		scenario_instances.append(new_instance)
	return scenario_instances

import os
def generate_scenario_lag(sl, s, pix, piEX):
	cus = 12
	prod = 4
	prod_cus = []
	for i in range(prod):
		prod_cus.append([]) 
		for j in range(cus):
			prod_cus[i].append(0)
	prod_cus[0][0]=1000
	prod_cus[0][2]=2000
	prod_cus[0][3]=1200
	prod_cus[0][5]=2400
	prod_cus[0][8]=1000
	prod_cus[0][10]=1000
	prod_cus[0][11]=1200
	prod_cus[1][0]=1000
	prod_cus[1][2]=1500
	prod_cus[1][3]=1500
	prod_cus[1][4]=2000
	prod_cus[1][5]=500
	prod_cus[1][7]=1000
	prod_cus[1][8]=1500
	prod_cus[1][9]=1000
	prod_cus[1][10]=1000
	prod_cus[1][11]=2000
	prod_cus[2][1]=1000
	prod_cus[2][2]=800
	prod_cus[2][3]=800
	prod_cus[2][5]=500
	prod_cus[2][6]=2000
	prod_cus[2][7]=1000
	prod_cus[2][10]=1000
	prod_cus[2][11]=1500
	prod_cus[3][1]=500
	prod_cus[3][2]=800
	prod_cus[3][3]=500
	prod_cus[3][4]=1000
	prod_cus[3][8]=800
	prod_cus[3][9]=800
	prod_cus[3][10]=500
	prod_cus[3][11]=1000

	ratio = [0.3, 0, -0.3]
	p = [0.25, 0.5, 0.25 ]
	os.system("cat lag_temp.dat > lag.dat")
	lag = open("lag.dat", "a")
	lag.write("param D :=\n")
	for c in range(12):
		for j in range(4):
			lag.write(str(j+1) + " " + str(c+1) + " " + str(prod_cus[j][c] + prod_cus[j][c] * ratio[s]) + "\n")
	lag.write(";\n")
	lag.write("param p :=" + str(p[s]) + ";\n")
	lag.write("param pix :=")
	for index in pix:
		lag.write(str(index[0]) + " " + str(index[1]) + " " + str(pix[index]) + "\n")
	lag.write(";\n")
	lag.write("param piEX :=")
	for index in piEX:
		lag.write(str(index[0]) + " " + str(index[1]) + " " + str(piEX[index]) + "\n")
	lag.write(";")
	lag.close()
	instance = sl.create_instance("lag.dat")
	return instance

def generate_sub_obj(m):
	sub_obj = []
	Cost = getattr(m, "Cost")
	for index in Cost:
		print index
		sub_obj.append(Cost[index])
	return sub_obj


#generate scenarios for the demand
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
#write demand 
demand = open("demand.dat", "w")
demand.write("param d:=\n")
ratio = [0.3, 0, -0.3]
for s in range(3):
	for c in range(12):
		for j in range(4):
			d = prod_cus[j][c] + prod_cus[j][c] * ratio[s]
			demand.write(str(j+1) + " " + str(c+1) + " " + str(s+1) + " " + str(d) + "\n")
demand.write(";")

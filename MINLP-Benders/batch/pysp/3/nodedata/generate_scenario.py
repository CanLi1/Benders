baseQ = [250000, 150000, 180000, 160000, 120000]
prob = [1.1, 1, 0.9]

for i1 in range(3):
	d = open("Node" + str(i1+1) + ".dat", "w")
	d.write("param Q :=\n")
	for j in range(5):
		d.write(str(j+1) + " " + str(baseQ[j]*prob[i1]) + "\n")
	d.write(";")
	d.close()

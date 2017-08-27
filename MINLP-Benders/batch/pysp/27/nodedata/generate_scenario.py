baseQ = [250000, 150000, 180000, 160000, 120000]
prob = [1.1, 1, 0.9]

for i1 in range(3):
	for i2 in range(3):
		for i3 in range(3):
			node = i1 + 3 * i2 + 9*i3 +1
			d = open("Node" + str(node) + ".dat", "w")
			d.write("param Q :=\n")
			d.write(  "1 " + str(baseQ[0]*prob[i1]) + "\n")
			d.write(  "2 " + str(baseQ[1]*prob[i2]) + "\n")
			d.write(  "3 " + str(baseQ[2]*prob[i3]) + "\n")
			d.write(  "4 " + str(baseQ[3]*prob[i3]) + "\n")
			d.write(  "5 " + str(baseQ[4]*prob[i3]) + "\n")
			d.write(";")
			d.close()

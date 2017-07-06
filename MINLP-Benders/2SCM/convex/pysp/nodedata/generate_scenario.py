D = {}
for i in range(4):
	D[i+1] = {}
D[1][3]=100
D[1][5]=5
D[2][3]=50
D[2][5]=3
D[3][3]=150
D[3][5]=2.5
D[4][3]=80
D[4][5]=2
node = open("AboveAverageNode.dat", "w")
node.write("param D :=\n")
for key in D:
	for key2 in D[key]:
		node.write(str(key) + " " + str(key2) + " " + str(D[key][key2]*1.3) + "\n")
node.write(";")
node.close()

node = open("AverageNode.dat", "w")
node.write("param D :=\n")
for key in D:
	for key2 in D[key]:
		node.write(str(key) + " " + str(key2) + " " + str(D[key][key2]) + "\n")
node.write(";")
node.close()

node = open("BelowAverageNode.dat", "w")
node.write("param D :=\n")
for key in D:
	for key2 in D[key]:
		node.write(str(key) + " " + str(key2) + " " + str(D[key][key2]*0.7) + "\n")
node.write(";")
node.close()
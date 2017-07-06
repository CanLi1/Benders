# structure = open("ScenarioStructure.dat", "w")
# structure.write("set Stages := FirstStage SecondStage ;\n\nset Nodes := RootNode \n")
# for i in range(256):
# 	structure.write("Node" + str(i+1) + "\n")
# structure.write(";\nparam NodeStage := RootNode         FirstStage\n")
# for i in range(256):
# 	structure.write("Node" + str(i+1) + " SecondStage\n")
# structure.write(";\n\nset Children[RootNode] := ")
# for i in range(256):
# 	structure.write("Node" + str(i+1) + "\n")
# structure.write(";\n\nparam ConditionalProbability := RootNode          1.0\n")
# for i in range(256):
# 	structure.write("Node" + str(i+1) + " 0.00390625" +"\n")
# structure.write(";\n\nset Scenarios :=")
# for i in range(256):
# 	structure.write("Scenario" + str(i+1) + "\n")
# structure.write(";\n\nparam ScenarioLeafNode :=")
# for i in range(256):
# 	structure.write("Scenario" + str(i+1) + " " + "Node" + str(i+1) + "\n")
# structure.write(";\n")
# structure.close()


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
for i0 in range(2):
	for i1 in range(2):
		for i2 in range(2):
			for i3 in range(2):
				for i4 in range(2):
					for i5 in range(2):
						for i6 in range(2):
							for i7 in range(2):
								num=2**0*i0+2**1*i1+2**2*i2+2**3*i3+2**4*i4+2**5*i5+2**6*i6+2**7*i7+1
								d = open("Node"+str(num) + ".dat", "w")
								d.write("param D :=\n")
								d.write("1 3 " + str(D[1][3]* (1+(i0-0.5)*2/3)) + "\n")
								d.write("1 5 " + str(D[1][5]* (1+(i1-0.5)*2/3) )+ "\n")
								d.write("2 3 " + str(D[2][3]* (1+(i2-0.5)*2/3)) + "\n")
								d.write("2 5 " + str(D[2][5]* (1+(i3-0.5)*2/3)) + "\n")
								d.write("3 3 " + str(D[3][3]* (1+(i4-0.5)*2/3)) + "\n")
								d.write("3 5 " + str(D[3][5]* (1+(i5-0.5)*2/3) )+ "\n")
								d.write("4 3 " + str(D[4][3]* (1+(i6-0.5)*2/3) )+ "\n")
								d.write("4 5 " + str(D[4][5]* (1+(i7-0.5)*2/3)) + "\n")
								d.write(";")
								d.close()

























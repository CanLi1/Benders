structure = open("temp", "w")
prob = [0.3, 0.4, 0.3]
structure.write("set Stages := FirstStage SecondStage ;\n\nset Nodes := RootNode \n")
for i in range(27):
	structure.write("Node" + str(i+1) + "\n")
structure.write(";\nparam NodeStage := RootNode         FirstStage\n")
for i in range(27):
	structure.write("Node" + str(i+1) + " SecondStage\n")
structure.write(";\n\nset Children[RootNode] := ")
for i in range(27):
	structure.write("Node" + str(i+1) + "\n")
structure.write(";\n\nparam ConditionalProbability := RootNode          1.0\n")
for i1 in range(3):
	for i2 in range(3):
		for i3 in range(3):
			node = i1 + 3 * i2 + 9*i3 +1
			newprob = prob[i1] * prob[i2] * prob[i3]
			structure.write("Node" + str(node) + " "+str(newprob) +"\n")
structure.write(";\n\nset Scenarios :=")
for i in range(27):
	structure.write("Scenario" + str(i+1) + "\n")
structure.write(";\n\nparam ScenarioLeafNode :=")
for i in range(27):
	structure.write("Scenario" + str(i+1) + " " + "Node" + str(i+1) + "\n")
structure.write(";\n")
structure.close()
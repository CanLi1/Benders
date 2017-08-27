structure = open("temp", "w")
prob = [0.3, 0.4, 0.3]
structure.write("set Stages := FirstStage SecondStage ;\n\nset Nodes := RootNode \n")
for i in range(3):
	structure.write("Node" + str(i+1) + "\n")
structure.write(";\nparam NodeStage := RootNode         FirstStage\n")
for i in range(3):
	structure.write("Node" + str(i+1) + " SecondStage\n")
structure.write(";\n\nset Children[RootNode] := ")
for i in range(3):
	structure.write("Node" + str(i+1) + "\n")
structure.write(";\n\nparam ConditionalProbability := RootNode          1.0\n")
for i in range(3):
	structure.write("Node" + str(i+1) + " "+str(prob[i]) +"\n")
structure.write(";\n\nset Scenarios :=")
for i in range(3):
	structure.write("Scenario" + str(i+1) + "\n")
structure.write(";\n\nparam ScenarioLeafNode :=")
for i in range(3):
	structure.write("Scenario" + str(i+1) + " " + "Node" + str(i+1) + "\n")
structure.write(";\n")
structure.close()
b = range(4)
a = range(4)
b[0]= 0.1
b[1]= 0.09
b[2]= 0.11
b[3]= 0.08

a[0]= 20
a[1]= 10
a[2]= 15
a[3]= 30
sufix  = open("wwph.suffixes", "w")
sufix.write("RootNode:\n")
for i in range(3):
	for j in range(4):
		sufix.write("  x[" + str(i+1) + "," + str(j+1) + "]:\n")
		sufix.write("    CostForRho: " + str(a[j]) + "\n")
for i in range(3):
	for j in range(4):
		sufix.write("  Q[" + str(i+1) + "," + str(j+1) + "]:\n")
		sufix.write("    CostForRho: " + str(b[j]) + "\n")
for i in range(3):
	for j in range(4):
		sufix.write("  QE[" + str(i+1) + "," + str(j+1) + "]:\n")
		sufix.write("    CostForRho: " + str(b[j]) + "\n")
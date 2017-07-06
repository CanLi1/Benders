a = open("temp", "w")
a.write("alias (")
for i in range(12):
	a.write("sub" + str(i)+ ",")
a.write(")\n")
for i in range(12):
	a.write( " " * i + "loop(sub" + str(i) + ",\n")


for i in  range(12):
	a.write(" " * (11-i) + ");\n")

for i in range(12):
	a.write(str(3**i) + "*(ord(sub" + str(i) + ")-1)+" )
a.write("\n")
for i in range(12):
	a.write(" " * 12 + "D(j,'C" + str(i+1)  + "', w )= tempD(j,'C" + str(i+1)  + "','2')*(1 + (ord(sub" + str(i) + ")-1.5)/2);\n")
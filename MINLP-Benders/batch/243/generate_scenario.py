a = open("temp", "w")
a.write("alias (")
for i in range(5):
	a.write("sub" + str(i)+ ",")
a.write(")\n")
for i in range(5):
	a.write( " " * i + "loop(sub" + str(i) + ",\n")


for i in  range(5):
	a.write(" " * (4-i) + ");\n")

for i in range(5):
	a.write(str(3**i) + "*(ord(sub" + str(i) + ")-1)+" )
a.write("\n")
for i in range(5):
	a.write(" " * 5 + "Q('i" + str(i+1)  + "', num )= baseQ('i" + str(i+1)  + "')*(1 + (ord(sub" + str(i) + ")-2)/10);\n")
a = open("temp", "w")
for i in range(8):
	a.write("\t" * i + "for i" + str(i) + " in range(2):\n")
a.write("\t"*8 + "num=")
for i in range(8):
	a.write("2**" + str(i)+"*i" + str(i) + "+")
a.write("1\n")
a.write("\t"*8 + 'd = open("Node"+str(num), "w")\n')



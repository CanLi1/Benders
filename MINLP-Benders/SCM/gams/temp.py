a = open("temp", "r").readlines()
for line in a:
	line.strip()
	linelist = line.split(",")
	for sub in linelist:
		print sub.replace("    ","")
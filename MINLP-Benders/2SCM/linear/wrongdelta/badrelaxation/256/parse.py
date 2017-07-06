a = open("obj", "r").readlines()
for line in a:
	if ',' in list(line):
		for item in line.split(','):
			print item 

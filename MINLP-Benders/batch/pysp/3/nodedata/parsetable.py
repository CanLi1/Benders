table = open("temp", "r").readlines()
count = 1
for line in table:
	entry = 0
	for item in  line.split():
		if entry != 0:
			print count, " ", entry, " ", item
		entry += 1
	count += 1
for i in range(8):
	if i % 2 == 0:
		print "D('c" + str(i/2 + 1) + "','j3',w)= baseD('c" + str(i/2+1) + "', 'j3')*(1 + (ord(sub"+ str(i) + ")-1.5)*2/3);"
	else:
		print "D('c" + str(i/2 + 1) + "','j5',w)= baseD('c" + str(i/2+1) + "', 'j5')*(1 + (ord(sub"+ str(i) + ")-1.5)*2/3);" 
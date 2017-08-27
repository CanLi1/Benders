sufix  = open("wwph.suffixes", "w")
sufix.write("RootNode:\n")
for i in range(6):
	sufix.write("  StageoneCost[" + str(i+1)  + "]:\n")
	sufix.write("    CostForRho: 250\n")
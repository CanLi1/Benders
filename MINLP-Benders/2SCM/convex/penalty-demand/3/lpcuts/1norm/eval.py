import os
lb = os.popen('grep "PARAMETER LB " *').readlines()
ub = os.popen('grep "PARAMETER UB " *').readlines()
file = []
lb_value=[]
ub_value=[]
for line in lb:
    if "lst" in line:
        lb_value.append(line.split("=")[1].replace(" ", ""))
        file.append(line.split(":")[0])

for line in ub:
    if "lst" in line:
        ub_value.append(line.split("=")[1].replace(" ", ""))

bound = open("bound", "w")
bound.write("file lb ub gap\n")
for i in range(len(file)):
    bound.write(file[i].strip() + " ")
    bound.write(lb_value[i].strip() + " ")
    bound.write(ub_value[i].strip() + " ")
    bound.write(str((float(ub_value[i])-float(lb_value[i]))/float(lb_value[i])*100)+"%\n")
bound.close()

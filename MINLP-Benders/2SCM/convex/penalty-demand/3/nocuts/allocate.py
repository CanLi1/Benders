import os
theta = ['0.5','1','1.5','2','0.2','3']
half = ['0.5','0.8','0.6'];
count =len(theta)*len(half)
for i in range(count):
    os.system('cp sample0.gms sample' + str(i+1) + '.gms')
c = 1
for i in theta:
    for j in half:
        os.system('sed -i "s/theta0\ \/1.5\//theta0\ \/' + i + '\//g" sample'+str(c)+".gms")
        os.system('sed -i "s/half0\ \/0.5\//half0\ \/' + j + '\//g" sample' + str(c) + ".gms")
        c = c+1

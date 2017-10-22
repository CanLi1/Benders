import os
for i in range(18):
    j=i+1
    a=open("parallel.sh", "w")
    a.write("#!/bin/sh\n\n# Set the number of nodes and processes per node\n#PBS -l nodes=1:ppn=12\n\n\n# Set max wallclock time\n#PBS -l walltime=48:00:00\n\n# Set maximum memory\n#PBS -l mem=64gb\n\n# Set name of job\n#PBS -N Job1\n\n# Use submission environment\n#PBS -V\n")
    a.write("cd "+os.getcwd() +"\n")
    a.write("gams sample"+str(j)+".gms"+" -lo=4 ")
    a.close()
    os.system("qsub parallel.sh")

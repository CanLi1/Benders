#!/bin/sh

# Set the number of nodes and processes per node
#PBS -l nodes=1:ppn=12

# Set max wallclock time
#PBS -l walltime=24:00:00

# Set maximum memory
#PBS -l mem=64gb

# Set name of job
#PBS -N Job1

# Use submission environment
#PBS -V

cd /home/canl1/work/Benders/MINLP-Benders/batch/pysp/81 
  mpiexec \
-np 1 pyomo_ns : \
-np 1 dispatch_srvr : \
-np 10 phsolverserver : \
-np 1  runph --model-directory=models --instance-directory=nodedata \
-k --traceback --enable-ww-extensions --max-iterations=2\
  --solver=baron --scenario-solver-options="CplexLibName=/opt/ibm/ILOG/CPLEX_Studio127/cplex/bin/x86-64_linux/libcplex1270.so" \
  --output-solver-logs  --default-rho=1 \
 --ww-extension-cfgfile=config/wwph.cfg --solver-manager=phpyro\
 --ww-extension-suffixfile=config/wwph.suffixes --linearize-nonbinary-penalty-terms=7 > out-baron.log

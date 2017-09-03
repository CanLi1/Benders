#!/bin/sh

# Set the number of nodes and processes per node
#PBS -l nodes=1:ppn=3

# Set max wallclock time
#PBS -l walltime=48:00:00

# Set maximum memory
#PBS -l mem=64gb

# Set name of job
#PBS -N Job1

# Use submission environment
#PBS -V

cd /home/canl1/work/Benders/MINLP-Benders/2SCM/convex/penalty-demand/3/nocuts
gams sample0.gms -lo=4 


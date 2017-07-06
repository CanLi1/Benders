#!/bin/sh

# Set the number of nodes and processes per node
#PBS -l nodes=1:ppn=3

# Set max wallclock time
#PBS -l walltime=24:00:00

# Set maximum memory
#PBS -l mem=12gb

# Set name of job
#PBS -N Job1

# Use submission environment
#PBS -V

cd ~/work/MINLP-Benders/2SCM/convex/bundle/3/weighted
gams samplecross.gms lo=4 

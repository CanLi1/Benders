runef --model-directory=models --instance-directory=nodedata \
 --traceback --solve  --solver=baron --solver-options="CplexLibName=/opt/ibm/ILOG/CPLEX_Studio127/cplex/bin/x86-64_linux/libcplex1270.so" \
--solver-options="maxTimeLimit=10000"  --keep-solver-files --output-solver-log> fullspacebaron.log

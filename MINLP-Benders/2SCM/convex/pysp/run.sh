  mpiexec \
-np 1 pyomo_ns : \
-np 1 dispatch_srvr : \
-np 3 phsolverserver : \
-np 1 runph --model-directory=models --instance-directory=nodedata \
--traceback --enable-ww-extensions --max-iterations=30\
  --solver=baron --scenario-solver-options="CplexLibName=/opt/ibm/ILOG/CPLEX_Studio127/cplex/bin/x86-64_linux/libcplex1270.so" \
 --scenario-solver-options="MaxTime=600" --output-solver-logs  --default-rho=1 \
 --ww-extension-cfgfile=config/wwph.cfg --solver-manager=phpyro\
 --ww-extension-suffixfile=config/wwph.suffixes --linearize-nonbinary-penalty-terms=7 >output3.log
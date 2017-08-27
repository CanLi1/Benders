runph --model-directory=models --instance-directory=nodedata \
--traceback --enable-ww-extensions --max-iterations=10\
  --solver=baron --scenario-solver-options="CplexLibName=/opt/ibm/ILOG/CPLEX_Studio127/cplex/bin/x86-64_linux/libcplex1270.so" \
  --scenario-solver-options="MaxTime=600" --output-solver-logs  --default-rho=1 \
 --ww-extension-cfgfile=config/wwph.cfg \
 --ww-extension-suffixfile=config/wwph.suffixes --linearize-nonbinary-penalty-terms=7 > out-baron.log

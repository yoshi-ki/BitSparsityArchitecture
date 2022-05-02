xvlog --sv PE_test.sv PE.sv CreateOneHotVector.sv CreateHistoGram.sv ReductionInPE.sv
xelab -debug typical Test_PE -s PETest.sim
xsim --runall PETest.sim
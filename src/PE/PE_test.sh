xvlog --sv PE_test.sv PE.sv NBitAdder.sv
xelab -debug typical Test_PE -s PETest.sim
xsim --runall PETest.sim
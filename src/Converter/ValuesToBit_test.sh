xvlog --sv ValuesToBit_test.sv ValuesToBit.sv
xelab -debug typical Test_ValuesToBit -s ValuesToBit.sim
xsim --runall ValuesToBit.sim
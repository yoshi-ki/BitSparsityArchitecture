xvlog --sv NBitAdder_test.sv NBitAdder.sv
xelab -debug typical Test_NBitAdder -s NBitAdderTest.sim
xsim --runall NBitAdderTest.sim
xvlog --sv CreateHistoGram_test.sv CreateHistoGram.sv
xelab -debug typical Test_CreateHistoGram -s CreateHistoGram.sim
xsim --runall CreateHistoGram.sim
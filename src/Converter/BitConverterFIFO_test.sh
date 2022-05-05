xvlog --sv BitConverterFIFO_test.sv BitConverterFIFO.sv FIFO.sv
xelab -debug typical Test_BitConverterFIFO -s BitConverterFIFO.sim
xsim --runall BitConverterFIFO.sim
`timescale 1ns / 100ps
`default_nettype none
module Test_NBitAdder;
  // Inputs
  reg [2:0] input1;
  reg [2:0] input2;
  // Outputs
  wire [3:0] answer;

  // Instantiate the Unit Under Test (UUT)
  NBitAdder #(.bitsize(3))
  uut
  (
    .input1(input1),
    .input2(input2),
    .answer(answer)
  );

  // compute a + b
  int a;
  int b;
  int c;
  initial begin
    for (a = 0; a < 8; a++) begin
      for (b = 0; b < 8; b++) begin
        input1 = a[2:0];
        input2 = b[2:0];
        #100;
        $display("%02d", answer);
        c = a + b;
        assert(answer == c[3:0]);
      end
    end
  end

endmodule
`default_nettype wire
`timescale 1ns / 100ps
`default_nettype none

// exec cpu for test
module Test_ValuesToBit ();
  // input
  reg CLK;
  reg RSTN;
  reg [7:0] InputValue;
  reg [2:0] BitPlace;

  ValuesToBitConverter valuesToBitConverter(
    .CLK(CLK),
    .RSTN(RSTN),
    .InputValue(InputValue),
    .BitPlace(BitPlace)
  );

  // test program
  int i;
  initial begin
    CLK = 0;
    for (i = 0; i < 40; i++) begin
      if (i == 0 || i == 1) begin
        InputValue = 8'b00000011;
      end
      else if (i == 20 || i == 21) begin
        InputValue = 8'b11110111;
      end
      else begin
        InputValue = 8'b00000000;
      end
      #10000 CLK = ~CLK;
      if (i % 2 == 0) begin
        $display("%02d", BitPlace);
      end
    end
  end
endmodule
`default_nettype wire
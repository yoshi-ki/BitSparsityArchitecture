`timescale 1ns / 100ps
`default_nettype none

// exec cpu for test
module Test_PE ();
  // input
  reg CLK;
  reg RSTN;
  reg [15:0][2:0] AExps;
  reg [15:0] ASigns;
  reg [15:0][2:0] BExps;
  reg [15:0] BSigns;

  // output
  reg [15:0][3:0] RESULT;

  PE pe(
  .CLK(CLK),
  .RSTN(RSTN),
  .AExps(AExps),
  .ASigns(ASigns),
  .BExps(BExps),
  .BSigns(BSigns),
  .RESULT(RESULT)
  );

  // test program
  int i;
  int j;
  initial begin
    for (i = 0; i < 16; i++) begin
        CLK = 1'b0;
        RSTN = 1'b0;
        AExps[i] = i[2:0];
        ASigns[i] = 1'b0;
        BExps[i] = i[2:0];
        BSigns[i] = 1'b0;

        #100;
        $display("%02d", RESULT[i]);
    end
  end
endmodule
`default_nettype wire
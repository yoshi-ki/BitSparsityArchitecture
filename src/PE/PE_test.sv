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
  reg [15:0] IsInvalidPair;

  // output
  reg [21:0] RESULT;

  PE pe(
  .CLK(CLK),
  .RSTN(RSTN),
  .AExps(AExps),
  .ASigns(ASigns),
  .BExps(BExps),
  .BSigns(BSigns),
  .IsInvalidPair(IsInvalidPair),
  .RESULT(RESULT)
  );

  // test program
  int result1;
  int result2;
  int result3;
  int i;
  int j;
  initial begin
    CLK = 0;
    // 245 case
    IsInvalidPair[15:0] = 16'b0000000000000000;
    for (i = 0; i < 16; i++) begin
      if (i == 0) begin
        AExps[i] = 3'b010;
        ASigns[i] = 1'b0;
        BExps[i] = 3'b001;
        BSigns[i] = 1'b0;
      end
      else if (i == 1) begin
        AExps[i] = 3'b100;
        ASigns[i] = 1'b1;
        BExps[i] = 3'b001;
        BSigns[i] = 1'b0;
      end
      else if (i == 15) begin
        AExps[i] = 3'b100;
        ASigns[i] = 1'b1;
        BExps[i] = 3'b100;
        BSigns[i] = 1'b1;
      end
      else begin
        AExps[i] = 3'b000;
        ASigns[i] = 1'b0;
        BExps[i] = 3'b000;
        BSigns[i] = 1'b0;
      end
    end
    #10000 CLK = ~CLK;
    #10000 CLK = ~CLK;
    $display("%22b", RESULT);
    result1 = 245;
    assert (RESULT == result1[21:0]);

    // -267 case
    IsInvalidPair[15:0] = 16'b0000000000000000;
    for (i = 0; i < 16; i++) begin
      if (i == 0) begin
        AExps[i] = 3'b010;
        ASigns[i] = 1'b0;
        BExps[i] = 3'b001;
        BSigns[i] = 1'b0;
      end
      else if (i == 1) begin
        AExps[i] = 3'b100;
        ASigns[i] = 1'b1;
        BExps[i] = 3'b001;
        BSigns[i] = 1'b0;
      end
      else if (i == 15) begin
        AExps[i] = 3'b100;
        ASigns[i] = 1'b0;
        BExps[i] = 3'b100;
        BSigns[i] = 1'b1;
      end
      else begin
        AExps[i] = 3'b000;
        ASigns[i] = 1'b0;
        BExps[i] = 3'b000;
        BSigns[i] = 1'b0;
      end
    end
    #10000 CLK = ~CLK;
    #10000 CLK = ~CLK;
    $display("%22b", RESULT);
    result2 = -267 + 245;
    assert (RESULT == result2[21:0]);

    // 232 case
    IsInvalidPair[15:0] = 16'b0111111111111100;
    for (i = 0; i < 16; i++) begin
      if (i == 0) begin
        AExps[i] = 3'b010;
        ASigns[i] = 1'b0;
        BExps[i] = 3'b001;
        BSigns[i] = 1'b0;
      end
      else if (i == 1) begin
        AExps[i] = 3'b100;
        ASigns[i] = 1'b1;
        BExps[i] = 3'b001;
        BSigns[i] = 1'b0;
      end
      else if (i == 15) begin
        AExps[i] = 3'b100;
        ASigns[i] = 1'b1;
        BExps[i] = 3'b100;
        BSigns[i] = 1'b1;
      end
      else begin
        AExps[i] = 3'b000;
        ASigns[i] = 1'b0;
        BExps[i] = 3'b000;
        BSigns[i] = 1'b0;
      end
    end
    #10000 CLK = ~CLK;
    #10000 CLK = ~CLK;
    $display("%22b", RESULT);
    result3 = 245 - 267 + 232;
    assert (RESULT == result3[21:0]);
  end
endmodule
`default_nettype wire
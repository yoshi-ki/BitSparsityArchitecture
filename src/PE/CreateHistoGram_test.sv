`timescale 1ns / 100ps
`default_nettype none

// exec cpu for test
module Test_CreateHistoGram ();
  // input
  reg [15:0][15:0] OneHotVector;
  reg [15:0] MultipliedSign;
  reg [15:0][5:0] BeforeAllignmentVector;

  CreateHistoGram  createHistoGram (
    .OneHotVector(OneHotVector),
    .MultipliedSign(MultipliedSign),
    .BeforeAllignmentVector(BeforeAllignmentVector)
  );

  // test program
  int i;
  int j;
  initial begin
    for (i = 0; i < 16; i++) begin
      // set signed bit
      MultipliedSign = 16'b0000000011111111;

      // set values
      if (i < 8) begin
        OneHotVector[i] = 16'b1010000000000101;
      end
      else begin
        OneHotVector[i] = 16'b0110000000000011;
      end
    end

    #10000;
    // position -> value
    $display("%6b", BeforeAllignmentVector[0]);
    $display("%6b", BeforeAllignmentVector[1]);
    $display("%6b", BeforeAllignmentVector[2]);
    $display("%6b", BeforeAllignmentVector[3]);
    $display("%6b", BeforeAllignmentVector[4]);
    $display("%6b", BeforeAllignmentVector[5]);
    $display("%6b", BeforeAllignmentVector[6]);
    $display("%6b", BeforeAllignmentVector[7]);
    $display("%6b", BeforeAllignmentVector[8]);
    $display("%6b", BeforeAllignmentVector[9]);
    $display("%6b", BeforeAllignmentVector[10]);
    $display("%6b", BeforeAllignmentVector[11]);
    $display("%6b", BeforeAllignmentVector[12]);
    $display("%6b", BeforeAllignmentVector[13]);
    $display("%6b", BeforeAllignmentVector[14]);
    $display("%6b", BeforeAllignmentVector[15]);
  end
endmodule
`default_nettype wire
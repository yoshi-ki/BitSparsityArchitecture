`default_nettype none

module PE (
  input wire CLK,
  input wire RSTN,
  input wire [15:0][2:0] AExps,
  input wire [15:0] ASigns,
  input wire [15:0][2:0] BExps,
  input wire [15:0] BSigns,
  input wire [15:0] IsInvalidPair,
  output reg [21:0] RESULT
);

  // step1: exponent
  wire [15:0][3:0] sumExps;
  wire [15:0] multipliedSign;
  genvar i;
  generate
  for(i=0;i<16;i=i+1)
    begin: DoNBitAddition
      assign sumExps[i] = AExps[i] + BExps[i];
      assign multipliedSign[i] = ASigns[i] ^ BSigns[i];
    end
  endgenerate

  // step2: convert to one-hot vector
  wire [15:0][15:0] oneHotVector;
  genvar j;
  generate
  for(j=0;j<16;j=j+1)
    begin: CreateOneHot
      CreateOneHotVector createOneHotVector(.SumExps(sumExps[j]), .OneHotVector(oneHotVector[j]));
    end
  endgenerate

  // step3: histogram
  // Note: we should take a look at the 15:0 or 0:15 very closely
  wire [15:0][5:0] beforeAllignmentVector;
  CreateHistoGram createHistoGram(
    .OneHotVector(oneHotVector),
    .MultipliedSign(multipliedSign),
    .IsInvalidPair(IsInvalidPair),
    .BeforeAllignmentVector(beforeAllignmentVector)
  );

  // step4: alignment
  wire [15:0][20:0] beforeReductionVector;
  generate
    genvar k;
    for(k=0;k<16;k=k+1) begin
      assign beforeReductionVector[k] = $signed(beforeAllignmentVector[k]) << k;
    end
  endgenerate

  // step5: reduction
  wire [21:0] psum;
  ReductionInPE reductionInPE(.BeforeReductionVector(beforeReductionVector), .PSUM(psum));

  // assign RESULT = psum;

  // step6: accumulation
  // TODO: if we have to add several sums, we need to add signals to start or busy to initialize the partial sums
  initial begin
    RESULT <= 22'b0;
  end

  always @(posedge CLK) begin
    RESULT <= $signed(RESULT) + $signed(psum);
  end


endmodule


`default_nettype wire
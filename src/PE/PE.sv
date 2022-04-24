`default_nettype none

module PE (
  input wire CLK,
  input wire RSTN,
  input wire [15:0][2:0] AExps,
  input wire [15:0] ASigns,
  input wire [15:0][2:0] BExps,
  input wire [15:0] BSigns,
  output wire [15:0][3:0] RESULT
);

  // step1: exponent
  wire [15:0][3:0] sumExps;
  wire [15:0] multipliedSign;
  genvar i;
  generate
  for(i=0;i<16;i=i+1)
    begin: DoNBitAddition
      NBitAdder #(.bitsize(3)) nBitAdder
        (
          .input1(AExps[i]),
          .input2(BExps[i]),
          .answer(sumExps[i])
        );
    end
    assign multipliedSign[i] = ASigns[i] ^ BSigns[i];
  endgenerate

  // step2: convert to one-hot vector
  wire [15:0][15:0] oneHotVector;
  //CreateOneHotVector createOneHotVector(.SumExps(sumExps), .OneHotVector(oneHotVector));

  assign RESULT = sumExps;

  // step3: histrogram

  // step4: addition

endmodule


`default_nettype wire
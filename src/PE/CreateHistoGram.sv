`default_nettype none

module CreateHistoGram (
  input wire [15:0][15:0] OneHotVector,
  input wire [15:0] MultipliedSign,
  output wire [15:0][5:0] BeforeAllignmentVector
);

generate
  genvar i;
  genvar j;
  wire [15:0][15:0] targetVectors;
  for(i=0;i<16;i=i+1) begin
    for(j=0;j<16;j=j+1) begin
      assign targetVectors[i][j] = OneHotVector[j][i];
    end
  end
endgenerate

genvar k;
generate
for(k=0;k<16;k=k+1)
  // create BeforeAllignmentVector[k]
  begin: CountBit
    BitCounterWithSign bitCounterWithSign(
      .TargetVector(targetVectors[k]),
      .MultipliedSign(MultipliedSign),
      .Count(BeforeAllignmentVector[k])
    );
  end
endgenerate

endmodule

module BitCounterWithSign
(
    input wire [15:0] TargetVector,
    input wire [15:0] MultipliedSign,
    output wire [5:0] Count
);

  // +1 vector
  wire [15:0] plusOneVector;
  generate
  genvar i;
  for(i=0;i<16;i=i+1) begin
    assign plusOneVector[i] = TargetVector[i] & !(MultipliedSign[i]);
  end
  endgenerate
  wire [4:0] plusOneCount;
  BitCounter #(.N(4)) bitCounterForPlus(
    .Bits(plusOneVector),
    .Count(plusOneCount)
  );

  // -1 vector
  wire [15:0] minusOneVector;
  generate
  genvar j;
  for(j=0;j<16;j=j+1) begin
    assign minusOneVector[j] = TargetVector[j] & MultipliedSign[j];
  end
  endgenerate
  wire [4:0] minusOneCount;
  BitCounter #(.N(4)) bitCounterForMinus(
    .Bits(minusOneVector),
    .Count(minusOneCount)
  );

  assign Count = $signed({1'b0,plusOneCount}) - $signed({1'b0,minusOneCount});
  // assign Count = {1'b0,plusOneCount};

endmodule

module BitCounter#(parameter N=4)
(
    input wire [(1<<N)-1:0] Bits,
    output wire [N:0] Count
    );

    if(N == 0) begin
        assign Count = Bits;
    end
    else begin
        localparam Width = 1<<N;
        localparam Half = 1<<(N-1);
        wire[Half-1:0] Hi = Bits[Width-1:Half];
        wire[N-1:0] CHi;
        BitCounter #(.N(N-1))counterH(.Bits(Hi),.Count(CHi));

        wire[Half-1:0] Lo = Bits[Half-1:0];
        wire[N-1:0] CLo;
        BitCounter #(.N(N-1))counterL(.Bits(Lo),.Count(CLo));

        assign Count = CHi + CLo;
    end
endmodule

`default_nettype wire
`timescale 1ns / 100ps
`default_nettype none

// exec cpu for test
module Test_BitConverterFIFO ();

  // input and output
  reg CLK;
  reg RSTN;
  reg [7:0] ActValuesFIFOWriteDataIn;
  reg ActValuesFIFOWriteEnable;
  reg ActBitPlacesFIFOReadEnable;
  reg ActValuesFIFOWriteReady;
  reg ActBitPlacesFIFOReadReady;
  reg [2:0] ActBitPlacesFIFOReadDataOut;

  BitConverterFIFO bitConverterFIFO(
    .CLK(CLK),
    .RSTN(RSTN),
    .ActValuesFIFOWriteDataIn(ActValuesFIFOWriteDataIn),
    .ActValuesFIFOWriteEnable(ActValuesFIFOWriteEnable),
    .ActBitPlacesFIFOReadEnable(ActBitPlacesFIFOReadEnable),
    .ActValuesFIFOWriteReady(ActValuesFIFOWriteReady),
    .ActBitPlacesFIFOReadReady(ActBitPlacesFIFOReadReady),
    .ActBitPlacesFIFOReadDataOut(ActBitPlacesFIFOReadDataOut)
  );

  // test program
  int i;
  reg hoge;
  initial begin
    CLK = 0;
    RSTN = 0;
    #10000 CLK = ~CLK;
    RSTN = ~RSTN;
    #10000 CLK = ~CLK;
    RSTN = ~RSTN;
    // write values here
    for (i = 0; i < 4000; i++) begin
      #10000 CLK = ~CLK;
      if (i % 2 == 0) begin
        // do nothing
      end
      else if (ActValuesFIFOWriteReady && (i == 37 || i == 41)) begin
        ActValuesFIFOWriteEnable = 1'b1;
      end
      else if (ActValuesFIFOWriteReady && (i == 39 || i == 43)) begin
        if (i == 39) begin
          ActValuesFIFOWriteDataIn = 8'b00010010;
        end
        else begin
          ActValuesFIFOWriteDataIn = 8'b10000100;
        end
      end
      else if (ActBitPlacesFIFOReadReady) begin
        ActBitPlacesFIFOReadEnable = 1'b1;
        $display("%02d", ActBitPlacesFIFOReadDataOut);
      end
      else begin
        ActValuesFIFOWriteEnable = 1'b0;
        ActBitPlacesFIFOReadEnable = 1'b0;
      end
    end
  end
endmodule
`default_nettype wire
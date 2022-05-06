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
  int flag;
  reg hoge;
  initial begin
    CLK = 0;
    RSTN = 0;
    flag = 0;
    #10000 CLK = ~CLK;
    RSTN = ~RSTN;
    #10000 CLK = ~CLK;
    RSTN = ~RSTN;
    // write values here
    for (i = 0; i < 4000; i++) begin
      #10000 CLK = ~CLK;
      if (i % 2 == 0) begin
        // do nothing
        continue;
      end
      else if (ActValuesFIFOWriteReady && (i == 37 || i == 41)) begin
        ActValuesFIFOWriteEnable = 1'b1;
        ActValuesFIFOWriteDataIn = 8'b00010010;
      end
      else begin
        ActValuesFIFOWriteEnable = 1'b0;
        ActBitPlacesFIFOReadEnable = 1'b0;
      end

      // test with wave form because it is not straightforward to output the fifo (because of 1 clock latecy)
      if (ActBitPlacesFIFOReadReady) begin
        ActBitPlacesFIFOReadEnable = 1'b1;
        flag = i;
        $display("%02d", ActBitPlacesFIFOReadDataOut);
      end
      else begin
        flag = 0;
      end
      if (flag) begin
        $display("%02d", ActBitPlacesFIFOReadDataOut);
      end
    end
  end
endmodule
`default_nettype wire
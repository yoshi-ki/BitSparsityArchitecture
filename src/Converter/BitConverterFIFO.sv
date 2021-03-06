`default_nettype none

// create large fifo which has two fifos and bit converter
module BitConverterFIFO (
  input wire CLK,
  input wire RSTN,
  input wire [7:0] ActValuesFIFOWriteDataIn,
  input wire ActValuesFIFOWriteEnable,
  input wire ActBitPlacesFIFOReadEnable,
  output wire ActValuesFIFOWriteReady,
  output wire ActBitPlacesFIFOReadReady,
  output wire [2:0] ActBitPlacesFIFOReadDataOut
);

// define values fifo here
  wire actValuesFIFOReadEnable;
  wire actValuesFIFOReadReady;
  wire [7:0] actValuesFIFOReadDataOut;

  ss_fifo_sync #(.Bw_d(8), .Bw_a(5)) actValuesFIFO(
    .wr_di(ActValuesFIFOWriteDataIn),
    .wr_en(ActValuesFIFOWriteEnable),
    .rd_en(actValuesFIFOReadEnable),
    .clk(CLK),
    .reset(RSTN),
    .wr_rdy(ActValuesFIFOWriteReady),
    .rd_rdy(actValuesFIFOReadReady),
    .rd_do(actValuesFIFOReadDataOut)
  );

// define bit places fifo here
  wire [2:0] actBitPlacesFIFOWriteDataIn;
  wire actBitPlacesFIFOWriteEnable;
  wire actBitPlacesFIFOWriteReady;

  ss_fifo_sync #(.Bw_d(3), .Bw_a(5)) actBitPlacesFIFO
  (
    .wr_di(actBitPlacesFIFOWriteDataIn),
    .wr_en(actBitPlacesFIFOWriteEnable),
    .rd_en(ActBitPlacesFIFOReadEnable),
    .clk(CLK),
    .reset(RSTN),
    .wr_rdy(actBitPlacesFIFOWriteReady),
    .rd_rdy(ActBitPlacesFIFOReadReady),
    .rd_do(ActBitPlacesFIFOReadDataOut)
  );

// connect modules here
  ValuesToBitConverter valuesToBitConverter(
    .CLK(CLK),
    .RSTN(RSTN),
    // for read from values fifo
    .ActValuesFIFOReadEnable(actValuesFIFOReadEnable),
    .ActValuesFIFOReadReady(actValuesFIFOReadReady),
    .ActValuesFIFOReadDataOut(actValuesFIFOReadDataOut),
    // for write to bits fifo
    .ActBitPlacesFIFOWriteReady(actBitPlacesFIFOWriteReady),
    .ActBitPlacesFIFOWriteEnable(actBitPlacesFIFOWriteEnable),
    .ActBitPlacesFIFOWriteDataIn(actBitPlacesFIFOWriteDataIn)
  );

endmodule


module ValuesToBitConverter (
  input wire CLK,
  input wire RSTN,
  output reg ActValuesFIFOReadEnable,
  input wire ActValuesFIFOReadReady,
  input wire [7:0] ActValuesFIFOReadDataOut,
  input wire ActBitPlacesFIFOWriteReady,
  output reg ActBitPlacesFIFOWriteEnable,
  output reg [2:0] ActBitPlacesFIFOWriteDataIn
);

  // define state
  reg [3:0] module_state;
  localparam s_read_ready_wait = 0;
  localparam s_read = 1;
  localparam s_write = 2;
  initial begin
    module_state <= s_read_ready_wait;
  end

  // define data processed inside the module
  reg [7:0] data;
  wire [2:0] place;

  function [2:0] getFirstZeroPlace(input [7:0] input_data);
    begin
      casex(input_data)
        8'b00000001: assign getFirstZeroPlace = 3'b000;
        8'b0000001x: assign getFirstZeroPlace = 3'b001;
        8'b000001xx: assign getFirstZeroPlace = 3'b010;
        8'b00001xxx: assign getFirstZeroPlace = 3'b011;
        8'b0001xxxx: assign getFirstZeroPlace = 3'b100;
        8'b001xxxxx: assign getFirstZeroPlace = 3'b101;
        8'b01xxxxxx: assign getFirstZeroPlace = 3'b110;
        8'b1xxxxxxx: assign getFirstZeroPlace = 3'b111;
        default: begin assign getFirstZeroPlace = 3'b000; end
      endcase
    end
  endfunction
  assign place = getFirstZeroPlace(data);

  always @(posedge CLK) begin
    case(module_state)
      s_read_ready_wait: begin
        ActBitPlacesFIFOWriteEnable <= 1'b0;
        if (ActValuesFIFOReadReady) begin
          ActValuesFIFOReadEnable <= 1'b1;
          module_state <= s_read;
        end
        else begin
          ActValuesFIFOReadEnable <= 1'b0;
        end
      end
      s_read: begin
        ActValuesFIFOReadEnable <= 1'b0;
        data <= ActValuesFIFOReadDataOut;
        module_state <= s_write;
      end
      s_write: begin
        if (data == 8'b00000000) begin
          // when input data is zero
          ActBitPlacesFIFOWriteEnable = 1'b0;
          module_state <= s_read_ready_wait;
        end
        else begin
          if (ActBitPlacesFIFOWriteReady) begin
            ActBitPlacesFIFOWriteEnable <= 1'b1;
            ActBitPlacesFIFOWriteDataIn <= place;
            data[place] <= 1'b0;
          end
          else begin
            ActBitPlacesFIFOWriteEnable <= 1'b0;
          end
        end
      end
    endcase
  end

endmodule

`default_nettype wire
`default_nettype none

module ValuesToBitConverter (
  input wire CLK,
  input wire RSTN,
  input wire [7:0] InputValue,
  output reg [2:0] BitPlace
);

  // define state
  reg [3:0] module_state;
  localparam s_read = 0;
  localparam s_process = 1;
  initial begin
    module_state <= s_read;
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
      s_read: begin
        data <= InputValue; // in future we use fifo and read when read ready
        // if read success we process the values
        module_state <= s_process;
      end
      s_process: begin
        // write the bit place to output
        BitPlace <= place;
        data[place] <= 1'b0;
        if (data == 8'b00000000) begin
          module_state <= s_read;
        end
      end
    endcase
  end

endmodule

`default_nettype wire
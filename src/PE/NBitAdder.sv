`default_nettype none

module NBitAdder #(parameter bitsize = 3)
(
  input wire [bitsize-1:0] input1,
  input wire [bitsize-1:0] input2,
  output wire [bitsize:0] answer
);
  wire  carry_out;
  wire [bitsize-1:0] carry;
  genvar i;
  generate
  for(i=0;i<bitsize;i=i+1)
    begin: generate_Three_bit_Adder
      if(i==0)
        half_adder f(input1[0],input2[0],answer[0],carry[0]);
      else
        full_adder f(input1[i],input2[i],carry[i-1],answer[i],carry[i]);
    end
    assign answer[bitsize] = carry[bitsize-1];
  endgenerate
endmodule

// half adder
module half_adder(
  input wire x,
  input wire y,
  output wire s,
  output wire c
);
  assign s=x^y;
  assign c=x&y;
endmodule

// full adder
module full_adder(
  input wire x,
  input wire y,
  input wire c_in,
  output wire s,
  output wire c_out
);
  assign s = (x^y) ^ c_in;
  assign c_out = (y&c_in)| (x&y) | (x&c_in);
endmodule

`default_nettype wire

// ref: https://www.fpga4student.com/2017/07/n-bit-adder-design-in-verilog.html
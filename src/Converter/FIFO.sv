`default_nettype none
module  ss_fifo_sync
#(
  parameter        Bw_d   = 8     , // data width
  parameter        Bw_a   = 10    , // address width
  parameter        Depth  = ( 1 << Bw_a ) ,
  parameter        Thrs_wr= Depth/4*3     ,       // for write ready
  parameter        Thrs_rd= 1             // for read ready
)
(
  input wire [Bw_d-1:00] wr_di,        // write data in
  input wire wr_en,                    // write enable
  input wire rd_en,                    // read enable
  input wire clk,                      // clock
  input wire reset,                    // sync reset ( h active )

  output wire wr_rdy,                  // buffer write ready
  output wire rd_rdy,                  // buffer read ready
  output reg [Bw_d-1:00] rd_do        // read data out
);

  // wires & regs
  reg     [Bw_a:00]        wr_ad  ;       // wr address
  reg     [Bw_a:00]        rd_ad  ;       // rd address
  wire    [Bw_a:00]        df_ad  ;       // address difference

  reg     [Bw_d-1:00]      m_ary  [0:Depth-1] ;       // memory array

  // write pointer
  always  @( posedge clk ) begin
          if      ( reset )       wr_ad   <= {(Bw_a+1){1'b0}} ;
          else if ( wr_en )       wr_ad   <= wr_ad + 1'b1 ;
  end

  // read pointer
  always  @( posedge clk ) begin
          if      ( reset )       rd_ad   <= {(Bw_a+1){1'b0}} ;
          else if ( rd_en )       rd_ad   <= rd_ad + 1'b1 ;
  end

  // occupancy
  assign           df_ad  = wr_ad - rd_ad ;
  assign           wr_rdy = ~df_ad[Bw_a] & ( df_ad[Bw_a-1:00] <= Thrs_wr ) ;
  assign           rd_rdy = ~df_ad[Bw_a] & ( df_ad[Bw_a-1:00] >= Thrs_rd ) ;

  // memory wr
  always  @( posedge clk ) begin
          if      ( wr_en )       m_ary[wr_ad[Bw_a-1:00]] <= wr_di ;
  end

  // memory rd
  always  @( posedge clk ) begin
          rd_do   <= m_ary[rd_ad[Bw_a-1:00]] ;
  end

endmodule
`default_nettype wire

// ref: https://www.acri.c.titech.ac.jp/wordpress/archives/10474
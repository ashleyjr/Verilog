`timescale 1ns/1ps
module ice_ram_2048x2b (
   input    wire              i_nrst,
   input    wire              i_wclk,
   input    wire     [10:0]   i_waddr,
   input    wire              i_we,
   input    wire     [1:0]    i_wdata,
   input    wire              i_rclk,
   input    wire     [10:0]   i_raddr,
   input    wire              i_re,
   output   wire     [1:0]    o_rdata
);


   ice_ram_DxWb #(
      .pD         (2048    ),
      .pW         (2       ),   
      .pMODE      (32'sd3  )
   ) ram (
      .i_nrst     (i_nrst  ),
      .i_wclk     (i_wclk  ),
      .i_waddr    (i_waddr ),
      .i_we       (i_we    ),
      .i_wdata    (i_wdata ),
      .i_rclk     (i_rclk  ),
      .i_raddr    (i_raddr ),
      .i_re       (i_re    ),
      .o_rdata    (o_rdata )
   );
endmodule


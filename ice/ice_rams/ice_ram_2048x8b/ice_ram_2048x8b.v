`timescale 1ns/1ps
module ice_ram_2048x8b(
   input    wire              i_nrst,
   input    wire              i_wclk,
   input    wire     [10:0]   i_waddr,
   input    wire              i_we,
   input    wire     [7:0]    i_wdata,
   input    wire              i_rclk,
   input    wire     [10:0]   i_raddr,
   input    wire              i_re,
   output   wire     [7:0]    o_rdata
);

   wire  [1:0]    o_rdata3,
                  o_rdata2,
                  o_rdata1,
                  o_rdata0;

   assign o_rdata = {o_rdata3,
                     o_rdata2,
                     o_rdata1,
                     o_rdata0};
   
   ice_ram_DxWb #(
      .pD         (2048          ),
      .pW         (2             ),   
      .pMODE      (32'sd3        )
   ) ram3 (
      .i_nrst     (i_nrst        ),
      .i_wclk     (i_wclk        ),
      .i_waddr    (i_waddr       ),
      .i_we       (i_we          ),
      .i_wdata    (i_wdata[7:6]  ),
      .i_rclk     (i_rclk        ),
      .i_raddr    (i_raddr       ),
      .i_re       (i_re          ),
      .o_rdata    (o_rdata3      )
   );
   ice_ram_DxWb #(
      .pD         (2048          ),
      .pW         (2             ),   
      .pMODE      (32'sd3        )
   ) ram2 (
      .i_nrst     (i_nrst        ),
      .i_wclk     (i_wclk        ),
      .i_waddr    (i_waddr       ),
      .i_we       (i_we          ),
      .i_wdata    (i_wdata[5:4]  ),
      .i_rclk     (i_rclk        ),
      .i_raddr    (i_raddr       ),
      .i_re       (i_re          ),
      .o_rdata    (o_rdata2      )
   );
   ice_ram_DxWb #(
      .pD         (2048          ),
      .pW         (2             ),   
      .pMODE      (32'sd3        )
   ) ram1 (
      .i_nrst     (i_nrst        ),
      .i_wclk     (i_wclk        ),
      .i_waddr    (i_waddr       ),
      .i_we       (i_we          ),
      .i_wdata    (i_wdata[3:2]  ),
      .i_rclk     (i_rclk        ),
      .i_raddr    (i_raddr       ),
      .i_re       (i_re          ),
      .o_rdata    (o_rdata1      )
   );
   ice_ram_DxWb #(
      .pD         (2048          ),
      .pW         (2             ),   
      .pMODE      (32'sd3        )
   ) ram0 (
      .i_nrst     (i_nrst        ),
      .i_wclk     (i_wclk        ),
      .i_waddr    (i_waddr       ),
      .i_we       (i_we          ),
      .i_wdata    (i_wdata[1:0]  ),
      .i_rclk     (i_rclk        ),
      .i_raddr    (i_raddr       ),
      .i_re       (i_re          ),
      .o_rdata    (o_rdata0      )
   );

endmodule
